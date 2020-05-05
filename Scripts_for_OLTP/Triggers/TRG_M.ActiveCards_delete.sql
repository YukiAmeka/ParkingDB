
IF OBJECT_ID ('Membership.ActiveCards_Trg_Del', 'TR') IS NOT NULL
DROP TRIGGER Membership.ActiveCards_Trg_Del
GO

     
CREATE TRIGGER Membership.ActiveCards_Trg_Del
ON Membership.ActiveCards               
FOR  DELETE
AS  
BEGIN
     
    DECLARE @DeletedQty INT
    DECLARE @Cap INT
    DECLARE @Capacity INT
    
   SET @DeletedQty = @@ROWCOUNT

   
    UPDATE Parking.Zones
        SET MemberReservedSlots = MemberReservedSlots + @DeletedQty 
        FROM Parking.Zones AS pz JOIN deleted AS d
        ON pz.ZoneID = d.ZoneID
                    BEGIN                 
                        SELECT * FROM Membership.Orders                           
                        SELECT * FROM Parking.Zones
                        SELECT * FROM Membership.ActiveCards
                    END          
END
