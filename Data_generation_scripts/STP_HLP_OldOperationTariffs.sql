CREATE PROCEDURE STP_HLP_OldOperationTariffs

(
        @TariffStartDate as DATE,
        @TariffEndDate as DATE,
		@changePrice AS BIT ---if 'false' prices in zones between 57 and 80 don`t change
)

AS
BEGIN

	DECLARE @TariffID INT
	DECLARE @Price DECIMAL (5,2)
	DECLARE @ZoneID INT
	DECLARE @PeriodID INT
	DECLARE @CurrentIdent INT
	DECLARE @TariffnameId INT
	DECLARE @TariffStartDateID INT
	DECLARE @TariffEndDateID INT
	DECLARE @priceIndex DECIMAL (3,2)
	SET @TariffEndDateID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @TariffEndDate)
	SET @TariffStartDateID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @TariffStartDate)
	SET @CurrentIdent = (SELECT IDENT_CURRENT('Operation.Tariffs'))
	SET @TariffID = (@CurrentIdent + 1) - 180
	WHILE @TariffID <= @CurrentIdent
		BEGIN
			SET @TariffNameID = (SELECT TariffNameID FROM Operation.Tariffs WHERE TariffID = @TariffID)
			SET @ZoneID = (SELECT [ZoneID] FROM Operation.Tariffs WHERE TariffID = @TariffID)
			IF @changePrice = 'True' 
				BEGIN	
				SET @Price = (SELECT Price FROM Operation.Tariffs WHERE TariffID = @TariffID)
				SET @priceIndex = RAND() * 0.05
				SET @Price = ROUND(@Price * (1 - @priceIndex),1,1)
				END
			ELSE 
				BEGIN	
				IF @zoneID BETWEEN 59 AND 80
					BEGIN	
					SET @price = (SELECT Price FROM Operation.Tariffs WHERE TariffID = @TariffID)
					END
				ELSE
					BEGIN
					SET @Price = (SELECT Price FROM Operation.Tariffs WHERE TariffID = @TariffID)
					SET @priceIndex = RAND() * 0.05
					SET @Price = ROUND(@Price * (1 - @priceIndex),1,1)
					END
				END
			INSERT INTO Operation.Tariffs (TariffNameID,[TariffStartDate],[TariffEndDate], [Price], [ZoneID]  )
			VALUES (@TariffNameID, @TariffStartDateID, @TariffEndDateID, @Price, @ZoneID )
			SET @TariffID += 1
		END
END




