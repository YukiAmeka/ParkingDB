
CREATE VIEW VW_STG_MembershipDimTariffs
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
LEFT JOIN Parking.Zones ON Membership.Tariffs.ZoneID = Parking.Zones.ZoneID
LEFT JOIN Parking.ZoneTypes ON Parking.Zones.ZoneTypeID = Parking.ZoneTypes.ZoneTypeID
LEFT JOIN Parking.SlotSizes ON Parking.ZoneTypes.SlotSizeID = Parking.SlotSizes.SlotSizeID
LEFT JOIN Parking.Lots ON Parking.Zones.LotID = Parking.Lots.LotID
LEFT JOIN Location.Cities ON Parking.Lots.CityID = Location.Cities.CityID
INNER JOIN Membership.Periods ON Membership.Tariffs.PeriodID = Membership.Periods.PeriodID

