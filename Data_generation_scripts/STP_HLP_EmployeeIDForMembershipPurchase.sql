CREATE PROCEDURE STP_EmployeeIDForMembershipPurchase
(
    @PurchaseDate DATE
    , @PurchaseTime TIME(0)
    , @LotID INT
    , @EmployeeID INT OUTPUT
)
AS
BEGIN

DECLARE @PurchaseDateTime DATETIME
SET @PurchaseDateTime = CAST(@PurchaseDate AS DATETIME) + CAST(@PurchaseTime AS DATETIME)

SELECT LotID, Staff.Employees.EmployeeID, DStart.TheDate AS DateStart, TimeStart, DEnd.TheDate AS DateEnd, TimeEnd
INTO #FullShifts
    FROM Staff.Shifts
    INNER JOIN Services.CalendarDates DStart ON Staff.Shifts.DateStart = DStart.DateID
    INNER JOIN Services.CalendarDates DEnd ON Staff.Shifts.DateEnd = DEnd.DateID
    INNER JOIN Staff.Employees ON Staff.Employees.EmployeeID = Staff.Shifts.EmployeeID
    WHERE LotID = @LotID

SET @EmployeeID = (SELECT EmployeeID
    FROM #FullShifts
    WHERE @PurchaseDateTime BETWEEN
	CAST(DateStart AS DATETIME) + CAST(TimeStart AS DATETIME) AND
	CAST(DateEnd AS DATETIME) + CAST(TimeEnd AS DATETIME))

DROP TABLE #FullShifts

END