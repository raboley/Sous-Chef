--- Add these two variables to capture errors
DECLARE @errors TABLE (errorType varchar(100),errorMessage varchar(MAX),shouldRollback Int)
DECLARE @errorMessage varchar(MAX)
BEGIN TRAN
-- Make sure there is a exists if statement that will return false if there is an error
IF EXISTS (SELECT 1 FROM master.INFORMATION_SCHEMA.COLUMNS /*where AreaCode = @Variable4*/)
BEGIN
-- in the else statement of this if add logic to insert the data into the @errors table
INSERT INTO @errors (errorType,errorMessage,shouldRollback)
        --SELECT 'Invalid Shared Area',CONCAT('ERROR Area Code ', @Variable4,' Does not exist.. so Worklist ', @variable2,' Cannot be created or updated'),1
		SELECT 'Test Error','Error (not really), master.information_schema.columns has lots of rows~!',1
END

IF EXISTS (SELECT 1 FROM @errors where shouldRollback = 1)
BEGIN
    --Flattening all rows into a single string
    SELECT @errorMessage =  STUFF(
  (
    SELECT CHAR(13) + errorMessage FROM @errors AS m
    ORDER BY errorMessage DESC
    FOR XML PATH(''), TYPE).value('.', 'nvarchar(max)'),1,1,'')
FROM @errors AS mv
    PRINT CHAR(13)+ CHAR(13) + 'Rolled Back Transaction'
    ROLLBACK
;THROW 60000,@errorMessage,1;
END
ELSE
BEGIN
	COMMIT
END