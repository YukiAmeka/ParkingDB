CREATE VIEW VW_STG_StaffDimLots

AS

SELECT  l.LotID, l.LotName, c.CityName, l.Address, l.PhoneNumber, l.Email 
FROM Parking.Lots AS l
JOIN Location.Cities AS c
ON c.CityID = l.CityID