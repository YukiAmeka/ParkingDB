 -- ===================================================================================================================================================
/*
Author:	Vasyl Andrusiak
Create date: 05.05.2020
Short description: procedure for  INSERT, UPDATE or DELETE rows in table [Parking].[Slots]
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC STP_InsertUpdateDeletessSlots @Action(VARCHAR(15), can be insert, update or delete),
@SlotID(INT), @IsOccupied(BIT), @SlotNumber(INT), @ZoneID(INT)
*/
-- ===================================================================================================================================================


ALTER PROCEDURE [dbo].[STP_InsertUpdateDeleteSlots] 
-- Add the parameters for the stored procedure here
@Action VARCHAR (15),
@SlotID INT,
@IsOccupied BIT,
@SlotNumber INT,
@ZoneID INT
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

	-- Inserting data into Slots
    -- Inserting if selected action is 'INSERT'

	IF @Action = 'INSERT'
				BEGIN    
					--Checking if selected SlotID is correct
				    IF EXISTS (SELECT S.SlotID
							FROM [Parking].[Slots] AS S
							WHERE  S.SlotID = @SlotID)
					BEGIN
					SET @ErrorText = CONCAT ('SlotID', @SlotID, 'does exist');
						RAISERROR(@ErrorText , 16 , 1);
					END

					IF NOT EXISTS (SELECT Z.ZoneID FROM [Parking].[Zones] AS Z WHERE ZoneID = @ZoneID) 
							BEGIN
								  SET @ErrorText = CONCAT('ZoneID', @ZoneID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END

		            INSERT INTO [Parking].[Slots](IsOccupied, SlotNumber, ZoneID)
					VALUES (@IsOccupied, @SlotNumber, @ZoneID);
				END

					-- Updating data in Slots

	IF @Action = 'UPDATE'
	IF NOT EXISTS (SELECT Z.ZoneID FROM [Parking].[Zones] AS Z WHERE ZoneID = @ZoneID) 
							BEGIN
								  SET @ErrorText = CONCAT('ZoneID', @ZoneID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END
				BEGIN 
					UPDATE [Parking].[Slots]
					SET IsOccupied = @IsOccupied,
						SlotNumber = @SlotNumber,
						ZoneID = @ZoneID
				END;

		---- Deleting data from Slots

	IF @Action = 'DELETE'
				BEGIN
					DELETE FROM [Parking].[Slots]
					WHERE SlotID = @SlotID
				END
		COMMIT TRAN
	END TRY

	BEGIN CATCH
	    PRINT @ErrorText;
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END


