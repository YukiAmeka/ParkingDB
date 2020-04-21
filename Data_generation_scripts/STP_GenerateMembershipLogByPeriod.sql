/* Generate historical log of membership cards' purchases (currently active clients only).
The procedure goes backwards in time (earliest record can be on 2015-01-01).
The number of clients drops off further in the past (the resulting set of records
if ordered chronologically has few active clients being active in the past, gradually being added).
Procedure updates table #MOrders that MUST EXIST in the script that calls the procedure */

CREATE PROCEDURE STP_GenerateMembershipLogByPeriod
(
    @PeriodID INT -- possible values: 1 - month, 2 - quarter, 3 - year, 4 - VIP (year)
    , @ClientNumberDrop DECIMAL(3,2) -- e.g. 0.05 - 5% drop off over each @PeriodInDays back in time
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
    DECLARE @ExpiryDate DATE

    /* Create temporary table to hold all active clients who currently have membership cards of @PeriodID sorted randomly
    with information about the type of their cards, when and where they were purchased */
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
    SET @TotalRecords = (SELECT COUNT(PeriodMembershipID) FROM #PeriodMembership) -- Number of (unique) records in #PeriodMembership
    SET @DropOuts = FLOOR(@TotalRecords * @ClientNumberDrop) -- Number of records that will be dropped at each iteration

    /* While there're still records in table #PeriodMembership and not yet 2015-01-01, go through all records with cursor */
    WHILE @TotalRecords > 0 AND (SELECT MIN (PurchaseDate) FROM #PeriodMembership) >= (DATEADD(DAY, @PeriodInDays, '2015-01-01'))
    BEGIN

        /* Implement the drop off of clients - delete the set % of last records in the randomly sorted table */
        DELETE FROM #PeriodMembership
            WHERE PeriodMembershipID BETWEEN (@TotalRecords - @DropOuts) AND @TotalRecords
        SET @TotalRecords = (SELECT COUNT(PeriodMembershipID) FROM #PeriodMembership)

        /* Create cursor to go through all records in #PeriodMembership one by one */
        DECLARE MembershipPurchaseLog CURSOR
            FOR SELECT LotID, ClientID, PurchaseDate, TariffID
            FROM #PeriodMembership

        OPEN MembershipPurchaseLog

        FETCH NEXT FROM MembershipPurchaseLog
            INTO @LotID, @ClientID, @StartDate, @TariffID

        /* Go through all remaining records in #PeriodMembership, store and process data in variables,
        add new records into table #MOrders */
        WHILE @@FETCH_STATUS = 0
            BEGIN

                /* Generate new date of purchase that extends back in time @PeriodInDays plus 1-3 days.
                Update #PeriodMembership PurchaseDate, which will be the starting date for the next iteration */
                SET @NewStartDate = (DATEADD(DAY, (ABS(CHECKSUM(NEWID()) % 3) + @PeriodInDays) * -1, @StartDate))
                UPDATE #PeriodMembership
                SET PurchaseDate = @NewStartDate
                WHERE ClientID = @ClientID

                /* Pick a random unused card from Membership.AllCards and mark it as used */
                SET @AllCardID = (SELECT TOP 1 AllCardID FROM CardListWithTariffs WHERE TariffID = @TariffID AND PeriodID = @PeriodID ORDER BY NEWID())
                UPDATE Membership.AllCards
                    SET IsUsed = 1
                    WHERE AllCardID = @AllCardID

                /* Generate random time when the purchase occurs */
                EXEC STP_GenerateRandomTime @StartTime = '08:00:00', @EndTime = '22:00:00', @RandomTime = @PurchaseTime OUTPUT

                /* Calculate expiry date */
                SET @ExpiryDate = (DATEADD(DAY, @PeriodInDays, @NewStartDate))

                /* Create new record about card purchase in #MOrders using copied or calculated data */
                INSERT INTO #MOrders (ClientID, AllCardID, PurchaseDate, TariffID, LotID, PurchaseTime, ExpiryDate)
                    VALUES (@ClientID, @AllCardID, @NewStartDate, @TariffID, @LotID, @PurchaseTime, @ExpiryDate)

                /* Fetch next line by cursor */
                FETCH NEXT FROM MembershipPurchaseLog
                    INTO @LotID, @ClientID, @StartDate, @TariffID
            END

        CLOSE MembershipPurchaseLog
        DEALLOCATE MembershipPurchaseLog
    END

    DROP TABLE #PeriodMembership
END