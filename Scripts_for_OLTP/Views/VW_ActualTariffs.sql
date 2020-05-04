CREATE VIEW VW_ActualTariffs
AS		

SELECT LC.CityName AS City, L.LotName AS Parking, ss.SlotDescription AS SlotType, tn.Name AS Tariff,
 t.Price,  c.theDate AS TariffStartDate, C1.TheDate AS TariffEndDate 
	FROM Operation.Tariffs t
	JOIN Services.CalendarDates c ON
	t.TariffStartDate = c.DateID
	JOIN Services.CalendarDates C1
	ON T.TariffEndDate = C1.DateID
	JOIN Operation.TariffNames tn 
	ON t.TariffNameID = tn.TariffNameID
	join parking.zoneS z 
	ON T.ZONEID = Z.ZONEID
	JOIN Parking.ZoneTypes zt
	ON z.ZoneTypeID = zt.ZoneTypeID
	JOIN Parking.SlotSizes ss
	ON zt.SlotSizeID = ss.SlotSizeID
	JOIN PARKING.LOTS L
	ON Z.LOTID = L.LOTID
	JOIN LOCATION.CITIES LC
	ON L.CITYID = LC.CITYID
	WHERE C.TheDate = '2020-01-01'