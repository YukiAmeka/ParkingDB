CREATE PROCEDURE STP_AddNonActiveClients
(
    @ZoneID INT
    , @TargetDate DATE
)
AS
BEGIN

DECLARE @ZoneID INT
SET @ZoneID = 1
    /* Create variable table Clients with information about the City where Client lives.
    Filtered by active Clients */

    CREATE TABLE #ClientsCities
    (
        ClientsCityID INT IDENTITY
        , ClientID INT
        , CityID INT
        , CityName VARCHAR(50)
        , ClosestCityWithParking INT
        , IsUsed BIT
    )
    INSERT INTO #ClientsCities
    SELECT ClientID, Location.Cities.CityID, CityName, ClosestCityWithParking, 0
        FROM Clientele.Clients
        INNER JOIN Location.Cities ON Location.Cities.CityID = Clientele.Clients.CityID
        WHERE IsCurrent = 0

    /* Create variable table Tariffs with information about the City where Parking Lot is located
    and Membership Cards. Filtered by unused Cards */

    CREATE TABLE #CardListWithTariffs
    (
        CardListWithTariffID INT IDENTITY
        , AllCardID INT
        , MemberCardNumber INT
        , IsUsed BIT
        , TariffID INT
        , PeriodID INT
        , ZoneID INT
        , LotID INT
        , CityWithParking INT
        , CityName VARCHAR(50)
    )
    INSERT INTO #CardListWithTariffs
    SELECT AllCardID, MemberCardNumber, IsUsed, Membership.Tariffs.TariffID, PeriodID, Parking.Zones.ZoneID, Parking.Lots.LotID, Location.Cities.CityID AS CityWithParking, CityName
        FROM Membership.AllCards
        INNER JOIN Membership.Tariffs ON Membership.Tariffs.TariffID = Membership.AllCards.TariffID
        INNER JOIN Parking.Zones ON Parking.Zones.ZoneID = Membership.Tariffs.ZoneID
        INNER JOIN Parking.Lots ON Parking.Lots.LotID = Parking.Zones.LotID
        INNER JOIN Location.Cities ON Location.Cities.CityID = Parking.Lots.CityID
        WHERE IsUsed = 0

    /* Create variable table with 1 record incl. Card Number randomly picked
    from Client's options based on the City of living */
    CREATE TABLE #CardForClient
    (
        CardForClientID INT NOT NULL IDENTITY
        , LotID INT
        , AllCardID INT
        , PeriodID INT
        , TariffID INT
        , ZoneID INT
        , ClientID INT
        , ClosestCityWithParking INT
        , CityWithParking INT
    )
    INSERT INTO #CardForClient
    SELECT TOP 1 LotID, AllCardID, PeriodID, TariffID, ZoneID, ClientID, ClosestCityWithParking, CityWithParking
        FROM #CardListWithTariffs
        INNER JOIN #ClientsCities ON [#ClientsCities].ClosestCityWithParking = [#CardListWithTariffs].CityWithParking
        WHERE ZoneID = @ZoneID
        ORDER BY NEWID()

    SELECT * FROM #CardForClient

    DROP TABLE #CardForClient
    DROP TABLE #CardListWithTariffs
    DROP TABLE #ClientsCities

    DECLARE @LotID INT
    SET @LotID = (SELECT LotID FROM #CardForClient WHERE CardForClientID = 1)

    /* Save AllCardID for the randomly picked Card Number */
    DECLARE @AllCardID INT
    SET @AllCardID = (SELECT AllCardID FROM #CardForClient WHERE CardForClientID = 1)

    /* Based on the picked Card's Tariff, generate random start date & calculate
    expiry date for the current record; insert into current record */
    DECLARE @PeriodID INT
    SET @PeriodID = (SELECT PeriodID FROM #CardForClient WHERE CardForClientID = 1)

    DECLARE @PurchaseDate DATE
    DECLARE @ExpiryDate DATE

    IF @PeriodID = 1
        EXEC STP_GenerateMembershipDates_OldClients @PeriodInDays = 30, @TargetDate = @TargetDate, @PurchaseDate = @PurchaseDate OUTPUT, @ExpiryDate = @ExpiryDate OUTPUT
    ELSE IF @PeriodID = 2
        EXEC STP_GenerateMembershipDates_OldClients @PeriodInDays = 90, @TargetDate = @TargetDate, @PurchaseDate = @PurchaseDate OUTPUT, @ExpiryDate = @ExpiryDate OUTPUT
    ELSE
        EXEC STP_GenerateMembershipDates_OldClients @PeriodInDays = 365, @TargetDate = @TargetDate, @PurchaseDate = @PurchaseDate OUTPUT, @ExpiryDate = @ExpiryDate OUTPUT

    DECLARE @TariffID INT
    SET @TariffID = (SELECT TariffID FROM #CardForClient WHERE CardForClientID = 1)

    DECLARE @ClientID INT
    SET @ClientID = (SELECT ClientID FROM #CardForClient WHERE CardForClientID = 1)



END