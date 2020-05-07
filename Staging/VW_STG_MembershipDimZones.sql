CREATE VIEW VW_STG_MembershipDimZones
AS
SELECT z.ZoneID, l.LotName, zt.ZoneTypeName, z.Capacity, ss.SlotDescription,
	c.CityName, l.Address, l.PhoneNumber, l.Email
	FROM Parking.Zones z
	JOIN Parking.Lots l ON l.LotID = z.LotID
	JOIN Parking.ZoneTypes zt ON z.ZoneTypeID = zt.ZoneTypeID
	JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID
	JOIN Location.Cities c ON l.CityID = c.CityID
        WHERE zt.ZoneTypeName = 'A' OR zt.ZoneTypeName = 'B'
GO