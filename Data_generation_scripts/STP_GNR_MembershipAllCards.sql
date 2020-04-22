/* Generate unique random Card Numbers of 7 digits.
Populate Membership.AllCards with @TotalNumber records of MemberCardNumber */

CREATE PROC STP_GNR_MembershipAllCards
(
    @TotalNumber AS int
)
AS
BEGIN
    WHILE @TotalNumber > 0
        BEGIN
            INSERT INTO Membership.AllCards (MemberCardNumber)
            VALUES (FLOOR(RAND()*(9999999-1000000+1)+1000000))
            SET @TotalNumber -= 1
        END
END