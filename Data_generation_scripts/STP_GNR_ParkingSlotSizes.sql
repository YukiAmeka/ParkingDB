CREATE PROCEDURE STP_GNR_ParkingSlotSizes
AS
BEGIN

INSERT INTO Parking.SlotSizes (SlotDescription)
VALUES 
('Standart'),
('Extended')

END