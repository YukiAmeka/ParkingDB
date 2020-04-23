  /* part of the process of generating data in this procedure */
	
CREATE PROCEDURE STP_HLP_OldMembershipTariffs
	 /* @ChangeProc - variable percentage */
(
        @TariffStartDate as DATE,
        @TariffEndDate as DATE,
		@ChangeProc DECIMAL
)

AS
BEGIN

	DECLARE @TariffID INT
	DECLARE @Price DECIMAL
	DECLARE @ZoneID INT
	DECLARE @PeriodID INT
	DECLARE @CurrentIdent INT


	SET @CurrentIdent = (SELECT IDENT_CURRENT('Membership.Tariffs'))
	SET @TariffID = (@CurrentIdent + 1) - 103
	WHILE @TariffID <= @CurrentIdent

		BEGIN
			SET @Price = (SELECT [Price] FROM Membership.Tariffs WHERE TariffID = @TariffID)
			SET @Price = @Price - (@Price * @ChangeProc )

			SET @ZoneID = (SELECT [ZoneID] FROM Membership.Tariffs WHERE TariffID = @TariffID)
			SET @PeriodID = (SELECT [PeriodID] FROM Membership.Tariffs WHERE TariffID = @TariffID)


			INSERT INTO Membership.Tariffs (Price, ZoneID, PeriodID, StartDate, EndDate)
			VALUES (@Price, @ZoneID, @PeriodID,  @TariffStartDate, @TariffEndDate)

			SET @TariffID += 1
		END
END
	 /* a variable percentage of the tariff prices between the current dates */

  EXEC STP_HLP_OldMembershipTariffs @TariffStartDate = '2019-01-01', @TariffEndDate = '2019-12-31', @ChangeProc = 0.03
  EXEC STP_HLP_OldMembershipTariffs @TariffStartDate = '2018-01-01', @TariffEndDate = '2018-12-31', @ChangeProc = 0.05
  EXEC STP_HLP_OldMembershipTariffs @TariffStartDate = '2017-01-01', @TariffEndDate = '2017-12-31', @ChangeProc = 0.08
  EXEC STP_HLP_OldMembershipTariffs @TariffStartDate = '2016-01-01', @TariffEndDate = '2016-12-31', @ChangeProc = 0.04
  EXEC STP_HLP_OldMembershipTariffs @TariffStartDate = '2015-01-01', @TariffEndDate = '2015-12-31', @ChangeProc = 0.02