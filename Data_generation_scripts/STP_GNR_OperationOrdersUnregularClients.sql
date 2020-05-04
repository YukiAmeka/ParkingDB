CREATE PROCEDURE STP_GNR_OperationOrdersUnregularClients

	AS 
		BEGIN

		-- Creating tempTable to keep and loop through all zones 

CREATE TABLE #Zones (
ID INT IDENTITY, 
ZoneID INT)

INSERT INTO #Zones (ZoneID)
SELECT DISTINCT(ZoneID) FROM Operation.Tariffs
ORDER BY ZoneID

		-- Creating tempTable #Tariffs to keep all tariffs with price and other information

SELECT  Price, TariffID, TariffStartDate, TariffEndDate, z.LotID, z.ZoneID, tn.Name 
    INTO #Tariffs
		FROM Operation.Tariffs AS t
		JOIN Parking.Zones AS z
		ON t.ZoneID = z.ZoneID
		JOIN Operation.TariffNames AS tn
		ON tn.TariffNameID = t.TariffNameID

		-- Creating #TempShifts and converting DATE and TIME into DATETIME

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
@TariffID INT,
@TariffID1 INT,
@TariffID2 INT,
@TariffID3 INT,
@TariffID4 INT,
@TariffID5 INT,
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


 SET @ShiftStart = '2015-01-01 06:00:00'     --Generating Start Date
 SET @ShiftEnd = DATEADD(dd, 1, @ShiftStart)

	WHILE @ShiftStart <= '2015-12-31 06:00:00'  --WHILE 1  Genegating End Date
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
		-- Using Generation STP to get random time entry and time exit and difference between them

 EXECUTE STP_HLP_DateTime @StartShift = @ShiftStart, 
                          @EndShift = @ShiftEnd,
						  @TimeEntry = @TimeEntry OUTPUT,
					      @TimeExit = @TimeExit OUTPUT,
					      @TimeDifference = @TimeDifference OUTPUT

 SET @CurrentDateEntry = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = (CONVERT(Date, @TimeEntry)))
 SET @CurrentTimeEntry = CONVERT(TIME(0), @TimeEntry)
 SET @CurrentDateExit = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = (CONVERT(Date, @TimeExit)))  
 SET @CurrentTimeExit = CONVERT(TIME(0), @TimeExit)


   -- Get All tariffs for particular lot and zone
 
					SET @Tariff1 = (SELECT Price FROM  #Tariffs
								WHERE Name = 'DayHour' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365    --DATE!?
								AND LotID = @LotID AND ZoneID = @ZoneID)  		

					SET @Tariff2 = (SELECT Price FROM #Tariffs
								WHERE Name = 'DayShift' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365     
								AND LotID = @LotID AND ZoneID = @ZoneID)

					SET @Tariff3 = (SELECT Price FROM  #Tariffs
								WHERE Name = 'NightHour' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365    
								AND LotID = @LotID AND ZoneID = @ZoneID)

					SET @Tariff4 = (SELECT Price FROM #Tariffs
								WHERE Name = 'NightShift' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365      
								AND LotID = @LotID AND ZoneID = @ZoneID)

					SET @Tariff5 = (SELECT Price FROM #Tariffs
								WHERE Name = 'AllDay' AND TariffStartDate <= @CurrentDateEntry AND TariffEndDate <= 365      
								AND LotID = @LotID AND ZoneID = @ZoneID)




					SET @TariffID1 = (SELECT TariffID FROM  #Tariffs
							WHERE Name = 'DayHour' AND @CurrentDateEntry BETWEEN TariffStartDate  AND TariffEndDate 
							AND LotID = @LotID AND ZoneID = @ZoneID) 
		
					SET @TariffID2 = (SELECT TariffID FROM  #Tariffs
							WHERE Name = 'DayShift' AND @CurrentDateEntry BETWEEN TariffStartDate  AND TariffEndDate 
							AND LotID = @LotID AND ZoneID = @ZoneID) 

					SET @TariffID3 = (SELECT TariffID FROM  #Tariffs
							WHERE Name = 'NightHour' AND @CurrentDateEntry BETWEEN TariffStartDate  AND TariffEndDate 
							AND LotID = @LotID AND ZoneID = @ZoneID) 

					SET @TariffID4 = (SELECT TariffID FROM  #Tariffs
							WHERE Name = 'NightShift' AND @CurrentDateEntry BETWEEN TariffStartDate  AND TariffEndDate 
							AND LotID = @LotID AND ZoneID = @ZoneID) 

					SET @TariffID5 = (SELECT TariffID FROM  #Tariffs
							WHERE Name = 'AllDay' AND @CurrentDateEntry BETWEEN TariffStartDate  AND TariffEndDate
							AND LotID = @LotID AND ZoneID = @ZoneID) 


--#####################################################
		--Calculating TotalCost

		--Compare tariffs and get the lowest one

 IF @TimeDifference <= 12
 BEGIN                                    
	IF @CurrentTimeEntry BETWEEN '06:00:00' AND '17:59:59'
    BEGIN
			SET @TariffDiff = CEILING(@Tariff2/@Tariff1)
				IF @TimeDifference < @TariffDiff
					 SELECT @TotalCost = @TimeDifference * @Tariff1,
							@TariffID = @TariffID1
				ELSE
					 SELECT @TotalCost = @Tariff2,
							@TariffID = @TariffID2
				
	END	
	ELSE
			IF (@CurrentTimeEntry > '18:00:00' AND @CurrentTimeEntry <= '23:59:59') 
				OR (@CurrentTimeEntry > '00:00:00' AND @CurrentTimeEntry <= '05:59:59')
				BEGIN
					SET @TariffDiff = CEILING(@Tariff4/@Tariff3)
					IF @TimeDifference < @TariffDiff
						SELECT @TotalCost = @TimeDifference * @Tariff3,
							   @TariffID = @TariffID3	
					ELSE
						SELECT @TotalCost = @Tariff4,
							   @TariffID = @TariffID4		
				END
 END



 IF @TimeDifference > 12 AND @TimeDifference <= 24
 SELECT @TotalCost = @Tariff5, 
		 @TariffID = @TariffID5



 IF @TimeDifference > 24
  SELECT @TotalCost = CEILING(@TimeDifference/24)*@Tariff5, 
		@TariffID = @TariffID5


--####################################################

		-- Compare car time entry and get employee that was on shift in that time

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
			
		 -- Compare car time exit and get employee that was on shift in that time													
		
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

		-- Inseting all generated data in Operation.Orders

 INSERT INTO Operation.Orders (ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, EmployeeOnExit, DateExit, TimeExit, TotalCost, TariffID)
 VALUES (@ZoneID, @CarID, @EmployeeOnEntry, @CurrentDateEntry, @CurrentTimeEntry, @EmployeeOnExit, @CurrentDateExit, @CurrentTimeExit, @TotalCost, @TariffID)

 SET @CarID = (SELECT TOP(1) c.CarID 
              FROM Clientele.Cars AS c
			  JOIN Parking.Lots AS l
			  ON c.CityID = l.CityID
			  WHERE c.ClientID IS NULL AND c.CityID IS NOT NULL AND l.LotID = @LotID
			  ORDER BY NEWID())


		--Increase  cycles
			  
  SET @Cycle = @Cycle + 1
  END                                   -- While 3

  SET @NextZone = @NextZone + 1

  END                           -- WHILE 2

  SET @ShiftStart = DATEADD(dd, 1, @ShiftStart)
  SET @ShiftEnd = DATEADD(dd, 1, @ShiftEnd)

  END                               -- WHILE 1


 DROP TABLE #Zones
 DROP TABLE #TempShifts
 DROP TABLE #Tariffs


  END
--########################################################
--########################################################



--SELECT * FROM Operation.Orders ORDER BY DateEntry, dateexit


