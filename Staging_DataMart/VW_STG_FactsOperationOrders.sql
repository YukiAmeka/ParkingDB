CREATE VIEW  VW_STG_FactsOperationOrders
AS
 SELECT o.OrderID, o.ZoneID, o.CarID, o.EmployeeOnEntry, o.EmployeeOnExit,
		CAST(c.TheDate AS DATETIME) + CAST(o.TimeEntry AS DATETIME) AS DateTimeStart, 
		CAST(c1.TheDate AS DATETIME)  + CAST(o.TimeExit AS DATETIME) AS DateTimeEnd, 
		o.TotalCost, 	o.TariffID, o.AllCardID
 FROM Operation.Orders o
 JOIN Operation.Tariffs t ON o.TariffID = t.TariffID
 JOIN Services.CalendarDates c 
 ON o.DateEntry = c.DateID
 JOIN Services.CalendarDates c1
 ON o.DateExit = c1.DateID

