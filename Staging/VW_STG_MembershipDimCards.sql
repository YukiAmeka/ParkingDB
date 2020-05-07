CREATE VIEW VW_DimCards
AS
SELECT
 Membership.AllCards.AllCardID
,MemberCardNumber
,ExpiryDate
,PeriodName
,ZoneTypeName
,SlotDescription
,LotName
,CityName

FROM Membership.AllCards
INNER JOIN Membership.ActiveCards ON Membership.ActiveCards.AllCardID = Membership.AllCards.AllCardID
INNER JOIN Membership.Tariffs ON Membership.AllCards.TariffID = Membership.Tariffs.TariffID
INNER JOIN Membership.Periods ON Membership.Periods.PeriodID = Membership.Tariffs.PeriodID
INNER JOIN Parking.Zones ON Membership.ActiveCards.ZoneID = Parking.Zones.ZoneID
INNER JOIN Parking.ZoneTypes ON Parking.Zones.ZoneTypeID = Parking.ZoneTypes.ZoneTypeID
INNER JOIN Parking.SlotSizes ON Parking.ZoneTypes.SlotSizeID = Parking.SlotSizes.SlotSizeID
INNER JOIN Parking.Lots ON Parking.Zones.LotID = Parking.Lots.LotID
INNER JOIN Location.Cities ON Parking.Lots.CityID = Location.Cities.CityID