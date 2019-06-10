-- ############## BEGIN: SETUP CODE  ##################################
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SPEC')
BEGIN
EXEC('CREATE SCHEMA SPEC')
END
-- all the drops statements
IF OBJECT_ID('SPEC.SPEC_AreasAndResponsibilities') IS NOT NULL DROP TABLE SPEC.SPEC_AreasAndResponsibilities

-- Now the inserts
CREATE TABLE SPEC.SPEC_AreasAndResponsibilities (
[Area Code] VARCHAR(7000) NULL,
[Area Description] VARCHAR(7000) NULL,
[Area Order] VARCHAR(7000) NULL,
[DELETE Area] VARCHAR(7000) NULL,
[DELETE Responsibility] VARCHAR(7000) NULL,
[Map to Responsibility Code] VARCHAR(7000) NULL,
[Responsibility Code] VARCHAR(7000) NULL,
[Responsibility Description] VARCHAR(7000) NULL,
[Responsibility Order] VARCHAR(7000) NULL
)
-- ############## END.: SETUP CODE  ##################################

-- #####################################################################################
-- ######## TEST: Insert into shared_areas with resposibility that doesn't exist ##############
-- #####################################################################################
-- Expected Result: Throws an error 
BEGIN -- test

	--- ###### Arrange #################
	-- Delete the area if it still exists for some reason
	DELETE FROM Shared_Areas WHERE AreaCode = 'SCHF'
	-- INSERT the specs
	INSERT INTO SPEC.SPEC_AreasAndResponsibilities (
	[Area Code],
	[Area Description],
	[Area Order],
	[DELETE Area],
	[DELETE Responsibility],
	[Map to Responsibility Code],
	[Responsibility Code],
	[Responsibility Description],
	[Responsibility Order]
	)
	SELECT 'SCHF','Sous Chef Testing area','99','','','TST','SCHF','Sous Chef Testing Responsibility','99'

	--- ###### execute #################
	-- Not catching for some reason
	BEGIN TRY
		EXEC [spec].[Shared_Areas] 'TEST: Insert into shared_areas with resposibility that exists','$(CaseNumber)'
	END TRY
	BEGIN CATCH
		SELECT 'TEST: Insert into shared_areas with resposibility that doesnt exist','Passed'
	END CATCH

	--- ###### Assert #################

	--- ###### Cleanup #################
	DELETE FROM Shared_Areas WHERE AreaCode = 'SCHF'
--#endregion
END
-- #####################################################################################
-- ######## TEST: Insert into shared_areas with resposibility that exists ##############
-- #####################################################################################
-- Expected Result: Successfully inserts the area
	--- ###### Arrange #################
	-- Delete the area if it still exists for some reason
	DELETE FROM Shared_Areas WHERE AreaCode = 'SCHF'
	-- INSERT the specs
	INSERT INTO SPEC.SPEC_AreasAndResponsibilities (
	[Area Code],
	[Area Description],
	[Area Order],
	[DELETE Area],
	[DELETE Responsibility],
	[Map to Responsibility Code],
	[Responsibility Code],
	[Responsibility Description],
	[Responsibility Order]
	)
	SELECT 'SCHF','Sous Chef Testing area','99','','','SA','SCHF','Sous Chef Testing Responsibility','99'

	--- ###### execute #################
	EXEC [spec].[Shared_Areas] 'TEST: Insert into shared_areas with resposibility that exists','$(CaseNumber)'

	--- ###### Assert #################
	IF EXISTS (SELECT 1 FROM Shared_Areas sa
		LEFT JOIN spec.SPEC_AreasAndResponsibilities sp
			ON [Area Code] = sa.AreaCode
		JOIN Shared_Responsibilities SR
			ON SR.PKShared_Responsibilities = sa.FKShared_Responsibilities
		WHERE 1=1 
			AND sa.AreaCode = sp.[Area Code]
			AND AreaDescription = sp.[Area Description]
			AND sa.AreaPrintOrder = sp.[Area Order]
			AND sr.ResponsibilityCode = sp.[Map to Responsibility Code]
			)
	BEGIN 
		SELECT 'TEST: Insert into shared_areas with resposibility that exists','Passed'
	END
	ELSE
	BEGIN
		SELECT 'TEST: Insert into shared_areas with resposibility that exists','Failed'
	END

	--- ###### Cleanup #################
	DELETE FROM Shared_Areas WHERE AreaCode = 'SCHF'

-- #####################################################################################
-- ######## TEST: UPDATE shared areas with area code that exists, but need to be changed ##############
-- #####################################################################################
-- Expected Result: Successfully updates the area

-- #####################################################################################
-- ######## TEST: Don't UPDATE shared areas with code that exists and is exactly the same##############
-- #####################################################################################
-- Expected Result: does nothing

-- #####################################################################################
-- ######## TEST: Update Shared areas with code that has invalid area  ##############
-- #####################################################################################
-- Expected Result: throws an error

-- #####################################################################################
-- ######## TEST: DELETE from shared areas where code does exist ##############
-- #####################################################################################
-- Expected Result: successfully deletes

-- #####################################################################################
-- ######## TEST: DELETE from shared areas where code doesn't exist ##############
-- #####################################################################################
-- Expected Result: does nothing
