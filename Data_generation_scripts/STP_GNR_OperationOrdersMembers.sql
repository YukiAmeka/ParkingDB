ALTER PROCEDURE STP_GNR_OperationOrdersMembers
AS

BEGIN

DECLARE @MembershipRecord TABLE (


       OrderID int 
      ,LotID int
      ,EmployeeID int
      ,AllCardID int
      ,ClientID int
      ,PurchaseDate date      
      ,TariffID int
      ,ExpiryDate date
  )                      


DECLARE
@OrderID int,
@AllCardID INT,
@ClientID INT,
@PurchaseDate DATE,
@PurchaseDateCount DATE,
@PurchaseTime TIME,
@ExpiryDate DATE,
@ZoneID INT,
@CarID INT,
@LotID INT,
@CurrentDateEntry INT,
@CurrentTimeEntry TIME(0),
@CurrentDateExit INT,
@CurrentTimeExit TIME(0),
@EmployeeOnEntry int,
@EmployeeOnExit int,
@LastMemberID int,
@NightMembers int


SET @LastMemberID = (SELECT IDENT_CURRENT ('[Membership].[Orders]'))


	SET @OrderID = 1

 WHILE 	@OrderID <=  2116--@LastMemberID                       --Check amount of MembershipOrders before execution

 BEGIN

	INSERT INTO @MembershipRecord (OrderID, LotID, EmployeeID , AllCardID , ClientID, PurchaseDate, TariffID, ExpiryDate  )
		SELECT OrderID, LotID, EmployeeID , AllCardID , ClientID, 
							PurchaseDate, TariffID, ExpiryDate   
		FROM Membership.Orders
		  WHERE OrderID = @OrderID 		    
				
	SET @NightMembers = (SELECT FLOOR(RAND()*(4-1+1)+1))

	SET @PurchaseDate = (SELECT PurchaseDate FROM @MembershipRecord WHERE OrderID = @OrderID )

	SET @ExpiryDate =(SELECT ExpiryDate FROM @MembershipRecord WHERE OrderID = @OrderID)

	     

	SET @ZoneID = (SELECT  ZoneID FROM Membership.Orders AS o
								JOIN Membership.Tariffs AS t
								ON o.TariffID = t.TariffID
									WHERE OrderID = @OrderID )

								
	

	SET @ClientID = (SELECT ClientID FROM @MembershipRecord WHERE OrderID = @OrderID)

	SET @CarID = (SELECT  TOP(1)  CarID 
              FROM Clientele.Cars 
			  WHERE ClientID = @ClientID
			  ORDER BY NEWID())


	SET @AllCardID = (SELECT AllCardID FROM @MembershipRecord WHERE OrderID = @OrderID)
	SET @LotID = (SELECT LotID FROM @MembershipRecord WHERE OrderID = @OrderID )
	
	
	SET @PurchaseDateCount = @PurchaseDate

  WHILE @PurchaseDateCount <= @ExpiryDate                                                         --WHILE 1 @PurchaseDateCount

     BEGIN

		 SET @CurrentDateEntry =  (SELECT DateID FROM Services.CalendarDates 
											WHERE  TheDate =@PurchaseDateCount)

		
	 IF @NightMembers = 4
	BEGIN

			EXEC STP_HLP_GenerateRandomTime @StartTime = '21:00:00', @EndTime = '23:00:00', @RandomTime = @CurrentTimeEntry OUTPUT
			EXEC STP_HLP_GenerateRandomTime @StartTime = '06:00:00', @EndTime = '07:00:00', @RandomTime = @CurrentTimeExit  OUTPUT

			SET @CurrentDateExit = (SELECT DateID FROM Services.CalendarDates 
											WHERE  TheDate = (SELECT DATEADD(day, 1, @PurchaseDateCount)))
	END

	ELSE

	   BEGIN

				EXEC STP_HLP_GenerateRandomTime @StartTime = '07:00:00', @EndTime = '10:00:00', @RandomTime = @CurrentTimeEntry OUTPUT
				EXEC STP_HLP_GenerateRandomTime @StartTime = '17:00:00', @EndTime = '20:00:00', @RandomTime = @CurrentTimeExit OUTPUT

				SET @CurrentDateExit = (SELECT DateID FROM Services.CalendarDates 
											WHERE  TheDate =@PurchaseDateCount)

	   END

			EXEC STP_HLP_FindEmployeeOnShift  @PurchaseDate = @PurchaseDateCount, @PurchaseTime  = @CurrentTimeEntry, @LotID = @LotID, @EmployeeID = @EmployeeOnEntry OUTPUT
			EXEC STP_HLP_FindEmployeeOnShift  @PurchaseDate = @PurchaseDateCount, @PurchaseTime  = @CurrentTimeExit, @LotID = @LotID, @EmployeeID = @EmployeeOnExit OUTPUT
    
    
	INSERT INTO Operation.Orders (ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, EmployeeOnExit, DateExit, TimeExit, TotalCost, AllCardID)
		VALUES (@ZoneID, @CarID, @EmployeeOnEntry, @CurrentDateEntry, @CurrentTimeEntry, @EmployeeOnExit, @CurrentDateExit, @CurrentTimeExit, 0.00, @AllCardID) 

	SET @PurchaseDateCount = DATEADD(day, 1, @PurchaseDateCount )

		 END      --WHILE 1 @PurchaseDateCount
	 
	 DELETE FROM @MembershipRecord
	 
	 SET @OrderID = @OrderID + 1
	 
	END

  END
	
	                                                                                    

	 --SELECT* FROM Operation.Orders

