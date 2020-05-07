
CREATE VIEW VW_DimTariffs
AS

SELECT 
 TariffID
,ZoneTypeName
,SlotDescription
,LotName
,CityName
,PeriodName
,Price
,StartDate
,EndDate

FROM Membership.Tariffs 
INNER JOIN Parking.Zones ON Membership.Tariffs.ZoneID = Parking.Zones.ZoneID
INNER JOIN Parking.ZoneTypes ON Parking.Zones.ZoneTypeID = Parking.ZoneTypes.ZoneTypeID
INNER JOIN Parking.SlotSizes ON Parking.ZoneTypes.SlotSizeID = Parking.SlotSizes.SlotSizeID
INNER JOIN Parking.Lots ON Parking.Zones.LotID = Parking.Lots.LotID
INNER JOIN Location.Cities ON Parking.Lots.CityID = Location.Cities.CityID
INNER JOIN Membership.Periods ON Membership.Tariffs.PeriodID = Membership.Periods.PeriodID

