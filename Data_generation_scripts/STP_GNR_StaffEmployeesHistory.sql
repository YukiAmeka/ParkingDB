
/* At one of our meetings, we have decided to create datamart for our employees too. 
So our first task was merging information about salary and position changes from different tables. 
Unfortunately, I couldn't do that using views only, so I have written a stored procedure to solve this issue.  
We have three main tables where we store different information about our staff. 
Table "StaffEmployees" is used for the main information about every employee. 
 The information about active staff and about fired employees is also stored here. 
Tables "StaffSalaryChanges" and "StaffPositionChanges" are used to store some events 
as position change or salary change during the working period for every employee. 
   */


CREATE PROCEDURE STP_GNR_StaffEmployeesHistory

AS


BEGIN                --BEGIN of Procedure

IF (OBJECT_ID('tempdb..#SalaryHistory') IS NOT NULL) DROP TABLE #SalaryHistory
IF (OBJECT_ID('tempdb..#PositionHistory') IS NOT NULL) DROP TABLE #PositionHistory

TRUNCATE TABLE Staff.EmployeesHistory

/*To solve this issue I've divided this process into three steps. 
On the first step I've merged most important data from "StaffEmployees" and "StaffSalaryChanges" 
and stored the result in the temporary table "#SalaryHistory".
The following step included merging "#SalaryHistory" and “StaffPositioChanges” 
with storing the result in #PositionHistory.
And on the last step, I've removed some duplicates and chosen only these columns 
that I am going to use in the table of facts for future datamart.
*/


CREATE TABLE #SalaryHistory
(
EmployeeID INT,
Salary DECIMAL(8,2),
SalaryStartDateID INT,
SalaryEndDateID INT
)


CREATE TABLE #PositionHistory
(
EmployeeID INT,
PositionID INT,
PositionStartDateID INT,
PositionEndDateID INT,
NewEmployeeID INT
)


DECLARE
@EmployeeID INT,
@Salary DECIMAL(8,2),
@SalaryStartDateID INT,
@SalaryEndDateID INT,
@cycle INT,
@EmployeeNumber INT,

@NewEmployeeID INT,
@PositionEndDateID INT,
@PositionID INT,
@PositionStartDateID INT,
@SalaryHistoryNumber INT

SET @EmployeeNumber = IDENT_CURRENT('Staff.Employees')
SET @cycle = 1

/*This cycle checks every employee for the availability of information in "StaffSalaryChanges"
And depending on the situation chooses some solution to create a salary history.
If an employee has some records in "StaffSalaryChanges" we store them into "#SalaryHistory" 
and add one record with a current salary that is stored in "StaffEmployees" only. 
Otherwise, our salary history contains just current information
*/
WHILE @cycle <= @EmployeeNumber
	BEGIN                      --WHILE 1
		IF EXISTS (SELECT e.EmployeeID
					FROM Staff.Employees AS e
					JOIN Staff.SalaryChanges AS s
					ON s.EmployeeID = e.EmployeeID
					WHERE e.EmployeeID = @cycle)
			BEGIN
				INSERT INTO #SalaryHistory (EmployeeID, Salary, SalaryStartDateID, SalaryEndDateID)
					SELECT e.EmployeeID, s.Salary, s.SalaryStartDateID, s.SalaryEndDateID
						FROM Staff.Employees AS e
						JOIN Staff.SalaryChanges AS s
						ON s.EmployeeID = e.EmployeeID
						WHERE e.EmployeeID = @cycle

						
						SET @EmployeeID = @cycle

						SET @Salary            = (SELECT Salary 
						                          FROM Staff.Employees 
												  WHERE EmployeeID = @EmployeeID) 

						SET @SalaryStartDateID = (SELECT MAX(SalaryEndDateID) + 1 
						                          FROM Staff.SalaryChanges
												  WHERE EmployeeID = @EmployeeID)

						SET @SalaryEndDateID  = (SELECT DateFired 
												  FROM Staff.Employees 
												  WHERE EmployeeID = @EmployeeID)


				INSERT INTO #SalaryHistory (EmployeeID, Salary, SalaryStartDateID, SalaryEndDateID)
					VALUES (@EmployeeID, @Salary, @SalaryStartDateID, @SalaryEndDateID)
					

			END

		ELSE
			BEGIN
				
						SET @EmployeeID = @cycle

						SET @Salary            = (SELECT Salary 
						                          FROM Staff.Employees 
												  WHERE EmployeeID = @EmployeeID) 

						SET @SalaryStartDateID = (SELECT DateHired
						                          FROM Staff.Employees
												  WHERE EmployeeID = @EmployeeID)

						SET @SalaryEndDateID  = (SELECT DateFired 
												  FROM Staff.Employees 
												  WHERE EmployeeID = @EmployeeID)


				INSERT INTO #SalaryHistory (EmployeeID, Salary, SalaryStartDateID, SalaryEndDateID)
					VALUES (@EmployeeID, @Salary, @SalaryStartDateID, @SalaryEndDateID)
			END
			
	
	SET @cycle = @cycle + 1                        
	END                       --WHILE 1

/*In this cycle, I've used the same approach to create a history of position changes for every employee.
The result is stored in "#SalaryHistory"
Here we have a bit more conditions because 
after promotion from the parking attendant to the parking manager 
the last one gets a new "ID"  in "StaffEmployee". 
To solve this issue we have decided to create some business key 
that helps us to attach some records with different ID to one person. 
*/	
--#################################################

SET @SalaryHistoryNumber = (SELECT COUNT(*) FROM #SalaryHistory)
SET @cycle = 1

WHILE @cycle <= @SalaryHistoryNumber
	BEGIN                         --WHILE 2
		IF EXISTS (SELECT s.EmployeeID 
					FROM #SalaryHistory AS s
					JOIN Staff.PositionChanges AS p
					ON s.EmployeeID = p.EmployeeID
					WHERE s.EmployeeID = @cycle)
			BEGIN												--IF EXISTS
					SET @NewEmployeeID = (SELECT NewEmployeeID 
											FROM Staff.PositionChanges
											WHERE EmployeeID = @cycle)
				
					IF @NewEmployeeID IS NOT NULL
						INSERT INTO #PositionHistory (EmployeeID, PositionID, PositionStartDateID, PositionEndDateID, NewEmployeeID)
						SELECT s.EmployeeID, p.PositionID, p.PositionStartDateID, p.PositionEndDateID, p.NewEmployeeID 
							FROM #SalaryHistory AS s
							JOIN Staff.PositionChanges AS p
							ON s.EmployeeID = p.EmployeeID
							WHERE s.EmployeeID = @cycle

					ELSE
						BEGIN
							
							INSERT INTO #PositionHistory (EmployeeID, PositionID, PositionStartDateID, PositionEndDateID, NewEmployeeID)
						    SELECT s.EmployeeID, p.PositionID, p.PositionStartDateID, p.PositionEndDateID, p.NewEmployeeID 
								FROM #SalaryHistory AS s
								JOIN Staff.PositionChanges AS p
								ON s.EmployeeID = p.EmployeeID
								WHERE s.EmployeeID = @cycle

							SET @PositionEndDateID = (SELECT DateFired 
													   FROM Staff.Employees 
													   WHERE EmployeeID = @cycle)

							SET @NewEmployeeID =     (SELECT TOP(1) EmployeeID 
												      FROM #PositionHistory
											          WHERE EmployeeID = @cycle)

							UPDATE #PositionHistory
								SET PositionEndDateID = @PositionEndDateID, NewEmployeeID = @NewEmployeeID
								WHERE  EmployeeID = @cycle
						
						END
						
						

			END														--IF EXISTS

		ELSE
			BEGIN
				INSERT INTO #PositionHistory (EmployeeID, PositionID, PositionStartDateID, PositionEndDateID, NewEmployeeID)
				SELECT s.EmployeeID, p.PositionID, p.PositionStartDateID, p.PositionEndDateID, p.NewEmployeeID 
					FROM #SalaryHistory AS s
					LEFT JOIN Staff.PositionChanges AS p
					ON s.EmployeeID = p.EmployeeID
					WHERE s.EmployeeID = @cycle

				SET @NewEmployeeID =       (SELECT TOP(1) EmployeeID 
									         FROM #SalaryHistory
									         WHERE EmployeeID = @cycle)

				SET @PositionID =          (SELECT PositionID 
											 FROM Staff.Employees
											 WHERE EmployeeID = @cycle)

				SET @PositionStartDateID = (SELECT DateHired 
											 FROM Staff.Employees
											 WHERE EmployeeID = @cycle)

				SET @PositionEndDateID =    (SELECT DateFired 
											  FROM Staff.Employees 
											  WHERE EmployeeID = @cycle)

				UPDATE #PositionHistory
					SET PositionID = @PositionID,
						PositionStartDateID = @PositionStartDateID,   
						PositionEndDateID = @PositionEndDateID, 
					    NewEmployeeID = @NewEmployeeID
					WHERE  EmployeeID = @cycle


			END
	
	SET @cycle = @cycle + 1  
	END                           --WHILE 2
 

/*Inventualy, I have merged information from all temporary tables 
to get all information about all changes for every employee.
This table is used as the main source for the table of fact for datamart. 
 */
INSERT INTO Staff.EmployeesHistory

SELECT DISTINCT p.NewEmployeeID, s.Salary,
				 (SELECT TheDate FROM Services.CalendarDates WHERE DateID = s.SalaryStartDateID) AS SalaryStartDate,
				 (SELECT TheDate FROM Services.CalendarDates WHERE DateID = s.SalaryEndDateID) AS SalaryEndDate,
				 (SELECT Title  FROM Staff.Positions WHERE PositionID =  p.PositionID) AS Position,
				 (SELECT TheDate FROM Services.CalendarDates WHERE DateID = p.PositionStartDateID) AS PositionStartDate, 
				 (SELECT TheDate FROM Services.CalendarDates WHERE DateID = p.PositionEndDateID) AS PositionEndDate, 
				 (SELECT TheDate FROM Services.CalendarDates WHERE DateID = e.DateHired) AS DateHired, 
				 (SELECT TheDate FROM Services.CalendarDates WHERE DateID = e.DateFired) AS DateFired, 
				 e.LotID, e.ManagerID
	  
 FROM #SalaryHistory AS s
 JOIN #PositionHistory AS p
 ON s.EmployeeID = p.EmployeeID
 JOIN Staff.Employees AS e
 ON s.EmployeeID = e.EmployeeID
 --WHERE s.EmployeeID IN (111,210)
 ORDER BY NewEmployeeID


 END                      --END of Procedure
 --################################


--EXECUTE STP_GNR_StaffEmployeesHistory

--SELECT * FROM Staff.EmployeesHistory

