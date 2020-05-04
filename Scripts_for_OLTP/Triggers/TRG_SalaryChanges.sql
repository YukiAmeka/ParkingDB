CREATE TRIGGER TRG_SalaryChanges
ON Staff.Employees
FOR UPDATE
AS

BEGIN

SET NOCOUNT ON;

DECLARE 
@SalaryStartDateID INT,
@SalaryEndDateID INT,
@EmployeeId INT,
@Salary DECIMAL (8,2),
@CountRows INT,
@Cycle INT
SET @CountRows = (SELECT Count (*) FROM Deleted) ---counts how many records are in Deleted table
SET @Cycle = 1	
WHILE @Cycle <= @CountRows
	BEGIN
	SET @EmployeeId = (SELECT EmployeeID FROM Deleted WHERE Deleted.EmployeeID = @Cycle)
	SET @Salary = (SELECT Salary FROM Deleted WHERE Deleted.EmployeeID = @Cycle)
	IF EXISTS (SELECT EmployeeID FROM Staff.SalaryChanges WHERE EmployeeID = @EmployeeId) ----checks if emp exists in table SalaryChanges
		BEGIN
			SET @SalaryStartDateID = (SELECT TOP (1) SalaryEndDateID FROM Staff.SalaryChanges
					WHERE EmployeeID = @EmployeeId ORDER BY SalaryChangeID DESC) 
			SET @SalaryEndDateID = (SELECT DateId FROM Services.CalendarDates WHERE TheDate = CONVERT (DATE, GETDATE()))
			INSERT INTO Staff.SalaryChanges ( EmployeeId, salary, SalaryStartDateID, SalaryEndDateID)
						VALUES (@EmployeeId, @Salary, @SalaryStartDateID, @SalaryEndDateID)
		END
	ELSE
		BEGIN
			SET @SalaryStartDateID = (SELECT DateHired FROM Staff.Employees 
					WHERE EmployeeID = @EmployeeId)
			SET @SalaryEndDateID = (SELECT DateId FROM Services.CalendarDates WHERE TheDate = CONVERT (DATE, GETDATE()))
			INSERT INTO Staff.SalaryChanges ( EmployeeId, salary, SalaryStartDateID, SalaryEndDateID)
					VALUES (@EmployeeId, @Salary, @SalaryStartDateID, @SalaryEndDateID)
			END
	SET @Cycle = @Cycle + 1
	END
END