CREATE PROCEDURE STP_HLP_AddMembershipPurchase
(
    @PurchaseDate DATE
    , @ExpiryDate DATE
    , @LotID INT
    , @ZoneID INT
    , @PeriodID INT
    , @ClientID INT
)
AS
BEGIN

    DECLARE @EmployeeID INT
    DECLARE @AllCardID INT
    DECLARE @PurchaseTime TIME(0)
    DECLARE @TariffID INT

    SET @EmployeeID = 1 -- temporary placeholder!

    EXEC STP_HLP_GenerateRandomTime @StartTime = '08:00:00', @EndTime = '22:00:00', @RandomTime = @PurchaseTime OUTPUT

    SET @TariffID = (SELECT TariffID FROM Membership.Tariffs
        WHERE ZoneID = @ZoneID
        AND PeriodID = @PeriodID
        AND (@PurchaseDate BETWEEN StartDate AND EndDate))

    SET @AllCardID = (SELECT TOP 1 AllCardID FROM Membership.AllCards WHERE IsUsed = 0 ORDER BY NEWID())

    UPDATE Membership.AllCards
        SET IsUsed = 1
        , TariffID = @TariffID
        WHERE AllCardID = @AllCardID

    /*EXEC STP_HLP_FindEmployeeOnShift
        @PurchaseDate = PurchaseDate
        , @PurchaseTime = PurchaseTime
        , @LotID = @LotID
        , @EmployeeID = @EmployeeID OUTPUT*/

    /* Compile and insert 1 record into #MOrders */
    INSERT INTO #MOrders (LotID, ZoneID, EmployeeID, AllCardID, ClientID, PurchaseDate, PurchaseTime, TariffID, ExpiryDate)
        VALUES (@LotID, @ZoneID, @EmployeeID, @AllCardID, @ClientID, @PurchaseDate, @PurchaseTime, @TariffID, @ExpiryDate)

END