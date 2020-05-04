/* Adds 1 record about a Membership Card purchase into Mambership.Orders table */
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

    /* Generate random time in the working hours */
    EXEC STP_HLP_GenerateRandomTime @StartTime = '08:00:00', @EndTime = '22:00:00', @RandomTime = @PurchaseTime OUTPUT

    /* Pick the correct Tariff based on the Zone and Purchase Date */
    SET @TariffID = (SELECT TariffID FROM Membership.Tariffs
        WHERE ZoneID = @ZoneID
        AND PeriodID = @PeriodID
        AND (@PurchaseDate BETWEEN StartDate AND EndDate))

    /* Randomly pick a card. Mark it as used & put information about the Tariff into AllCards table */
    SET @AllCardID = (SELECT TOP 1 AllCardID FROM Membership.AllCards WHERE IsUsed = 0 ORDER BY NEWID())

    UPDATE Membership.AllCards
        SET IsUsed = 1
        , TariffID = @TariffID
        WHERE AllCardID = @AllCardID

    /* Identify, which Employee was on shift at Purchase Time */
    EXEC STP_HLP_FindEmployeeOnShift
        @PurchaseDate = @PurchaseDate
        , @PurchaseTime = @PurchaseTime
        , @LotID = @LotID
        , @EmployeeID = @EmployeeID OUTPUT

    /* Compile and insert 1 record into #MOrders */
    INSERT INTO #MOrders (LotID, ZoneID, EmployeeID, AllCardID, ClientID, PurchaseDate, PurchaseTime, TariffID, ExpiryDate)
        VALUES (@LotID, @ZoneID, @EmployeeID, @AllCardID, @ClientID, @PurchaseDate, @PurchaseTime, @TariffID, @ExpiryDate)

END