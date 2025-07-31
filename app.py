from flask import Flask, render_template, jsonify, request, session, redirect, url_for
import database
import os

app = Flask(__name__)

app.secret_key = os.urandom(24)


@app.route('/login', methods=['GET', 'POST'])
def login():
    """Handles the user login form."""
    if 'user_id' in session:
        return redirect(url_for('dashboard'))
        
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user_account = database.get_user_for_login(username)

        if user_account and database.verify_password(user_account['hashedpassword'], password):
            session['user_id'] = user_account['employee']
            session['username'] = user_account['username']
            return redirect(url_for('dashboard'))
        else:
            return render_template('login.html', error="Invalid username or password")
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    """Clears the user session to log them out."""
    session.clear()
    return redirect(url_for('public_dashboard'))



@app.route('/')
def index():
    """The main entry point. Redirects to the public dashboard."""
    return redirect(url_for('public_dashboard'))

@app.route('/dashboard')
def dashboard():
    """Renders the main dashboard page."""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    return render_template('dashboard.html')

@app.route('/employees')
def employees_page():
    """Renders the employee management page."""
    if 'user_id' not in session:
        return redirect(url_for('login'))
    return render_template('employees.html')

@app.route('/public/')
def public_dashboard():
    """Renders the public dashboard page."""
    return render_template('public_dashboard.html')

@app.route('/public/projects')
def public_projects():
    """Renders the public projects page."""
    return render_template('public_projects.html')

@app.route('/public/contractors')
def public_contractors():
    """Renders the public contractors page."""
    return render_template('public_contractors.html')


@app.before_request
def require_login_for_api():
    """
    This function runs before every request. It acts as a security guard,
    ensuring that only logged-in users can access API endpoints that are not public.
    """
    if request.path.startswith('/api/') and not request.path.startswith('/api/public/') and 'user_id' not in session:
        return jsonify({"success": False, "message": "Unauthorized. Please log in."}), 401

@app.route('/api/dashboard-stats')
def api_dashboard_stats():
    """API for the main dashboard statistics."""
    return jsonify(database.get_dashboard_stats())

@app.route('/api/employees', methods=['GET', 'POST'])
def api_employees():
    """API for getting all employees and adding a new one."""
    if request.method == 'POST':
        result = database.add_employee_and_create_login(request.json)
        status = 201 if result.get('success') else 400
        return jsonify(result), status
    
    employees = database.get_all_employees()
    return jsonify(employees)

@app.route('/api/employees/<string:emp_id>/status', methods=['PUT'])
def api_update_employee_status(emp_id):
    """API to update an employee's status."""
    status_data = request.json.get('status')
    if not status_data:
        return jsonify({"success": False, "message": "Status not provided."}), 400
        
    result = database.update_employee_status(emp_id, status_data)
    status = 200 if result.get('success') else 400
    return jsonify(result), status

@app.route('/api/public/projects', methods=['GET'])
def api_public_projects():
    """API for getting all projects for the public."""
    projects = database.get_all_projects_public()
    return jsonify(projects)

@app.route('/api/public/contractors', methods=['GET'])
def api_public_contractors():
    """API for getting all contractors for the public."""
    contractors = database.get_all_contractors_public()
    return jsonify(contractors)



if __name__ == '__main__':
    app.run(debug=True, port=4590)