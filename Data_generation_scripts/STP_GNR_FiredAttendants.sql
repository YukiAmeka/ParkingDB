CREATE PROCEDURE STP_FireAtt
AS
BEGIN


DECLARE
@RandEmpID int,
@NewAttedID int, 
@CityId int,
@LotID int,
@ManagerID int,
@FiredEmployeeID int ,
@AmountOfFired int,
@K int ,
@DateStart int,
@DateEnd int,
@DateStep int

SET @DateStart = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = '2015-06-01')
SET @DateEnd = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = '2020-01-01')

SET @DateStep = 185


WHILE @DateStart <= @DateEnd
   BEGIN


SET @AmountOfFired = (SELECT FLOOR(RAND()*(10-5)+5))



SET @K = 1

WHILE @K <= @AmountOfFired
  BEGIN
       

-- Selecting random attendant to fire
 SET @FiredEmployeeID =(	 SELECT TOP(1)EmployeeID
	 FROM Staff.Employees
	 WHERE PositionID = 1 AND DateFired IS NULL
	 ORDER BY NEWID())




	 -- Firing old attendant
	 UPDATE Staff.Employees
	 SET DateFired = @DateStart                       
	 WHERE EmployeeID = @FiredEmployeeID

SET @CityId = (SELECT CityID FROM Staff.Employees 
			      WHERE EmployeeID = @FiredEmployeeID)

SET @LotID = (SELECT LotID FROM Staff.Employees 
			      WHERE EmployeeID = @FiredEmployeeID)

SET @ManagerID = (SELECT ManagerID FROM Staff.Employees 
			      WHERE EmployeeID = @FiredEmployeeID)

-- Hiring a new parking attendant:
       -- Inserting data from TempEmployee table
	   -- Getting random EmployeeID from TempEmployee 
	   SET @RandEmpID = (SELECT TOP(1) EmployeeID 
					     FROM TempEmployee
						 WHERE IsUsed = 0
						 ORDER BY NEWID())
					 

       -- Inserting random Employee instead of fired parking attendent     
       INSERT INTO  Staff.Employees (FirstName, Surname, Gender, DateOfBirth, PhoneNumber, 
	                                 Email, HomeAddress) 
                             SELECT  FirstName, Surname, Gender, DateOfBirth, PhoneNumber, 
							         Email, HomeAddress
                             FROM TempEmployee 
                             WHERE EmployeeID = @RandEmpID
		 
		 -- Update column 'IsUsed' in TempEmployee table		
	    UPDATE TempEmployee SET IsUsed = 1 WHERE EmployeeID = @RandEmpID


		SET @NewAttedID = (SELECT IDENT_CURRENT('Staff.Employees'))


       --  Adding the rest data for new parking attendant
       UPDATE Staff.Employees 
       SET CityID = @CityId , LotID = @LotID, DateHired = @DateStart + 1, PositionID = 1,
                      Salary = 1700, ManagerID = @ManagerID                                       
       WHERE EmployeeID = @NewAttedID

	   SET @K = @K + 1

	   END                                                                                        -- WHILE 2
	   
	   SET  @DateStart = @DateStart + @DateStep
	   
	   END                                                                                    -- WHILE 1
	   
	   END																							-- Procedure


	   
	   
     


