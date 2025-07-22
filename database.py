import oracledb
import os
from dotenv import load_dotenv

load_dotenv()

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

def get_all_employees():
    """Fetches all employees from the database.
    
    Returns:
        list: A list of tuples containing employee data.
    """
    conn = oracle_connect()
    if conn is None:
        return []

    cursor = conn.cursor()
    query = """
        SELECT 
            e.employeeId,
            e.firstName || ' ' || e.lastName AS fullName,
            r.title AS roleTitle,
            d.name AS divisionName
        FROM 
            Employee e
        JOIN 
            Role r ON e.role = r.roleId
        JOIN 
            Division d ON e.division = d.divisionId
        WHERE 
            e.status = 'active'
    """

    try:
        cursor.execute(query)
        columns = [col[0] for col in cursor.description]
        employees = [dict(zip(columns, row)) for row in cursor.fetchall()]
        return employees
    except oracledb.DatabaseError as e:
        error, = e.args
        print(f"Error fetching employees: {error.message}")
        return []
    finally:
        cursor.close()
        conn.close()

def get_projects_with_budget():
    """
    Fetches all projects and their total allocated budget.
    """
    conn = oracle_connect()
    if not conn:
        return []

    cursor = conn.cursor()
    query = """
        SELECT 
            p.projectId,
            p.name AS projectName,
            SUM(b.amountAllocated) AS totalAllocated
        FROM 
            Project p
        LEFT JOIN 
            Budget b ON p.projectId = b.project
        GROUP BY 
            p.projectId, p.name
        ORDER BY 
            totalAllocated DESC
    """
    try:
        cursor.execute(query)
        columns = [col[0].lower() for col in cursor.description]
        projects = [dict(zip(columns, row)) for row in cursor.fetchall()]
        return projects
    except oracledb.Error as e:
        print(f"Error executing query: {e}")
        return []
    finally:
        if conn:
            cursor.close()
            conn.close()

def add_new_employee(emp_data):
    """
    Adds a new employee by calling the stored procedure.
    `emp_data` is a dictionary containing all the required employee details.
    """
    conn = oracle_connect()
    if not conn:
        return {"success": False, "message": "Database connection failed."}
    
    cursor = conn.cursor()
    try:
        # The stored procedure expects parameters in a specific order
        cursor.callproc("add_new_employee_with_login", [
            emp_data['employeeId'],
            emp_data['firstName'],
            emp_data['lastName'],
            emp_data['email'],
            emp_data['phone'],
            emp_data['division'],
            emp_data['role'],
            emp_data.get('manager', None) # Use .get() for optional fields
        ])
        conn.commit()
        return {"success": True, "message": "Employee added successfully."}
    except oracledb.Error as e:
        conn.rollback() # Roll back changes if an error occurs
        print(f"Error calling stored procedure: {e}")
        # Provide a more user-friendly error message
        error_message = str(e).split("\n")[0] # Get the first line of the Oracle error
        return {"success": False, "message": f"Failed to add employee. DB Error: {error_message}"}
    finally:
        if conn:
            cursor.close()
            conn.close()


if __name__ == "__main__":
    # Test the functions
    print(get_all_employees())
    print(get_projects_with_budget())