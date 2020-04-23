/* Generate unique random Card Numbers of 7 digits.
Populate Membership.AllCards with @TotalNumber records of MemberCardNumber */


CREATE PROC STP_GNR_MembershipAllCards

AS
BEGIN
	DECLARE @TotalNumber int
	SET @TotalNumber = 0
		WHILE @TotalNumber < 50000
	
	
		BEGIN	
			declare @Lower int
			SET @Lower = 1000000
			declare @Upper int
			SET @Upper = 9999999
					SET @Lower=  @Lower + CONVERT(INT, (@Upper-@Lower+1)*RAND())
					IF NOT EXISTS ( SELECT 1 FROM [Membership].[AllCards] WHERE MemberCardNumber = @Lower )
			BEGIN
					INSERT INTO [Membership].[AllCards](MemberCardNumber) VALUES(@Lower)
					SET @TotalNumber += 1
			END
		END 
END


 EXEC STP_GNR_MembershipAllCards