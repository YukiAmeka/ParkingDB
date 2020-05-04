 -- ===================================================================================================================================================
/*
Author:	
Create date: 
Short description: 
Initial ticket number: 
Modifications: <date>, <user>[, <ticket number>] - <changes description> ...
Sample execution: EXEC procname @param1
*/
-- ===================================================================================================================================================


ALTER PROCEDURE 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET NOCOUNT ON;

		COMMIT TRAN
	END TRY

	BEGIN CATCH

		SELECT ERROR_MESSAGE() + ' Rollback transaction.'
		ROLLBACK TRAN
		
	END CATCH

END