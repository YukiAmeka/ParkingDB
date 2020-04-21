/* Populate table Membership.Orders with historical data about all purchases of membership cards since 2015-01-01 */

DECLARE @ClientID INT
DECLARE @AllCardID INT
DECLARE @StartDate DATE
DECLARE @TariffID INT
DECLARE @LotID INT
DECLARE @PurchaseTime TIME(0)
DECLARE @ExpiryDate DATE

/* Create temporary table with the same structure as Membership.Orders that will accumulate records
for them to be sorted chronologically before being inserted into Membership.Orders */
CREATE TABLE #MOrders
(
    OrderID int NOT NULL PRIMARY KEY IDENTITY,
    LotID int NULL,
    EmployeeID int NULL,
    AllCardID int NULL,
    ClientID int NULL,
    PurchaseDate DATE NULL,
    PurchaseTime time (0) NULL,
    TariffID int NULL,
    ExpiryDate date NULL
)

/* Record purchases of all active cards listed in Membership.ActiveCards table */

/* Create cursor to go through all records in Membership.ActiveCards + info about related Tariffs, Lots & Zones one by one */
DECLARE ActiveClients CURSOR
    FOR SELECT ClientID, Membership.ActiveCards.AllCardID, Membership.ActiveCards.StartDate, Membership.AllCards.TariffID, Parking.Zones.LotID, Membership.ActiveCards.ExpiryDate
        FROM Membership.ActiveCards
		INNER JOIN Membership.AllCards ON Membership.ActiveCards.AllCardID = Membership.AllCards.AllCardID
		INNER JOIN Membership.Tariffs ON Membership.AllCards.TariffID = Membership.Tariffs.TariffID
		INNER JOIN Parking.Zones ON Parking.Zones.ZoneID = Membership.Tariffs.ZoneID
		INNER JOIN Parking.Lots ON Parking.Zones.LotID = Parking.Lots.LotID

OPEN ActiveClients

FETCH NEXT FROM ActiveClients
    INTO @ClientID, @AllCardID, @StartDate, @TariffID, @LotID, @ExpiryDate

/* Go through all records in ActiveClients, store data in variables,
generate random time of purchase; add new records into table #MOrders */
WHILE @@FETCH_STATUS = 0
    BEGIN

        /* Generate random time when the purchase occurs */
        EXEC STP_GenerateRandomTime @StartTime = '08:00:00', @EndTime = '22:00:00', @RandomTime = @PurchaseTime OUTPUT

        INSERT INTO #MOrders (ClientID, AllCardID, PurchaseDate, TariffID, LotID, PurchaseTime, ExpiryDate)
            VALUES (@ClientID, @AllCardID, @StartDate, @TariffID, @LotID, @PurchaseTime, @ExpiryDate)

        FETCH NEXT FROM ActiveClients
            INTO @ClientID, @AllCardID, @StartDate, @TariffID, @LotID, @ExpiryDate
    END

/* Close cursor */
CLOSE ActiveClients
DEALLOCATE ActiveClients
GO

/* Create view containing all unused cards to use as a source of picking a new card for a client */
CREATE VIEW CardListWithTariffs AS
SELECT AllCardID, IsUsed, Membership.Tariffs.TariffID, PeriodID
    FROM Membership.AllCards
    INNER JOIN Membership.Tariffs ON Membership.Tariffs.TariffID = Membership.AllCards.TariffID
    WHERE IsUsed = 0
GO

/* Generate old records of active clients buyng cards in the past (not further than 2015-01-01) */
EXEC STP_GenerateMembershipLogByPeriod @PeriodID = 1, @ClientNumberDrop = 0.05, @PeriodInDays = 30 -- monthly cards
EXEC STP_GenerateMembershipLogByPeriod @PeriodID = 2, @ClientNumberDrop = 0.03, @PeriodInDays = 90 -- quarterly cards
EXEC STP_GenerateMembershipLogByPeriod @PeriodID = 3, @ClientNumberDrop = 0.10, @PeriodInDays = 365 -- yearly cards

/* Sort #MOrders chronologically and copy all data into Membership.Orders */
INSERT INTO Membership.Orders
SELECT LotID, EmployeeID, AllCardID, ClientID, PurchaseDate, PurchaseTime, TariffID, ExpiryDate FROM #MOrders
ORDER BY PurchaseDate, PurchaseTime

--SELECT ClientID, COUNT(AllCardID) AS Q FROM #MOrders GROUP BY ClientID ORDER BY Q DESC


DROP TABLE #MOrders
DROP VIEW CardListWithTariffs