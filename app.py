from flask import Flask, render_template, jsonify, request
import database

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/api/employees')
def api_get_employees():
    """API endpoint to get all active employees."""
    employees = database.get_all_employees()
    return jsonify(employees)

@app.route('/api/projects')
def api_get_projects():
    """API endpoint to get all projects with their total allocated budget."""
    projects = database.get_projects_with_budget()
    return jsonify(projects)

@app.route('/api/employees', methods=['POST'])
def api_add_employee():
    """ API endpoint to add new employee.
    Expectes a JSON payload with employee data from a form."""

    employee_data = request.json

    result = database.add_new_employee(employee_data)

    status_code = 201 if result['success'] else 400

    return jsonify(result), status_code

if __name__ == '__main__':
    app.run(debug=True)