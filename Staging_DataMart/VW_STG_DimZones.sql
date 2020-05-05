CREATE VIEW VW_STG_DimZones
AS
SELECT z.ZoneID, c.CityName AS City, l.LotID AS ParkingID, l.LotName As Parking_Name, ss.SlotDescription as Slot_Type, z.Capacity, 
	l.Address, l.PhoneNumber, l.Email
	FROM Parking.Zones z
	JOIN Parking.Lots l ON l.LotID = z.LotID
	JOIN Parking.ZoneTypes zt ON z.ZoneTypeID = zt.ZoneTypeID
	JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID
	JOIN Location.Cities c ON l.CityID = c.CityID
GO