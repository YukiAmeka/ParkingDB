CREATE VIEW VW_ListOfBirthdaysForNextMonth  
AS  
SELECT TOP 1000 E.FirstName, E.Surname, E.DateOfBirth, [dbo].FN_ComputeAge(DateOfBirth) AS Age  
FROM [Staff].[Employees] AS E  
WHERE Month(DateOfBirth) = ( Month(CURRENT_TIMESTAMP) + 1)  
ORDER BY Day(DateOfBirth)


-- This function calculates full age Emloyees

ALTER FUNCTION [dbo].[FN_ComputeAge](@DoB DATETIME)
RETURNS NVARCHAR(50)
AS
BEGIN
 

	DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
	SELECT @tempdate = @DOB

	SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) 
	OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END
	SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)

	SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - CASE WHEN DAY(@DOB) > DAY(GETDATE()) THEN 1 ELSE 0 END
	SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)

	SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

	DECLARE @Age NVARCHAR(50)
	SET @Age = Cast(@years AS  NVARCHAR(4)) + ' Years ' + Cast(@months AS  NVARCHAR(2))+ ' Months ' +  Cast(@days AS  NVARCHAR(2))+ ' Days Old'
	RETURN @Age

End