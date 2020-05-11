/* Create OLTP view for future data transfer into Data Mart Membership dimension Cars */
CREATE VIEW VW_STG_MembershipDimCars
AS
SELECT CarID
    , Plate
    , Brand
	, Model
    , ClientID
FROM Clientele.Cars
INNER JOIN Clientele.CarModels ON Clientele.Cars.CarModelID = Clientele.CarModels.CarModelID
WHERE ClientID IS NOT NULL AND
    ClientID IN
        (SELECT ClientID FROM VW_STG_MembershipDimClients)