CREATE VIEW VW_MonthlyRevenueOnLots
AS

SELECT * FROM 
		(SELECT LotID, YEAR(TheDate) AS [Year], DATENAME(MONTH, TheDate) AS [Month], SUM (Revenue) AS Revenue
             FROM 
				(SELECT LotID, SUM(TotalCost) AS Revenue, c.TheDate
						FROM Operation.Orders o
						JOIN Services.CalendarDates c
						ON o.DateExit = c.DateID 
						JOIN Parking.Zones z
						ON o.ZoneID = z.ZoneID
						WHERE  AllCardID IS NULL
						GROUP BY   LotID, c.TheDate) AS R
			GROUP BY LotID, YEAR(TheDate), DATENAME(MONTH, TheDate)) AS MontlyProfit
			PIVOT(SUM(Revenue)   
				FOR Month IN ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November], [December])) AS YearlyProfit

	

		
