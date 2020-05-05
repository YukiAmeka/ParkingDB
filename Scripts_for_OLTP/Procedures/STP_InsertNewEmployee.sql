 -- ===================================================================================================================================================
/*
Author:	Mariia Terletska
Create date: 2020-05-05
Short description: Insert a new Employee to Parking DB
Initial ticket number: DEMO2
Modifications: <2020-05-05>, <Mariia>, [<DEMO2>] - <changes description> ...
*/
-- ===================================================================================================================================================

ALTER PROCEDURE STP_InsertNewEmployee (
		@FirstName VARCHAR(50)
		,@Surname VARCHAR(50)
		,@Gender CHAR(1)
		,@DateOfBirth DATE
		,@PhoneNumber VARCHAR(50)
		,@Email VARCHAR(100)
		,@CityName VARCHAR(50)
		,@HomeAddress VARCHAR(200)
		,@LotName VARCHAR(50)
		,@DateHired DATE
		,@Position VARCHAR(50)
		,@Salary DECIMAL(8,2)
		,@Manager VARCHAR(100)
		,@Msg NVARCHAR(MAX) OUTPUT
)	
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

			DECLARE
				@CityID INT
				,@LotID INT
				,@EmployeePositionID INT
				,@ManagerID INT
				,@DateHiredID INT

			SET @CityID = (SELECT CityID FROM Location.Cities WHERE CityName = @CityName)
			SET @LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
			SET @EmployeePositionID = (SELECT PositionID FROM Staff.Positions WHERE Title = @Position)
			IF @EmployeePositionID = 1 
				SET @ManagerID = (SELECT EmployeeID FROM Staff.Employees 
							  WHERE FirstName = (SELECT LTRIM(RTRIM(SUBSTRING(@Manager, 0, CHARINDEX(' ', @Manager + ' ')))))
							  AND Surname = (SELECT LTRIM(RTRIM(SUBSTRING(@Manager, CHARINDEX(' ', @Manager + ' ') + 1, 8000))))
							  AND LotID = @LotID 
							  AND CityID = @CityID
							  AND PositionID = 2)
			ELSE IF @EmployeePositionID = 4
				SET @ManagerID = (SELECT EmployeeID FROM Staff.Employees 
							  WHERE FirstName = (SELECT LTRIM(RTRIM(SUBSTRING(@Manager, 0, CHARINDEX(' ', @Manager + ' ')))))
							  AND Surname = (SELECT LTRIM(RTRIM(SUBSTRING(@Manager, CHARINDEX(' ', @Manager + ' ') + 1, 8000))))
							  AND LotID = @LotID 
							  AND CityID = @CityID
							  AND PositionID = 5)
		    ELSE 
				SET @ManagerID = (SELECT EmployeeID FROM Staff.Employees 
							  WHERE FirstName = (SELECT LTRIM(RTRIM(SUBSTRING(@Manager, 0, CHARINDEX(' ', @Manager + ' ')))))
							  AND Surname = (SELECT LTRIM(RTRIM(SUBSTRING(@Manager, CHARINDEX(' ', @Manager + ' ') + 1, 8000))))
							  AND LotID = @LotID 
							  AND CityID = @CityID
							  AND PositionID = 3)
			SET @DateHiredID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @DateHired)

			IF NOT EXISTS (SELECT 1 FROM Staff.Employees WHERE  FirstName = @FirstName AND Surname = @Surname AND DateOfBirth = @DateOfBirth AND Email = @Email) 		
			BEGIN 
				PRINT 'Insert into Employee table'
				INSERT INTO Staff.Employees (FirstName, Surname, Gender, DateOfBirth, PhoneNumber, Email, CityID, HomeAddress, LotID, DateHired, PositionID, Salary, ManagerID)
					VALUES
					(
					 @FirstName
					,@Surname 
					,@Gender 
					,@DateOfBirth 
					,@PhoneNumber 
					,@Email 
					,@CityID
					,@HomeAddress 
					,@LotID 
					,@DateHiredID
					,@EmployeePositionID
					,@Salary 
					,@ManagerID 
					)

				SET @Msg='Table Details Saved Successfully.'
			END
				ELSE
					SET @Msg = @FirstName + ' ' + @Surname + 'A person under such FirstName and Surname already exists. Enter another data.'
					PRINT @Msg	
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		SET @Msg = ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END

/*
Sample execution: 
DECLARE
@Msg NVARCHAR(MAX)
EXEC STP_InsertNewEmployee 
			@FirstName ='Petro'
			,@Surname = 'Petrenko' 
			,@Gender = 'm' 
			,@DateOfBirth = '1982-04-21' 
			,@PhoneNumber = '+44 0354 5478952' 
			,@Email = 'petro.petrenko@gmail.com' 
			,@CityName = 'Bristol' 
			,@HomeAddress = '519-11 Nec Rd.' 
			,@LotName = 'B-1' 
			,@DateHired = '2020-05-05' 
			,@Position = 'Parking Attendant' 
			,@Salary = '2000' 
			,@Manager = 'Timothy Love'
			,@Msg = @Msg OUTPUT

			PRINT @Msg

*/
 


