CREATE PROC STP_InsertNewMembershipOrders
(   @ClientID INT,
    @lotID    INT, 
    @TariffID    INT, 
    @PeriodID    INT, 
    @EmployeeID  INT			                   
)

AS 
  BEGIN 
      DECLARE @FreeSlots INT 
      DECLARE @PurchaseDate DATE 

      SET @PurchaseDate = Getdate() 

      DECLARE @ExpiryDate DATE 
      DECLARE @PeriodName INT 

      SET @PeriodName =(SELECT periodid 
                        FROM   [Membership].[periods] 
                        WHERE  periodid = @PeriodID) 
      SET @ExpiryDate = (SELECT CASE 
                                  WHEN @PeriodName = 1 THEN 
                                  Dateadd(mm, 1, @PurchaseDate) 
                                  WHEN @PeriodName = 2 THEN 
                                  Dateadd(mm, 3, @PurchaseDate) 
                                  ELSE Dateadd(yy, 1, @PurchaseDate) 
                                END) 

      DECLARE @PurchaseTime TIME(0) 

      SET @PurchaseTime = (SELECT CONVERT(TIME, Getdate())) 

      DECLARE @Date DATE 

      SET @PurchaseDate = (SELECT CONVERT(DATE, Getdate()))
	  
          
            DECLARE @CardID INT 

            SET @CardId = (SELECT TOP 1 allcardid 
                           FROM   [Membership].[allcards] 
                           WHERE  isused = 0 
                           ORDER  BY Newid()) 

	  INSERT INTO membership.orders 
                        (lotid, 
                         employeeid, 
                         allcardid, 
                         clientid, 
                         purchasedate, 
                         purchasetime, 
                         tariffid, 
                         expirydate) 
            VALUES      (@lotID, 
                         @EmployeeID, 
                         @CardId, 
                         @ClientID, 
                         @PurchaseDate, 
                         @PurchaseTime, 
                         @TariffID, 
                         @ExpiryDate) 

	END