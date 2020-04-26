

CREATE PROCEDURE STP_GNR_SalaryChanges

AS

BEGIN




--CREATE TABLE #SalaryChangesTemp (
--   SalaryChangeID int NOT NULL PRIMARY KEY IDENTITY,
--   EmployeeID int NULL,
--   Salary decimal(8,2) NULL,
--   SalaryStartDateID int NULL,
--   SalaryEndDateID int NULL
--);

DECLARE 
@DateStart int,
@EndDate INT,
@DateStep INT,
@EmployeeID INT,
@SalaryNew DECIMAL (8,2),
@SalaryOld DECIMAL (8,2),
@SalaryStartDateID INT,
@SalaryEndDateID INT,
@Position INT,
@Lot INT,
@City INT,
@Cycle INT,
@DateFired INT,
@DateHired INT,
@A INT

SET @DateStart = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = '2015-07-02')
SET @EndDate = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = '2019-07-10')

SET @DateStep = 366


SET @A = (SELECT IDENT_CURRENT('Staff.Employees'))  -- takes last EmployeeID 

WHILE @DateStart <= @EndDate      
BEGIN                   --WHILE 1  generates for all years
SET @Cycle = 1
WHILE @Cycle <=  @A     --WHILE 2 generates for all employees
BEGIN
	SET @EmployeeID = @Cycle
	SET @DateFired = (SELECT DateFired FROM Staff.Employees WHERE EmployeeID = @Cycle)
	SET @DateHired = (SELECT DateHired FROM Staff.Employees WHERE EmployeeID = @EmployeeID)
	IF  (@DateFired IS NULL AND @DateStart >= @DateHired + 180 ) 
		OR  (@DateFired >  @DateStart AND @DateStart >= @DateHired + 180)  
		BEGIN
			SET @SalaryOld = (SELECT salary FROM Staff.Employees WHERE EmployeeID = @EmployeeID)
			IF EXISTS (SELECT EmployeeID FROM Staff.SalaryChanges WHERE EmployeeID = @EmployeeId)
				BEGIN
					SET @SalaryStartDateID = (SELECT TOP (1)SalaryEndDateID FROM Staff.SalaryChanges   
								WHERE EmployeeID = @EmployeeId ORDER BY SalaryChangeID DESC) + 1   
					SET @SalaryEndDateID = @DateStart
				END
			ELSE
				BEGIN	
					SET @SalaryStartDateID = (SELECT DateHired FROM Staff.Employees WHERE EmployeeID = @EmployeeID)
					SET @SalaryEndDateID =  @DateStart
				END
			 
			SET @Position = (SELECT PositionID FROM Staff.Employees WHERE EmployeeID = @EmployeeID) 
			SET @Lot = (SELECT LotID FROM Staff.Employees WHERE EmployeeID = @EmployeeID)
			SET @City = (SELECT CityID FROM Parking.Lots WHERE LotID = @Lot)
			SET @SalaryNew = CASE
						WHEN @Position = 1 AND @City = 1 THEN ROUND(@SalaryOld *  1.08,1,1)
						WHEN @Position = 1 AND @City = 11 THEN ROUND(@SalaryOld * 1.05,1,1)
						WHEN @Position = 1 AND @City = 21 THEN ROUND(@SalaryOld * 1.05,1,1)
						WHEN @Position = 1 AND @City = 31 THEN ROUND(@SalaryOld * 1.04,1,1)
						WHEN @Position = 1 AND @City = 41 THEN ROUND(@SalaryOld * 1.04,1,1)
						WHEN @Position = 1 AND @City = 51 THEN ROUND(@SalaryOld * 1.04,1,1)
						WHEN @Position = 1 AND @City = 61 THEN ROUND(@SalaryOld * 1.03,1,1)
						WHEN @Position = 1 AND @City = 71 THEN ROUND(@SalaryOld * 1.03,1,1)
						
						WHEN @Position = 2 AND @City = 1 THEN ROUND(@SalaryOld * 1.12,1,1)
						WHEN @Position = 2 AND @City = 11 THEN ROUND(@SalaryOld * 1.09,1,1)
						WHEN @Position = 2 AND @City = 21 THEN ROUND(@SalaryOld * 1.09,1,1)
						WHEN @Position = 2 AND @City = 31 THEN ROUND(@SalaryOld * 1.08,1,1)
						WHEN @Position = 2 AND @City = 41 THEN ROUND(@SalaryOld * 1.08,1,1)
						WHEN @Position = 2 AND @City = 51 THEN ROUND(@SalaryOld * 1.08,1,1)
						WHEN @Position = 2 AND @City = 61 THEN ROUND(@SalaryOld * 1.07,1,1)
						WHEN @Position = 2 AND @City = 71 THEN ROUND(@SalaryOld * 1.07,1,1)

						WHEN @Position = 3 THEN ROUND(@SalaryOld * 1.15,1,1)

						ELSE ROUND(@SalaryOld * 1.06,1,1)
						END
			UPDATE Staff.Employees
				SET Salary = @SalaryNew WHERE EmployeeID = @EmployeeID
			INSERT INTO Staff.SalaryChanges (EmployeeID, Salary, SalaryStartDateID, SalaryEndDateID) VALUES
									(@EmployeeID, @SalaryOld, @SalaryStartDateID, @SalaryEndDateID)
		END   --- if
	
		SET @Cycle = @Cycle + 1	
	
	END  --WHILE 2

	SET @DateStart = @DateStart + @DateStep
	PRINT @DateStart

END   --WHILE 1

END



--TRUNCATE TABLE Staff.SalaryChanges
--DBCC CHECKIDENT('[Staff].[SalaryChanges]', RESEED, 0)
