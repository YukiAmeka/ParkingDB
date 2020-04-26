CREATE PROCEDURE STP_HLP_DateTime (
@startShift DATETIME, 
@endShift DATETIME,
@timeEntry DATETIME OUTPUT,
@TimeExit DATETIME OUTPUT,
@TIMEDIFFERENCE DECIMAL(6,2) OUTPUT
)
AS 
BEGIN

-- DECLARE @startShift DATETIME = '2020-04-12 18:00:00'
-- DECLARE @endShift DATETIME = '2020-04-13 05:00:00' 
DECLARE @maxSeconds int = DATEDIFF(ss, @startShift, @endShift)
DECLARE @randomSeconds int = (@maxSeconds + 1) * RAND(convert(varbinary, newId() )) 

SET @TimeEntry = (SELECT (convert(dateTime, DateAdd(second, @randomSeconds, @startShift)))) 
--SELECT @TimeEntry

SET @maxSeconds = DATEDIFF(ss, @TimeEntry, @endShift)
--PRINT @maxSeconds
SET @randomSeconds = (@maxSeconds + 30000) * RAND(convert(varbinary, newId() )) 
---PRINT @randomSeconds
SET @TimeExit  = (SELECT (convert(dateTime, DateAdd(ss, @randomSeconds, @TimeEntry))))
 
DECLARE @ROUNDTIME DECIMAL(6,2) = (SELECT DATEDIFF(mi, @TimeEntry, @TimeExit))
SET @TIMEDIFFERENCE = CEILING(@ROUNDTIME/60)

--SELECT @TimeExit	
--SELECT @TIMEDIFFERENCE
--SELECT @startShift + @TIMEDIFFERENCE
IF @TIMEDIFFERENCE = 0.0
   SET @TIMEDIFFERENCE = @TIMEDIFFERENCE + 1

--SELECT @timeEntry, @TimeExit, CASE WHEN @TIMEDIFFERENCE = 0  THEN 1
--								   ELSE @TIMEDIFFERENCE
--							       END AS TimeDiff

END





DECLARE 
@timeEntry DATETIME,
@TimeExit DATETIME,
@TIMEDIFFERENCE DECIMAL(6,2)

EXECUTE STP_GeneratingDateTime @startShift = '2015-01-01 06:00:00', 
                               @endShift = '2015-01-02 06:00:00',
							   @timeEntry = @timeEntry OUTPUT,
							   @TimeExit = @TimeExit OUTPUT,
							   @TIMEDIFFERENCE = @TIMEDIFFERENCE OUTPUT

SELECT @timeEntry, @TimeExit, @TIMEDIFFERENCE



