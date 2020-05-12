CREATE VIEW  [dbo].[VW_STG_FactsOperationOrders2]
AS
 	 SELECT  o.OrderID, o.ZoneID, o.CarID,
		CAST(c.TheDate AS DATETIME) + CAST(o.TimeEntry AS DATETIME) AS DateTimeEntry, 
		CAST(c1.TheDate AS DATETIME)  + CAST(o.TimeExit AS DATETIME) AS DateTimeExit, o.TotalCost, o.TariffID	
		 FROM Operation.Orders o
		 LEFT JOIN Operation.Tariffs t ON o.TariffID = t.TariffID
		 JOIN Services.CalendarDates c 
		 ON o.DateEntry = c.DateID
		 JOIN Services.CalendarDates c1
		 ON o.DateExit = c1.DateID

	WHERE o.DateExit <= (SELECT MAX (DateExit) FROM Operation.Orders) -7  		
	ORDER BY DateTimeEntry DESC
	OFFSET 0 ROWS


