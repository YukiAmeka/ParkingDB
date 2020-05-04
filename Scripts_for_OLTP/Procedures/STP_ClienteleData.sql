--- Procedure for adding new client to client table and adding new appropriate order
ALTER PROC STP_ClienteleData (@FirstName   VARCHAR(100), 
                               @Surname     VARCHAR(100), 
                               @Gender      CHAR(1), 
                               @Telephone   CHAR(15), 
                               @Email       VARCHAR(100), 
                               @HomeAddress VARCHAR(100), 
                               @CityID      INT, 
                               @lotID       INT, 
                               @TariffID    INT, 
                               @PeriodID    INT, 
                               @EmployeeID  INT,
			                   @ClientID INT OUTPUT) 
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

      IF NOT EXISTS (SELECT 1 
                     FROM   clientele.clients 
                     WHERE  firstname = @FirstName 
                            AND surname = @Surname 
                            AND telephone = @Telephone) 
        BEGIN 
            PRINT 'Insert into client' 

            INSERT INTO clientele.clients 
                        (firstname, 
                         surname, 
                         gender, 
                         telephone, 
                         email, 
                         homeaddress, 
                         cityid) 
            VALUES      (@FirstName, 
                         @Surname, 
                         @Gender, 
                         @Telephone, 
                         @Email, 
                         @HomeAddress, 
                         @CityID) 

            DECLARE @LastID INT 

            SET @LastID = (SELECT Ident_current('[Clientele].[Clients]')) 

            DECLARE @CardID INT 

            SET @CardId = (SELECT TOP 1 allcardid 
                           FROM   [Membership].[allcards] 
                           WHERE  isused = 0 
                           ORDER  BY Newid()) 

            PRINT 'Insert into orders' 

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
                         @LastID, 
                         @PurchaseDate, 
                         @PurchaseTime, 
                         @TariffID, 
                         @ExpiryDate) 

           INSERT INTO Membership.ActiveCards( ClientID,AllCardID,ZoneId,StartDate,ExpiryDate)
		  SELECT ClientID,AllCardID,Z.ZoneId,PurchaseDate,ExpiryDate FROM [Membership].[Orders]
          INNER JOIN Membership.Tariffs ON [Membership].[Orders].TariffID =  Membership.Tariffs.TariffID  
          INNER JOIN Parking.Zones Z ON Membership.Tariffs.ZoneID = Z.ZoneID
          WHERE OrderID IN (SELECT Ident_current('[Membership].[Orders]'))

	

		  END
      ELSE 
        PRINT @firstName + ' ' + @Surname + ' is our client' 
SET @ClientID = (SELECT ClientID FROM Membership.ActiveCards WHERE AllCardID =  @CardId)
  END 
