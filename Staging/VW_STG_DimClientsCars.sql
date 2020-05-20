CREATE VIEW VW_STG_DimClientsCars
AS
SELECT Client.ClientID, Client.FirstName, Client.Surname, Client.Gender, Client.Telephone, Client.Email, 
Loc.CityName, Client.HomeAddress, Client.IsCurrent, Cars.Plate, Model.Brand, Model.Model, Cars.CarID
FROM [Clientele].[Cars] AS Cars
INNER JOIN [Clientele].[CarModels] AS Model ON Cars.CarModelID = Model.CarModelID
RIGHT JOIN [Clientele].[Clients] AS Client ON Cars.ClientID = Client.ClientID
INNER JOIN [Location].[Cities] AS Loc ON Client.CityID = Loc.CityID