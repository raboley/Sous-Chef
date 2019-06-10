--- ###### When #################
-- Not catching for some reason
BEGIN TRY
	EXEC [spec].STAT_WorkGroup_Codes 'TEST: Insert into STAT Workgroup Codes','$(CaseNumber)'
END TRY
BEGIN CATCH
	SELECT 'TEST: Insert into STAT Workgroup Codes - ERROR','Fail'
END CATCH