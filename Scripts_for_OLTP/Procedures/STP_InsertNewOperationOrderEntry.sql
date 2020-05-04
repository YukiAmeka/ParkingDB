 -- ===================================================================================================================================================
/*
Author:	Volodymyr Lavryntsiv
Create date: 2020-04-27
Short description: Inserting new order when the car is entering the parking lot
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: 

----1--- No memmbership, don\t want new membership, car exists
--EXEC STP_InsertNewOperationOrderEntry 'L-1','standart','TH14UNQ','Mannix','Bernard', '2020-04-26', '11:24:00',NULL,'False'

----2-- No memmbership, don\t want new membership, car don`t exist
--EXEC STP_InsertNewOperationOrderEntry 'S-1', 'extended', 'ZZ12ZZK', 'Edan', 'Pugh', '2020-04-26', '18:27:00', NULL,'False'

----3--No memmbership, want new membership, car exists
--EXEC STP_InsertNewOperationOrderEntry 'L-1','standart','UU46KCQ','Mannix','Bernard', '2020-04-27', '11:27:00', NULL, 'true'

----4--No memmbership, want new membership, car don`t exists
--EXEC STP_InsertNewOperationOrderEntry 'L-1','extended','ZZ11ZZC','Mannix','Bernard', '2020-04-27', '11:48:00', NULL, 'true'

----5--Has memmbership, car exists
--EXEC STP_InsertNewOperationOrderEntry 'L-1','standart','IY71FGW','Mannix','Bernard', '2020-04-26', '11:27:00', 3350162, 'false'

---6---membership non valid

--EXEC STP_InsertNewOperationOrderEntry 'L-1','standart','IY71FGW','Mannix','Bernard', '2020-04-26', '16:56:00', 3350161, 'false'
-- ===================================================================================================================================================

*/
CREATE PROCEDURE STP_InsertNewOperationOrderEntry (
	@LotName VARCHAR (50),
	@SlotDescription VARCHAR (20),
	@Plate CHAR(7),
	@EmployeeOnEntryName VARCHAR (50),
	@EmployeeOnEntrySurname VARCHAR (50),
	@DateEntry DATE,
	@TimeEntry TIME,
	@MemberCardNumber INT NULL,
	@WantNewMembership BIT
	)
AS

BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

----------BEGIN PROCEDURE-------------

DECLARE 
@ZoneID INT,
@CarID INT,
@EmployeeOnEntryID INT,
@DateEntryID INT,
@ClientID INT,
@AllCardId INT,
@CityID INT,
@LotID INT

SET @LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)	

SET @CityID = (SELECT CityID FROM Parking.Lots WHERE LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)) 


SET @DateEntryID = (SELECT DateID FROM Services.CalendarDates WHERE TheDate = @DateEntry)

SET @EmployeeOnEntryID = (SELECT DISTINCT e.EmployeeID FROM Staff.Employees e
						 JOIN Parking.Lots l ON e.LotID = l.LotID AND l.LotID = @LotID
						 AND e.FirstName =  @EmployeeOnEntryName AND e.Surname = @EmployeeOnEntrySurname)

---1--- No memmbership, don`t want new membership, car exists

IF @MemberCardNumber IS NULL AND @WantNewMembership = 'False' AND EXISTS ( SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate) 
	BEGIN
	SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
		JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
		JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND zt.ZoneTypeName IN ('C','D')
		JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
							ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))
	SET @CarID = (SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate)
	SET @AllCardId = NULL
	INSERT INTO Operation.Orders ( ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, AllCardID) VALUES
							(@ZoneID, @CarID, @EmployeeOnEntryID, @DateEntryID, @TimeEntry, @AllCardID)
	END

---2---  No memmbership, don`t want new membership, car don`t exist

ELSE IF @MemberCardNumber IS NULL AND @WantNewMembership = 'False' AND NOT EXISTS ( SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate) 
	BEGIN
	SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
		JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
		JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND zt.ZoneTypeName IN ('C','D')
		JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
							ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))

	EXEC STP_InsertNewCar @Plate, 'Auris','Toyota' , @CarID = @CarID OUTPUT
	PRINT 'New Car was created'
	SET @AllCardId = NULL
	INSERT INTO Operation.Orders ( ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, AllCardID) VALUES
							(@ZoneID, @CarID, @EmployeeOnEntryID, @DateEntryID, @TimeEntry, @AllCardID)
	END

---3--- No memmbership, want new membership, car exists

ELSE IF @MemberCardNumber IS NULL AND @WantNewMembership = 'TRUE' AND EXISTS ( SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate) 
	BEGIN
		SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
		JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
		JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND zt.ZoneTypeName IN ('A','B')
		JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
							ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))
	
		SET @CarID = (SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate)
		EXEC STP_ClienteleData 'Volodya', 'Lavryntsiv', 'm', '+380631699263', 
								'volodya.lavryntsiv@gmail.com', 'London', @CityID, @LotID ,1,2,@EmployeeOnEntryID, 
								@ClientID = @ClientID OUTPUT 
		PRINT 'New Client was created'

		UPDATE Clientele.Cars
			SET ClientID = @ClientID WHERE CarID = @CarID

		SET @AllCardId = (SELECT AllCardId FROM Membership.ActiveCards WHERE ClientID = @ClientID AND StartDate < = @DateEntry)

		INSERT INTO Operation.Orders ( ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, AllCardID) VALUES
							(@ZoneID, @CarID, @EmployeeOnEntryID, @DateEntryID, @TimeEntry, @AllCardID)

	END

---4--- No memmbership, want new membership, car don`t exists
ELSE IF @MemberCardNumber IS NULL AND @WantNewMembership = 'TRUE' AND NOT EXISTS ( SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate) 
	BEGIN
		SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
		JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
		JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND zt.ZoneTypeName IN ('A','B')
		JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
							ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))
	
		EXEC STP_InsertNewCar @Plate, 'M2','BMW' , @CarID = @CarID OUTPUT
		PRINT 'New Car was created'

		EXEC STP_ClienteleData 'Ostap', 'Mykyta', 'm', '+380631647245', 
								'Ostap.Mykyta@gmail.com', 'London', @CityID, @LotID ,3,1,@EmployeeOnEntryID, 
								@ClientID = @ClientID OUTPUT 
		PRINT 'New Client was created'

		UPDATE Clientele.Cars
			SET ClientID = @ClientID WHERE CarID = @CarID

		SET @AllCardId = (SELECT AllCardId FROM Membership.ActiveCards WHERE ClientID = @ClientID AND StartDate < = @DateEntry)

		INSERT INTO Operation.Orders ( ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, AllCardID) VALUES
							(@ZoneID, @CarID, @EmployeeOnEntryID, @DateEntryID, @TimeEntry, @AllCardID)
	
	END	

---5--- Has memmbership, car exists

ELSE IF @MemberCardNumber IS NOT NULL AND @WantNewMembership = 'FALSE' AND EXISTS ( SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate) 
	BEGIN
	SET @AllCardId = (SELECT a.AllCardId FROM Membership.ActiveCards a 
						JOIN Membership.AllCards ac ON a.AllCardID = ac.AllCardID AND ac.MemberCardNumber = @MemberCardNumber
						AND StartDate < = @DateEntry)
	IF @AllCardId IS NOT NULL	
		BEGIN	
			SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
						JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
						JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND zt.ZoneTypeName IN ('A','B')
						JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
						ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))

			SET @CarID = (SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate)

			INSERT INTO Operation.Orders ( ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, AllCardID) VALUES
							(@ZoneID, @CarID, @EmployeeOnEntryID, @DateEntryID, @TimeEntry, @AllCardID)

		END
	ELSE IF @AllCardId IS NULL
		BEGIN
			SET @ZoneID = (SELECT z.ZoneID FROM Parking.Zones z 
				JOIN Parking.Lots l ON z.LotID = l.LotID AND z.LotID = (SELECT LotID FROM Parking.Lots WHERE LotName = @LotName)
				JOIN Parking.ZoneTypes zt ON z.ZoneTypeID =  zt.ZoneTypeID AND zt.ZoneTypeName IN ('C','D')
				JOIN Parking.SlotSizes ss ON zt.SlotSizeID = ss.SlotSizeID AND	
				ss.SlotSizeID = (SELECT SlotSizeID FROM Parking.SlotSizes WHERE SlotDescription = @SlotDescription))
			SET @CarID = (SELECT CarID FROM  Clientele.Cars WHERE Plate = @Plate)
		
		INSERT INTO Operation.Orders ( ZoneID, CarID, EmployeeOnEntry, DateEntry, TimeEntry, AllCardID) VALUES
							(@ZoneID, @CarID, @EmployeeOnEntryID, @DateEntryID, @TimeEntry, @AllCardID)

		END
	END
---------------END PROCEDURE-----------
		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END