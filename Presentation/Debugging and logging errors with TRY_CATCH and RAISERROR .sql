/* Switch on line numbers in MS SQL Server Management Studio:
Tools -> Options... -> Text Editor -> Transact-SQL -> General -> Line numbers */

/* Create table to store the log of all errors if needed */
CREATE TABLE DBErrors
    (ErrorID        INT IDENTITY(1, 1),
    UserName       VARCHAR(100),
    ErrorNumber    INT,
    ErrorState     INT,
    ErrorSeverity  INT,
    ErrorLine      INT,
    ErrorProcedure VARCHAR(MAX),
    ErrorMessage   VARCHAR(MAX),
    ErrorDateTime  DATETIME)

/* Turn off the running count of affected rows during code execution */
SET NOCOUNT ON

/* Put potentially buggy code in TRY.
If no errors with severety level > 10 occur, code in CATCH never gets executed */
BEGIN TRY
    PRINT '=== Before minor warning'

    /* Error with severity level below 10 - minor warning or informational message. Control stays in TRY */
    RAISERROR ('Check the declared length of your variable', 10, 1)
    PRINT '=== After minor warning, before serious error'

    /* Severity level 16 (default) error - serious error. Control moves on to CATCH */
    RAISERROR ('Adding duplicate records is not allowed', 16, 1)

    /* Control has moved on to CATCH, so this line doesn't get executed */
    PRINT '=== After serious error'

END TRY
BEGIN CATCH

    /* CATCH section can be completely empty -> system will ignore the error.
    Programs that use the DB as a backend won't know errors occured unless we include
    statements that explicitly pass on the info (e.g. SELECT, RAISERROR, PRINT) */

	/* New error message - doesn't interfere with the one that occured in TRY */
	RAISERROR ('Error in CATCH', 16, 1)

    /* Show system information about the error that occured in TRY */
    SELECT
        ERROR_NUMBER() AS ErrorNumber, -- Error #: 1-49999 system errors, 50000+ - user-defined errors (50000 by default)
        ERROR_STATE() AS ErrorState, -- 0-255; "If the same user-defined error is raised at multiple locations, using a unique state number for each location can help find which section of code is raising the errors." (MS docs)
        ERROR_SEVERITY() AS ErrorSeverity, -- Severity level: 0-10 minor, 11-19 serious, 20-25 - fatal (client connection is terminated)
        ERROR_PROCEDURE() AS ErrorProcedure, -- Name of Procedure or Trigger where the error occured
        ERROR_LINE() AS ErrorLine, -- Line # on which the buggy code sits
        ERROR_MESSAGE() AS ErrorMessage; -- Explanation of the error's nature

    /* Put system information about the error that occured in TRY into the log of all errors */
    INSERT INTO DBErrors
        VALUES
        (SUSER_SNAME(), -- Name under which user is logged in
        ERROR_NUMBER(),
        ERROR_STATE(),
        ERROR_SEVERITY(),
        ERROR_LINE(),
        ERROR_PROCEDURE(),
        ERROR_MESSAGE(),
        GETDATE()); -- Datestamp of when the error occured

    /* Print out the values of variables, records etc that may be the source of error for debugging */

END CATCH


/* Look up system table with errors */
SELECT * FROM master.dbo.sysmessages

/* Add a custom error to the system table for repeated use */
EXEC sp_addmessage @msgnum = 50001 -- 50000+ - user-defined errors (50000 by default)
	, @severity = 11 -- severity level 0-18 can be specified by any user; 19-25 - only by users with special permissions
	, @msgtext = 'Check the declared length of your variable' -- Custom explanation of the error's nature; max 2,047 characters
    --, @replace = 'replace'               -- If existing error warning needs to be modified

/* Using the created custom error. Severity in RAISERROR overrides severity in sp_addmessage */
RAISERROR (50001, 11, 1)

/* Remove custom error by error number*/
EXEC sp_dropmessage 50001
