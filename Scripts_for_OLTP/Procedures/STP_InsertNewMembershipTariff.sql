 /*
 
Author:	Ihor Prytula
Create date: 2020-04-27
Short description: Insert new Membership tariff

EXEC STP_InsertNewMembershipTariff 'L-1', 'Standart', 'QuaterFull', 270.00, '2020-05-05', '2020-08-05'
*/


IF OBJECT_ID ('STP_InsertNewMembershipTariff') IS NOT NULL
DROP PROCEDURE STP_InsertNewMembershipTariff
GO


CREATE PROCEDURE STP_InsertNewMembershipTariff 
	( 
	 @LotName VARCHAR (50)
	,@SlotDescription VARCHAR (20)
	,@PeriodName VARCHAR(20)
	,@Price DECIMAL (12,2)
	,@StartDate DATE
	,@EndDate DATE
	)

AS									  
BEGIN
BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;
	
			DECLARE @ZoneID INT
			DECLARE @PeriodID INT	
			
					
			SET @PeriodID = (SELECT PeriodID FROM Membership.Periods WHERE PeriodName = @PeriodName)
			SET @ZoneID = (SELECT Parking.Zones.ZoneID FROM Parking.Zones
				
				INNER JOIN Parking.Lots ON Parking.Zones.LotID = Parking.Lots.LotID
				AND Parking.Zones.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)

	 			INNER JOIN Parking.ZoneTypes ON Parking.Zones.ZoneTypeID = Parking.ZoneTypes.ZoneTypeID
				AND Parking.ZoneTypes.ZoneTypeName IN ('A','B')
		
				INNER JOIN Parking.SlotSizes ON Parking.ZoneTypes.SlotSizeID = Parking.SlotSizes.SlotSizeID
				AND Parking.SlotSizes.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))
	
			INSERT INTO Membership.Tariffs (ZoneID, PeriodID, Price, StartDate, EndDate)
				VALUES	(@ZoneID, @PeriodID, @Price, @StartDate, @EndDate)
		COMMIT TRAN
END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
	END CATCH
END



