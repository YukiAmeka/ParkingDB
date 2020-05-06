CREATE VIEW VW_ParkingCostsForEmployees
AS
WITH CTE_ParkingCostsForEmployees(LotName, Position, Salary, [Count Positions], [Cost By Positions])
		AS
		(
			SELECT TOP 1000 L.LotName,  P.Title AS Position, AVG(E.Salary) AS Salary,
			COUNT(P.Title) AS [Count Position], 
			SUM(E.Salary) AS [Total Cost] 
			FROM [Staff].[Employees] AS E
			INNER JOIN [Parking].[Lots] AS L
			ON E.LotID = L.LotID
			INNER JOIN [Staff].[Positions] AS P
			ON E.PositionID = P.PositionID
			INNER JOIN [Location].[Cities] AS C
			ON E.CityID = C.CityID
			GROUP BY  L.LotName, P.Title
			ORDER BY L.LotName, Position
		)
		SELECT * FROM CTE_ParkingCostsForEmployees
		,
		CTE_ParkingCostsForEmployees2 AS 
		(
			SELECT TOP 1000  CTE.LotName, CTE.Position, CTE.Salary, CTE.[Count Positions], CTE.[Cost By Positions],
			SUM([Count Positions]) OVER(PARTITION BY CTE.LotName ORDER BY CTE.[Count Positions] ROWS BETWEEN
				UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Total Count By Lot],
			SUM([Cost By Positions]) OVER(PARTITION BY CTE.LotName ORDER BY CTE.[Cost By Positions] ROWS BETWEEN
				UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Total Cost By Lot]
			FROM CTE_ParkingCostsForEmployees AS CTE 
			ORDER BY [Total Cost By Lot] DESC, [Cost By Positions] DESC
		),
		CTE_ParkingCostsForEmployees3 AS 
		(
			SELECT  TOP 1000 CTE.LotName, CTE.Position,  CTE.Salary, CTE.[Count Positions], CTE.[Cost By Positions],
			[Total Count By Lot], [Total Cost By Lot],
			SUM([Count Positions]) OVER(ORDER BY CTE.[Count Positions] ROWS BETWEEN
				UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Total Count],
			SUM([Cost By Positions]) OVER(ORDER BY CTE.[Cost By Positions] ROWS BETWEEN
				UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Total Cost]

			FROM CTE_ParkingCostsForEmployees2 AS CTE
			ORDER BY CTE.[Total Cost By Lot] DESC, CTE.[Total Count By Lot] DESC
		)
		SELECT * FROM CTE_ParkingCostsForEmployees3