/* Generate random purchase date & calculate expiry date
for a card that is active at a given date */

CREATE PROC STP_HLP_PurchaseDateForActiveCard
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
    SET @PurchaseDate = (DATEADD(DAY, ABS(CHECKSUM(NEWID()) % (@PeriodInDays - 1)), @EarliestDate))
    SET @ExpiryDate = (DATEADD(DAY, @PeriodInDays, @PurchaseDate))
END



/* TEST CODE AND EXAMPLE OF USE*/

--DECLARE @PurchaseDate DATE
--DECLARE @ExpiryDate DATE
--EXEC STP_HLP_PurchaseDateForActiveCard @PeriodInDays = 30, @TargetDate = '2020-04-20', @PurchaseDate = @PurchaseDate OUTPUT, @ExpiryDate = @ExpiryDate OUTPUT
--PRINT @PurchaseDate
--PRINT @ExpiryDate
