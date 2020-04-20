DECLARE @ClientID INT
DECLARE @AllCardID INT
DECLARE @StartDate DATE
DECLARE @TariffID INT
DECLARE @LotID INT
DECLARE @PurchaseTime TIME(0)

DECLARE ActiveClients CURSOR
    FOR SELECT ClientID, Membership.ActiveCards.AllCardID, Membership.ActiveCards.StartDate, Membership.AllCards.TariffID, Parking.Zones.LotID
        FROM Membership.ActiveCards
		INNER JOIN Membership.AllCards ON Membership.ActiveCards.AllCardID = Membership.AllCards.AllCardID
		INNER JOIN Membership.Tariffs ON Membership.AllCards.TariffID = Membership.Tariffs.TariffID
		INNER JOIN Parking.Zones ON Parking.Zones.ZoneID = Membership.Tariffs.ZoneID
		INNER JOIN Parking.Lots ON Parking.Zones.LotID = Parking.Lots.LotID

OPEN ActiveClients

FETCH NEXT FROM ActiveClients
    INTO @ClientID, @AllCardID, @StartDate, @TariffID, @LotID

CREATE TABLE #MOrders
(
    OrderID int NOT NULL PRIMARY KEY IDENTITY,
    LotID int NULL,
    EmployeeID int NULL,
    AllCardID int NULL,
    ClientID int NULL,
    PurchaseDate DATE NULL,
    PurchaseTime time (0) NULL,
    TariffID INT
)

WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC STP_GenerateRandomTime @StartTime = '08:00:00', @SecondsTillEndTime = 50400, @RandomTime = @PurchaseTime OUTPUT

        INSERT INTO #MOrders (ClientID, AllCardID, PurchaseDate, TariffID, LotID, PurchaseTime)
            VALUES (@ClientID, @AllCardID, @StartDate, @TariffID, @LotID, @PurchaseTime)

        FETCH NEXT FROM ActiveClients
            INTO @ClientID, @AllCardID, @StartDate, @TariffID, @LotID
    END

CLOSE ActiveClients
DEALLOCATE ActiveClients
GO

CREATE VIEW CardListWithTariffs AS
SELECT AllCardID, IsUsed, Membership.Tariffs.TariffID, PeriodID
    FROM Membership.AllCards
    INNER JOIN Membership.Tariffs ON Membership.Tariffs.TariffID = Membership.AllCards.TariffID
    WHERE IsUsed = 0
GO

EXEC STP_GenerateMembershipLogByPeriod @PeriodID = 1, @ClientNumberDrop = 0.05, @PeriodInDays = 30
EXEC STP_GenerateMembershipLogByPeriod @PeriodID = 2, @ClientNumberDrop = 0.03, @PeriodInDays = 90
EXEC STP_GenerateMembershipLogByPeriod @PeriodID = 3, @ClientNumberDrop = 0.10, @PeriodInDays = 365

SELECT * FROM #MOrders ORDER BY PurchaseDate, PurchaseTime
SELECT ClientID, COUNT(AllCardID) AS Q FROM #MOrders GROUP BY ClientID ORDER BY Q DESC


DROP TABLE #MOrders
DROP VIEW CardListWithTariffs