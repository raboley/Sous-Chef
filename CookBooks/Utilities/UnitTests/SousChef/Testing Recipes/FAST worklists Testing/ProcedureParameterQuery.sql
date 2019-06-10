IF OBJECT_ID('tempdb..#SprocParameters') IS NOT NULL DROP TABLE #SprocParameters
GO
create table #SprocParameters

	(
		SprocName VARCHAR(MAX)
		,ParameterNames VARCHAR(MAX)
		
		)

--Get a list of all of the procedures
INSERT INTO #SprocParameters
(
	SprocName
)
select SO.name AS [ObjectName]
FROM sys.objects AS SO
WHERE TYPE IN ('P','FN')
and SCHEMA_NAME(SCHEMA_ID) in ('dbo')


	DECLARE @SprocName VARCHAR(MAX)
	DECLARE @ParameterNames VARCHAR(MAX)
	DECLARE @Table_Cursor as CURSOR;

    SET @Table_Cursor = CURSOR FOR
    select SprocName from #SprocParameters
	Set @ParameterNames=''

    OPEN @Table_Cursor
 
    FETCH NEXT FROM @Table_Cursor INTO @SprocName
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
		Set @ParameterNames=''
		SELECT @ParameterNames=@ParameterNames + Coalesce(P.Name+ ', ','') 
		FROM sys.objects AS SO
		INNER JOIN sys.parameters AS P 
		ON SO.OBJECT_ID = P.OBJECT_ID
		WHERE SO.OBJECT_ID IN ( SELECT OBJECT_ID 
		FROM sys.objects
		WHERE TYPE IN ('P','FN'))
		and SCHEMA_NAME(SCHEMA_ID) in ('dbo')
		and SO.Name = @SprocName
		ORDER BY  P.parameter_id
				
        Update #SprocParameters
		SET ParameterNames =LEFT(@ParameterNames,LEN(@ParameterNames)-1)
		WHERE SprocName=@SprocName
            
           
		 FETCH NEXT FROM @Table_Cursor INTO  @SprocName
	END
 
CLOSE @Table_Cursor;
DEALLOCATE @Table_Cursor;

select 'exec '+ SprocName+' '+ParameterNames from #SprocParameters where sprocname like '%TTL%'
 order by SprocName 


