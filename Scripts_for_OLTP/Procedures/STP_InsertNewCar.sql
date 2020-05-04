 -- ===================================================================================================================================================
/*
Author:	Volodymyr Lavryntsiv
Create date: 2020-04-27
Short description: Insert new car into the database 
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution:

DECLARE @CARID INT
EXEC STP_InsertNewCar 'ZZ04ZZG', 'M2','BMW' , @CarID = @CarID OUTPUT
*/
-- ===================================================================================================================================================


CREATE PROCEDURE STP_InsertNewCar (
	@Plate CHAR(7),
	@CarModel VARCHAR(50),
	@CarBrand VARCHAR(50),
	@CarID INT OUTPUT
	 )
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

			DECLARE 
			@CarModelID	INT,
			@clientID INT

			SET @CarModelID = (SELECT CarModelID FROM Clientele.CarModels WHERE Model = @CarModel AND Brand = @CarBrand	)
			PRINT @CarModelID

			INSERT INTO Clientele.Cars (Plate, CarModelID) VALUES
			(@Plate, @CarModelID)

			SET @CarID = (SELECT CarID FROM Clientele.Cars WHERE Plate = @Plate) 
		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END