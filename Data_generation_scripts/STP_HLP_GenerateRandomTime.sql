/* Generate random time within given limits */

CREATE PROCEDURE STP_GenerateRandomTime
(
    @StartTime TIME(0)
    , @EndTime TIME(0)
    , @RandomTime TIME(0) OUTPUT
)
AS
BEGIN
    DECLARE @SecondsTillEndTime INT
    SET @SecondsTillEndTime = DATEDIFF(ss, @StartTime, @EndTime)

    SET @RandomTime = (SELECT DATEADD(ss, ABS(CHECKSUM(NewId()) % @SecondsTillEndTime), CAST(@StartTime AS Time(0))))
END



/* TEST CODE AND EXAMPLE OF USE*/

--DECLARE @PurchaseTime TIME(0)
--EXEC STP_GenerateRandomTime @StartTime = '08:00:00', @EndTime = '22:00:00', @RandomTime = @PurchaseTime OUTPUT
--PRINT @PurchaseTime