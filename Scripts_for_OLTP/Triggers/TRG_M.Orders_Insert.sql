

/* trigger that triggers after INSERT and performs INSERT function in 1 table and UPDATE function in 2 tables */
IF OBJECT_ID ('Membership.Orders_Trg_Ins', 'TR') IS NOT NULL
DROP TRIGGER Membership.Orders_Trg_Ins
GO
     
CREATE TRIGGER Membership.Orders_Trg_Ins
ON Membership.Orders             
FOR  INSERT
AS
BEGIN
    
    DECLARE @Tariff INT 
    DECLARE @FreeSlots INT
    DECLARE @Capacity INT
    DECLARE @Zone INT

     
    SET @Tariff = (SELECT TOP 1 TariffID FROM inserted)
    SET @Capacity = (SELECT MemberReservedSlots FROM Parking.zones WHERE  zoneid = (SELECT zoneid FROM   Membership.Tariffs  WHERE TariffID = @Tariff))
	SET @Zone = (SELECT ZoneID FROM Membership.Tariffs WHERE  TariffID = @Tariff)
    SET @FreeSlots = (SELECT MemberReservedSlots FROM Parking.zones WHERE  ZoneID = @Zone)

/* after purchasing a ticket, the number of available seats in the corresponding parking space is reduced */		
        UPDATE Parking.Zones
		SET MemberReservedSlots = MemberReservedSlots - 1
        WHERE ZoneID = @Zone
        IF @Capacity = 0    
			BEGIN
				PRINT 'Sorry there are no available seats' 
				ROLLBACK TRAN
                RETURN
            END
/* when a customer receives a subscription card, it is marked as used in the Is Used box */           
        UPDATE Membership.AllCards       
        SET IsUsed = 1
        FROM Membership.AllCards AS MAC JOIN inserted AS i
        ON MAC.AllCardID = i.AllCardID                
			BEGIN                 
				SELECT * FROM Membership.Orders                           
                SELECT * FROM Parking.Zones
                SELECT * FROM Membership.AllCards
                SELECT * FROM Membership.ActiveCards
            END          
END
