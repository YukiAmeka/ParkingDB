/* Check if all required data is inserted & the client is not in the DB yet before adding a new record */
CREATE TRIGGER TRG_ClienteleClients_INS
ON Clientele.Clients
AFTER INSERT
AS
BEGIN
    DECLARE @FirstName VARCHAR(100)
    DECLARE @Surname VARCHAR(100)
    DECLARE @Gender CHAR(1)
    DECLARE @Telephone CHAR(15)
    DECLARE @Email VARCHAR(100)
    DECLARE @HomeAddress VARCHAR(100)
    DECLARE @CityID INT

    SET @FirstName = (SELECT FirstName FROM inserted)
    SET @Surname = (SELECT Surname FROM inserted)
    SET @Telephone = (SELECT Telephone FROM inserted)
    SET @Email = (SELECT Email FROM inserted)
    SET @CityID = (SELECT CityID FROM inserted)

    IF @FirstName IS NULL OR @Surname IS NULL
        BEGIN
            RAISERROR('Please provide client''s first name and surname', 16, 1)
            ROLLBACK TRAN
            RETURN
        END

    IF @Telephone IS NULL AND @Email IS NULL
        BEGIN
            RAISERROR('Please provide client''s contact information', 16, 1)
            ROLLBACK TRAN
            RETURN
        END

    IF @CityID IS NULL
        BEGIN
            RAISERROR('Please choose client''s home city', 16, 1)
            ROLLBACK TRAN
            RETURN
        END

    IF (SELECT COUNT(*)
            FROM Clientele.Clients
                WHERE FirstName = @FirstName
                AND Surname = @Surname
                AND (Telephone = @Telephone
                OR Email = @Email)) > 1
        BEGIN
            RAISERROR('This client is already in the database', 16, 1)
            ROLLBACK TRAN
            RETURN
        END
END