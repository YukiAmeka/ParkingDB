/* Generate historical log of membership cards' purchases (currently active clients only).
The procedure goes backwards in time (earliest record can be on 2015-01-01).
The number of clients drops off further in the past (the resulting set of records
if ordered chronologically has few active clients being active in the past, gradually being added).
Procedure updates table #MOrders that MUST EXIST in the script that calls the procedure */

CREATE PROCEDURE STP_HLP_ClientsExpiredMembership
(
    @LotID INT
    , @ZoneID INT
    , @ClientID INT
    , @PurchaseDate DATE
    , @PeriodID INT -- possible values: 1 - month, 2 - quarter, 3 - year, 4 - VIP (year)
)
AS

BEGIN

    DECLARE @PeriodInDays INT
    DECLARE @ClientNumberDrop INT
    SET @ClientNumberDrop = 5

    DECLARE @NewPurchaseDate DATE
    DECLARE @AllCardID INT
    DECLARE @StartDate DATE
    DECLARE @TariffID INT
    DECLARE @PurchaseTime TIME(0)
    DECLARE @ExpiryDate DATE
    DECLARE @EmployeeID INT

    SET @PeriodInDays = (SELECT CASE
        WHEN @PeriodID = 1 THEN 30
        WHEN @PeriodID = 2 THEN 90
        ELSE 365 END)

        /* Go through all remaining records in #PeriodMembership, store and process data in variables,
        add new records into table #MOrders */
        WHILE FLOOR(RAND()*100+1) > @ClientNumberDrop AND @PurchaseDate >= '2016-01-01'
        BEGIN

            /* Generate new date of purchase that extends back in time @PeriodInDays plus 1-3 days.
            Update #PeriodMembership PurchaseDate, which will be the starting date for the next iteration */
            SET @PurchaseDate = (DATEADD(DAY, (ABS(CHECKSUM(NEWID()) % 3) + @PeriodInDays) * -1, @PurchaseDate))

            /* Calculate expiry date */
            SET @ExpiryDate = (DATEADD(DAY, @PeriodInDays, @PurchaseDate))

            EXEC STP_HLP_AddMembershipPurchase
                @PurchaseDate = @PurchaseDate
                , @ExpiryDate = @ExpiryDate
                , @LotID = @LotID
                , @ZoneID = @ZoneID
                , @PeriodID = @PeriodID
                , @ClientID = @ClientID

            SET @ClientNumberDrop += 5
        END
END