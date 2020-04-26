/* Populate table Membership.Orders with historical data about all purchases of membership cards since 2015-01-01 */
CREATE PROCEDURE STP_GNR_MembershipOrders
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @MaxCapacity INT
    DECLARE @WantedCapacity INT
    DECLARE @MemberReservedSlots INT
    DECLARE @MissingClients INT
    DECLARE @LotID INT
    DECLARE @ZoneID INT
    DECLARE @CapacityCounter INT
    DECLARE @ZoneCounter INT
    DECLARE @ZonesForMembers INT
    DECLARE @TotalZonesNumber INT
    DECLARE @TargetDate DATE
    DECLARE @PeriodID INT
    DECLARE @ClientID INT
    DECLARE @PurchaseDate DATE
    DECLARE @ExpiryDate DATE
    DECLARE @PeriodInDays INT
    DECLARE @ParkingCityID INT
    DECLARE @HomeCityID INT

    /* Create temporary table with the same structure as Membership.Orders that will accumulate records
    for them to be sorted chronologically before being inserted into Membership.Orders */
    IF OBJECT_ID ('#MOrders') IS NOT NULL
        DROP TABLE #MOrders

    CREATE TABLE #MOrders
    (
        OrderID int NOT NULL PRIMARY KEY IDENTITY
        , LotID int NULL
        , ZoneID int NULL
        , EmployeeID int NULL
        , AllCardID int NULL
        , ClientID int NULL
        , PurchaseDate DATE NULL
        , PurchaseTime time (0) NULL
        , TariffID int NULL
        , ExpiryDate date NULL
    )

    /* Create temporary table with information about maximum capacity of each
    existing A & B slot (slots for membership card holders only) */
    IF OBJECT_ID ('#Capacity') IS NOT NULL
        DROP TABLE #Capacity

    CREATE TABLE #Capacity (
        CapacityID INT IDENTITY
        , ZoneID INT
        , Capacity INT
        , MemberReservedSlots INT
    )
    INSERT INTO #Capacity
    SELECT ZoneID, Capacity, 0
    FROM Parking.Zones
    INNER JOIN Parking.Lots ON Parking.Lots.LotID = Parking.Zones.LotID
    WHERE (ZoneTypeID BETWEEN 1 AND 2) AND Capacity > 0

    /* Define reference values */
    SET @ZonesForMembers = (SELECT COUNT(CapacityID) FROM #Capacity)
    SET @TotalZonesNumber = (SELECT COUNT(ZoneID) FROM Parking.Zones)
    SET @TargetDate = (SELECT CONVERT(DATE, getdate())) -- the date of data generation

    /* Generate records about membership cards bought between mid-2014 & now.
    @TargetDate goes back 30 days & #Capacity is filled in with relevant data at the end of each iteration. */
    WHILE @TargetDate >= '2015-06-01'
    BEGIN

        /* Go through each member-only zone & add active cards for the date as needed */
        SET @CapacityCounter = 1
        WHILE @CapacityCounter <= @ZonesForMembers
        BEGIN

            /* Identify how many cards active at @TargetDate need to be added to reach @WantedCapacity in this zone*/
            SET @MaxCapacity = (SELECT Capacity FROM #Capacity WHERE CapacityID = @CapacityCounter)
            SET @WantedCapacity = @MaxCapacity * (FLOOR(RAND()*(90-80+1)+80)) / 100
            SET @MemberReservedSlots = (SELECT MemberReservedSlots FROM #Capacity WHERE CapacityID = @CapacityCounter)
            SET @MissingClients = @WantedCapacity - @MemberReservedSlots
            SET @ZoneID = (SELECT ZoneID FROM #Capacity WHERE CapacityID = @CapacityCounter)
            SET @LotID = (SELECT LotID FROM Parking.Zones WHERE ZoneID = @ZoneID)

            /* Keep adding records about new sold membership cards until their # reaches WantedCapacity for a given date */
            WHILE @MissingClients > 0
            BEGIN

                /* Randomly generate if the client was buying monthly, quarterly or yearly cards */
                SET @PeriodID = (FLOOR(RAND()*3+1))
                SET @PeriodInDays = (SELECT CASE
                    WHEN @PeriodID = 1 THEN 30
                    WHEN @PeriodID = 2 THEN 90
                    ELSE 365 END)

                /* Generate random purchase date & calculate expiry date */
                EXEC STP_HLP_PurchaseDateForActiveCard
                    @PeriodInDays = @PeriodInDays
                    , @TargetDate = @TargetDate
                    , @PurchaseDate = @PurchaseDate OUTPUT
                    , @ExpiryDate = @ExpiryDate OUTPUT

                /* Randomly pick a client who has not had any purchase records generated yet */
                SET @ClientID = (SELECT TOP 1 ClientID FROM Clientele.Clients WHERE IsCurrent = 0 ORDER BY NEWID())

                /* Add 1 record into #MOrders. Make corresponding changes into AllCards*/
                EXEC STP_HLP_AddMembershipPurchase
                    @PurchaseDate = @PurchaseDate
                    , @ExpiryDate = @ExpiryDate
                    , @LotID = @LotID
                    , @ZoneID = @ZoneID
                    , @PeriodID = @PeriodID
                    , @ClientID = @ClientID

                /* Assign a Home City - same or neighboring one to where the Parking Lot is located - to the Client */
                SET @ParkingCityID = (SELECT CityID FROM Parking.Lots WHERE LotID = @LotID)

                IF FLOOR(RAND()*100+1) > 30
                    SET @HomeCityID = (SELECT TOP 1 CityID FROM Location.Cities WHERE ClosestCityWithParking = @ParkingCityID ORDER BY NEWID())
                ELSE
                    SET @HomeCityID = @ParkingCityID

                UPDATE Clientele.Clients
                    SET IsCurrent = 1
                    , CityID = @HomeCityID
                    WHERE ClientID = @ClientID

                /* Add records about prior purchases of the same Client if any */
                EXEC STP_HLP_ClientsExpiredMembership
                    @PurchaseDate = @PurchaseDate
                    , @LotID = @LotID
                    , @ZoneID = @ZoneID
                    , @PeriodID = @PeriodID
                    , @ClientID = @ClientID

                /* Next client */
                SET @MissingClients -= 1
            END

            /* Next zone */
            SET @CapacityCounter += 1
        END

        /* Step 1 month back in time to check the difference between WantedCapacity & MemberReservedSlots then.
        Some MemberReservedSlots will be covered by already generated expired cards and longer membership periods */
        SET @TargetDate = (DATEADD(DAY, -30, @TargetDate))
        SET @ZoneCounter = 1

        /* Fill in temporary table #Capacity with data for the new date */
        WHILE @ZoneCounter <= @TotalZonesNumber
        BEGIN
            UPDATE #Capacity
                SET MemberReservedSlots = (SELECT COUNT(OrderID) FROM #MOrders
                    WHERE (ZoneID = @ZoneCounter) AND (@TargetDate BETWEEN PurchaseDate AND ExpiryDate))
                WHERE ZoneID = @ZoneCounter
            SET @ZoneCounter += 1
        END
    END

    /* Sort #MOrders chronologically and copy all data into Membership.Orders */
    INSERT INTO Membership.Orders
    SELECT LotID, EmployeeID, AllCardID, ClientID, PurchaseDate, PurchaseTime, TariffID, ExpiryDate FROM #MOrders
    ORDER BY PurchaseDate, PurchaseTime

    /* Purge data that is outside of set parameters */
    DELETE FROM Membership.Orders
        WHERE PurchaseDate < '2015-01-01' OR TariffID IS NULL

    /* Post-processing of table Parking.Zones: fill in MemberReservedSlots with up-to-date info */
    SET @TargetDate = (SELECT CONVERT(DATE, getdate())) -- the date of data generation
    SET @ZoneCounter = 1

    WHILE @ZoneCounter <= @TotalZonesNumber
    BEGIN
        UPDATE Parking.Zones
            SET MemberReservedSlots = (SELECT COUNT(OrderID) FROM Membership.Orders
                INNER JOIN Membership.Tariffs ON Membership.Orders.TariffID = Membership.Tariffs.TariffID
                WHERE (ZoneID = @ZoneCounter) AND (@TargetDate BETWEEN PurchaseDate AND ExpiryDate))
            WHERE ZoneID = @ZoneCounter
        SET @ZoneCounter += 1
    END

    /* Post-processing of table Clientele.Clients: delete unused records;
    mark only clients that have active cards to date as current ones */
    /*DELETE FROM Clientele.Clients WHERE CityID IS NULL */

    UPDATE Clientele.Clients
        SET IsCurrent = 0
    UPDATE Clientele.Clients
        SET IsCurrent = 1
        WHERE ClientID IN (SELECT ClientID FROM Membership.Orders
            WHERE @TargetDate BETWEEN PurchaseDate AND ExpiryDate)

    /* Drop all temporary objects */
    DROP TABLE #MOrders
    DROP TABLE #Capacity

END