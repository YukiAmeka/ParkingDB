/* Create OLTP view for future data transfer into Data Mart Operation dimension Tariffs */

CREATE VIEW VW_STG_OperationDimTariffs
AS
SELECT t.TariffID
	, tn.Name AS TariffName
	, c.CityName AS City
	, l.LotName AS ParkingName
	, s.SlotDescription AS SlotType
	, t.Price
	, cd1.TheDate AS TariffStartDate
	, cd2.TheDate AS TariffEndDate

FROM Operation.Tariffs AS t
INNER JOIN Operation.TariffNames AS tn ON t.TariffNameID = tn.TariffNameID
INNER JOIN Parking.Zones AS z ON z.ZoneID = t.ZoneID
INNER JOIN Parking.ZoneTypes AS zt ON zt.ZoneTypeID = z.ZoneTypeID
INNER JOIN Parking.Lots AS l ON l.LotID = z.LotID
INNER JOIN Location.Cities AS c ON c.CityID = l.CityID
INNER JOIN Parking.SlotSizes AS s ON s.SlotSizeID = zt.SlotSizeID
INNER JOIN Services.CalendarDates AS cd1 ON cd1.DateID = t.TariffStartDate
INNER JOIN Services.CalendarDates AS cd2 ON cd2.DateID = t.TariffEndDate




