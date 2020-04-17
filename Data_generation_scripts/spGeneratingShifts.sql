CREATE PROCEDURE spGeneratingShifts
AS 

BEGIN


DECLARE 
--@CurDate date, 
--@CurDateId int,
@CurAttendantsID int,
@FirstDateID int = 1,
@K int, 
@EntryDay int,
@ExitDay int,
@LotID int


--SELECT @CurDate = (SELECT  Convert(date, getdate()) )
--PRINT @CurDate

--SELECT @CurDateId = 
--(SELECT DateID 
--FROM Services.CalendarDates
--WHERE TheDate = @CurDate)
--PRINT @CurDateId


SET @LotID = 1

-- Control four shifts of parking attendant
SET @K = 0

-- Create cycle to insert data into Staff.Shifts 

WHILE @LotID <= 22
BEGIN

WHILE
@FirstDateID <= 365--@CurDateId 
  BEGIN 
	  IF @K = 3
	    BEGIN
		SET @FirstDateID = @FirstDateID + 1

		-- Insert filtered employees into temporary variable table
			SELECT @CurAttendantsID = (SELECT EmployeeID FROM Staff.Employees
				WHERE PositionID = 1 AND (DateFired IS NULL  AND   DateHired <  1900) AND LotID = @LotID --@CurDateId)
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
			SELECT @CurAttendantsID = (SELECT EmployeeID FROM Staff.Employees
				WHERE PositionID = 1 AND (DateFired IS NULL  AND   DateHired <  1900) AND LotID = @LotID --@CurDateId)
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
 

EXECUTE spGeneratingShifts
--GO
SELECT a.*, b.LotID  FROM Staff.Shifts a
JOIN [Staff].[Employees] b ON a.EmployeeID = b.EmployeeID
ORDER BY DateStart, TimeStart

--DELETE FROM Staff.Shifts