DECLARE @debug INT = 1

DECLARE @SousChefArea INT = (SELECT TOP 1 PKShared_Areas FROM Shared_Areas SR WHERE AreaCode = 'SCHF')

--- ###### Then #################
IF EXISTS (SELECT  1
FROM Shared_Workgroups swg
WHERE WorkgroupCode = 55
	AND WorkgroupDescription = 'SCHF T Workgroup'
	AND swg.FKShared_Areas = @SousChefArea
)
BEGIN
	SELECT  'TEST: Insert into STAT Workgroup Codes','Pass' 
END 
ELSE
BEGIN
	SELECT 'TEST: Insert into STAT Workgroup Codes','Fail'
		
	IF @Debug = 1
	BEGIN
		SELECT * FROM Shared_Workgroups
	END
END