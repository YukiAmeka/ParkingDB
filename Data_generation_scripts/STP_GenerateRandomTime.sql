CREATE PROCEDURE STP_GenerateRandomTime
(
    @StartTime TIME(0)
    , @SecondsTillEndTime INT
    , @RandomTime TIME(0) OUTPUT
)
AS
BEGIN
    SET @RandomTime = (SELECT DATEADD(s, ABS(CHECKSUM(NewId()) % @SecondsTillEndTime), CAST(@StartTime AS Time(0))))
END




DECLARE @PurchaseTime TIME(0)
EXEC STP_GenerateRandomTime @StartTime = '08:00:00', @SecondsTillEndTime = 50400, @RandomTime = @PurchaseTime OUTPUT
PRINT @PurchaseTime