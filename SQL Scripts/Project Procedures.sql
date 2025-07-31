SET SERVEROUTPUT ON; --Makingsure output is displayed, beacuse I sepnt hours trying to find the problem.

CREATE OR REPLACE PROCEDURE add_new_employee_with_login (
    p_employeeId     CHAR,
    p_firstName      VARCHAR2,
    p_lastName       VARCHAR2,
    p_email          VARCHAR2,
    p_phone          CHAR,
    p_division       CHAR,
    p_role           CHAR,
    p_manager        CHAR
) AS
    v_userName      VARCHAR2(100);
    v_baseUserName  VARCHAR2(100);
    v_suffix        NUMBER := 0;
    v_exists        NUMBER;
    v_mgr_count     NUMBER;
BEGIN
    
    IF p_manager IS NOT NULL THEN
        SELECT COUNT(*) INTO v_mgr_count
        FROM Employee
        WHERE employeeId = p_manager
          AND division = p_division
          AND role = 'active';

        IF v_mgr_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Manager is not in the same division.');
            RETURN;
        END IF;
    END IF;


    INSERT INTO Employee (
        employeeId, firstName, lastName, email, phone, division, role, manager
    ) VALUES (
        p_employeeId, p_firstName, p_lastName, p_email, p_phone, p_division, p_role, p_manager
    );

    DBMS_OUTPUT.PUT_LINE('Employee data inserted successfully.');

    
    v_baseUserName := LOWER(p_firstName || '.' || p_lastName);
    v_userName := v_baseUserName;

    LOOP
        SELECT COUNT(*) INTO v_exists
        FROM Login
        WHERE userName = v_userName;

        EXIT WHEN v_exists = 0;

        v_suffix := v_suffix + 1;
        v_userName := LOWER(p_firstName || '.' || p_lastName || v_suffix);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Generated username: ' || v_userName);

    INSERT INTO Login (
        employee, userName, hashedPassword
    ) VALUES (
        p_employeeId, v_userName, 'defaultHash'
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Login added successfully with username: ' || v_userName);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

COMMIT;

EXEC add_new_employee_with_login('E123', 'John', 'Doe', 'john.doe@again.gov', '1231234123', 'P001', 'R001', NULL);


CREATE OR REPLACE PROCEDURE get_assignments (
    p_employeeId CHAR
) AS
    v_employeeName VARCHAR2(200);
BEGIN
    SELECT firstName || ' ' || lastName
    INTO v_employeeName
    FROM Employee
    WHERE employeeId = p_employeeId;
    
    DBMS_OUTPUT.PUT_LINE('Employee: '  || v_employeeName);
    
    FOR rec IN (
        SELECT P.name AS projName, A.projectStatus, A.startDate, A.endDate
        FROM Assignment A
        JOIN Project P ON A.project = P.projectId
        WHERE A.employee = p_employeeId
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Project: ' || rec.projName || ', Status: ' || rec.projectStatus ||
            ', Start: ' || rec.startDate || ', End: ' || NVL(TO_CHAR(rec.endDate), 'Ongoing')
        );
    END LOOP;
END;
/


EXEC get_assignments('E002');

COMMIT;