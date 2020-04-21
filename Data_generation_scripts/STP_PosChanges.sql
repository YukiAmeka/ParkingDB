CREATE PROCEDURE STP_PositionChanges
AS

	BEGIN

-- Creating table for staging attendant information during promotion to manager position 
CREATE TABLE #ChangePosition (
   EmployeeID int,
   Photo IMAGE,
   FirstName varchar(50),
   Surname varchar(50),
   Gender char(1),
   DateOfBirth date,
   PhoneNumber varchar(50),
   Email varchar(100),
   CityID int,
   HomeAddress varchar(200),
   LotID int,
   DateHired int,
   PositionID int,
   Salary decimal(8,2),
   ManagerID int,
   DateFired int
   )

  --Creating temporary table for @LotMAXNumber attendants(future manager) 
	



DECLARE 
@StartDate INT,    -- Start of position changes period
@EndDate INT,      -- End of period
@Counter INT,      --
@LotNumber INT,    -- current number of fired parking manager during chosen time period 
@LotMAXNumber INT, -- Max number of fired parking manager during chosen time period 
@EmpID INT,
@EmployeeID INT,
@LotID INT,
@RandEmpID INT,
@ManagerID INT,
@NewAttedID INT,
@DateStep INT




 SET @StartDate = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = '2015-07-01')
 SET @EndDate =   (SELECT DateID FROM Services.CalendarDates WHERE TheDate = '2020-01-01')



 SET @DateStep = 185
 
WHILE @StartDate <= @EndDate                     --WHILE 2
BEGIN



                                                      
--Using temporary table for @LotMAXNumber attendants(future manager) 
                      --  from @LotMAXNumber random lots
	CREATE TABLE #Lots (
	ID INT IDENTITY,
	LotID INT, 
	EmployeeID INT)
  
   INSERT INTO #Lots (LotID)
   SELECT TOP(4) LotID
   FROM Parking.Lots
   ORDER BY NEWID()

   SET @LotNumber = 1
   SET @LotMAXNumber = 4
    
	WHILE @LotNumber <= @LotMAXNumber                -- WHILE 2
       BEGIN
	    UPDATE #Lots SET EmployeeID = 
	      (SELECT TOP(1) EmployeeID 
	       FROM Staff.Employees
           WHERE LotID = (SELECT LotID 
		                  FROM #Lots 
						  WHERE ID = @LotNumber) AND PositionID = 1 AND DateFired IS NULL)
						  
	    WHERE ID = @LotNumber

	    SET @LotNumber = @LotNumber + 1
		  
	   END                                        -- for WHILE 2
	
 
--################################################

-- The process of attendants promotion:
--Stage1: Getting EmployeeID and LotID for chosen @LotMAXNumber attendant from 
-- random generated temporary table #Lots
     SET @EmpID = 1
     WHILE @EmpID <= @LotMAXNumber                                 --WHILE 3
	   BEGIN


	     
	     SET @EmployeeID = (SELECT EmployeeID 
	                      FROM #Lots 
						  WHERE ID = @EmpID) 

	     SET @LotID = (SELECT LotID
	                      FROM #Lots
						  WHERE ID = @EmpID) 


  
-- Stage2: Inserting all data about chosen attendant into #ChangePosition
        INSERT INTO #ChangePosition 
        SELECT * FROM Staff.Employees
        WHERE EmployeeID = @EmployeeID
	   
-- Stage3: Fire attendent and put him 'DateFired'
        UPDATE Staff.Employees
        SET DateFired = @StartDate                           
        WHERE EmployeeID = @EmployeeID
	   
-- Stage4: Fire manager and put him 'DateFired'
        UPDATE Staff.Employees
        SET DateFired = @StartDate                             
        WHERE PositionID = 2 AND LotID = @LotID

-- Stage5: Attendant becomes a new parking manager
        INSERT INTO Staff.Employees (Photo, FirstName, Surname, Gender, DateOfBirth, 
		                             PhoneNumber, Email, CityID, HomeAddress, LotID, 
									 DateHired, PositionID, Salary, ManagerID )
                             SELECT  Photo, FirstName, Surname, Gender, DateOfBirth, 
							         PhoneNumber, Email, CityID, HomeAddress, LotID, 
									 @StartDate + 1, 2, 2200, 1   
                             FROM #ChangePosition 
	    
--      Get EmployeeID for new manager 
		SET @ManagerID = (SELECT IDENT_CURRENT('Staff.Employees'))

	

--    Set the rest attendants new manager ID
		UPDATE Staff.Employees
		SET ManagerID = @ManagerID
		WHERE PositionID = 1 and LotID = @LotID and DateFired is null
		

--Stage6: Hiring a new parking attendant:
       -- Inserting data from TempEmployee table
	   -- Getting random EmployeeID from TempEmployee 
	   SET @RandEmpID = (SELECT TOP(1) EmployeeID 
					     FROM TempEmployee
						 WHERE IsUsed = 0
						 ORDER BY NEWID())
       -- Inserting random Employee instead of promoted parking attendent     
       INSERT INTO  Staff.Employees (FirstName, Surname, Gender, DateOfBirth, PhoneNumber, 
	                                 Email, HomeAddress) 
                             SELECT  FirstName, Surname, Gender, DateOfBirth, PhoneNumber, 
							         Email, HomeAddress
                             FROM TempEmployee 
                             WHERE EmployeeID = @RandEmpID
		 
		 
		SET @NewAttedID = (SELECT IDENT_CURRENT('Staff.Employees'))



-- Update column 'IsUsed' in TempEmployee table	   
	    UPDATE TempEmployee SET IsUsed = 1 WHERE EmployeeID = @RandEmpID

       --  Adding the rest data for new parking attendant
       UPDATE Staff.Employees 
       SET CityID = (SELECT CityID FROM #ChangePosition), LotID = @LotID, 
                     DateHired = @StartDate + 1, PositionID = 1, Salary = 1700, ManagerID = @ManagerID  
       WHERE EmployeeID = @NewAttedID                                                                 

	   DELETE #ChangePosition

	   SET @EmpID = @EmpID + 1
     END -- for WHILE 3

     DROP TABLE #Lots

	 SET @StartDate = @StartDate + @DateStep
	
 

	 END -- for WHILE 1 

	 END -- Procedure




  


 

   
   

  
  
   
   
  

