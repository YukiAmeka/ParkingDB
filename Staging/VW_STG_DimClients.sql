CREATE VIEW VW_STG_DimClients
AS
SELECT C.ClientID, C.FirstName AS [Name], C.Surname, C.Gender, C.Telephone, C.Email, C.HomeAddress, 
Ct.CityName, O.PurchaseDate, O.ExpiryDate
FROM [Clientele].[Clients] AS C
JOIN [Location].[Cities] AS Ct ON C.CityID = Ct.CityID
JOIN [Membership].[Orders] AS O ON C.ClientID = O.ClientID