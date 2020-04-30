CREATE PROCEDURE STP_GNR_OperationOrdersUnregularRestClients
 
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

--TRUNCATE TABLE #Zones

DECLARE
@TimeCheckStart TIME(0),
@TimeCheckEnd TIME(0),
@CarNumber INT,
@CurrentDateEntry INT,
@DateEntry INT,
@Capacity INT,
@ZoneID INT,
@CarID INT,
@EmployeeOnEntry INT,
@EmployeeOnExit INT,
@CurrentDateExit INT,
@CurrentTimeEntry TIME,
@CurrentTimeExit TIME,
@LotID INT,
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
@CarOccupied INT,
@NextZone INT



	--Check the capacity every 3h
 SET @DateEntry = 2

 SET @ShiftStart = '2015-01-02 00:00:00'
 SET @ShiftEnd = DATEADD(hh, 6, @ShiftStart)


 WHILE @DateEntry <= 365             -- WHILE 1
 BEGIN

	SET @NextZone = 1

		WHILE @NextZone <= 36                     --WHILE 2
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

			   


	SET @TimeCheckStart = '00:00:01'
	SET @TimeCheckEnd = DATEADD(hh, 3, @TimeCheckStart)

	

	WHILE @TimeCheckStart <= '21:00:00'       --WHILE 3
		BEGIN
			SET @CarNumber = 0
			SET @CarOccupied = (SELECT COUNT(*) FROM Operation.Orders
						     WHERE DateEntry = @DateEntry AND TimeEntry >= @TimeCheckStart AND TimeEntry < @TimeCheckEnd AND TimeExit >= @TimeCheckEnd)
			WHILE  @CarNumber <= (@Capacity - @CarOccupied) *0.8         --WHILE  4

				BEGIN
					
					--##############################################
					-- Using Generation STP

					EXECUTE STP_HLP_DateTime        @StartShift = @ShiftStart, 
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


--#####################################################
	--Calculating TotalCost

	--Compare tariffs and get the lowest one

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

	INSERT INTO Operation.Orders (ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, EmployeeOnExit, DateExit, TimeExit, TotalCost)											  
	VALUES (@ZoneID, @CarID, @EmployeeOnEntry, @CurrentDateEntry, @CurrentTimeEntry, @EmployeeOnExit, @CurrentDateExit, @CurrentTimeExit, @TotalCost)
						
		SET @CarNumber = @CarNumber + 1

			  SET @CarID = (SELECT TOP(1) c.CarID 
              FROM Clientele.Cars AS c
			  JOIN Parking.Lots AS l
			  ON c.CityID = l.CityID
			  WHERE c.ClientID IS NULL AND c.CityID IS NOT NULL AND l.LotID = @LotID
			  ORDER BY NEWID())

				END                                         --WHILE 4

			SET @TimeCheckStart = DATEADD(hh, 3, @TimeCheckStart)		

			SET @TimeCheckEnd = DATEADD(hh, 3, @TimeCheckStart)

		
		--Increase cycles
	
		END                                                   --WHILE 3		
		  SET @NextZone = @NextZone + 1

	END                                                   --WHILE 2

	SET @DateEntry = @DateEntry + 1
		SET @ShiftStart = DATEADD(dd, 1, @ShiftStart)
			SET @ShiftEnd = DATEADD(dd, 1, @ShiftEnd)
 END                                                 -- WHILE @DateEntry 1

DROP TABLE #Zones
DROP TABLE #TempShifts
DROP TABLE #Tariffs

 END
