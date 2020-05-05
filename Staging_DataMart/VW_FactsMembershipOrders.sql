CREATE VIEW VW_FactsMembershipOrders

SELECT O.OrderID,Z.ZoneID,T.TariffID,A.AllCardID,C.ClientID, PurchaseDate,PurchaseTime FROM Membership.Orders O
INNER JOIN Membership.AllCards A ON O.AllCardID = A.AllCardID
INNER JOIN Clientele.Clients C ON O.ClientID =c.ClientID 
INNER JOIN Membership.Tariffs T ON O.TariffID = T.TariffID
INNER JOIN Parking.Zones Z ON T.ZoneID = Z.ZoneID

