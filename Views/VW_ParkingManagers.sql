-- This view shows shief managers every parking lots and ex managers

CREATE VIEW VW_ParkingManager  
AS  
SELECT TOP 1000 E.FirstName, E.Surname, L.LotName, E.PhoneNumber, E.Email,
[dbo].[CurrentOrEx](E.DateFired) AS [CurrentOrEx]  

FROM [Staff].[Employees] AS E  

LEFT JOIN [Parking].[Lots] AS L  
ON E.LotID = L.LotID  

WHERE PositionID = 2  

ORDER BY [CurrentOrEx], L.LotName, E.FirstName, E.Surname

-- Function which shows if manager is current or ex  

GO
ALTER FUNCTION [dbo].[CurrentOrEx](@DateFired INT)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @X AS VARCHAR(10)
	IF(@DateFired IS NULL)
		BEGIN
			SET @X = 'Current'  
		END
	ELSE
		BEGIN
			SET @X = 'Ex'  
		END
 RETURN @X
END