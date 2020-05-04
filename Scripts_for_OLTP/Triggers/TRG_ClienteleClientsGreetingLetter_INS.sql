--Sending a greeting letter to a newly registered client into the Parking system
CREATE TRIGGER TRG_ClienteleClientsGreetingLetter_INS
       ON Clientele.Clients
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @ClientID INT,
			   @FirstName VARCHAR(100),
			   @Surname VARCHAR(100),
			   @ClientGender CHAR(1),
			   @Email VARCHAR(100),
			   @Appiel VARCHAR(5)

       SELECT @ClientID = INSERTED.ClientID, 
			  @ClientGender = INSERTED.Gender,
			  @FirstName = INSERTED.FirstName,
			  @Surname = INSERTED.Surname,
			  @Email = INSERTED.Email
	   
       FROM INSERTED

	   IF @ClientGender = 'm'
			SET @Appiel = 'Mr'
	   ELSE 
			SET @Appiel = 'Mrs'

       DECLARE @body VARCHAR(500) = 
				'Dear' + @Appiel + @FirstName + @Surname + ',' + 'You are welcome to use the servises of our Parking System'

       EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Queens Parking Chain'
           ,@recipients =  @Email
           ,@subject = 'Welcome to Parking System'
           ,@body = @body
           ,@importance ='Normal'
END

--DELETE FROM Clientele.Clients
--WHERE ClientID = 4001

--INSERT INTO Clientele.Clients
--VALUES ('Mariia', 'Terletska', 'f', '0963717308', 'terletska.mariia@gmail.com', 'Shevchenka str', 0, 1)

