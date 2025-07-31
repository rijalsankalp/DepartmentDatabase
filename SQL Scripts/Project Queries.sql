--Query 1: All active employees with their roles and divisions
--Business Value: Useful for HR to see current staffing and organizational structure.

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



--Query 2: Total allocated budget per project
--Business Value: Helps Finance Division monitor how much has been allocated to each project.

SELECT 
    p.projectId,
    p.name AS projectName,
    SUM(b.amountAllocated) AS totalAllocated
FROM 
    Project p
JOIN 
    Budget b ON p.projectId = b.project
GROUP BY 
    p.projectId, p.name;
    
    
    
--Query 3: Contractors with licenses expiring this year
--Business Value: Ensures contractor licenses are renewed on time, avoiding legal issues.

SELECT 
    c.contractorId,
    c.name AS contractorName,
    l.licenseNum,
    l.expiryDate
FROM 
    Contractor c
JOIN 
    License l ON c.contractorId = l.contractorId
WHERE 
    EXTRACT(YEAR FROM l.expiryDate) = EXTRACT(YEAR FROM SYSDATE);



--Query 4: Employees who are currently assigned to projects
--Business Value: Shows who is actively engaged in projects – important for planning and reassignment.

SELECT 
    e.employeeId,
    e.firstName || ' ' || e.lastName AS fullName,
    a.project,
    a.projectStatus,
    a.startDate,
    a.endDate
FROM 
    Assignment a
JOIN 
    Employee e ON a.employee = e.employeeId
WHERE 
    a.endDate IS NULL OR a.endDate > SYSDATE;



--Query 5: Count of employees per division
--Business Value: Helps detect overstaffing or understaffing in divisions.

SELECT 
    d.name AS divisionName,
    COUNT(e.employeeId) AS totalEmployees
FROM 
    Division d
LEFT JOIN 
    Employee e ON d.divisionId = e.division
GROUP BY 
    d.name;