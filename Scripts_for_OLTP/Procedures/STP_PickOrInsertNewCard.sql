 -- ===================================================================================================================================================
/*
Author: Anna Levchenko
Create date: 2020-05-06
Short description: Return AllCardID if the card unused; add a new one if doesn't exist
                    If non-valid data is entered - rollback & return 0
Initial ticket number:
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC @AllCardID = STP_PickOrInsertNewCard 1944223, 78
*/
-- ===================================================================================================================================================


ALTER PROCEDURE STP_PickOrInsertNewCard
(
    @MemberCardNumber INT
    , @TariffID INT
)

AS
BEGIN
    DECLARE @AllCardID INT
    SET @AllCardID = 0

    BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

            /* Data validity checks */
            IF @MemberCardNumber < 1000000 OR @MemberCardNumber > 9999999
                RAISERROR ('Number does not contain 7 digits.', 16, 1)

            IF @TariffID NOT IN (SELECT TariffID FROM Membership.Tariffs)
                RAISERROR ('Tariff does not exist', 16, 1)

            /* Number look-up */
            IF @MemberCardNumber IN (SELECT MemberCardNumber FROM Membership.AllCards)
                IF (SELECT IsUsed FROM Membership.AllCards WHERE MemberCardNumber = @MemberCardNumber) = 0
                    BEGIN
                        UPDATE Membership.AllCards
                            SET IsUsed = 1, TariffID = @TariffID
                            WHERE MemberCardNumber = @MemberCardNumber
                        SET @AllCardID = (SELECT AllCardID FROM Membership.AllCards WHERE MemberCardNumber = @MemberCardNumber)
                    END
                ELSE
                    RAISERROR ('Card already used', 16, 1)
            ELSE
            BEGIN
                /* Insert new record into Membership.AllCards table */
                INSERT INTO Membership.AllCards (IsUsed, MemberCardNumber, TariffID)
                    VALUES (1, @MemberCardNumber, @TariffID)

                SET @AllCardID = IDENT_CURRENT('Membership.AllCards')
            END
		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN

	END CATCH

    RETURN @AllCardID
END