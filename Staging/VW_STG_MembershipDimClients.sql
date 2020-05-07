/* Create OLTP view for future data transfer into Data Mart Membership dimension Clients */
CREATE VIEW VW_STG_MembershipDimClients
AS
SELECT Clientele.Clients.ClientID AS ClientID
    , FirstName
    , Surname
    , Gender
    , Telephone
    , Email
    , HomeAddress
    , CityName
	, MIN(PurchaseDate) AS FirstPurchaseDate
	, MAX(ExpiryDate) AS LatestExpiryDate
FROM Clientele.Clients
INNER JOIN Location.Cities ON Clientele.Clients.CityID = Location.Cities.CityID
INNER JOIN Membership.Orders ON Membership.Orders.ClientID = Clientele.Clients.ClientID
GROUP BY Clientele.Clients.ClientID, FirstName, Surname, Gender, Telephone, Email, HomeAddress, CityName