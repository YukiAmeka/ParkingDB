CREATE PROCEDURE STP_GNR_ClienteleCars
AS
 BEGIN
DECLARE @plateID INT
DECLARE @client INT
DECLARE @model INT
DECLARE @cycle INT
DECLARE @plate CHAR(7)
DECLARE @a INT
DECLARE @CityId INT

SET @cycle = (SELECT count(*) from Clientele.Clients)
SET @client = (SELECT TOP 1 ClientID FROM Clientele.Clients) 
SET @plateID = 1

WHILE @cycle > 0
	BEGIN
	SET @model = (SELECT TOP 1 CarModelID FROM Clientele.CarModels
		ORDER BY NEWID())
	SET @plate = (SELECT plate from carplates WHERE PlateId = @plateID)
	INSERT INTO Clientele.Cars (Plate, ClientID, CarModelID) VALUES (@plate, @client, @model)
	SET @cycle = @cycle - 1
	SET @plateID = @plateID + 1
	SET @client = @client + 1
	END

SET @cycle = ((SELECT count(*) from Clientele.Clients) * 0.50)
WHILE @cycle > 0
	BEGIN
	SET @model = (SELECT TOP 1 CarModelID FROM Clientele.CarModels
		ORDER BY NEWID())
	SET @plate = (SELECT plate from carplates WHERE PlateId = @plateID)
	SET @client = (SELECT TOP 1 ClientID FROM Clientele.Clients
		ORDER BY NEWID())
	INSERT INTO Clientele.Cars (Plate, ClientID, CarModelID) VALUES (@plate, @client, @model)
	SET @cycle = @cycle - 1
	SET @plateID = @plateID + 1
	END

SET @cycle = 10001
WHILE @cycle <= 100000
	BEGIN
	SET @model = (SELECT TOP 1 CarModelID FROM Clientele.CarModels
		ORDER BY NEWID())
	SET @plate = (SELECT plate from carplates WHERE PlateId = @plateID)
	SET @CityId = CASE 
		WHEN @CYCLE BETWEEN 10001 AND 46000 THEN 1
		WHEN @CYCLE BETWEEN 46001 AND 56000 THEN 11
		WHEN @CYCLE BETWEEN 56001 AND 66000 THEN 21
		WHEN @CYCLE BETWEEN 66001 AND 74000 THEN 31
		WHEN @CYCLE BETWEEN 74001 AND 82000 THEN 41
		WHEN @CYCLE BETWEEN 82001 AND 90000 THEN 51
		WHEN @CYCLE BETWEEN 90001 AND 95000 THEN 61
		WHEN @CYCLE BETWEEN 95001 AND 100000 THEN 71
		END	
	INSERT INTO Clientele.Cars (Plate, CarModelID, CityId) VALUES (@plate,  @model, @CityId)
	SET @cycle = @cycle + 1
	SET @plateID = @plateID + 1
	END
END
GO
