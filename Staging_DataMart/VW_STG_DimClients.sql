CREATE VIEW VW_STG_DimClients
AS
SELECT C.ClientID, C.FirstName AS [Name], C.Surname, C.Gender, C.Telephone, C.Email, C.HomeAddress, 
C.IsCurrent, Ct.CityName AS CityWhereLive, Cit.CityName AS [ClosestCityWithParking]
FROM [Clientele].[Clients] AS C
JOIN [Location].[Cities] AS Ct ON C.CityID = Ct.CityID
JOIN [Location].[Cities] AS Cit ON Cit.CityID = Ct.ClosestCityWithParking
