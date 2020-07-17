 -- ===================================================================================================================================================
/*
Author: Anna Levchenko
Create date: 2020-05-24
Short description:
Initial ticket number:
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC procname @param1
*/
-- ===================================================================================================================================================


ALTER PROCEDURE STP_UpdateMembershipDimClients
(
    @ClientID INT
	, @FirstName VARCHAR(100)
	, @Surname VARCHAR(100)
	, @Telephone CHAR(15)
	, @Email VARCHAR(100)
	, @HomeAddress VARCHAR(200)
    , @CityName VARCHAR(50)
	, @LatestExpiryDate DATE
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

            DECLARE @RowUpdated INT
            SET @RowUpdated = 0

            IF (SELECT FirstName FROM Membership.DimClients WHERE ClientID = @ClientID) <> @FirstName
            BEGIN
                UPDATE Membership.DimClients
                    SET FirstName = @FirstName WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF (SELECT Surname FROM Membership.DimClients WHERE ClientID = @ClientID) <> @Surname
            BEGIN
                UPDATE Membership.DimClients
                    SET Surname = @Surname WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF (SELECT Telephone FROM Membership.DimClients WHERE ClientID = @ClientID) <> @Telephone
            BEGIN
                UPDATE Membership.DimClients
                    SET Telephone = @Telephone WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF (SELECT Email FROM Membership.DimClients WHERE ClientID = @ClientID) <> @Email
            BEGIN
                UPDATE Membership.DimClients
                    SET Email = @Email WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF (SELECT HomeAddress FROM Membership.DimClients WHERE ClientID = @ClientID) <> @HomeAddress
            BEGIN
                UPDATE Membership.DimClients
                    SET HomeAddress = @HomeAddress WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF (SELECT CityName FROM Membership.DimClients WHERE ClientID = @ClientID) <> @CityName
            BEGIN
                UPDATE Membership.DimClients
                    SET CityName = @CityName WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF (SELECT LatestExpiryDate FROM Membership.DimClients WHERE ClientID = @ClientID) <> @LatestExpiryDate
            BEGIN
                UPDATE Membership.DimClients
                    SET LatestExpiryDate = @LatestExpiryDate WHERE ClientID = @ClientID
                SET @RowUpdated += 1
            END

            IF @RowUpdated > 0
                SET @RowUpdated = 1
            RETURN @RowUpdated

		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN

	END CATCH

END