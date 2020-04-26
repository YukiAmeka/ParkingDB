CREATE PROCEDURE STP_GNR_MembershipActiveCards
AS
BEGIN
DECLARE @Date DATE
SET @Date = '2020-04-28'

INSERT INTO Membership.ActiveCards 
SELECT ClientID, AllCardID, [Parking].[Zones].ZoneID, StartDate, ExpiryDate FROM [Membership].[Orders] 
INNER JOIN [Membership].[Tariffs] ON [Membership].[Tariffs].TariffID = [Membership].[Orders].TariffID
INNER JOIN [Parking].[Zones] ON [Parking].[Zones].ZoneID = [Membership].[Tariffs].ZoneID
 
WHERE @Date BETWEEN StartDate AND ExpiryDate
END