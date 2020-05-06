 /*
 
Author:	Ihor Prytula
Create date: 2020-04-27
Short description: Insert new Membership Periods

EXEC STP_InsertNewMembershipPeriods 'semi-annual'
*/

IF OBJECT_ID ('STP_InsertNewMembershipPeriods') IS NOT NULL
DROP PROCEDURE STP_InsertNewMembershipPeriods
GO

CREATE PROCEDURE STP_InsertNewMembershipPeriods

(
 @PeriodName VARCHAR (20)
)
                                                                                       
AS									  
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;
				INSERT INTO Membership.Periods (PeriodName)
				VALUES (@PeriodName)
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
	END CATCH
END            


