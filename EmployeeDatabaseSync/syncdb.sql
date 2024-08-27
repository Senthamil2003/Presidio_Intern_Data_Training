drop table Employee_tgt

create table Employee_src(
id int primary key identity,
employee_name varchar(20),
isDelete bit,
)

create table Employee_tgt(
id int primary key identity,
employeeId int  ,
rescentUpdate datetime,
employee_name varchar(20));

select * from Employee_src;
select * from Employee_tgt;


update Employee_src set isDelete=1 where id=1
truncate table employee_src
INSERT INTO Employee_src 
VALUES ('John Doe',0),
       ('Jane Smith',0),
       ('Alice Johnson',0);

CREATE or ALTER PROCEDURE Syncb
(
    @DebugFlag int = 0  
)
AS
BEGIN
        IF @DebugFlag = 1
			BEGIN  
				PRINT 'debug is working ' ;
				SELECT * FROM Employee_src;
				SELECT employeeId, employee_name, rescentUpdate
				FROM employee_tgt tgt
				WHERE rescentUpdate = (
				SELECT MAX(tgt2.rescentUpdate)
				FROM employee_tgt tgt2
				WHERE tgt2.employeeId = tgt.employeeId
);

			END

		ELSE
			BEGIN
    INSERT INTO employee_tgt (employeeId, employee_name, rescentUpdate)
    SELECT src.id, src.employee_name,  GETDATE()
    FROM employee_src src
    LEFT JOIN employee_tgt tgt ON src.id = tgt.employeeId
    WHERE tgt.employeeId IS NULL;

    
    INSERT INTO employee_tgt (employeeId, employee_name, rescentUpdate)
    SELECT src.id, src.employee_name,  GETDATE()
    FROM employee_src src
    INNER JOIN employee_tgt tgt ON src.id = tgt.employeeId
    WHERE src.employee_name <> tgt.employee_name
    AND tgt.rescentUpdate = (
        SELECT MAX(tgt2.rescentUpdate)
        FROM employee_tgt tgt2
        WHERE tgt2.employeeId = tgt.employeeId
    );

				
	END
END;



exec Syncb 