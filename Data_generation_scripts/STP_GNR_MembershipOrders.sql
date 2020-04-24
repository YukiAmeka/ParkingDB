/* Populate table Membership.Orders with historical data about all purchases of membership cards since 2015-01-01 */
CREATE PROCEDURE STP_GNR_MembershipOrders
AS
BEGIN

    /* Create temporary table with the same structure as Membership.Orders that will accumulate records
    for them to be sorted chronologically before being inserted into Membership.Orders */
    IF OBJECT_ID ('#MOrders') IS NOT NULL
        DROP TABLE #MOrders

    CREATE TABLE #MOrders
    (
        OrderID int NOT NULL PRIMARY KEY IDENTITY,
        LotID int NULL,
        ZoneID int NULL,
        EmployeeID int NULL,
        AllCardID int NULL,
        ClientID int NULL,
        PurchaseDate DATE NULL,
        PurchaseTime time (0) NULL,
        TariffID int NULL,
        ExpiryDate date NULL
    )

    /* Create temporary table with information about maximum capacity of each
    existing A & B slot (slots for membership card holders only) */
    IF OBJECT_ID ('#Capacity') IS NOT NULL
        DROP TABLE #Capacity

    UPDATE Parking.Zones
        SET MemberReservedSlots = 0

    CREATE TABLE #Capacity (
    CapacityID INT IDENTITY,
    ZoneID INT,
    Capacity INT,
    MemberReservedSlots INT
    )
    INSERT INTO #Capacity
    SELECT ZoneID, Capacity, MemberReservedSlots
    FROM Parking.Zones
    INNER JOIN Parking.Lots ON Parking.Lots.LotID = Parking.Zones.LotID
    WHERE (ZoneTypeID BETWEEN 1 AND 2) AND Capacity > 0


    DECLARE @MaxCapacity INT
    DECLARE @WantedCapacity INT
    DECLARE @MemberReservedSlots INT
    DECLARE @MissingClients INT
    DECLARE @LotID INT
    DECLARE @ZoneID INT
    DECLARE @CapacityCounter INT
    DECLARE @ZoneCounter INT
    DECLARE @ZonesForMembers INT
    DECLARE @TargetDate DATE
    DECLARE @PeriodID INT
    DECLARE @ClientID INT
    DECLARE @PurchaseDate DATE
    DECLARE @ExpiryDate DATE
    DECLARE @PeriodInDays INT
    DECLARE @ParkingCityID INT
    DECLARE @HomeCityID INT

    SET @ZonesForMembers = (SELECT COUNT(ZoneID) FROM #Capacity)
    SET @TargetDate = (SELECT CONVERT(DATE, getdate())) -- the date of data generation

    WHILE @TargetDate >= '2016-01-01'
    BEGIN
        SET @CapacityCounter = 1
        WHILE @CapacityCounter < @ZonesForMembers
        BEGIN

            SET @MaxCapacity = (SELECT Capacity FROM #Capacity WHERE CapacityID = @CapacityCounter)
            SET @WantedCapacity = @MaxCapacity * (FLOOR(RAND()*(80-60+1)+60)) / 100
            SET @MemberReservedSlots = (SELECT MemberReservedSlots FROM #Capacity WHERE CapacityID = @CapacityCounter)
            SET @MissingClients = @WantedCapacity - @MemberReservedSlots
            SET @ZoneID = (SELECT ZoneID FROM #Capacity WHERE CapacityID = @CapacityCounter)
            SET @LotID = (SELECT LotID FROM Parking.Zones WHERE ZoneID = @ZoneID)

            /* Keep adding records about new sold membership cards until their # reaches WantedCapacity for a given date */
            WHILE @MissingClients > 0
            BEGIN

                SET @PeriodID = (FLOOR(RAND()*3+1))
                SET @PeriodInDays = (SELECT CASE
                    WHEN @PeriodID = 1 THEN 30
                    WHEN @PeriodID = 2 THEN 90
                    ELSE 365 END)

                EXEC STP_HLP_PurchaseDateForActiveCard
                    @PeriodInDays = @PeriodInDays
                    , @TargetDate = @TargetDate
                    , @PurchaseDate = @PurchaseDate OUTPUT
                    , @ExpiryDate = @ExpiryDate OUTPUT

                SET @ClientID = (SELECT TOP 1 ClientID FROM Clientele.Clients WHERE IsCurrent = 0 ORDER BY NEWID())

                /* Add 1 record into Membership.Orders. Make corresponding changes into AllCards*/
                EXEC STP_HLP_AddMembershipPurchase
                    @PurchaseDate = @PurchaseDate
                    , @ExpiryDate = @ExpiryDate
                    , @LotID = @LotID
                    , @ZoneID = @ZoneID
                    , @PeriodID = @PeriodID
                    , @ClientID = @ClientID

                /* Make corresponding changes into Clients */
                SET @ParkingCityID = (SELECT CityID FROM Parking.Lots WHERE LotID = @LotID)

                IF FLOOR(RAND()*100+1) > 30
                    SET @HomeCityID = (SELECT TOP 1 CityID FROM Location.Cities WHERE ClosestCityWithParking = @ParkingCityID ORDER BY NEWID())
                ELSE
                    SET @HomeCityID = @ParkingCityID

                UPDATE Clientele.Clients
                    SET IsCurrent = 1
                    , CityID = @HomeCityID
                    WHERE ClientID = @ClientID

                /* Add records about prior purchases of the same Client */
                EXEC STP_HLP_ClientsExpiredMembership
                    @PurchaseDate = @PurchaseDate
                    , @LotID = @LotID
                    , @ZoneID = @ZoneID
                    , @PeriodID = @PeriodID
                    , @ClientID = @ClientID

                SET @MissingClients -= 1
            END

            SET @CapacityCounter += 1
        END

        SET @TargetDate = (DATEADD(DAY, -30, @TargetDate))
        SET @ZoneCounter = 1

        /* Fill in temporary table #Capacity */
        WHILE @ZoneCounter <= 88
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


    SET @TargetDate = (SELECT CONVERT(DATE, getdate())) -- the date of data generation

    /* Post-processing of table Parking.Zones: fill in MemberReservedSlots with up-to-date info */
    SET @ZoneCounter = 1

    WHILE @ZoneCounter <= 88
    BEGIN
        UPDATE #Capacity
            SET MemberReservedSlots = (SELECT COUNT(OrderID) FROM Membership.Orders
                WHERE (ZoneID = @ZoneCounter) AND (@TargetDate BETWEEN PurchaseDate AND ExpiryDate))
            WHERE ZoneID = @ZoneCounter
        SET @ZoneCounter += 1
    END

    UPDATE Parking.Zones
        SET MemberReservedSlots = (SELECT MemberReservedSlots FROM #Capacity
            WHERE (ZoneID = @ZoneCounter))
        WHERE ZoneID = @ZoneCounter

    /* Post-processing of table Clientele.Clients: delete unused records;
    mark only clients that have active cards to date as current ones */
    DELETE FROM Clientele.Clients WHERE CityID IS NULL

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