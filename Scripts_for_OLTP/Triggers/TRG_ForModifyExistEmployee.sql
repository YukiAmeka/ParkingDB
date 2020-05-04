ALTER TRIGGER TR_VW_EmployeeContactInformationForUpdate
ON VW_EmployeeContactInformation
INSTEAD OF UPDATE
AS

BEGIN
	DECLARE @CityID INT
	DECLARE @LotID INT
	DECLARE @PositionID INT
	DECLARE @HiredID INT
	DECLARE @FiredID INT
	DECLARE @ManagerID INT

 
	IF(UPDATE(CityName)) 
		BEGIN
			SELECT @CityID = C.CityID
			FROM [Location].[Cities] AS C
			INNER JOIN inserted
			ON inserted.CityName = C.CityName
  
			IF(@CityID IS NULL )
			BEGIN
				RAISERROR('Invalid City Name', 16, 1)
				RETURN
			END
  
			UPDATE E SET CityID  = @CityID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END

	IF(UPDATE(LotName)) 
		BEGIN
			SELECT @LotID = L.LotID
			FROM [Parking].[Lots] AS L
			INNER JOIN inserted
			ON inserted.LotName = L.LotName
  
			IF(@LotID IS NULL )
			BEGIN
				RAISERROR('Invalid Lot Name', 16, 1)
				RETURN
			END
  
			UPDATE E SET LotID  = @LotID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END

	IF(UPDATE(Title)) 
		BEGIN
			SELECT @PositionID = PositionID
			FROM [Staff].[Positions] AS P
			INNER JOIN inserted
			ON inserted.Title = P.Title
  
			IF(@PositionID IS NULL )
			BEGIN
				RAISERROR('Invalid Position Name', 16, 1)
				RETURN
			END
  
			UPDATE E SET PositionID  = @PositionID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END

	IF(UPDATE(Title)) 
		BEGIN
			SELECT @PositionID = PositionID
			FROM [Staff].[Positions] AS P
			INNER JOIN inserted
			ON inserted.Title = P.Title
  
			IF(@PositionID IS NULL )
			BEGIN
				RAISERROR('Invalid Position Name', 16, 1)
				RETURN
			END
  
			UPDATE E SET PositionID  = @PositionID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END

	IF(UPDATE(Hired)) 
		BEGIN
			SELECT @HiredID = DateID
			FROM [Services].[CalendarDates] AS Hired
			INNER JOIN inserted
			ON inserted.Hired = Hired.TheDate
  
			IF(@HiredID IS NULL )
			BEGIN
				RAISERROR('Invalid date Hired ', 16, 1)
				RETURN
			END
  
			UPDATE E SET DateHired  = @HiredID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END

		IF(UPDATE(Fired)) 
		BEGIN
			SELECT @FiredID = DateID
			FROM [Services].[CalendarDates] AS Fired
			INNER JOIN inserted
			ON inserted.Fired = Fired.TheDate
  
			IF(@FiredID IS NULL )
			BEGIN
				RAISERROR('Invalid date Hired ', 16, 1)
				RETURN
			END
  
			UPDATE E SET DateFired  = @FiredID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END

		IF(UPDATE(Manager)) 
		BEGIN
			SELECT @ManagerID = Manager
			FROM [Staff].[Employees] AS E
			INNER JOIN inserted
			ON inserted.Manager = E.EmployeeID
  
			IF(@ManagerID IS NULL )
			BEGIN
				RAISERROR('Invalid manager name ', 16, 1)
				RETURN
			END
  
			UPDATE E SET ManagerID  = @ManagerID
			FROM inserted
			INNER JOIN  [Staff].[Employees] AS E
			ON E.EmployeeID = inserted.EmployeeID
		END
END