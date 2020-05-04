 -- ===================================================================================================================================================
/*
Author:	Volodymyr Lavryntsiv
Create date: 2020-04-27
Short description: Completing of the order and calculation of the total cost
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution:


----1--- No memmbership, don\t want new membership, car exists
--EXEC STP_InsertNewOperationOrderExit 'TH14UNQ', 'Mannix', 'Bernard', '2020-04-26','18:54:00'

----2-- No memmbership, don\t want new membership, car don`t exist
--EXEC STP_InsertNewOperationOrderExit  'ZZ12ZZK', 'Edan', 'Pugh', '2020-05-04','19:26:00'

----3--No memmbership, want new membership, car exists
--EXEC STP_InsertNewOperationOrderExit  'UU46KCQ', 'Charles', 'Randolph', '2020-05-04','18:56:00'

----4--No memmbership, want new membership, car don`t exists
--EXEC STP_InsertNewOperationOrderExit 'ZZ11ZZC', 'Mannix', 'Bernard', '2020-05-04','12:54:00'

----5--Has memmbership, car exists
--EXEC STP_InsertNewOperationOrderExit  'IY71FGW', 'Charles', 'Randolph', '2020-04-27','18:56:00'

---6---membership non valid
--EXEC STP_InsertNewOperationOrderExit  'IY71FGW', 'Charles', 'Randolph', '2020-04-27','19:09:00'
*/
-- ===================================================================================================================================================


CREATE PROCEDURE STP_InsertNewOperationOrderExit (
	@plate CHAR(7),
	@EmployeeOnExitName VARCHAR (50),
	@EmployeeOnExitSurname VARCHAR (50),
	@DateExit DATE,
	@TimeExit TIME
	)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

------------BEGIN PROCEDURE-------------

DECLARE

@EmployeeOnExitID INT,
@LotID INT,
@OrderID INT,
@DateExitID INT,
@TotalCost DECIMAL (6,2),
@AllCardID INT,
@CheckMemb BIT,
@Tariff1 decimal(6, 2),
@Tariff2 decimal(6, 2),
@Tariff3 decimal(6, 2),
@Tariff4 decimal(6, 2),
@Tariff5 decimal(6, 2),
@DateEntry INT,
@ZoneID INT,
@TimeDifference DECIMAL	(6,2),
@TimeEntry TIME(0),
@TariffDiff INT,
@TariffStartDate DATE


SET @OrderID = (SELECT TOP(1) OrderID  FROM Operation.Orders
				WHERE CarID = (SELECT CarID FROM Clientele.Cars WHERE Plate = @plate)
				AND (DateExit IS NULL OR TotalCost IS NULL))

SET @ZoneID = (SELECT ZoneID FROM Operation.Orders WHERE OrderID = @OrderID)

SET @DateEntry = (SELECT DateEntry FROM Operation.Orders WHERE OrderID = @OrderID)

SET @TimeEntry = (SELECT TimeEntry FROM Operation.Orders WHERE OrderID = @OrderID)

SET @LotID = (SELECT l.LotID FROM Parking.Lots l JOIN Parking.Zones z ON z.LotID = l.LotID
			  JOIN Operation.Orders o ON o.ZoneID = z.ZoneID WHERE o.OrderID = @OrderID)
				 
SET @EmployeeOnExitID = (SELECT DISTINCT e.EmployeeID FROM Staff.Employees e
							JOIN Parking.Lots l ON e.LotID = l.LotID AND l.LotID = @LotID
						 AND e.FirstName =  @EmployeeOnExitName AND e.Surname = @EmployeeOnExitSurname)
SET @DateExitID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @DateExit)

SET @AllCardID = (SELECT AllCardID FROM Operation.Orders WHERE OrderID = @OrderID)

IF EXISTS (SELECT * FROM Membership.AllCards m JOIN Membership.ActiveCards a ON m.AllCardID = a.AllCardID
				 WHERE m.AllCardID = @AllCardID AND a.ExpiryDate >= @DateExit) ---before exit checks if member card is active 
	SET @CheckMemb = 1
ELSE
	SET @CheckMemb = 0

IF @CheckMemb = 1
	SET @TotalCost = 0  --- cost is 0 for customers with membership 

ELSE 
	BEGIN
	SET @Tariff1 = (SELECT Price FROM VW_ActualTariffs
								WHERE Tariff = 'DayHour'
								AND LotID = @LotID AND ZoneID = @ZoneID) 

	SET @Tariff2 = (SELECT Price FROM VW_ActualTariffs
								WHERE Tariff = 'DayShift'
								AND LotID = @LotID AND ZoneID = @ZoneID) 

	SET @Tariff3 = (SELECT Price FROM VW_ActualTariffs
								WHERE Tariff = 'NightHour'
								AND LotID = @LotID AND ZoneID = @ZoneID) 


	SET @Tariff4 = (SELECT Price FROM VW_ActualTariffs
								WHERE Tariff = 'NightShift'
								AND LotID = @LotID AND ZoneID = @ZoneID) 


	SET @Tariff5 = (SELECT Price FROM VW_ActualTariffs
								WHERE Tariff = 'AllDay'
								AND LotID = @LotID AND ZoneID = @ZoneID) 

	DECLARE @ROUNDTIME DECIMAL(6,2) = (SELECT DATEDIFF(mi, @TimeEntry, @TimeExit))
	SET @TIMEDIFFERENCE = CEILING(@ROUNDTIME/60)
	
		IF @TimeDifference <= 12
		BEGIN                                    
			IF @TimeEntry BETWEEN '06:00:00' AND '17:59:59'
				BEGIN
				SET @TariffDiff = CEILING(@Tariff2/@Tariff1)
				IF @TimeDifference < @TariffDiff
					BEGIN
						SET @TotalCost = @TimeDifference * @Tariff1
						SET @TariffID = @Tariff1
					END
				ELSE
					BEGIN
						SET @TotalCost = @Tariff2
						SET @TariffID = @Tariff2
					END
				END	
			ELSE
				IF (@TimeEntry > '18:00:00' AND @TimeEntry <= '23:59:59') 
					OR (@TimeEntry > '00:00:00' AND @TimeEntry <= '05:59:59')
				BEGIN
					SET @TariffDiff = CEILING(@Tariff4/@Tariff3)
					IF @TimeDifference < @TariffDiff
						BEGIN
							SET @TotalCost = @TimeDifference * @Tariff3	
							SET @TariffID = @Tariff3
						END
					ELSE
						BEGIN
							SET @TotalCost = @Tariff4		
							SET @TariffID = @Tariff4
						END
				END
		END

	IF @TimeDifference > 12 AND @TimeDifference <= 24
		BEGIN
			SET @TotalCost = @Tariff5
			SET @TariffID = @Tariff5
		END

	IF @TimeDifference > 24
		BEGIN
			SET @TotalCost = CEILING(@TimeDifference/24)*@Tariff5
			SET @TariffID = @Tariff5
		END
	END

UPDATE Operation.Orders
	SET EmployeeOnExit = @EmployeeOnExitID,
		DateExit = @DateExitID,
		TimeExit = @TimeExit,
		TotalCost = @TotalCost
	WHERE OrderID = @OrderID

-----------END PROCEDURE---------------

		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END