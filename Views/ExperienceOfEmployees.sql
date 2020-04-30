CREATE VIEW VW_ExperienceEmployees  
AS  
	SELECT TOP 1000 E.FirstName AS [Name], e.Surname, P.Title AS Position,  
	FLOOR((DATEDIFF(MONTH, C.TheDate, CURRENT_TIMESTAMP)) / 12) AS ExperienceYears,  
	FLOOR((DATEDIFF(MONTH, C.TheDate, CURRENT_TIMESTAMP)) % 12) AS ExperienceMonths  

	FROM [Staff].[Employees] AS E  

	INNER JOIN [Staff].[Positions] AS P  
	ON E.PositionID = P.PositionID  

	INNER JOIN [Services].[CalendarDates] AS C  
	ON E.DateHired = C.DateID  

	ORDER BY ExperienceYears DESC, ExperienceMonths  DESC, [Name] ASC, Surname ASC  
