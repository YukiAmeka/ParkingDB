CREATE VIEW VW_FactsMembershipOrders
AS
SELECT O.OrderID,Z.ZoneID,T.TariffID,A.AllCardID,C.ClientID, PurchaseDate,PurchaseTime,Price AS TotalCost FROM Membership.Orders O
INNER JOIN Membership.AllCards A ON O.AllCardID = A.AllCardID
INNER JOIN Clientele.Clients C ON O.ClientID =c.ClientID 
INNER JOIN Membership.Tariffs T ON O.TariffID = T.TariffID
INNER JOIN Parking.Zones Z ON T.ZoneID = Z.ZoneID
WHERE O.PurchaseDate <=  (SELECT DATEADD(dd, -7,(SELECT MAX(PurchaseDate) FROM Membership.Orders)))
ORDER BY O.OrderID
OFFSET 0 ROWS	

