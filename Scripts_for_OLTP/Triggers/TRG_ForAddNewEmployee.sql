ALTER TRIGGER TR_VW_EmployeeContactInformation
ON VW_EmployeeContactInformation
INSTEAD OF INSERT
AS

BEGIN

	DECLARE @CityID INT
	DECLARE @LotID INT
	DECLARE @PositionID INT
	DECLARE @HiredID INT
	DECLARE @ManagerID INT

	SELECT @CityID = CityID
	FROM [Location].[Cities] AS Cities
	INNER JOIN inserted
	ON inserted.CityName = Cities.CityName
 
	SELECT @LotID = LotID
	FROM [Parking].[Lots]  AS Lots
	INNER JOIN inserted
	ON inserted.LotName = Lots.[LotName]

	SELECT @PositionID = PositionID
	FROM [Staff].[Positions] AS P
	INNER JOIN inserted
	ON inserted.Title = P.Title

	SELECT @HiredID = DateID
	FROM [Services].[CalendarDates] AS Hired
	INNER JOIN inserted
	ON inserted.Hired = Hired.TheDate


	SELECT @ManagerID = Manager
	FROM [Staff].[Employees] AS E
	INNER JOIN inserted
	ON inserted.Manager = E.EmployeeID

	BEGIN TRY  
		DECLARE @ErrorMsg VARCHAR(255)

		IF(@CityID IS NULL)
			BEGIN
				SET @ErrorMsg = 'Invalid City name . Statement terminated'
				RAISERROR(@ErrorMsg, 16, 1)
				RETURN
			END

		IF(@LotID IS NULL)
			BEGIN
				SET @ErrorMsg = 'Invalid Lot name . Statement terminated'
				RAISERROR(@ErrorMsg, 16, 1)
				RETURN
			END

		IF(@PositionID IS NULL)
			BEGIN
				SET @ErrorMsg = 'Invalid Position name . Statement terminated'
				RAISERROR(@ErrorMsg, 16, 1)
				RETURN
			END

		IF(@HiredID IS NULL)
			BEGIN
				SET @ErrorMsg = 'Invalid Lot name . Statement terminated'
				RAISERROR(@ErrorMsg, 16, 1)
				RETURN
		END

		IF(@CityID IS NULL)
			BEGIN
				SET @ErrorMsg = 'Invalid @ManagerID name . Statement terminated'
				RAISERROR(@ErrorMsg, 16, 1)
				RETURN
			END

	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT @ErrorMsg
	END CATCH

		INSERT  INTO [Staff].[Employees](FirstName, Surname, Gender, DateOfBirth, PhoneNumber, Email, CityID, HomeAddress,
		LotID, DateHired,  PositionID, Salary, ManagerID)
		SELECT  FirstName, Surname, Gender, DateOfBirth, PhoneNumber, Email, @CityID, HomeAddress,
		@LotID, @HiredID,  @PositionID, Salary, @ManagerID
		FROM inserted

END