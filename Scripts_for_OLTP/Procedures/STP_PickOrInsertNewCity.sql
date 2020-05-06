 -- ===================================================================================================================================================
/*
Author: Anna Levchenko
Create date: 2020-05-05
Short description: Return CityID of a city/town from Location.Cities table; add a new one if doesn't exist.
                    If non-valid data is entered - rollback & return 0
Initial ticket number:
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC @CityID = STP_PickOrInsertNewCity 'Swindon', 11
                  EXEC @CityID = STP_PickOrInsertNewCity '  Cardiff  '
*/
-- ===================================================================================================================================================


ALTER PROCEDURE STP_PickOrInsertNewCity
(
    @CityName VARCHAR(50)
    , @ClosestCityWithParking INT = NULL
)

AS
BEGIN
    DECLARE @CityID INT
    SET @CityID = 0

    BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

            /* Remove leading & trailing spaces */
            SET @CityName = LTRIM(RTRIM(@CityName))

            /* Data validity checks */
            IF LEN(@CityName) < 1
                RAISERROR ('Empty string.', 16, 1)

            IF @CityName NOT LIKE '[A-Z]%[A-Z]' OR @CityName LIKE '%[,.?!\/()<>$0-9%]%'
                RAISERROR ('Non-alphabetic character or string.', 16, 1)

            /* Duplicate rows' check */
            IF @CityName IN (SELECT CityName FROM Location.Cities)
                SET @CityID = (SELECT CityID FROM Location.Cities WHERE CityName = @CityName)
            ELSE
            BEGIN
                /* Capitalize 1st letter */
                SET @CityName = UPPER(LEFT(@CityName, 1)) + SUBSTRING(@CityName, 2, LEN(@CityName))

                /* Insert new record into Location.Cities table */
                INSERT INTO Location.Cities (CityName, ClosestCityWithParking)
                    VALUES (@CityName, @ClosestCityWithParking)

                SET @CityID = IDENT_CURRENT('Location.Cities')
            END
		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN

	END CATCH

    RETURN @CityID
END