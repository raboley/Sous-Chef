USE $(TRACDatabase)
GO

/****** Object:  StoredProcedure [SPEC].[Shared_Facility_Codes]    Script Date: 5/9/2017 6:37:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[SPEC].[STAT_Activity_Codes]') IS NOT NULL
    BEGIN
    DROP PROCEDURE [SPEC].[STAT_Activity_Codes]    ;
    PRINT '<<< DROPPED PROCEDURE [SPEC].[STAT_Activity_Codes]     >>>';
END;
GO

CREATE PROCEDURE [SPEC].[STAT_Activity_Codes] 

/*       COPYRIGHT (c) Huron Healthcare    WRITTEN: Russell Boley   PURPOSE:   Update Or insert Facility Codes   
ASSUMPTIONS:  Files have already been staged <-- not smart enough to know this.    
CHANGE LOG:  2013-01-21: Created      ~CUSTOM~ 		
Initials Date - Adapted for [Client] [HIS] KeyAR Import Master <- Replace with your client and HIS 
SAMPLE CALL:    EXEC [SPEC].[Shared_Facility_Codes] 1, @@SERVERNAME, 1; */
AS
BEGIN
  SET NOCOUNT ON;
  SET QUOTED_IDENTIFIER ON;


IF OBJECT_ID('tempdb..#WhileList') IS NOT NULL DROP TABLE #WhileList

DECLARE @i int = 1
----- [CHG1] -----
DECLARE @Variable1 VARCHAR(100)
DECLARE @Variable2 VARCHAR(100)
DECLARE @Variable3 VARCHAR(100)
DECLARE @Variable4 VARCHAR(100)
DECLARE @variable5 VARCHAR(MAX)
DECLARE @Variable6 VARCHAR(100)
DECLARE @Variable7 VARCHAR(100)
DECLARE @Variable8 VARCHAR(100)
DECLARE @Variable9 VARCHAR(100)
DECLARE @variableDELETE VARCHAR(100)

DECLARE @PK varchar(20)
DECLARE @workGroup	VARCHAR(100)
DECLARE @repcode VARCHAR(100)
DECLARE @accessgroup int
DECLARE @errors TABLE (MinorCode varchar(50),MajorCode varchar(50),MinorDescription Varchar(50),ErrorMessage VARCHAR(MAX))
DECLARE @PKGrid varchar(20)
DECLARE @operator varchar (50)

CREATE TABLE #WhileList (id int IDENTITY(1,1),Variable1 varchar(100),Variable2 VARCHAR(100),Variable3 VARCHAR(100)
,Variable4 VARCHAR(100),Variable5 VARCHAR(MAX),Variable6 VARCHAR(100),Variable7 VARCHAR(100),Variable8 VARCHAR(100),Variable9 VARCHAR(100)
--,variableDELETE VARCHAR(100)
)

INSERT INTO #WhileList(Variable1,Variable2,Variable3
,Variable4,Variable5,Variable6,Variable7,Variable8,Variable9
--,VariableDELETE
)
SELECT DISTINCT
	-- [CHG2] Add Columns here
 [Activity Code]--Variable1
,[Activity Description] --Variable2
,CASE WHEN [Activity Category Code] = 'NULL' THEN NULL ELSE [Activity Category Code] END--Variable3
,[Default Tickle Days] --Variable4
,[Maximum Tickle Days] --Variable5
,CASE WHEN IsDisabled IN ('True','1') THEN 1 ELSE 0 END--Variable6
,NULL --Variable7
,NULL --Variable8
,NULL --Variable9

	-- [CHG2] end of adding columns
FROM spec.SPEC_Activity_Codes
WHERE [Activity Code] <> ''

BEGIN TRAN
----------------WHILE LOOP to enumerate through every user------------------------
WHILE (@i <= (SELECT COUNT(*) FROM #WhileList)) 
BEGIN 


SET @Variable1 = (SELECT Variable1 FROM #WhileList WHERE id = @i)
SET @Variable2 = (SELECT variable2 FROM #WhileList WHERE id = @i)
SET @Variable3 = (SELECT Variable3 FROM #WhileList WHERE id = @i)
SET @Variable4 = (SELECT variable4 FROM #WhileList WHERE id = @i)
SET @variable5 = (SELECT variable5 FROM #WhileList WHERE id = @i)
SET @Variable6 = (SELECT Variable6 FROM #WhileList WHERE id = @i)
SET @Variable7 = (SELECT Variable7 FROM #WhileList WHERE id = @i)
SET @Variable8 = (SELECT Variable8 FROM #WhileList WHERE id = @i)
SET @Variable9 = (SELECT Variable9 FROM #WhileList WHERE id = @i)
/*
SET @VariableDELETE = (SELECT VariableDELETE FROM #WhileList WHERE id = @i)
*/

------- [CHG3] GET THE assignments PK for updates.-------
---- change this to pull the PK of the worklist for update statements
SET @PK = (SELECT PKSTAT_Activities FROM STAT_Activities WHERE ActivityCode = @Variable1)
	
----  Do stuff ----
--=========================================================================
PRINT ''
PRINT @variable1 +'|' + @variable2 +'|'+ @variable3 --+'|'+ @variable4 +'|'+ @variable5 +'|'+ @variable6 +'|'+ @variable7 +'|'
--+ @variable8 +'|'+ @variable9 +'|'

--- checking to see if code already exists
	IF @PK IS NOT NULL
	BEGIN
		PRINT 'UPDATING ' + @variable1 +'|' + @variable2 +'|'+ @variable3 --+'|'+ @variable4 +'|'+ @variable5 +'|'+ @variable6 +'|'+ @variable7 +'|'
		--+ @variable8 +'|'+ @variable9 +'|'
		---- [CHG7] change this to be correct sproc to update the GRIDS
		exec dbo.spf_STATActivityCodes_Update 1,'MPDRXTP1',@PK,@variable1,@Variable3,@Variable2,@variable4,@variable5,'',@Variable6
		
	END
	ELSE
	BEGIN
		PRINT 'INSERTING' +@variable1 +'|' + @variable2 +'|'+ @variable3 --+'|'+ @variable4 +'|'+ @variable5 +'|'+ @variable6 +'|'+ @variable7 +'|'
		--+ @variable8 +'|'+ @variable9 +'|'
		---- [CHG8] change this to be correct sproc for inserting grids
		exec dbo.spf_STATActivityCodes_Insert 1,'MPDRXTP1',@variable1,@Variable3,@Variable2,@variable4,@variable5,'',@Variable6
		
	END
--=========================================================================
	--------- end of things to do ---------------------------------------------------------------------------------------------------

	-- This should be last and set the id +1 so it does the next row
	SET @i = (@i + 1)
END 
----------------------------------------
COMMIT



 END;


GO
