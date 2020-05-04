CREATE VIEW [dbo].[VW_EmployeeContactInformation]
AS 
	SELECT TOP 1000 Empl.EmployeeID, Empl.FirstName, Empl.Surname, Empl.Gender, Empl.DateOfBirth, Empl.PhoneNumber,
	Empl.Email, Cities.CityName, Empl.HomeAddress, Empl.Salary,  Lots.LotName, Pos.Title,
	Hired.TheDate AS Hired, Fired.TheDate AS Fired, Manager.FirstName + ' ' + Manager.Surname AS Manager

	FROM [Staff].[Employees] AS Empl

	LEFT JOIN  [Location].[Cities] AS Cities
	ON Empl.CityID = Cities.CityID

	LEFT JOIN [Parking].[Lots]  AS Lots
	ON Empl.LotID = Lots.LotID

	LEFT JOIN [Staff].[Positions]  AS Pos
	ON Pos.PositionID = Empl.PositionID

	LEFT JOIN [Services].[CalendarDates]  AS Hired
	ON Empl.DateHired = Hired.DateID

	LEFT JOIN [Services].[CalendarDates]  AS Fired
	ON Empl.DateFired = Fired.DateID

	LEFT JOIN [Staff].[Employees]   AS Manager
	ON Empl.ManagerID = Manager.EmployeeID

	ORDER BY Empl.EmployeeID
GO