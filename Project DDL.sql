-- Division Table
CREATE TABLE Division (
    divisionId CHAR(4),
    name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone CHAR(10),
    CONSTRAINT division_pk PRIMARY KEY (divisionId),
    CONSTRAINT division_uq_name UNIQUE (name),
    CONSTRAINT division_uq_email UNIQUE (email)
);

-- Role Table
CREATE TABLE Role (
    roleId CHAR(4),
    title VARCHAR2(50) NOT NULL,
    salary NUMBER NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (roleId),
    CONSTRAINT role_ck_salary CHECK (salary BETWEEN 30000 AND 50000),
    CONSTRAINT role_uq_title UNIQUE (title)
);

-- Employee Table
CREATE TABLE Employee (
    employeeId CHAR(5),
    firstName VARCHAR2(50) NOT NULL,
    lastName VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone CHAR(10),
    division CHAR(4) NOT NULL,
    role CHAR(4) NOT NULL,
    manager CHAR(5),
    status VARCHAR2(15) DEFAULT 'active' CHECK (status IN ('active', 'left', 'retired', 'terminated')),
    CONSTRAINT employee_pk PRIMARY KEY (employeeId),
    CONSTRAINT employee_fk_division FOREIGN KEY (division) REFERENCES Division(divisionId),
    CONSTRAINT employee_fk_role FOREIGN KEY (role) REFERENCES Role(roleId),
    CONSTRAINT employee_fk_manager FOREIGN KEY (manager) REFERENCES Employee(employeeId),
    CONSTRAINT employee_uq_email UNIQUE (email)
);

-- Login Table
CREATE TABLE Login (
    employee CHAR(5),
    userName VARCHAR2(25) NOT NULL,
    hashedPassword CHAR(256) NOT NULL,
    CONSTRAINT login_pk PRIMARY KEY (employee),
    CONSTRAINT login_fk_employee FOREIGN KEY (employee) REFERENCES Employee(employeeId),
    CONSTRAINT login_uq_userName UNIQUE (userName)
);

-- Project Table
CREATE TABLE Project (
    projectId CHAR(10),
    name VARCHAR2(100) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,
    street VARCHAR2(100) NOT NULL,
    district VARCHAR2(15) NOT NULL,
    province VARCHAR2(15) NOT NULL,
    zip CHAR(5) NOT NULL,
    CONSTRAINT project_pk PRIMARY KEY (projectId),
    CONSTRAINT project_ck_start CHECK (startDate > DATE '2000-01-01'),
    CONSTRAINT project_ck_dates CHECK (endDate IS NULL OR endDate > startDate)
);

-- Budget Table
CREATE TABLE Budget (
    budgetId CHAR(10),
    project CHAR(10) NOT NULL,
    amountAllocated NUMBER NOT NULL,
    dateApproved DATE NOT NULL,
    CONSTRAINT budget_pk PRIMARY KEY (budgetId),
    CONSTRAINT budget_fk_project FOREIGN KEY (project) REFERENCES Project(projectId),
    CONSTRAINT budget_ck_amount CHECK (amountAllocated > 1000000),
    CONSTRAINT budget_ck_date CHECK (dateApproved > DATE '2000-01-01')
);

-- Contractor Table
CREATE TABLE Contractor (
    contractorId CHAR(10),
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone CHAR(10) NOT NULL,
    street VARCHAR2(100) NOT NULL,
    district VARCHAR2(15) NOT NULL,
    province VARCHAR2(15) NOT NULL,
    zip CHAR(5) NOT NULL,
    status VARCHAR2(15) DEFAULT 'active' CHECK (status IN ('active', 'left', 'suspended', 'blacklisted')),
    CONSTRAINT contractor_pk PRIMARY KEY (contractorId),
    CONSTRAINT contractor_uq_email UNIQUE (email),
    CONSTRAINT contractor_uq_phone UNIQUE (phone)
);

-- License Table
CREATE TABLE License (
    licenseNum CHAR(10),
    contractorId CHAR(10) NOT NULL,
    issueDate DATE NOT NULL,
    expiryDate DATE NOT NULL,
    CONSTRAINT license_pk PRIMARY KEY (licenseNum),
    CONSTRAINT license_fk_contractor FOREIGN KEY (contractorId) REFERENCES Contractor(contractorId),
    CONSTRAINT license_ck_dates CHECK (expiryDate > issueDate),
    CONSTRAINT license_ck_issue CHECK (issueDate > DATE '2000-01-01')
);

-- Assignment Table
CREATE TABLE Assignment (
    project CHAR(10) NOT NULL,
    projectStatus VARCHAR2(15) NOT NULL,
    license CHAR(10) NOT NULL,
    employee CHAR(5) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,
    CONSTRAINT assignment_pk PRIMARY KEY (project, projectStatus, license, employee),
    CONSTRAINT assignment_fk_project FOREIGN KEY (project) REFERENCES Project(projectId),
    CONSTRAINT assignment_fk_license FOREIGN KEY (license) REFERENCES License(licenseNum),
    CONSTRAINT assignment_fk_employee FOREIGN KEY (employee) REFERENCES Employee(employeeId),
    CONSTRAINT assignment_ck_status CHECK (projectStatus IN ('planning', 'procurement', 'building', 'completing')),
    CONSTRAINT assignment_ck_start CHECK (startDate > DATE '2000-01-01'),
    CONSTRAINT assignment_ck_dates CHECK (endDate IS NULL OR endDate > startDate)
);

CREATE VIEW ActiveEmployeeDetails AS
SELECT 
    e.employeeId,
    e.firstName || ' ' || e.lastName AS fullName,
    r.title AS roleTitle,
    d.name AS divisionName,
    e.email,
    e.phone
FROM 
    Employee e
JOIN 
    Role r ON e.role = r.roleId
JOIN 
    Division d ON e.division = d.divisionId
WHERE 
    e.status = 'active';
