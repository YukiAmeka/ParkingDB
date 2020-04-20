CREATE PROCEDURE STP_GenerateMembershipLogByPeriod
(
    @PeriodID INT
    , @ClientNumberDrop DECIMAL(3,2)
    , @PeriodInDays INT
)
AS

BEGIN

    DECLARE @NewStartDate DATE
    DECLARE @ClientID INT
    DECLARE @AllCardID INT
    DECLARE @StartDate DATE
    DECLARE @TariffID INT
    DECLARE @LotID INT
    DECLARE @PurchaseTime TIME(0)

    CREATE TABLE #PeriodMembership
    (
        PeriodMembershipID INT IDENTITY
        , LotID INT
        , ClientID INT
        , PurchaseDate DATE
        , TariffID INT
        , PeriodID INT
    )
    INSERT INTO #PeriodMembership
    SELECT LotID, ClientID, PurchaseDate, Membership.Tariffs.TariffID, Membership.Tariffs.PeriodID
        FROM #MOrders
        INNER JOIN Membership.Tariffs ON Membership.Tariffs.TariffID = [#MOrders].TariffID
        INNER JOIN Membership.Periods ON Membership.Periods.PeriodID = Membership.Tariffs.PeriodID
        WHERE Membership.Tariffs.PeriodID = @PeriodID
        ORDER BY NEWID()

    DECLARE @DropOuts INT
    DECLARE @TotalRecords INT
    SET @TotalRecords = (SELECT COUNT(PeriodMembershipID) FROM #PeriodMembership)
    SET @DropOuts = FLOOR(@TotalRecords * @ClientNumberDrop)



    WHILE @TotalRecords > 0 AND (SELECT MIN (PurchaseDate) FROM #PeriodMembership) >= (DATEADD(DAY, @PeriodInDays, '2015-01-01'))
    BEGIN
        DELETE FROM #PeriodMembership
            WHERE PeriodMembershipID BETWEEN (@TotalRecords - @DropOuts) AND @TotalRecords
        SET @TotalRecords = (SELECT COUNT(PeriodMembershipID) FROM #PeriodMembership)

        DECLARE MembershipPurchaseLog CURSOR
            FOR SELECT LotID, ClientID, PurchaseDate, TariffID
            FROM #PeriodMembership

        OPEN MembershipPurchaseLog

        FETCH NEXT FROM MembershipPurchaseLog
            INTO @LotID, @ClientID, @StartDate, @TariffID

        WHILE @@FETCH_STATUS = 0
            BEGIN

                SET @NewStartDate = (DATEADD(DAY, (ABS(CHECKSUM(NEWID()) % 3) + @PeriodInDays) * -1, @StartDate))
                UPDATE #PeriodMembership
                SET PurchaseDate = @NewStartDate
                WHERE ClientID = @ClientID

                SET @AllCardID = (SELECT TOP 1 AllCardID FROM CardListWithTariffs WHERE TariffID = @TariffID AND PeriodID = @PeriodID ORDER BY NEWID())
                UPDATE Membership.AllCards
                    SET IsUsed = 1
                    WHERE AllCardID = @AllCardID

                EXEC STP_GenerateRandomTime @StartTime = '08:00:00', @SecondsTillEndTime = 50400, @RandomTime = @PurchaseTime OUTPUT

                INSERT INTO #MOrders (ClientID, AllCardID, PurchaseDate, TariffID, LotID, PurchaseTime)
                    VALUES (@ClientID, @AllCardID, @NewStartDate, @TariffID, @LotID, @PurchaseTime)

                FETCH NEXT FROM MembershipPurchaseLog
                    INTO @LotID, @ClientID, @StartDate, @TariffID
            END

        CLOSE MembershipPurchaseLog
        DEALLOCATE MembershipPurchaseLog
    END

    DROP TABLE #PeriodMembership
END