CREATE VIEW VW_MaxCarsPerDayMonthYear
	AS		
		
		WITH CountByDays (LotID, CarAmountPerDay, TheDate) AS 
		
			   (SELECT  LotID, COUNT(CarID) AS  CarAmountPerDay,  c.TheDate   --, DateExit
				FROM Operation.Orders o
				   JOIN [Services].CalendarDates c
				ON o.DateEntry = c.DateID 
				   JOIN Parking.Zones z
				ON o.ZoneID = z.ZoneID
				WHERE  CarID IS NOT NULL
				GROUP BY   lotID, c.TheDate			
				)

					SELECT a.LotID, MAX (CarAmountPerDay) AS MaxCarAmountPerDay , g.MaxCarAmountPerMonth, SUM(CarAmountPerDay) AS CarAmountPerYear   
					FROM CountByDays a
					OUTER APPLY (	SELECT TOP 1 SUM(CarAmountPerDay) AS MaxCarAmountPerMonth, LotID, MONTH(TheDate) AS TheDate
									FROM CountByDays b
									WHERE a.LotID = b.LotID
									GROUP BY LotID, MONTH(TheDate)
									ORDER BY LotID, SUM(CarAmountPerDay) DESC ) g
									GROUP BY a.LotID , g.MaxCarAmountPerMonth

									



			--SELECT * FROM VW_MaxCarsPerDayMonthYear  ORDER BY LotID

						




			