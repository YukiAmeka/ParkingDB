CREATE PROCEDURE STP_GNR_OperationOrdersUnregularClients

	AS 
		BEGIN


CREATE TABLE #Zones (
ID INT IDENTITY, 
ZoneID INT)

INSERT INTO #Zones (ZoneID)
SELECT DISTINCT(ZoneID) FROM Operation.Tariffs
ORDER BY ZoneID


SELECT  Price, TariffID, TariffStartDate, TariffEndDate, z.LotID, z.ZoneID, tn.Name 
    INTO #Tariffs
		FROM Operation.Tariffs AS t
		JOIN Parking.Zones AS z
		ON t.ZoneID = z.ZoneID
		JOIN Operation.TariffNames AS tn
		ON tn.TariffNameID = t.TariffNameID


	SELECT * INTO #TempShifts
	FROM(
		SELECT s.EmployeeID, CAST(c.TheDate AS DATETIME) + CAST(s.TimeStart AS DATETIME) AS DateTimeStart, 
		CAST(c1.TheDate AS DATETIME)  + CAST(s.TimeEnd AS DATETIME) AS DateTimeEnd
		FROM Staff.Shifts s
		JOIN Services.CalendarDates c
		ON s.DateStart = c.DateID
		JOIN Services.CalendarDates c1
		ON s.DateEnd = c1.DateID) q
						





DECLARE 
@ZoneID INT,
@CarID INT,
@EmployeeOnEntry INT,
@EmployeeOnExit INT,
@Capacity INT,
@CurrentDateEntry INT,
@CurrentDateExit INT,
@CurrentTimeEntry TIME,
@CurrentTimeExit TIME,
@LotID INT,
@Cycle INT,
@Tariff1 decimal(6, 2),
@Tariff2 decimal(6, 2),
@Tariff3 decimal(6, 2),
@Tariff4 decimal(6, 2),
@Tariff5 decimal(6, 2),
@Total decimal(6, 2),
@TotalCost decimal(6,2),
@TimeDiff INT,
@TariffDiff INT,           --NightShift/NightHour OR DayShift/DayHour
@TimeEntry DATETIME,
@TimeExit DATETIME,
@TimeDifference DECIMAL(6,2),
@ShiftStart DATETIME,
@ShiftEnd DATETIME,
@TimeCheckStart TIME(0),
@TimeCheckEnd TIME(0),
@CarNumber INT,
@NextZone INT


SET @ShiftStart = '2015-01-01 06:00:00'
SET @ShiftEnd = DATEADD(dd, 1, @ShiftStart)

WHILE @ShiftStart <= '2015-12-31 06:00:00'  --WHILE 1
BEGIN

SET @NextZone = 1

WHILE @NextZone <= 36                   --WHILE 2
BEGIN

SET @ZoneID = (SELECT ZoneID FROM #Zones WHERE ID = @NextZone)
SET @LotID = (SELECT LotID FROM Parking.Zones WHERE ZoneID = @ZoneID)
SET @CarID = (SELECT TOP(1) c.CarID 
              FROM Clientele.Cars AS c
			  JOIN Parking.Lots AS l
			  ON c.CityID = l.CityID
			  WHERE c.ClientID IS NULL AND c.CityID IS NOT NULL AND l.LotID = @LotID
			  ORDER BY NEWID())


SET @Capacity = (SELECT Capacity 
                 FROM Parking.Zones 
				 WHERE ZoneID =  @ZoneID)

SET @Cycle = 1

WHILE @Cycle < = @Capacity * 0.8            -- While 3
BEGIN
--##############################################
-- Using Generation STP

EXECUTE STP_GeneratingDateTime @StartShift = @ShiftStart, 
                               @EndShift = @ShiftEnd,
							   @TimeEntry = @TimeEntry OUTPUT,
							   @TimeExit = @TimeExit OUTPUT,
							   @TimeDifference = @TimeDifference OUTPUT

SET @CurrentDateEntry = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = (CONVERT(Date, @TimeEntry)))
SET @CurrentTimeEntry = CONVERT(TIME(0), @TimeEntry)
SET @CurrentDateExit = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = (CONVERT(Date, @TimeExit)))  
SET @CurrentTimeExit = CONVERT(TIME(0), @TimeExit)


SET @Tariff1 = (SELECT Price FROM  #Tariffs
								WHERE Name = 'DayHour' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365    --DATE!!!!!!!!!!!!!
								AND LotID = @LotID AND ZoneID = @ZoneID) 

SET @Tariff2 = (SELECT Price FROM #Tariffs
								WHERE Name = 'DayShift' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365      --DATE!!!!!!!!!!!!!
								AND LotID = @LotID AND ZoneID = @ZoneID)

SET @Tariff3 = (SELECT Price FROM  #Tariffs
								WHERE Name = 'NightHour' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365    --DATE!!!!!!!!!!!!!
								AND LotID = @LotID AND ZoneID = @ZoneID)


SET @Tariff4 = (SELECT Price FROM #Tariffs
								WHERE Name = 'NightShift' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365      --DATE!!!!!!!!!!!!!
								AND LotID = @LotID AND ZoneID = @ZoneID)


SET @Tariff5 = (SELECT Price FROM #Tariffs
								WHERE Name = 'AllDay' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365      --DATE!!!!!!!!!!!!!
								AND LotID = @LotID AND ZoneID = @ZoneID)


--#####################################################
--Calculating TotalCost


IF @TimeDifference <= 12
BEGIN                                    
	IF @CurrentTimeEntry BETWEEN '06:00:00' AND '17:59:59'
		BEGIN
			SET @TariffDiff = CEILING(@Tariff2/@Tariff1)
			IF @TimeDifference < @TariffDiff
				SET @TotalCost = @TimeDifference * @Tariff1
			ELSE
				SET @TotalCost = @Tariff2
				
		END	
	ELSE
			IF (@CurrentTimeEntry > '18:00:00' AND @CurrentTimeEntry <= '23:59:59') 
				OR (@CurrentTimeEntry > '00:00:00' AND @CurrentTimeEntry <= '05:59:59')
				BEGIN
					SET @TariffDiff = CEILING(@Tariff4/@Tariff3)
					IF @TimeDifference < @TariffDiff
						SET @TotalCost = @TimeDifference * @Tariff3	
					ELSE
						SET @TotalCost = @Tariff4		
				END
END

IF @TimeDifference > 12 AND @TimeDifference <= 24
SET @TotalCost = @Tariff5

IF @TimeDifference > 24
SET @TotalCost = CEILING(@TimeDifference/24)*@Tariff5


--####################################################

SET @EmployeeOnEntry = (SELECT s.EmployeeID
                        FROM #TempShifts AS s
						JOIN Staff.Employees AS e
						ON s.EmployeeID = e.EmployeeID
						JOIN Parking.Lots AS l
						ON e.LotID = l.LotID
						JOIN Parking.Zones AS z
						ON l.LotID = z.LotID
	                    WHERE DateTimeStart <= @TimeEntry  AND DateTimeEnd > @TimeEntry AND (DateTimeEnd < @TimeExit OR DateTimeEnd >@TimeExit )
						 
						AND l.LotID = @LotID 
						AND z.ZoneID = @ZoneID) 				
																

SET @EmployeeOnExit = (SELECT s.EmployeeID
                        FROM #TempShifts AS s
						JOIN Staff.Employees AS e
						ON s.EmployeeID = e.EmployeeID
						JOIN Parking.Lots AS l
						ON e.LotID = l.LotID
						JOIN Parking.Zones AS z
						ON l.LotID = z.LotID
	                    WHERE DateTimeStart  <= @TimeExit 
						AND DateTimeEnd > @TimeEntry AND DateTimeEnd > @TimeExit
						AND l.LotID = @LotID 
						AND z.ZoneID = @ZoneID) 

--##################################################

INSERT INTO Operation.Orders (ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, EmployeeOnExit, DateExit, TimeExit, TotalCost)
VALUES (@ZoneID, @CarID, @EmployeeOnEntry, @CurrentDateEntry, @CurrentTimeEntry, @EmployeeOnExit, @CurrentDateExit, @CurrentTimeExit, @TotalCost)

SET @CarID = (SELECT TOP(1) c.CarID 
              FROM Clientele.Cars AS c
			  JOIN Parking.Lots AS l
			  ON c.CityID = l.CityID
			  WHERE c.ClientID IS NULL AND c.CityID IS NOT NULL AND l.LotID = @LotID
			  ORDER BY NEWID())


SET @Cycle = @Cycle + 1
END                                   -- While 3

SET @NextZone = @NextZone + 1

END                           -- WHILE 2

SET @ShiftStart = DATEADD(dd, 1, @ShiftStart)
SET @ShiftEnd = DATEADD(dd, 1, @ShiftEnd)

END                               -- WHILE 1


DELETE FROM #Zones
DELETE FROM #TempShifts

  END
--########################################################
--########################################################



--SELECT * FROM Operation.Orders
