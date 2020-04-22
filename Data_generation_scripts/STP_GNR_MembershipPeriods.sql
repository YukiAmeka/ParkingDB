CREATE PROCEDURE STP_GNR_MembershipPeriods
AS
BEGIN
  INSERT INTO [Membership].[Periods] (PeriodName)
    VALUES
    ('MonthFull')
    ,('QuaterFull')
    ,('YearFull')
    ,('VIP')
END