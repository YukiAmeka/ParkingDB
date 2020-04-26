CREATE PROCEDURE STP_GeneratingCurEmployees
AS

BEGIN

DECLARE 
@LotID INT,
@DateHired INT,
@K INT,
@CityID INT,
@EmployeeID INT,
@AttCity INT,
@A INT


--Selecting data from EmployeeTemp table for 19 main positions
INSERT INTO Staff.Employees(FirstName, Surname, Gender, DateOfBirth, PhoneNumber, Email, HomeAddress) 
SELECT TOP (129) FirstName, Surname, Gender, DateOfBirth, PhoneNumber, Email, HomeAddress
FROM TempEmployee

UPDATE TempEmployee
SET IsUsed = 1
WHERE EmployeeID BETWEEN 1 AND 129


--Setting DateID for DateHired from Calendar
SET @DateHired = (SELECT DateID FROM [Services].[CalendarDates]
				WHERE TheDate = '2015-01-01')

UPDATE Staff.Employees
SET CityID = 1, DateHired = @DateHired, PositionID = 3, Salary = 5000
WHERE EmployeeID = 1

UPDATE Staff.Employees 
SET CityID = 1, DateHired = @DateHired, PositionID = 5, Salary = 3600, ManagerID = 1
WHERE EmployeeID = 2

UPDATE Staff.Employees
SET CityID = 1, DateHired = @DateHired, PositionID = 7, Salary = 4000, ManagerID = 1
WHERE EmployeeID = 3

SET @K = 1
SET @CityID = 1
SET @EmployeeID = 3

WHILE @K <= 8
BEGIN
	SET @EmployeeID = @EmployeeID + 1

	UPDATE Staff.Employees
	SET CityID = @CityID, DateHired = @DateHired, PositionID = 4, Salary = 2800, ManagerID = 2
	WHERE EmployeeID = @EmployeeID

	SET @EmployeeID = @EmployeeID + 1

	UPDATE Staff.Employees
	SET CityID = @CityID, DateHired = @DateHired, PositionID = 6, Salary = 2000, ManagerID = 1
	WHERE EmployeeID = @EmployeeID

	SET @CityID = @CityID + 10

	SET @K = @K + 1
END

--###########################################

--Generating Parking Attendants and Managers data
SET @LotID = 1
SET @EmployeeID = 19

WHILE @LotID <= 22
BEGIN

	IF @LotID BETWEEN 1 AND 8 SET @CityID = 1
	IF @LotID BETWEEN 9 AND 11 SET @CityID = 11
	IF @LotID BETWEEN 12 AND 14 SET @CityID = 21
	IF @LotID BETWEEN 15 AND 16 SET @CityID = 31
	IF @LotID BETWEEN 17 AND 18 SET @CityID = 41
	IF @LotID BETWEEN 19 AND 20 SET @CityID = 51
	IF @LotID = 21 SET @CityID = 61
	IF @LotID = 22 SET @CityID = 71

	SET @EmployeeID = @EmployeeID + 1
	UPDATE Staff.Employees
	SET CityID = @CityID, DateHired = @DateHired, LotID = @LotID, PositionID = 2, Salary = 2200, ManagerID = 1
	WHERE EmployeeID = @EmployeeID

	SET @A = 1
	WHILE @A <= 4
		BEGIN
			
			SET @AttCity = (SELECT TOP (1) CityID FROM [Location].[Cities]
							WHERE CityID BETWEEN @CityID AND @CityID+9
							ORDER BY NEWID())

			UPDATE Staff.Employees
			SET CityID = @AttCity, DateHired = @DateHired, LotID = @LotID, PositionID = 1, Salary = 1700, ManagerID = @EmployeeID
			WHERE EmployeeID = @EmployeeID + @A
			SET @A = @A + 1

		END
	SET @EmployeeID = @EmployeeID + 4
	SET @LotID = @LotID + 1

--END WHILE	
END

--Marking used Employees in TempEmployee table
--UPDATE  dbo.TempEmployee
--SET dbo.TempEmployee.IsUsed = 1
--WHERE EmployeeID BETWEEN 1 AND 129

END





--TRUNCATE TABLE  [dbo].[EmployeesTest]