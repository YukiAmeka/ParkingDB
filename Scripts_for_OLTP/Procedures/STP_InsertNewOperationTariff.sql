--CREATE TABLE #TariffsTemp (
--    TariffID INT PRIMARY KEY IDENTITY NOT NULL,
--    TariffNameID INT NULL,
--    TariffStartDate INT NOT NULL DEFAULT 1827 ,
--    TariffEndDate INT NOT NULL DEFAULT 2192,
--    Price decimal(10,2) NULL,
--    ZoneID INT NULL
--);		


CREATE PROCEDURE STP_InsertNewOperationTariff (
	@LotName VARCHAR (50),
	@SlotDescription VARCHAR (20),
	@TariffName VARCHAR(30),
	@Price DECIMAL (8,2),
	@TariffStartDate DATE,
	@TariffEndDate DATE
	)
AS

BEGIN

DECLARE 
@TariffNameID INT,
@TariffStartDateID INT, 
@TariffEndDateID INT,
@ZoneID INT

SET @TariffNameID = (SELECT TariffNameID FROM Operation.TariffNames WHERE Name = @TariffName)
SET @TariffStartDateID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @TariffStartDate)
SET @TariffEndDateID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @TariffEndDate)
SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
		JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
		JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND ZoneTypeName IN ('C','D')
		JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
							ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))

INSERT INTO #TariffsTemp (TariffNameID, TariffStartDate, TariffEndDate, Price, ZoneID) 
		VALUES (@TariffNameID, @TariffStartDateID, @TariffEndDateID, @Price, @ZoneID)

END



--EXEC STP_InsertNewOperationTariff 'L-1', 'Extended',  'DayHour', 6.00,  '2020-04-25', '2020-12-31'

--SELECT * FROM 	#TariffsTemp
--TRUNCATE TABLE  #TariffsTemp