 -- ===================================================================================================================================================
/*
Author:	Vasyl Andrusiak
Create date: 05.05.2020
Short description: procedure for  INSERT, UPDATE or DELETE rows in table [Parking].[SlotSizes]
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC STP_InsertUpdateDeleteZoneTypes @Action(VARCHAR(15), can be insert, update or delete),
@ZoneTypeID(INT), @@ZoneTypeName(varchar(20)), @Description(varchar(200)), @SlotSizeID(INT)
*/
-- ===================================================================================================================================================

ALTER PROCEDURE [dbo].[STP_InsertUpdateDeleteZoneTypes] 
-- Add the parameters for the stored procedure here
@Action VARCHAR (15),
@ZoneTypeID INT,
@ZoneTypeName VARCHAR(20),
@Description VARCHAR(200),
@SlotSizeID INT
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

	-- Inserting data into SlotSizes
    -- Inserting if selected action is 'INSERT'

	IF @Action = 'INSERT'
				BEGIN    
					--Checking if selected ZoneTypeID is correct
				    IF EXISTS (SELECT ZT.ZoneTypeID
							FROM [Parking].[ZoneTypes] AS ZT
							WHERE  ZT.ZoneTypeID = @ZoneTypeID)
					BEGIN
					SET @ErrorText = CONCAT ('ZoneTypeID', @ZoneTypeID, 'does not correct');
						RAISERROR(@ErrorText , 16 , 1);
					END

					IF NOT EXISTS (SELECT SS.SlotSizeID FROM [Parking].[SlotSizes] AS SS WHERE SS.SlotSizeID = @SlotSizeID) 
							BEGIN
								  SET @ErrorText = CONCAT('SlotSizeID', @SlotSizeID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END
		            INSERT INTO [Parking].[ZoneTypes](ZoneTypeName, [Description], SlotSizeID)
					VALUES (@ZoneTypeName, @Description, @SlotSizeID);
				END

					-- Updating data in ZoneTypes

	IF @Action = 'UPDATE'
	 IF NOT EXISTS (SELECT SS.SlotSizeID FROM [Parking].[SlotSizes] AS SS WHERE SS.SlotSizeID = @SlotSizeID) 
							BEGIN
								  SET @ErrorText = CONCAT('SlotSizeID', @SlotSizeID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END
				BEGIN 
					UPDATE [Parking].[ZoneTypes]
					SET ZoneTypeName = @ZoneTypeName,
					Description = @Description,
					SlotSizeID = @SlotSizeID
                    WHERE ZoneTypeID = @ZoneTypeID
				END;

		---- Deleting data from ZoneTypes

	IF @Action = 'DELETE'
				BEGIN
					DELETE FROM [Parking].[ZoneTypes]
					WHERE ZoneTypeID = @ZoneTypeID
				END
		COMMIT TRAN
	END TRY

	BEGIN CATCH
	    PRINT @ErrorText;
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END



