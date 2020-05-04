-- This view shows us which client`s cards expire date

CREATE VIEW VW_ExpiryDateOfCards  
AS  
SELECT TOP 1000 E.FirstName AS [Name], E.Surname, DATEDIFF(DAY, CURRENT_TIMESTAMP, ExpiryDate) AS DaysLeft  
FROM [Membership].[ActiveCards] AS AC  
INNER JOIN [Staff].[Employees] AS E  
ON AC.ClientID = E.EmployeeID  
WHERE DATEDIFF(DAY, CURRENT_TIMESTAMP, ExpiryDate) < 31  
ORDER BY DaysLeft, [Name], E.Surname  
