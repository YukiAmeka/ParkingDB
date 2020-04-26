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
	SET @TariffID = (@CurrentIdent + 1) - 109
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


