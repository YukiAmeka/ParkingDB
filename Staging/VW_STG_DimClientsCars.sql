CREATE VIEW VW_STG_DimClientsCars
AS
SELECT C.ClientID, CL.FirstName, CL.Surname, CL.Gender, CL.Telephone, CL.Email, CT.CityName,
CL.HomeAddress, CL.IsCurrent, C.Plate, CM.Brand, CM.Model, C.CarID
FROM [Clientele].[Cars] AS C
JOIN [Clientele].[Clients] AS CL ON C.ClientID = CL.ClientID
JOIN [Clientele].[CarModels] AS CM ON C.CarModelID = CM.CarModelID
JOIN [Location].[Cities] AS CT ON CL.CityID = CT.CityID