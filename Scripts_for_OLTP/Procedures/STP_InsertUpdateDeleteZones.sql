 -- ===================================================================================================================================================
/*
Author:	Vasyl Andrusiak
Create date: 05.05.2020
Short description: procedure for  INSERT, UPDATE or DELETE rows in table [Parking].[Zones]
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC STP_InsertUpdateDeleteZones @Action(VARCHAR(15), can be insert, update or delete),
@ZoneID(INT), @Capacity(INT), @LotID(INT), @ZoneTypeID(INT), @FreeSlots(INT)
*/
-- ===================================================================================================================================================


ALTER PROCEDURE [dbo].[STP_InsertUpdateDeleteZones] 
-- Add the parameters for the stored procedure here
@Action VARCHAR (15),
@ZoneID INT,
@Capacity INT,
@LotID INT,
@ZoneTypeID INT,
@FreeSlots INT
AS
BEGIN
	--to avoid showig the affected rows
		SET NOCOUNT ON;
	--Transaction for saving state 
		BEGIN TRANSACTION;
	--block try-catch for catching errors
	BEGIN TRY
		DECLARE @ErrorText NVARCHAR(200);
		   --Check if operation is valid
		   IF @Action NOT IN ('INSERT', 'UPDATE', 'DELETE')
			  BEGIN
				 RAISERROR('Action is invalid. Please specify your Action as: "INSERT", "UPDATE","DELETE"' , 16 , 1);
			  END;

	-- Inserting data into Zones
    -- Inserting if selected action is 'INSERT'

	IF @Action = 'INSERT'
				BEGIN    
					--Checking if selected ZoneID is correct
				    IF EXISTS (SELECT Z.ZoneID
							FROM [Parking].[Zones] AS Z
							WHERE  Z.ZoneID = @ZoneID)
					BEGIN
					SET @ErrorText = CONCAT ('ZoneTypeID', @ZoneTypeID, 'does exist');
						RAISERROR(@ErrorText , 16 , 1);
					END

					IF NOT EXISTS (SELECT L.LotID FROM [Parking].[Lots] AS L WHERE L.LotID = @LotID) 
							BEGIN
								  SET @ErrorText = CONCAT('LotID', @LotID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END

					IF NOT EXISTS (SELECT ZT.ZoneTypeID FROM [Parking].[ZoneTypes] AS ZT WHERE ZT.ZoneTypeID = @ZoneTypeID) 
							BEGIN
								  SET @ErrorText = CONCAT('ZoneTypeID', @ZoneTypeID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END
		            INSERT INTO [Parking].[Zones](Capacity, LotID, ZoneTypeID, FreeSlots)
					VALUES (@Capacity, @LotID, @ZoneTypeID, @FreeSlots);
				END

					-- Updating data in Zones

	IF @Action = 'UPDATE'
	IF NOT EXISTS (SELECT L.LotID FROM [Parking].[Lots] AS L WHERE L.LotID = @LotID) 
							BEGIN
								  SET @ErrorText = CONCAT('LotID', @LotID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END

					IF NOT EXISTS (SELECT ZT.ZoneTypeID FROM [Parking].[ZoneTypes] AS ZT WHERE ZT.ZoneTypeID = @ZoneTypeID) 
							BEGIN
								  SET @ErrorText = CONCAT('ZoneTypeID', @ZoneTypeID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END
				BEGIN 
					UPDATE [Parking].[Zones]
					SET Capacity = @Capacity,
						LotID = @LotID,
						ZoneTypeID = @ZoneTypeID,
						FreeSlots = @FreeSlots
				END;

		---- Deleting data from Zones

	IF @Action = 'DELETE'
				BEGIN
					DELETE FROM [Parking].[Zones]
					WHERE ZoneID = @ZoneID
				END
		COMMIT TRAN
	END TRY

	BEGIN CATCH
	    PRINT @ErrorText;
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END


