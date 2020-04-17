/* Create variable table Clients with information about the City where Client lives.
Filtered by active Clients */
IF OBJECT_ID ('ClientsCities') IS NOT NULL
DROP VIEW ClientsCities
GO

CREATE VIEW ClientsCities AS
SELECT ClientID, Location.Cities.CityID AS AnyCity, CityName, ClosestCityWithParking
    FROM Clientele.Clients
    INNER JOIN Location.Cities ON Location.Cities.CityID = Clientele.Clients.CityID
    WHERE IsCurrent = 1
GO

/* Create variable table Tariffs with information about the City where Parking Lot is located
and Membership Cards. Filtered by unused Cards */
IF OBJECT_ID ('CardListWithTariffs') IS NOT NULL
DROP VIEW CardListWithTariffs
GO

CREATE VIEW CardListWithTariffs AS
SELECT AllCardID, MemberCardNumber, IsUsed, Membership.Tariffs.TariffID, PeriodID, Parking.Zones.ZoneID, Parking.Lots.LotID, Location.Cities.CityID AS CityWithParking, CityName
    FROM Membership.AllCards
    INNER JOIN Membership.Tariffs ON Membership.Tariffs.TariffID = Membership.AllCards.TariffID
    INNER JOIN Parking.Zones ON Parking.Zones.ZoneID = Membership.Tariffs.ZoneID
    INNER JOIN Parking.Lots ON Parking.Lots.LotID = Parking.Zones.LotID
    INNER JOIN Location.Cities ON Location.Cities.CityID = Parking.Lots.CityID
    WHERE IsUsed = 0
GO

/* Generate records for each active client in table Membership.ActiveCards */
INSERT INTO Membership.ActiveCards (ClientID)
    SELECT ClientID
        FROM ClientsCities

/* Add information in the rest of columns in table Membership.ActiveCards one client at a time */
DECLARE @CurrentClient INT
SET @CurrentClient = 1

WHILE @CurrentClient <= 10000
BEGIN

    /* Check if the Client has been added as an active one; if not - skip to next iteration */
    IF @CurrentClient IN (SELECT ClientID FROM Membership.ActiveCards)
    BEGIN

        /* Create variable table with 1 record incl. Card Number randomly picked
        from Client's options based on the City of living */
        CREATE TABLE #CardForClient
        (
            CardForClientID INT NOT NULL IDENTITY
            , ClientID INT
            , ClosestCityWithParking INT
            , CityWithParking INT
            , AllCardID INT
            , PeriodID INT
        )
        INSERT INTO #CardForClient
        SELECT TOP 1 ClientID, ClosestCityWithParking, CityWithParking, AllCardID, PeriodID
            FROM CardListWithTariffs
            INNER JOIN ClientsCities ON ClientsCities.ClosestCityWithParking = CardListWithTariffs.CityWithParking
            WHERE ClientID = @CurrentClient
            ORDER BY NEWID()

        /* Save AllCardID for the randomly picked Card Number */
        DECLARE @CurrentCard INT
        SET @CurrentCard = (SELECT AllCardID FROM #CardForClient WHERE CardForClientID = 1)

        /* Add link to Card Number for the current record */
        UPDATE Membership.ActiveCards
            SET AllCardID = @CurrentCard
            WHERE ClientID = @CurrentClient

        /* Mark the card allocated to the Client as used */
        UPDATE Membership.AllCards
            SET IsUsed = 1
            WHERE AllCardID = @CurrentCard

        /* Based on the picked Card's Tariff, generate random start date & calculate
        expiry date for the current record; insert into current record */
        DECLARE @Period INT
        SET @Period = (SELECT PeriodID FROM #CardForClient WHERE CardForClientID = 1)

        IF @Period = 1
            EXEC STP_GenerateMembershipDates @PeriodInDays = 25, @StartDate = '2020-04-01', @Member = @CurrentClient
        ELSE IF @Period = 2
            EXEC STP_GenerateMembershipDates @PeriodInDays = 85, @StartDate = '2020-02-02', @Member = @CurrentClient
        ELSE
            EXEC STP_GenerateMembershipDates @PeriodInDays = 360, @StartDate = '2019-05-01', @Member = @CurrentClient

        /* Finish current loop iteration and prep for the next one */
        DROP TABLE #CardForClient
        SET @CurrentClient += 1
    END
    ELSE
        SET @CurrentClient += 1
        CONTINUE
END