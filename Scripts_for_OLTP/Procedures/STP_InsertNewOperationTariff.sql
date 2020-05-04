 -- ===================================================================================================================================================
/*
Author:	Volodymyr Lavryntsiv
Create date: 2020-04-27
Short description: Insert new operational tariff
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: 

EXEC STP_InsertNewOperationTariff 'L-1', 'Extended',  'DayHour', 6.00,  '2020-04-25', '2020-12-31'
*/
-- ===================================================================================================================================================


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
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;
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

			INSERT INTO Operation.Tariffs (TariffNameID, TariffStartDate, TariffEndDate, Price, ZoneID) 
				VALUES (@TariffNameID, @TariffStartDateID, @TariffEndDateID, @Price, @ZoneID)

		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END