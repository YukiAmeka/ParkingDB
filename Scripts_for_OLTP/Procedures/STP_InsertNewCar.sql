alter PROCEDURE STP_InsertNewCar (
	@Plate CHAR(7),
	@CarModel VARCHAR(50),
	@CarBrand VARCHAR(50),
	@CarID INT OUTPUT
	 )
AS

BEGIN

DECLARE 
@CarModelID	INT,
@clientID INT

SET @CarModelID = (SELECT CarModelID FROM Clientele.CarModels WHERE Model = @CarModel AND Brand = @CarBrand	)
PRINT @CarModelID

INSERT INTO Clientele.Cars (Plate, CarModelID) VALUES
			(@Plate, @CarModelID)

SET @CarID = (SELECT CarID FROM Clientele.Cars WHERE Plate = @Plate) 

END

DECLARE @CARID INT
EXEC STP_InsertNewCar 'ZZ04ZZG', 'M2','BMW' , @CarID = @CarID OUTPUT

--DECLARE @CARMODELID INT
--SET @CarModelID = (SELECT CarModelID FROM Clientele.CarModels WHERE Model = 'M2' AND Brand = 'BMW')

--PRINT @CarModelID
--INSERT INTO Clientele.Cars (Plate, CarModelID) VALUES
--			('ZZ12ZZP', @CarModelID)

--SELECT * FROM Clientele.Cars WHERE Plate = 'ZZ00ZZM'