 -- ===================================================================================================================================================
/*
Author:	Vasyl Andrusiak
Create date: 05.05.2020
Short description: procedure for  INSERT, UPDATE or DELETE rows in table [Parking].[Lots]
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC STP_InsertUpdateDeleteLots @Action(VARCHAR(15), can be insert, update or delete),
@LotID(INT), @LotName(VARCHAR (50)), @CityID(INT), @Address(VARCHAR (50)), @PhoneNumber(VARCHAR (30)), @Email(VARCHAR (50))

*/
-- ===================================================================================================================================================


CREATE PROCEDURE [dbo].[STP_InsertUpdateDeleteLots] 
-- Add the parameters for the stored procedure here
@Action VARCHAR (15),
@LotID INT,
@LotName VARCHAR (50),
@CityID INT,
@Address VARCHAR (50),
@PhoneNumber VARCHAR (30),
@Email VARCHAR (50)
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

	-- Inserting data into Lots
    -- Inserting if selected action is 'INSERT'

	IF @Action = 'INSERT'
				BEGIN    
					--Checking if selected LotID is exist
				    IF EXISTS (SELECT L.LotID
							FROM [Parking].[Lots] AS L
							WHERE  L.LotID = @LotID)
					BEGIN
					SET @ErrorText = CONCAT ('LotID', @LotID, 'does exist');
						RAISERROR(@ErrorText , 16 , 1);
					END

					IF NOT EXISTS (SELECT C.CityID FROM [Location].[Cities] AS C WHERE C.CityID = @CityID) 
							BEGIN
								  SET @ErrorText = CONCAT('CityID', @CityID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END

		            INSERT INTO [Parking].[Lots]([LotName], [CityID], [Address], [PhoneNumber], [Email])
					VALUES (@LotName, @CityID, @Address, @PhoneNumber, @Email);
				END

					-- Updating data in Lots

	IF @Action = 'UPDATE'
	IF NOT EXISTS (SELECT C.CityID FROM [Location].[Cities] AS C WHERE C.CityID = @CityID) 
							BEGIN
								  SET @ErrorText = CONCAT('CityID', @CityID, ' does not exist');
								 RAISERROR(@ErrorText , 16 , 1);
							END
				BEGIN 
					UPDATE [Parking].[Lots]
					SET [LotName] = @LotName,
						[CityID] = @CityID,
						[Address] = @Address,
						[PhoneNumber] = @PhoneNumber,
						[Email] = @Email
				END;

		---- Deleting data from Lots

	IF @Action = 'DELETE'
				BEGIN
					DELETE FROM [Parking].[Lots]
					WHERE LotID = @LotID
				END
		COMMIT TRAN
	END TRY

	BEGIN CATCH
	    PRINT @ErrorText;
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END


