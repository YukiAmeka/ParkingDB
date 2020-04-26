CREATE PROCEDURE STP_GNR_ParkingZoneTypes
AS

BEGIN

INSERT INTO Parking.ZoneTypes (ZoneTypeName, Description, SlotSizeID)
VALUES 
('A', 'Standard slot for owners of membership', 1),
('B', 'Extended slot for owners of membership', 2),
('C', 'Standard slot for walk-in clients', 1),
('D', 'Extended slot for walk-in clients', 2)

END