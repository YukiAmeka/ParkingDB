/* Generate info about possible prior membership cards' purchases by 1 client.
The procedure goes backwards in time (earliest record can be on 2015-06-01).
The likelihood that the client had older cards drops off further in the past */
CREATE PROCEDURE STP_HLP_ClientsExpiredMembership
(
    @LotID INT
    , @ZoneID INT
    , @ClientID INT
    , @PurchaseDate DATE
    , @PeriodID INT
)
AS

BEGIN

    DECLARE @PeriodInDays INT
    DECLARE @ClientNumberDrop INT
    DECLARE @NewPurchaseDate DATE
    DECLARE @AllCardID INT
    DECLARE @StartDate DATE
    DECLARE @TariffID INT
    DECLARE @PurchaseTime TIME(0)
    DECLARE @ExpiryDate DATE
    DECLARE @EmployeeID INT

    SET @ClientNumberDrop = 5
    SET @PeriodInDays = (SELECT CASE
        WHEN @PeriodID = 1 THEN 30
        WHEN @PeriodID = 2 THEN 90
        ELSE 365 END)

        /* Keep generating older records until roll low or reach cut-off date */
        WHILE FLOOR(RAND()*100+1) > @ClientNumberDrop AND @PurchaseDate >= '2015-06-01'
        BEGIN

            /* Generate new date of purchase that extends back in time @PeriodInDays plus 1-3 days. */
            SET @PurchaseDate = (DATEADD(DAY, (ABS(CHECKSUM(NEWID()) % 3) + @PeriodInDays) * -1, @PurchaseDate))

            /* Calculate expiry date */
            SET @ExpiryDate = (DATEADD(DAY, @PeriodInDays, @PurchaseDate))

            /* Add a record about Membership Card purchase */
            EXEC STP_HLP_AddMembershipPurchase
                @PurchaseDate = @PurchaseDate
                , @ExpiryDate = @ExpiryDate
                , @LotID = @LotID
                , @ZoneID = @ZoneID
                , @PeriodID = @PeriodID
                , @ClientID = @ClientID

            /* Lower the likelihood that the client had another older card on next iteration */
            SET @ClientNumberDrop += 5
        END
END