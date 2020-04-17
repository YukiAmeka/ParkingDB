/* Generate random start date & calculate expiry date
for the current record; insert into current record */

CREATE PROC STP_GenerateMembershipDates
(
        @PeriodInDays  AS INT
        ,@StartDate AS DATE
        ,@Member AS INT
)
AS
BEGIN
    DECLARE @MembershipStartDate DATE
    DECLARE @MembershipExpiryDate DATE

    SET @MembershipStartDate = (DATEADD(DAY, ABS(CHECKSUM(NEWID()) % @PeriodInDays), @StartDate))
    SET @MembershipExpiryDate = (DATEADD(DAY, @PeriodInDays + 5, @MembershipStartDate))

    UPDATE Membership.ActiveCards
        SET StartDate = @MembershipStartDate, ExpiryDate = @MembershipExpiryDate
        WHERE ClientID = @Member
END