import oracledb
import os
import bcrypt
from dotenv import load_dotenv

load_dotenv()

def get_user_for_login(username):
    """
    Fetches a user's login details from the Login table.
    This is specifically for the authentication process.
    """
    conn = oracle_connect()
    if not conn:
        return None
    
    cursor = conn.cursor()
    query = """
            SELECT * FROM Login
            WHERE LOWER(userName) = LOWER(:username) 
        """
    
    try:
        cursor.execute(query, {'username': username})
        user = cursor.fetchone()
        if user:
            columns = [col[0].lower() for col in cursor.description]
            return dict(zip(columns, user))
        return None

    except oracledb.Error as e:
        print(f"Error fetching user for login: {e}")
        return None
    finally:
        if conn:
            cursor.close()
            conn.close()
    
def verify_password(hashed_password, plain_password):
    """
    Verifies a plain text password against a hashed password.
    Returns True if they match, False otherwise.
    """

    return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))


def oracle_connect():
    """    Establishes a connection to the Oracle database using environment variables.
    Returns:
        oracledb.Connection: A connection object to the Oracle database.
    """
    try:
        conn = oracledb.connect(
            user = os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            dsn=os.getenv("DB_DSN")
        )

        print("Database Connection Successful")
        return conn
    except oracledb.DatabaseError as e:
        error, = e.args
        print(f"Database Connection Failed: {error.message}")
        return None
    
def _execute_query(query, params = None, fetch = "all"):
    """
    Helper funtion to execute queires and handle connections
    """

    conn = oracle_connect()

    if not conn: return None

    cursor = conn.cursor()

    try:
        cursor.execute(query, params or {})
        if fetch == "all":
            columns = [col[0].lower() for col in cursor.description]
            return [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        elif fetch == "one":
            columns = [col[0].lower() for col in cursor.description]
            return dict(zip(columns, cursor.fetchone()))
        
        elif fetch == "none":
            conn.commit()
            return {"success": True}
    except:
        conn.rollback()
        print("Error executing query")
        return {"success": False, "message": "str(e).split('\n')[0]"}
    finally:
        cursor.close()
        conn.close()        
        
def get_all_employees():
    """
    Fetches all employees with their role and division.
    """
    query = """
        SELECT e.employeeId, e.firstName, e.lastName, e.email, e.phone, e.Status, r.title AS roleTitle, d.name AS divisionName, m.firstName ||' '|| m.lastName AS managerName
        FROM Employee e
        JOIN Role r ON e.roleId = r.roleId
        JOIN Division d ON e.divisionId = d.divisionId
        LEFT JOIN Employee m ON e.managerId = m.empluyeeId
        ORDER BY e.firstName, e.lastName
        """
    return _execute_query(query)

def get_employee_by_Id(employee_id):
    """
    Fetches a single employee by their ID.
    """

    query = """
        SELECT e.employeeId, e.firstName, e.lastName, e.email, e.phone, e.Status, r.title AS roleTitle, d.name AS divisionName, m.firstName ||' '|| m.lastName AS managerName
        FROM Employee e
        JOIN Role r ON e.roleId = r.roleId
        JOIN Division d ON e.divisionId = d.divisionId
        LEFT JOIN Employee m ON e.managerId = m.empluyeeId
        WHERE e.iemployeeId = :employee_id
        """
    return _execute_query(query, {"employee_id": employee_id}, fetch="one")

def add_employee_and_create_login(emp_data):
    """
    Creates a new employee and a corresponding login with a hashed password
    in a single, secure database transaction using only Python.
    Includes validation for foreign keys before attempting the transaction.
    """
    conn = oracle_connect()
    if not conn: return {"success": False, "message": "Database connection failed."}
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT COUNT(*) FROM Role WHERE roleId = :role_id", role_id=emp_data['role'])
        if cursor.fetchone()[0] == 0:
            return {"success": False, "message": f"Invalid Role ID: {emp_data['role']} does not exist."}

        cursor.execute("SELECT COUNT(*) FROM Division WHERE divisionId = :div_id", div_id=emp_data['division'])
        if cursor.fetchone()[0] == 0:
            return {"success": False, "message": f"Invalid Division ID: {emp_data['division']} does not exist."}
            
        if emp_data.get('manager'):
            cursor.execute("SELECT COUNT(*) FROM Employee WHERE employeeId = :mgr_id", mgr_id=emp_data['manager'])
            if cursor.fetchone()[0] == 0:
                 return {"success": False, "message": f"Invalid Manager ID: {emp_data['manager']} does not exist."}

    except oracledb.Error as e:
        return {"success": False, "message": f"Validation Error: {str(e).splitlines()[0]}"}

    username = emp_data['email']
    default_password = emp_data['email'].encode('utf-8')
    hashed_password = bcrypt.hashpw(default_password, bcrypt.gensalt()).decode('utf-8')

    print(f"Creating employee and login for '{username}' with pasword: {default_password}, and hashed password: {hashed_password}")

    try:
        employee_query = """
            INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
            VALUES (:employeeId, :firstName, :lastName, :email, :phone, :division, :role, :manager, 'active')
        """
        cursor.execute(employee_query, {
            'employeeId': emp_data['employeeId'],
            'firstName': emp_data['firstName'],
            'lastName': emp_data['lastName'],
            'email': emp_data['email'],
            'phone': emp_data['phone'],
            'division': emp_data['division'],
            'role': emp_data['role'],
            'manager': emp_data.get('manager', None)
        })

        login_query = """
            INSERT INTO Login (employee, userName, hashedPassword)
            VALUES (:employee, :userName, :hashedPassword)
        """
        cursor.execute(login_query, {
            'employee': emp_data['employeeId'],
            'userName': username,
            'hashedPassword': hashed_password
        })

        conn.commit()
        return {"success": True, "message": f"Employee and login for '{username}' created successfully."}

    except oracledb.Error as e:
        conn.rollback()
        error_message = str(e).split("\n")[0]
        if "ORA-00001" in error_message:
            return {"success": False, "message": "Employee ID, Email, or Username already exists."}
        return {"success": False, "message": f"Database Error: {error_message}"}
    finally:
        if conn: cursor.close(); conn.close()

def update_employee_details(employee_id, emp_data):
    """ Updates an employee's details. """
    query = """
        UPDATE Employee
        SET firstName = :firstName, lastName = :lastName, email = :email, phone = :phone,
            division = :division, role = :role, manager = :manager
        WHERE employeeId = :employeeId
    """
    params = {**emp_data, 'employeeId': employee_id}
    return _execute_query(query, params, fetch="none")

def update_employee_status(employee_id, status):
    """ Updates an employee's status (e.g., 'left', 'terminated'). """
    query = "UPDATE Employee SET status = :status WHERE employeeId = :id"
    return _execute_query(query, {"status": status, "id": employee_id}, fetch="none")

def get_all_projects():
    """ Fetches all projects with basic details. """
    query = "SELECT * FROM Project ORDER BY startDate DESC"
    return _execute_query(query)

def get_projects_with_budget():
    """ Fetches all projects and their total allocated budget. """
    query = """
        SELECT p.projectId, p.name AS projectName, p.startDate, p.endDate, SUM(b.amountAllocated) AS totalAllocated
        FROM Project p
        LEFT JOIN Budget b ON p.projectId = b.project
        GROUP BY p.projectId, p.name, p.startDate, p.endDate
        ORDER BY p.startDate DESC
    """
    return _execute_query(query)

def get_project_by_id(project_id):
    """ Fetches a single project by its ID. """
    query = "SELECT * FROM Project WHERE projectId = :id"
    return _execute_query(query, {"id": project_id}, fetch="one")

def add_new_project(proj_data):
    """ Adds a new project to the database. """
    query = """
        INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
        VALUES (:projectId, :name, TO_DATE(:startDate, 'YYYY-MM-DD'), TO_DATE(:endDate, 'YYYY-MM-DD'), :street, :district, :province, :zip)
    """
    return _execute_query(query, proj_data, fetch="none")

def update_project_details(project_id, proj_data):
    """ Updates a project's details. """
    query = """
        UPDATE Project
        SET name = :name, startDate = TO_DATE(:startDate, 'YYYY-MM-DD'), endDate = TO_DATE(:endDate, 'YYYY-MM-DD'),
            street = :street, district = :district, province = :province, zip = :zip
        WHERE projectId = :projectId
    """
    params = {**proj_data, 'projectId': project_id}
    return _execute_query(query, params, fetch="none")

def get_project_assignments(project_id):
    """ Gets all employees assigned to a specific project. """
    query = """
        SELECT e.employeeId, e.firstName || ' ' || e.lastName as fullName, a.projectStatus, a.startDate, a.endDate
        FROM Assignment a
        JOIN Employee e ON a.employee = e.employeeId
        WHERE a.project = :id
    """
    return _execute_query(query, {"id": project_id})

def get_all_contractors():
    """ Fetches all contractors. """
    query = "SELECT * FROM Contractor ORDER BY name"
    return _execute_query(query)

def add_new_contractor(contractor_data):
    """ Adds a new contractor. """
    query = """
        INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
        VALUES (:contractorId, :name, :email, :phone, :street, :district, :province, :zip, 'active')
    """
    return _execute_query(query, contractor_data, fetch="none")

def update_contractor_status(contractor_id, status):
    """ Updates a contractor's status ('active', 'suspended', etc.). """
    query = "UPDATE Contractor SET status = :status WHERE contractorId = :id"
    return _execute_query(query, {"status": status, "id": contractor_id}, fetch="none")

def get_contractor_licenses(contractor_id):
    """ Fetches all licenses for a specific contractor. """
    query = "SELECT * FROM License WHERE contractorId = :id ORDER BY expiryDate DESC"
    return _execute_query(query, {"id": contractor_id})

def add_new_license(license_data):
    """ Adds a new license for a contractor. """
    query = """
        INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
        VALUES (:licenseNum, :contractorId, TO_DATE(:issueDate, 'YYYY-MM-DD'), TO_DATE(:expiryDate, 'YYYY-MM-DD'))
    """
    return _execute_query(query, license_data, fetch="none")

def get_dashboard_stats():
    """ Fetches high-level statistics for the main dashboard. """
    stats = {}
    
    q1 = "SELECT COUNT(*) AS count FROM Employee WHERE status = 'active'"
    stats['active_employees'] = _execute_query(q1, fetch="one")['count']
    
    q2 = "SELECT COUNT(*) AS count FROM Project WHERE endDate IS NULL OR endDate > SYSDATE"
    stats['ongoing_projects'] = _execute_query(q2, fetch="one")['count']
    
    q3 = "SELECT SUM(amountAllocated) AS total FROM Budget"
    stats['total_budget'] = _execute_query(q3, fetch="one")['total']
    
    return stats

def get_all_projects_public():
    """ Fetches all projects with limited details for public viewing. """
    query = "SELECT name, district, province, startDate FROM Project WHERE endDate IS NULL OR endDate > SYSDATE ORDER BY startDate DESC"
    return _execute_query(query)

def get_all_contractors_public():
    """ Fetches all active contractors with limited details for public viewing. """
    query = "SELECT name, district, province FROM Contractor WHERE status = 'active' ORDER BY name"
    return _execute_query(query)


if __name__ == "__main__":
    conn = oracle_connect()
    if conn:
        print("Connection successful!")
        conn.close()
    else:
        print("Connection failed.")

    admin_data = {
        'employeeId': 1,
        'firstName': 'Admin',
        'lastName': 'User',
        'email': 'admin',
        'phone': '1234567890',
        'division': 'A001',
        'role': 'R001',
        'manager': None
    }
    
    result = add_employee_and_create_login(admin_data)
    print(result)