EXEC [spec].[Shared_Areas] '$(Location)','$(CaseNumber)'

/*
UPDATE Shared_Workgroups set FKShared_Areas = 1
UPDATE QUIC_DeficiencyCodes SET FKShared_Areas = 1
UPDATE QUIC_VirtualQUICLists set FKShared_Areas = 1
UPDATE Shared_MinorDenialCodes set FKShared_Areas = 1
UPDATE QUIC_BillableWIP SET FKShared_Areas = 1
DELETE FROM Shared_Areas WHERE AreaCode <> 'SA'
*/

