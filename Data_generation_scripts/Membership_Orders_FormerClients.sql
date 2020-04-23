CREATE TABLE #Capacity (
CapacityID INT IDENTITY,
ZoneID INT,
Capacity INT,
OccupiedSlots INT
)

INSERT INTO #Capacity
SELECT Parking.Zones.ZoneID, Capacity, 0
FROM Parking.Zones
WHERE  (ZoneTypeID BETWEEN 1 AND 2) AND Capacity > 0


GO
CREATE VIEW OrdersByTariffs AS
    SELECT [PurchaseDate], [OrderID], [Membership].[Tariffs].TariffID AS TariffID, ZoneID, ExpiryDate, [PeriodID]
    FROM [Membership].[Orders]
    INNER JOIN [Membership].[Tariffs] ON [Membership].[Tariffs].TariffID = [Membership].[Orders].TariffID
GO

DECLARE @CheckDate DATE
DECLARE @ZoneCounter INT

SET @CheckDate = '2020-04-01'
SET @ZoneCounter = 1

/* Fill in temporary table #Capacity */
WHILE @ZoneCounter <= 88
BEGIN

	UPDATE #Capacity
		SET OccupiedSlots = (SELECT COUNT(OrderID) FROM OrdersByTariffs
			WHERE (ZoneID = @ZoneCounter) AND (@CheckDate BETWEEN PurchaseDate AND ExpiryDate))
		WHERE ZoneID = @ZoneCounter

	SET @ZoneCounter += 1
END

DECLARE @MaxCapacity INT
DECLARE @WantedCapacity INT
DECLARE @OccupiedSlots INT
DECLARE @MissingClients INT
DECLARE @ZoneID INT
DECLARE @CapacityCounter INT

SET @CapacityCounter = 1

WHILE @CapacityCounter < 36
BEGIN

    SET @MaxCapacity = (SELECT Capacity FROM #Capacity WHERE CapacityID = @CapacityCounter)
    SET @WantedCapacity = @MaxCapacity * (FLOOR(RAND()*(80-60+1)+60)) / 100
    SET @OccupiedSlots = (SELECT OccupiedSlots FROM #Capacity WHERE CapacityID = @CapacityCounter)
    SET @MissingClients = @WantedCapacity - @OccupiedSlots
    SET @ZoneID = (SELECT ZoneID FROM #Capacity WHERE CapacityID = @CapacityCounter)

    WHILE @MissingClients > 0
    BEGIN


        SET @MissingClients -= 1
    END

    SET @CapacityCounter += 1
END



SELECT * FROM #Capacity
--SELECT * FROM OrdersByTariffs

DROP VIEW OrdersByTariffs
DROP TABLE #Capacity