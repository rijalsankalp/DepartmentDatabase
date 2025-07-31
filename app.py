from flask import Flask, render_template, jsonify, request, session, redirect, url_for
import database
import os

app = Flask(__name__)

app.secret_key = os.urandom(24)


@app.route('/login', methods=['GET', 'POST'])
def login():
    """Handles the user login form."""
    # If the user is already logged in, send them to the dashboard.
    if 'user_id' in session:
        return redirect(url_for('dashboard'))
        
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password'] # We now get the password from the form
        user_account = database.get_user_for_login(username)

        print(user_account)
        
        # Check if the user exists AND if the provided password matches the stored hash.
        if user_account and database.verify_password(user_account['hashedpassword'], password):
            # If successful, store user info in the session
            session['user_id'] = user_account['employee']
            session['username'] = user_account['username']
            return redirect(url_for('dashboard'))
        else:
            # If login fails, show an error message.
            return render_template('login.html', error="Invalid username or password")
            
    # For a GET request, just show the login page.
    return render_template('login.html')

@app.route('/logout')
def logout():
    """Clears the user session to log them out."""
    session.clear()
    return redirect(url_for('login'))



@app.route('/')
def index():
    """The main entry point. Redirects to login or dashboard."""
    if 'user_id' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

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


@app.before_request
def require_login_for_api():
    """
    This function runs before every request. It acts as a security guard,
    ensuring that only logged-in users can access API endpoints.
    """
    if request.path.startswith('/api/') and 'user_id' not in session:
        return jsonify({"success": False, "message": "Unauthorized. Please log in."}), 401

@app.route('/api/dashboard-stats')
def api_dashboard_stats():
    """API for the main dashboard statistics."""
    return jsonify(database.get_dashboard_stats())

@app.route('/api/employees', methods=['GET', 'POST'])
def api_employees():
    """API for getting all employees and adding a new one."""
    if request.method == 'POST':
        # This calls our new, secure function from database.py
        result = database.add_employee_and_create_login(request.json)
        status = 201 if result.get('success') else 400
        return jsonify(result), status
    
    # For a GET request, return all employees
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



if __name__ == '__main__':
    app.run(debug=True)