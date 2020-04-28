CREATE PROCEDURE STP_GNR_StaffShifts(
@ShiftEndDate DATE 
)
AS 

BEGIN

-- DELETE FROM Staff.Shifts
-- DBCC CHECKIDENT('Staff.Shifts', RESEED, 0)

DECLARE 
@CurAttendantsID int,
@FirstDateID int,
@K int, 
@EntryDay int,
@ExitDay int,
@LotID int,
@LastDateID int



-- Control four shifts of parking attendant
SET @K = 0

-- Create cycle to insert data into Staff.Shifts 

SET @LotID = 1

WHILE @LotID <= 22
BEGIN

SET @FirstDateID = 1
SET @LastDateID = (SELECT DateID FROM Services.CalendarDates
  WHERE TheDate = @ShiftEndDate)

WHILE
@FirstDateID <= @LastDateID
  BEGIN 
	  IF @K = 3
	    BEGIN
		SET @FirstDateID = @FirstDateID + 1

		-- Insert filtered employees into temporary variable table
			SET @CurAttendantsID = (SELECT EmployeeID FROM Staff.Employees

				WHERE PositionID = 1 AND LotID = @LotID AND ((DateFired IS NULL  AND   DateHired <=  @FirstDateID  ) OR
									     ( DateFired IS NOT NULL AND DateHired <=  @FirstDateID AND DateFired >= @FirstDateID))

					ORDER BY EmployeeID
					OFFSET @K ROWS FETCH NEXT 1 ROWS ONLY)		

			         SET @EntryDay = @FirstDateID
					 SET @ExitDay = @FirstDateID + 1

					 INSERT INTO [Staff].[Shifts] (EmployeeID, DateStart, TimeStart, DateEnd, TimeEnd  )
	                 VALUES (@CurAttendantsID, @EntryDay, '18:00:00', @ExitDay, '06:00:00')

			  --SELECT * FROM @CurAttendants
              SET  @K = 0

        SET @FirstDateID = @FirstDateID + 1
	    END

       ELSE
         BEGIN
		    -- Insert filtered employees into temporary variable table
			SET @CurAttendantsID = (SELECT EmployeeID FROM Staff.Employees
				WHERE PositionID = 1 AND LotID = @LotID AND ((DateFired IS NULL  AND   DateHired <=  @FirstDateID  ) OR
									     ( DateFired IS NOT NULL AND DateHired <=  @FirstDateID AND DateFired >= @FirstDateID))
					ORDER BY EmployeeID
					OFFSET @K ROWS FETCH NEXT 1 ROWS ONLY)
		
			    
				IF @K = 0
	              BEGIN
				     SET @EntryDay = @FirstDateID
					 SET @ExitDay = @FirstDateID
					 INSERT INTO [Staff].[Shifts] (EmployeeID, DateStart, TimeStart, DateEnd, TimeEnd  )
	                 VALUES (@CurAttendantsID, @EntryDay, '06:00:00', @ExitDay, '18:00:00' )
		
		          END

				IF @K = 1
	              BEGIN
				     SET @EntryDay = @FirstDateID
					 SET @ExitDay = @FirstDateID + 1
					 INSERT INTO [Staff].[Shifts] (EmployeeID, DateStart, TimeStart, DateEnd, TimeEnd  )
	                 VALUES (@CurAttendantsID, @EntryDay, '18:00:00', @ExitDay, '06:00:00' )
		
		          END

				IF @K = 2
	              BEGIN
				     SET @EntryDay = @FirstDateID + 1
					 SET @ExitDay = @FirstDateID + 1
					 INSERT INTO [Staff].[Shifts] (EmployeeID, DateStart, TimeStart, DateEnd, TimeEnd  )
	                 VALUES (@CurAttendantsID, @EntryDay, '06:00:00', @ExitDay, '18:00:00' )
		
		          END
				  				   

	          --SELECT * FROM @CurAttendants
			  SET @K = @K +1
              
          END
  
 
 
 
  --SET @FirstDateID = @FirstDateID + 1
  
  END
SET @LotID = @LotID + 1
SET @FirstDateID = 1
END

END
 
 --EXECUTE STP_GNR_StaffShifts @ShiftEndDate = '2020-04-30'





