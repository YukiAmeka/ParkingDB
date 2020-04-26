/* Find the Employee who is/was on shift at a given Parking Lot at a given date & time */
CREATE PROCEDURE STP_HLP_FindEmployeeOnShift
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

    /* Create temporary table based on Staff.Shifts with Date fields filled in from Services.CalendarDates.
    Data is filtered to contain only records assiciated with a given LotID */
    IF OBJECT_ID ('#FullShifts') IS NOT NULL
        DROP TABLE #FullShifts

    SELECT LotID, Staff.Employees.EmployeeID, DStart.TheDate AS DateStart, TimeStart, DEnd.TheDate AS DateEnd, TimeEnd
    INTO #FullShifts
        FROM Staff.Shifts
        INNER JOIN Services.CalendarDates DStart ON Staff.Shifts.DateStart = DStart.DateID
        INNER JOIN Services.CalendarDates DEnd ON Staff.Shifts.DateEnd = DEnd.DateID
        INNER JOIN Staff.Employees ON Staff.Employees.EmployeeID = Staff.Shifts.EmployeeID
        WHERE LotID = @LotID

    /* Find EmployeeID of the parking attendant whose shift started before & ended after @PurchaseDateTime */
    SET @EmployeeID = (SELECT TOP 1 EmployeeID
        FROM #FullShifts
        WHERE @PurchaseDateTime BETWEEN
        CAST(DateStart AS DATETIME) + CAST(TimeStart AS DATETIME) AND
        CAST(DateEnd AS DATETIME) + CAST(TimeEnd AS DATETIME))

    /* Drop all temporary objects */
    DROP TABLE #FullShifts

END