-- ############## BEGIN: SETUP CODE  ##################################
BEGIN TRAN

DECLARE @debug INT = 1
--- Spec schema needs to exist since all things are derived from that.
IF NOT EXISTS (SELECT *
FROM sys.schemas
WHERE name = 'SPEC')
BEGIN
	EXEC('CREATE SCHEMA SPEC')
END

-- all the drops statements
IF OBJECT_ID('SPEC.SPEC_STAT_Workgroup_Specs') IS NOT NULL DROP TABLE SPEC.SPEC_STAT_Workgroup_Specs

-- Now create the table again
CREATE TABLE SPEC.SPEC_STAT_Workgroup_Specs
(
	[AssignmentGroup] VARCHAR(7000) NULL,
	[CaseNumber] VARCHAR(7000) NULL,
	[ChangeCode] VARCHAR(7000) NULL,
	[Criteria Variable] VARCHAR(7000) NULL,
	[DeleteAssignments] VARCHAR(7000) NULL,
	[Operator] VARCHAR(7000) NULL,
	[Priority] VARCHAR(7000) NULL,
	[Reporting Area Code] VARCHAR(7000) NULL,
	[Value] VARCHAR(MAX) NULL,
	[Workgroup Code] VARCHAR(7000) NULL,
	[Workgroup Description] VARCHAR(7000) NULL
)

--- Removing things we will add later in case they exist for some reason
DELETE FROM Shared_Workgroups WHERE WorkgroupCode = '55'
DELETE FROM Shared_Areas WHERE AreaCode = 'SCHF'
DELETE FROM Shared_Responsibilities WHERE ResponsibilityCode = 'SCHF'


--- Adding the Setup code we will need for all tests
INSERT INTO Shared_Responsibilities
SELECT 1, 'Sous Chef Testing', GETDATE(), NULL, 'SCHF', 'Sous Chef Testing area', 1

INSERT INTO Shared_Areas
SELECT 1, 'Sous Chef Testing', GETDATE(), 'SCHF', 'Sous Chef Testing area', 1, (SELECT TOP 1
		PKShared_Responsibilities
	FROM Shared_Responsibilities SR
	WHERE ResponsibilityCode = 'SCHF')

DECLARE @SousChefArea INT = (SELECT TOP 1 PKShared_Areas FROM Shared_Areas SR WHERE AreaCode = 'SCHF')

INSERT INTO Shared_Workgroups
SELECT 1,'SCHF T Workgroup -Update',GETDATE(),@SousChefArea,'55','SCHF T Workgroup'

-- ############## END.: SETUP CODE  ##################################

-- #####################################################################################
-- ######## TEST: Update a Workgroup Code Description ##############
-- #####################################################################################
-- Expected Result: Successfully inserts the area
BEGIN --test2

	--- ###### Arrange #################
	-- Delete the area if it still exists for some reason
DELETE FROM SPEC.SPEC_STAT_Workgroup_Specs
	-- INSERT the specs
INSERT INTO SPEC.SPEC_STAT_Workgroup_Specs (
	[AssignmentGroup],
	[CaseNumber],
	[ChangeCode],
	[Criteria Variable],
	[DeleteAssignments],
	[Operator],
	[Priority],
	[Reporting Area Code],
	[Value],
	[Workgroup Code],
	[Workgroup Description]
)
--- Inserting a Row to insert into specs table
SELECT 
	[AssignmentGroup] = '1',
	[CaseNumber] = '$(CaseNumber)',
	[ChangeCode] = '',
	[Criteria Variable] = '',
	[DeleteAssignments] = '',
	[Operator] = '',
	[Priority] = 1,
	[Reporting Area Code] = 'SCHF',
	[Value] = '',
	[Workgroup Code] = '55',
	[Workgroup Description] = 'SCHF T Workgroup -Update'

	--- ###### execute #################
	-- Not catching for some reason
	BEGIN TRY
		EXEC [spec].STAT_WorkGroup_Codes 'TEST: Insert into STAT Workgroup Codes','$(CaseNumber)'
	END TRY
	BEGIN CATCH
		SELECT 'TEST: Insert into STAT Workgroup Codes','Fail'
	END CATCH

	--- ###### Assert #################
	IF EXISTS (SELECT  1
	FROM Shared_Workgroups 
	WHERE WorkgroupCode = 55
		AND WorkgroupDescription = 'SCHF T Workgroup -Update')
	BEGIN
		SELECT  'TEST: Update STAT Workgroup Code Description','Pass' 
	END 
	ELSE
	BEGIN
		SELECT 'TEST: Update STAT Workgroup Code Description','Fail'
	END
	--- ###### Cleanup #################
--#endregion
END

-- #####################################################################################
-- ######## TEST: UPDATE shared areas with area code that exists, but need to be changed ##############
-- #####################################################################################
-- Expected Result: Successfully updates the area

-- #####################################################################################
-- ######## TEST: Don't UPDATE shared areas with code that exists and is exactly the same 
-- #####################################################################################
-- Expected Result: does nothing

-- #####################################################################################
-- ######## TEST: Update Shared areas with code that has invalid area  ##############
-- #####################################################################################
-- Expected Result: throws an error