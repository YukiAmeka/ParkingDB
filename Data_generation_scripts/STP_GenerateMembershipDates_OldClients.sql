/* Generate random start date & calculate expiry date
for the current record; insert into current record */

CREATE PROC STP_GenerateMembershipDates_OldClients
(
        @PeriodInDays  AS INT
        ,@TargetDate AS DATE
        ,@PurchaseDate AS DATE OUTPUT
        ,@ExpiryDate AS DATE OUTPUT
)
AS
BEGIN
    DECLARE @EarliestDate DATE

    SET @EarliestDate = (DATEADD(DAY, @PeriodInDays * -1 + 1, @TargetDate))
    SET @PurchaseDate = (DATEADD(DAY, ABS(CHECKSUM(NEWID()) % @PeriodInDays - 2), @EarliestDate))
    SET @ExpiryDate = (DATEADD(DAY, @PeriodInDays, @PurchaseDate))
END

DECLARE @PurchaseDate DATE
DECLARE @ExpiryDate DATE

EXEC STP_GenerateMembershipDates_OldClients @PeriodInDays = 30, @TargetDate = '2020-04-20', @PurchaseDate = @PurchaseDate OUTPUT, @ExpiryDate = @ExpiryDate OUTPUT

PRINT @PurchaseDate
PRINT @ExpiryDate
