 -- ===================================================================================================================================================
/*
Author:	Vasyl Andrusiak
Create date: 05.05.2020
Short description: procedure for  INSERT, UPDATE or DELETE rows in table [Parking].[SlotSizes]
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC STP_InsertUpdateDeleteSlotSizes @Action(VARCHAR(200), can be insert, update or delete),
@SlotSizeID(INT), @SlotDescription(varchar(20))
*/
-- ===================================================================================================================================================

CREATE PROCEDURE [dbo].[STP_InsertUpdateDeleteSlotSizes] 
-- Add the parameters for the stored procedure here
@Action VARCHAR (15),
@SlotSizeID INT,
@SlotDescription VARCHAR(20)
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
					--Checking if selected LotName is correct
				    IF EXISTS (SELECT SS.SlotDescription
							FROM [Parking].[SlotSizes] AS SS
							WHERE  SS.SlotDescription = @SlotDescription)
					BEGIN
					SET @ErrorText = CONCAT ('SlotDescription', @SlotDescription, 'does not correct');
						RAISERROR(@ErrorText , 16 , 1);
					END
				
		            INSERT INTO [Parking].[SlotSizes](SlotDescription)
					VALUES (@SlotDescription);
				END

					-- Updating data in Products

	IF @Action = 'UPDATE'
				BEGIN 
					UPDATE [Parking].[SlotSizes] 
					SET SlotDescription = @SlotDescription
                    WHERE SlotSizeID = @SlotSizeID
				END;

		---- Deleting data from Products

	IF @Action = 'DELETE'
				BEGIN
					DELETE FROM [Parking].[SlotSizes]
					WHERE SlotSizeID = @SlotSizeID
				END
		COMMIT TRAN
	END TRY

	BEGIN CATCH
	    PRINT @ErrorText;
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END
