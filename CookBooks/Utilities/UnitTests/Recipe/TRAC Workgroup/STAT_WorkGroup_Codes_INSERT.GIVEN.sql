--- ###### Given #################
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
	[Workgroup Description] = 'SCHF T Workgroup'