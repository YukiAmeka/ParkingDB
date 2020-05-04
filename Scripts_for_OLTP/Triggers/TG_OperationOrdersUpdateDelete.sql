 
  CREATE TRIGGER TG_OperationOrdersTestDelete 
  ON Operation.Orders
  INSTEAD OF UPDATE, DELETE
  AS 
  BEGIN
  RAISERROR  ('You cannot DELETE or UPDATE rows',16,1)
  RETURN
  END	

 -- DELETE FROM Operation.Orders WHERE OrderID = 1