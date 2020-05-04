/* Returns a table with all Member-only zones, their actual capacity and
the number of Membership cards sold for each zone which are active at a particular date */
CREATE FUNCTION FN_ZoneReservationsByDate
(
    @CheckDate DATE
)
RETURNS @Capacity TABLE
(
    CapacityID INT IDENTITY
    , ZoneID INT
    , Capacity INT
    , MemberReservedSlots INT
)
AS
BEGIN

    DECLARE @TotalZonesNumber INT
    DECLARE @ZoneCounter INT

    SET @TotalZonesNumber = (SELECT COUNT(ZoneID) FROM Parking.Zones)
    SET @ZoneCounter = 1

    /* Set up table @Capacity */
    INSERT INTO @Capacity
    SELECT Parking.Zones.ZoneID, Capacity, 0
    FROM Parking.Zones
    WHERE  (ZoneTypeID BETWEEN 1 AND 2) AND Capacity > 0

    /* Fill in table @Capacity using historical data about Membership Card purchases*/
    WHILE @ZoneCounter <= @TotalZonesNumber
    BEGIN
        WITH OrdersByZones AS
        (
            SELECT OrderID, PurchaseDate, ExpiryDate, ZoneID
                FROM Membership.Orders
                INNER JOIN Membership.Tariffs ON Membership.Tariffs.TariffID = Membership.Orders.TariffID
        )
        UPDATE @Capacity
            SET MemberReservedSlots = (SELECT COUNT(OrderID) FROM OrdersByZones
                WHERE (ZoneID = @ZoneCounter) AND (@CheckDate BETWEEN PurchaseDate AND ExpiryDate))
            WHERE ZoneID = @ZoneCounter

        SET @ZoneCounter += 1
    END
    RETURN
END


/* TEST CODE AND EXAMPLE OF USE*/

-- SELECT * FROM FN_ZoneReservationsByDate ('2019-02-03')
