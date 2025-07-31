--DIVISION--
INSERT INTO Division (divisionId, name, email, phone) VALUES ('A001', 'Administration', 'admin@company.com', '0123456789');
INSERT INTO Division (divisionId, name, email, phone) VALUES('P001', 'Project', 'projects@company.com', '0987654321');
INSERT INTO Division (divisionId, name, email, phone) VALUES('L001', 'License', 'license@company.com', '0112233445');
INSERT INTO Division (divisionId, name, email, phone) VALUES('F001', 'Finance', 'finance@company.com', '0213344556');
INSERT INTO Division (divisionId, name, email, phone) VALUES('S001', 'Software Maintenance', 'support@company.com', '0222333444');
INSERT INTO Division (divisionId, name, email, phone) VALUES('T001', 'TempDivision', 'temp@company.com', '0202020202');

UPDATE Division SET phone ='0235462746' where divisionId = 'F001';
DELETE FROM Division WHERE divisionId = 'T001';


--ROLE--
INSERT INTO Role (roleId, title, salary) VALUES ('R001', 'Manager', 49000);
INSERT INTO Role (roleId, title, salary) VALUES ('R002', 'Supervisor', 38000);
INSERT INTO Role (roleId, title, salary) VALUES ('R003', 'Engineer', 45000);
INSERT INTO Role (roleId, title, salary) VALUES ('R004', 'Accountant', 40000);
INSERT INTO Role (roleId, title, salary) VALUES ('R005', 'Technician', 42000);
INSERT INTO Role (roleId, title, salary) VALUES ('R006', 'Director', 50000);
INSERT INTO Role (roleId, title, salary) VALUES ('R007', 'Clerk', 35000);
INSERT INTO Role (roleId, title, salary) VALUES ('R008', 'Intern', 30000);

UPDATE Role SET salary = 47000 WHERE roleId = 'R001';
DELETE FROM Role WHERE roleId = 'R008';

--EMPLOYEE--
INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E001', 'John', 'Smith', 'john.smith@gamil.com', '0789654321', 'A001', 'R001', NULL, 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E002', 'Amit', 'Sharma', 'amit.sharma@yahoo.com', '0938746254', 'P001', 'R002', 'E001', 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E003', 'Sita', 'Thapa', 'sita.thapa@hotmail.com', '0934567890', 'P001', 'R003', 'E002', 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E004', 'Emily', 'Johnson', 'emily.johnson@aol.com', '0741234567', 'F001', 'R004', 'E001', 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E005', 'Ravi', 'Patel', 'ravi.patel@some.com', '0945236789', 'P001', 'R003', 'E002', 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E006', 'Jack', 'Williams', 'jack.williams@random.com', '0765634958', 'S001', 'R005', 'E003', 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E007', 'Raj', 'Singh', 'raj.singh@ohgod.com', '0935647382', 'P001', 'R002', 'E002', 'active');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E008', 'Linda', 'Brown', 'linda.brown@damn.com', '0756894321', 'P001', 'R001', 'E001', 'left');

INSERT INTO Employee (employeeId, firstName, lastName, email, phone, division, role, manager, status)
VALUES ('E009', 'Mohak', 'White', 'mohak.white@enough.com', '0756894363', 'P001', 'R001', 'E001', 'left');


UPDATE Employee SET status = 'terminated' WHERE employeeId = 'E003';
DELETE FROM Employee WHERE employeeId = 'E008';


--LOGIN--
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E001', 'john.smith', 'hashed_password_1');
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E002', 'amit.sharma', 'hashed_password_2');
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E003', 'sita.thapa', 'hashed_password_3');
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E004', 'emily.johnson', 'hashed_password_4');
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E005', 'ravi.patel', 'hashed_password_5');
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E006', 'jack.williams', 'hashed_password_6');
INSERT INTO Login (employee, userName, hashedPassword) VALUES ('E007', 'raj.singh', 'hashed_password_7');


UPDATE Login SET userName = 'john.smith01' WHERE employee = 'E001';
DELETE FROM Login WHERE employee = 'E007';



--PROJECT--
INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P001', 'City Road Expansion', TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'), 'Baker Street', 'Westminster', 'London', 'W1A1A');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P002', 'Hospital Renovation', TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2026-02-28', 'YYYY-MM-DD'), 'MG Road', 'Andheri', 'Mumbai', '40058');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P003', 'Bridge Construction', TO_DATE('2025-05-15', 'YYYY-MM-DD'), TO_DATE('2026-11-30', 'YYYY-MM-DD'), 'Baneshwor', 'Kathmandu', 'Bagmati', '03101');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P004', 'Residential Complex', TO_DATE('2025-06-01', 'YYYY-MM-DD'), TO_DATE('2026-05-31', 'YYYY-MM-DD'), 'Oxford Street', 'Cambridge', 'UK', 'CB11A');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P005', 'Shopping Mall', TO_DATE('2025-07-01', 'YYYY-MM-DD'), TO_DATE('2026-06-30', 'YYYY-MM-DD'), 'Lodha Road', 'Bandra', 'Mumbai', '40050');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P006', 'Airport Terminal', TO_DATE('2025-08-01', 'YYYY-MM-DD'), TO_DATE('2026-07-31', 'YYYY-MM-DD'), 'LAX Blvd', 'Los Angeles', 'California', '90045');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P007', 'Park Development', TO_DATE('2025-09-01', 'YYYY-MM-DD'), TO_DATE('2026-08-31', 'YYYY-MM-DD'), 'Central Park', 'New York', 'NY', '10024');

INSERT INTO Project (projectId, name, startDate, endDate, street, district, province, zip)
VALUES ('P008', 'Water Treatment Plant', TO_DATE('2025-10-01', 'YYYY-MM-DD'), TO_DATE('2026-09-30', 'YYYY-MM-DD'), 'Himalaya Road', 'Kathmandu', 'Bagmati', '03105');


UPDATE Project SET street = 'Baker Street Revised' WHERE projectId = 'P001';
DELETE FROM Project WHERE projectId = 'P008';

--BUDGET--
INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B001', 'P001', 5000000, TO_DATE('2025-01-01', 'YYYY-MM-DD'));

INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B002', 'P002', 3500000, TO_DATE('2025-03-01', 'YYYY-MM-DD'));

INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B003', 'P003', 7500000, TO_DATE('2025-05-15', 'YYYY-MM-DD'));

INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B004', 'P004', 6000000, TO_DATE('2025-06-01', 'YYYY-MM-DD'));

INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B005', 'P005', 10000000, TO_DATE('2025-07-01', 'YYYY-MM-DD'));

INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B006', 'P006', 12000000, TO_DATE('2025-08-01', 'YYYY-MM-DD'));

INSERT INTO Budget (budgetId, project, amountAllocated, dateApproved)
VALUES ('B007', 'P007', 8000000, TO_DATE('2025-09-01', 'YYYY-MM-DD'));

UPDATE Budget SET amountAllocated = 5500000 WHERE budgetId = 'B001';
DELETE FROM Budget WHERE budgetId = 'B007';

--CONTRACTOR--
INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C001', 'ABC Construction', 'abc@construction.com', '0123234215', 'Oxford Road', 'London', 'London', 'W1A2B', 'active');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C002', 'XYZ Engineers', 'xyz@engineers.com', '4384234592', 'Juhu Beach Road', 'Mumbai', 'Maharashtra', '40049', 'active');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C003', 'Bridge Builders Pvt. Ltd.', 'bridgebuilders@nepal.com', '0914567890', 'Kalimati', 'Kathmandu', 'Bagmati', '03102', 'active');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C004', 'Elite Contractors', 'elite@contractors.com', '0741256789', 'Queens Street', 'Manchester', 'UK', 'M11A', 'active');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C005', 'Sunny Builders', 'sunny@builders.com', '089561234', 'Marine Drive', 'Mumbai', 'Maharashtra', '40053', 'suspended');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C006', 'Steel Structures', 'steel@structures.com', '096543210', 'Main Street', 'New York', 'NY', '10001', 'active');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C007', 'Green Projects', 'green@projects.com', '091012131', 'Market Road', 'Kathmandu', 'Bagmati', '03103', 'active');

INSERT INTO Contractor (contractorId, name, email, phone, street, district, province, zip, status)
VALUES ('C008', 'Future Innovations', 'future@innovations.com', '0734567890', 'Hollywood Blvd', 'Los Angeles', 'California', '90028', 'blacklisted');


UPDATE Contractor SET status = 'suspended' WHERE contractorId = 'C005';
DELETE FROM Contractor WHERE contractorId = 'C008';

--LICENSE--
INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L001', 'C001', TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));

INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L002', 'C002', TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2026-02-28', 'YYYY-MM-DD'));

INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L003', 'C003', TO_DATE('2025-05-15', 'YYYY-MM-DD'), TO_DATE('2026-11-30', 'YYYY-MM-DD'));

INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L004', 'C004', TO_DATE('2025-06-01', 'YYYY-MM-DD'), TO_DATE('2026-05-31', 'YYYY-MM-DD'));

INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L005', 'C005', TO_DATE('2025-07-01', 'YYYY-MM-DD'), TO_DATE('2026-06-30', 'YYYY-MM-DD'));

INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L006', 'C006', TO_DATE('2025-08-01', 'YYYY-MM-DD'), TO_DATE('2026-07-31', 'YYYY-MM-DD'));

INSERT INTO License (licenseNum, contractorId, issueDate, expiryDate)
VALUES ('L007', 'C007', TO_DATE('2025-09-01', 'YYYY-MM-DD'), TO_DATE('2026-08-31', 'YYYY-MM-DD'));


UPDATE License SET expiryDate = TO_DATE('2027-01-01', 'YYYY-MM-DD') WHERE licenseNum = 'L003';
DELETE FROM License WHERE licenseNum = 'L007';

--ASSIGNMENT--
INSERT INTO Assignment(project, projectStatus, license, employee, startDate, endDate)
VALUES ('P001', 'planning', 'L001', 'E002', TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-04-01', 'YYYY-MM-DD'));

INSERT INTO Assignment(project, projectStatus, license, employee, startDate, endDate)
VALUES ('P001', 'procurement', 'L002', 'E003', TO_DATE('2025-04-02', 'YYYY-MM-DD'), TO_DATE('2025-06-02', 'YYYY-MM-DD'));

INSERT INTO Assignment(project, projectStatus, license, employee, startDate, endDate)
VALUES ('P001', 'building', 'L003', 'E002', TO_DATE('2025-06-03', 'YYYY-MM-DD'), TO_DATE('2025-08-03', 'YYYY-MM-DD'));

INSERT INTO Assignment(project, projectStatus, license, employee, startDate, endDate)
VALUES ('P002', 'planning', 'L004', 'E005', TO_DATE('2025-04-02', 'YYYY-MM-DD'), TO_DATE('2025-06-02', 'YYYY-MM-DD'));

INSERT INTO Assignment(project, projectStatus, license, employee, startDate, endDate)
VALUES ('P003', 'completing', 'L005', 'E007', TO_DATE('2025-08-02', 'YYYY-MM-DD'), NULL);

UPDATE Assignment SET endDate = DATE'2025-10-02' WHERE project = 'P003'AND projectStatus = 'completing' AND license = 'L005' AND employee = 'E007';
DELETE FROM Assignment WHERE project = 'P002';

--ACCESSING VIEW--
SELECT * FROM ActiveEmployeeDetails;

