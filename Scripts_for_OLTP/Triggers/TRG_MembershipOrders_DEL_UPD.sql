/* Protect existing records in Membership.Orders from being tampered with */
CREATE TRIGGER TRG_MembershipOrders_DEL_UPD
ON Membership.Orders
INSTEAD OF DELETE, UPDATE
AS
BEGIN
    RAISERROR ('Deleting or updating records about former purchases is not allowed', 16, 1)
END