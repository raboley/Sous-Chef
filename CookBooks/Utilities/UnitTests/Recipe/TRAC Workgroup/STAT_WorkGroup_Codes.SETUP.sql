/*****
[[Workgroup Codes]]

This script creates the setup code needed for all tests in this suite of tests.

*/
-- Create a new stored procedure called 'STAT_WorkGroup_Codes_Setup' in schema 'SPEC'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'SPEC'
    AND SPECIFIC_NAME = N'STAT_WorkGroup_Codes_Setup'
)
DROP PROCEDURE SPEC.STAT_WorkGroup_Codes_Setup
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE SPEC.STAT_WorkGroup_Codes_Setup
--   @param1 /*parameter name*/ int /*datatype_for_param1*/ = 0, /*default_value_for_param1*/
--   @param2 /*parameter name*/ int /*datatype_for_param1*/ = 0 /*default_value_for_param2*/
-- add more stored procedure parameters here
AS
BEGIN
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
END



