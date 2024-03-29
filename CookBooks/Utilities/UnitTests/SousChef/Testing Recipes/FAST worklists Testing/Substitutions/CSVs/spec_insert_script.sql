IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SPEC')
BEGIN
EXEC('CREATE SCHEMA SPEC')
END
-- all the drops statements
IF OBJECT_ID('SPEC.SPEC_QUIC_Billholds') IS NOT NULL DROP TABLE SPEC.SPEC_QUIC_Billholds
IF OBJECT_ID('SPEC.SPEC_STAT_Workgroup_Specs') IS NOT NULL DROP TABLE SPEC.SPEC_STAT_Workgroup_Specs
IF OBJECT_ID('SPEC.SPEC_STAT_Worklist_Specs') IS NOT NULL DROP TABLE SPEC.SPEC_STAT_Worklist_Specs
-- Now the inserts
CREATE TABLE SPEC.SPEC_QUIC_Billholds (
[Area Priority] VARCHAR(7000) NULL,
[AreaCode] VARCHAR(7000) NULL,
[Def Priority] VARCHAR(7000) NULL,
[DeficiencyCode] VARCHAR(7000) NULL,
[DeficiencyComments] VARCHAR(7000) NULL,
[DeficiencyDescription] VARCHAR(7000) NULL,
[DelinquentDays] VARCHAR(7000) NULL,
[IsDisabled] VARCHAR(7000) NULL,
[IsInfoOnly] VARCHAR(7000) NULL,
[SourceCode] VARCHAR(7000) NULL
)
INSERT INTO SPEC.SPEC_QUIC_Billholds (
[Area Priority],
[AreaCode],
[Def Priority],
[DeficiencyCode],
[DeficiencyComments],
[DeficiencyDescription],
[DelinquentDays],
[IsDisabled],
[IsInfoOnly],
[SourceCode]
)
SELECT '80','BILL','5','nREJC','','nThrive Rejected Claims','5','False','False','nThrive' UNION
SELECT '80','BILL','10','nRASC','','nThrive Reassigned Claims','5','False','False','nThrive' UNION
SELECT '80','BILL','15','nSECC','','nThrive Secondary Claims','5','False','False','nThrive' UNION
SELECT '80','BILL','20','nTERC','','nThrive Tertiary Claims','5','False','False','nThrive' UNION
SELECT '80','BILL','25','nSHAD','','nThrive Shadow Claims','5','False','True','nThrive' UNION
SELECT '10','IV','100','CAUTH','','Cerner Missing CM/Auth/Short Stay Review','5','False','False','Cerner' UNION
SELECT '10','REG','105','CMNPI','','Cerner Missing NPI','5','False','False','Cerner' UNION
SELECT '10','REG','110','CPARV','','Cerner Patient Access Review','5','False','False','Cerner' UNION
SELECT '10','IV','115','nAUTH','','nThrive Missing CM / AUTH / Short Stay Review','5','False','False','nThrive' UNION
SELECT '10','REG','120','nMNPI','','nThrive Missing NPI','5','False','False','nThrive' UNION
SELECT '10','REG','125','nPIRV','','nThrive Patient Information Review','5','False','False','nThrive' UNION
SELECT '10','REG','130','nSIDR','','nThrive Subscriber ID Review','5','False','False','nThrive' UNION
SELECT '10','REG','135','nSTPR','','nThrive Statement Period Review','5','False','False','nThrive' UNION
SELECT '35','CGS','350','CCGRV','','Cerner Charge Review','5','False','False','Cerner' UNION
SELECT '35','CGS','355','nMICH','','nThrive Missing Charges','5','False','False','nThrive' UNION
SELECT '40','CODE','400','CCDRV','','Cerner Pending Coding Review','5','False','False','Cerner' UNION
SELECT '40','CODE','405','nCODR','','nThrive Coding Review','5','False','False','nThrive' UNION
SELECT '40','CODE','410','nHCRV','','nThrive HCPCS Review','5','False','False','nThrive' UNION
SELECT '40','CODE','415','nMEDN','','nThrive Medical Necessity','5','False','False','nThrive' UNION
SELECT '80','BILL','700','CDUPC','','Cerner Duplicate, Overlap, or Combined Claims','5','False','False','Cerner' UNION
SELECT '80','BILL','705','CMIOC','','Cerner Missing Information on Claim','5','False','False','Cerner' UNION
SELECT '80','BILL','710','CCRED','','Cerner Credit Review','5','False','False','Cerner' UNION
SELECT '80','BILL','715','CHMS','','Cerner HMS Hold','5','False','False','Cerner' UNION
SELECT '80','BILL','720','CNAUD','','Cerner Nurse Auditor Review','5','False','False','Cerner' UNION
SELECT '80','BILL','725','CPFSD','','Cerner PFS Denial Review Hold ','5','False','False','Cerner' UNION
SELECT '80','BILL','730','CPPFS','','Cerner Patient Financial Services Review','5','False','False','Cerner' UNION
SELECT '80','BILL','735','CSUPR','','Cerner Supervisor Review','5','False','False','Cerner' UNION
SELECT '80','BILL','740','CPFSO','','Cerner PFS Hold Other','5','False','False','Cerner' UNION
SELECT '80','BILL','745','CPFIN','','Cerner PFS Info Only','5','False','True','Cerner' UNION
SELECT '80','BILL','750','nMCRO','','nThrive Missing Condition Code, Rev Code, Occ Code','5','False','False','nThrive' UNION
SELECT '80','BILL','755','nDUPC','','nThrive Duplicate, Overlap, or Combined Claims','5','False','False','nThrive' UNION
SELECT '80','BILL','760','nMIOC','','nThrive Missing Information on Claim','5','False','False','nThrive' UNION
SELECT '80','BILL','765','nINSR','','nThrive Insurance Plan Information Review','5','False','False','nThrive' UNION
SELECT '80','BILL','770','nBINV','','nThrive Invalid Bill Type','5','False','False','nThrive' UNION
SELECT '80','BILL','775','nHOSP','','nThrive Hospice Hold','5','False','False','nThrive' UNION
SELECT '80','BILL','780','nBEDT','','nThrive Blank Edit Population','5','False','False','nThrive' UNION
SELECT '90','VEND','900','CMCPD','','Cerner Medi-Cal Pending','5','False','False','Cerner' UNION
SELECT '90','VEND','905','CVEND','','Cerner Vendor Hold','5','False','False','Cerner' UNION
SELECT '90','VEND','910','nVEND','','nThrive Vendor Hold','5','False','False','nThrive' UNION
SELECT '110','OTHR','1100','CSNFR','','Cerner SNF Revew','5','False','False','Cerner' UNION
SELECT '110','OTHR','1105','COTHR','','Cerner Other Hold','5','False','False','Cerner' UNION
SELECT '110','OTHR','1110','nDPRV','','nThrive Department / Provider Review','5','False','False','nThrive' UNION
SELECT '110','OTHR','1115','nSNFR','','nThrive SNF Review','5','False','False','nThrive' UNION
SELECT '110','OTHR','1120','nOTHR','','nThrive Other Hold','5','False','False','nThrive' UNION
SELECT '','','','','','','','','',''
CREATE TABLE SPEC.SPEC_STAT_Workgroup_Specs (
[AssignmentGroup] VARCHAR(7000) NULL,
[CaseNumber] VARCHAR(7000) NULL,
[Change] VARCHAR(7000) NULL,
[Criteria Variable] VARCHAR(7000) NULL,
[Operator] VARCHAR(7000) NULL,
[Priority] VARCHAR(7000) NULL,
[Reporting Area Code] VARCHAR(7000) NULL,
[Value] VARCHAR(MAX) NULL,
[Workgroup Code] VARCHAR(7000) NULL,
[Workgroup Description] VARCHAR(7000) NULL
)
INSERT INTO SPEC.SPEC_STAT_Workgroup_Specs (
[AssignmentGroup],
[CaseNumber],
[Change],
[Criteria Variable],
[Operator],
[Priority],
[Reporting Area Code],
[Value],
[Workgroup Code],
[Workgroup Description]
)
SELECT '1','','','ClientPatientTypeCode','=','1','POTH','SNF-CERNER','O1','Other' UNION
SELECT '1','','','AccountBalance','<>','1','POTH','0','O1','Other' UNION
SELECT '2','','','ClientPatientTypeCode','=','1','POTH','C-CERNER','O1','Other' UNION
SELECT '2','','','AccountBalance','<>','1','POTH','0','O1','Other' UNION
SELECT '3','','','Facility','=','1','POTH','CSU','O1','Other' UNION
SELECT '3','','','AccountBalance','<>','1','POTH','0','O1','Other' UNION
SELECT '1','','','AccountBalance','<=','5','POTH','-0.01','10','Credits' UNION
SELECT '1','','','AccountBalance','<>','2','VEND','0','20','Vendor' UNION
SELECT '1','','','VendorFlag','IN','2','VEND','AMCOL , Carep , CMRE  , CSI P , IC SY , JL Pr , Legal , MediR , MVA C , MVA P , Progr , RSour , SAC C , Vital','20','Vendor' UNION
SELECT '1','','','isWithVendor','=','2','VEND','1','20','Vendor' UNION
SELECT '2','','','AccountBalance','>=','2','VEND','0.01','20','Vendor' UNION
SELECT '2','','','MajorFinancialClassCode','=','2','VEND','VEND','20','Vendor' UNION
SELECT '1','','','AccountBalance','>=','3','SELF','0.01','30','Self Pay' UNION
SELECT '1','','','DischargeAge','>=','3','SELF','0','30','Self Pay' UNION
SELECT '1','','','MajorFinancialClassCode','=','3','SELF','SELF','30','Self Pay' UNION
SELECT '1','','','MinorFinancialClassCode','IN','4','COMM','CAP, COMM, EHMO, MCAP','40','COMM POD B' UNION
SELECT '1','','','IsSubmitted','=','4','COMM','1','40','COMM POD B' UNION
SELECT '1','','','AccountBalance','>=','4','COMM','0.01','40','COMM POD B' UNION
SELECT '1','','','CarrierCode','NOT IN','4','COMM','89684, 4644, 57703, 72664, 31803, 75704, 22003, 44950','40','COMM POD B' UNION
SELECT '2','','','IsSubmitted','=','4','COMM','1','40','COMM POD B' UNION
SELECT '2','','','AccountBalance','>=','4','COMM','0.01','40','COMM POD B' UNION
SELECT '2','','','CarrierCode','IN','4','COMM','70691, 4620, 72699','40','COMM POD B' UNION
SELECT '1','','','MinorFinancialClassCode','IN','5','COMM','COCA, MC, PPO','45','COMM POD A' UNION
SELECT '1','','','IsSubmitted','=','5','COMM','1','45','COMM POD A' UNION
SELECT '1','','','AccountBalance','>=','5','COMM','0.01','45','COMM POD A' UNION
SELECT '1','','','AccountBalance','>=','6','GOVT','0.01','50','Medicare' UNION
SELECT '1','','','MajorFinancialClassCode','IN','6','GOVT','CARE, MIL','50','Medicare' UNION
SELECT '1','','','IsSubmitted','=','6','GOVT','1','50','Medicare' UNION
SELECT '1','','','CarrierCode','NOT IN','6','GOVT','72699, 5891, 44951, 72699','50','Medicare' UNION
SELECT '2','','','AccountBalance','>=','6','GOVT','0.01','50','Medicare' UNION
SELECT '2','','','CarrierCode','IN','6','GOVT','89684, 4644, 31803, 70694, 4632, 31804, 31805','50','Medicare' UNION
SELECT '2','','','IsSubmitted','=','6','GOVT','1','50','Medicare' UNION
SELECT '1','','','AccountBalance','>=','7','GOVT','0.01','60','Medi-Cal' UNION
SELECT '1','','','MajorFinancialClassCode','IN','7','GOVT','MCAL, LHMO','60','Medi-Cal' UNION
SELECT '1','','','IsSubmitted','=','7','GOVT','1','60','Medi-Cal' UNION
SELECT '1','','','CarrierCode','NOT IN','7','GOVT','70691,  70694, 4632, 31804, 31805','60','Medi-Cal' UNION
SELECT '2','','','CarrierCode','IN','7','GOVT','57703, 72699, 5891, 44950, 44951, 72664, 75704, 22003, 4620','60','Medi-Cal' UNION
SELECT '2','','','AccountBalance','>=','7','GOVT','0.01','60','Medi-Cal' UNION
SELECT '2','','','IsSubmitted','=','7','GOVT','1','60','Medi-Cal' UNION
SELECT '','','','','','8','POTH','','99','Transfer' UNION
SELECT '1','123456','UPDATE','AccountBalance','>=','9','SA','0.01','80','Specialty - TEST Sous Chef' UNION
SELECT '1','123456','UPDATE','IsSubmitted','=','9','SA','1','80','Specialty - TEST Sous Chef' UNION
SELECT '1','123456','INSERT','AccountBalance','<>','10','SA','0','98','TEST for Sous Chef' UNION
SELECT '1','123456','INSERT','ClientPatientTypeCode','=','10','SA','SNF-CERNER','98','TEST for Sous Chef' UNION
SELECT '','','','','','','','','',''
CREATE TABLE SPEC.SPEC_STAT_Worklist_Specs (
[AccessGroupCode] VARCHAR(7000) NULL,
[Assignment Criteria Operator] VARCHAR(7000) NULL,
[Assignment Criteria Variable] VARCHAR(7000) NULL,
[CaseNumber] VARCHAR(7000) NULL,
[Change] VARCHAR(7000) NULL,
[Count On TRAC Report] VARCHAR(7000) NULL,
[Group] VARCHAR(7000) NULL,
[Initial Followup] VARCHAR(7000) NULL,
[IsDisabled] VARCHAR(7000) NULL,
[IsMRGroup] VARCHAR(7000) NULL,
[Priority] VARCHAR(7000) NULL,
[Rep Code] VARCHAR(7000) NULL,
[Transfer Worklist] VARCHAR(7000) NULL,
[Value] VARCHAR(MAX) NULL,
[Workgroup Code] VARCHAR(7000) NULL,
[Worklist] VARCHAR(7000) NULL,
[Worklist Code] VARCHAR(7000) NULL,
[Worklist Description] VARCHAR(7000) NULL
)
INSERT INTO SPEC.SPEC_STAT_Worklist_Specs (
[AccessGroupCode],
[Assignment Criteria Operator],
[Assignment Criteria Variable],
[CaseNumber],
[Change],
[Count On TRAC Report],
[Group],
[Initial Followup],
[IsDisabled],
[IsMRGroup],
[Priority],
[Rep Code],
[Transfer Worklist],
[Value],
[Workgroup Code],
[Worklist],
[Worklist Code],
[Worklist Description]
)
SELECT '','','','','','','','','','','','','','DO NOT remove, alter, re-order or unhide this string. This string is needed to ensure no data in this column gets truncated. In ace OLDB 12 excel conversion it will determine a columns datatype by checking the top 8 rows of any table or spreadsheet.  to ensure that this column always contains data longer than 255 characters this string is hidden and added to the spreadsheet as the first column.  It will not alter the specs in any way, just ensure that the datatype selected for this column is of MEMO type which can hold 64000 characters, instead of TEXT type which can only hold 255 characters.  DO NOT remove, alter, re-order or unhide this string.','','','','' UNION
SELECT 'ALL','=','Facility','','','False','1','1','False','False','3','','Always','CSU','','O112','12','CSU' UNION
SELECT 'ALL','=','ClientPatientTypeCode','','','False','1','1','False','False','2','','Always','C-CERNER','','O111','11','Client' UNION
SELECT 'ALL','=','ClientPatientTypeCode','','','False','1','1','False','False','1','','Always','SNF-CERNER','','O110','10','Skilled Nursing' UNION
SELECT 'ALL','','','','','False','1','','True','False','46','','Always','','99','9999','99','Zero Balance Transfer Worklist' UNION
SELECT 'ALL','','','','','True','1','','False','False','45','PEMG','Never','','80','8099','99','Clinical Denial' UNION
SELECT 'ALL','','','','','True','1','','False','False','44','KAMI','Never','','80','8098','98','HMS' UNION
SELECT 'ALL','','','','','True','1','','False','False','43','MAKH','Never','','80','8097','97','Max Khalolaeiad' UNION
SELECT 'ALL','','','','','True','1','','False','False','42','JAIN','Never','','80','8096','96','Jabeen Inambdar' UNION
SELECT 'ALL','','','','','True','1','','False','False','41','TiNg','Never','','80','8095','95','Tim Nguyen' UNION
SELECT 'ALL','','','','','True','1','','False','False','40','ChAl','Never','','80','8094','94','Chris Alnutt' UNION
SELECT 'ALL','','','',' ','True','1','','False','False','39','YLHU','Never','','80','8093','93','YLonn Hudson-Walker' UNION
SELECT 'ALL','','','','','True','1','','False','False','38','CHCI','Never','','80','8092','92','Charlene Ciego' UNION
SELECT 'ALL','','','','','True','1','','False','False','37','VAME','Never','','80','8091','91','Valerie Mercado' UNION
SELECT 'ALL','','','','','True','1','','False','False','36','LIEN','Never','','80','8090','90','Lisa Ennis' UNION
SELECT 'ALL','>=','PatientLastName','123456','INSERT','True','1','30','False','False','30','REBU','Always','AutoAlphaSplit','60','6045','45','Medi-Cal Reina' UNION
SELECT 'ALL','>=','PatientLastName','123456','INSERT','True','1','30','False','False','29','HARO','Always','AutoAlphaSplit','60','6040','40','Medi-Cal Hazel' UNION
SELECT 'ALL','<=','PatientLastName','123456','INSERT','True','1','30','False','False','29','HARO','Always','AutoAlphaSplit','60','6040','40','Medi-Cal Hazel' UNION
SELECT 'ALL','>=','PatientLastName','123456','INSERT','True','1','30','False','False','28','LEAL','Always','AutoAlphaSplit','60','6035','35','Medi-Cal Leticia' UNION
SELECT 'ALL','<=','PatientLastName','123456','INSERT','True','1','30','False','False','28','LEAL','Always','AutoAlphaSplit','60','6035','35','Medi-Cal Leticia' UNION
SELECT 'ALL','>=','PatientLastName','123456','INSERT','True','1','30','False','False','27','ERSA','Always','AutoAlphaSplit','60','6030','30','Medi-Cal Eric' UNION
SELECT 'ALL','<=','PatientLastName','123456','INSERT','True','1','30','False','False','27','ERSA','Always','AutoAlphaSplit','60','6030','30','Medi-Cal Eric' UNION
SELECT 'ALL','>=','PatientLastName','123456','INSERT','True','1','30','False','False','23','MAAG','Always','AutoAlphaSplit','60','6025','25','Medi-Cal Mayra' UNION
SELECT 'ALL','<=','PatientLastName','123456','INSERT','True','1','30','False','False','23','MAAG','Always','AutoAlphaSplit','60','6025','25','Medi-Cal Mayra' UNION
SELECT 'ALL','<=','PatientLastName','123456','INSERT','True','1','30','False','False','22','PAWE','Always','AutoAlphaSplit','60','6020','20','Medi-Cal Patty' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','30','False','False','35','NIQU','Always','2601 , 2604 , 2602 , 2607 , 2606','50','5085','85','Medicare A - D' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','35','NIQU','Always','Dezz','50','5085','85','Medicare A - D' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','30','False','False','34','CHMC','Always','2601 , 2604 , 2602 , 2607 , 2606','50','5080','80','Medicare D - J' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','34','CHMC','Always','Jzzz','50','5080','80','Medicare D - J' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','34','CHMC','Always','Dfzz','50','5080','80','Medicare D - J' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','30','False','False','33','DEOD','Always','2601 , 2604 , 2602 , 2607 , 2606 , 72683 , 72684 , 8712 , 8361','50','5075','75','Medicare, Tricare P - S' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','33','DEOD','Always','Szzz','50','5075','75','Medicare, Tricare P - S' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','33','DEOD','Always','P','50','5075','75','Medicare, Tricare P - S' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','30','False','False','32','ELGU','Always','72683 , 72684 , 8712 , 8361, 8601,89684,8710, 44726, 8601, 8600,4644,  31803, 70694, 4632, 31804, 31805','50','5070','70','Tricare, VA, Healthnet Medi-Cal OP, Military' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','30','False','False','31','CHGA','Always','2601 , 2604 , 2602 , 2607 , 2606 , 72683 , 72684 , 8712 , 8361','50','5065','65','Medicare, Tricare T - Z' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','31','CHGA','Always','T','50','5065','65','Medicare, Tricare T - Z' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','30','False','False','38','JUOD','Always','2601 , 2604 , 2602 , 2607 , 2606 , 72683 , 72684 , 8712 , 8361','50','5060','60','Medicare, Tricare K - O' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','38','JUOD','Always','K','50','5060','60','Medicare, Tricare K - O' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','38','JUOD','Always','Ozzz','50','5060','60','Medicare, Tricare K - O' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','12','MARA','Always','SMIS','45','4531','31','POD A Maria SM - Z' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','11','BEJO','Always','PAE','45','4529','29','POD A Betty PA - SM' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','11','BEJO','Always','SMIRZ','45','4529','29','POD A Betty PA - SM' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','10','SHDE','Always','LEN','45','4527','27','POD A Sheila LE - PA' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','10','SHDE','Always','PADZ','45','4527','27','POD A Sheila LE - PA' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','9','RHSE','Always','GONZ','45','4525','25','POD A Rhonee GO - LE' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','9','RHSE','Always','LEMZ','45','4525','25','POD A Rhonee GO - LE' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','8','MEBA','Always','CHP','45','4523','23','POD A Megan CH - GO' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','8','MEBA','Always','GONYZ','45','4523','23','POD A Megan CH - GO' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','7','DIGA','Always','CHOZ','45','4521','21','POD A Diana A - CH' UNION
SELECT 'ALL','IN','CarrierCode','','','True','1','35','False','False','6','DIGA','Always','38775, 6730','40','4045','45','Automobile Worklist' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','17','GEMA','Always','SANE','40','4041','41','POD B Gennine SA - Z' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','16','DISA','Always','MELM','40','4039','39','POD B Diana ME - SA' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','16','DISA','Always','SANDZ','40','4039','39','POD B Diana ME - SA' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','15','LAJO','Always','HILM','40','4037','37','POD B Lashon HI - ME' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','15','LAJO','Always','MELLZ','40','4037','37','POD B Lashon HI - ME' UNION
SELECT 'ALL','>=','PatientLastName','','','True','1','30','False','False','14','JAPA','Always','DAD','40','4035','35','POD B Janine DA - HI' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','14','JAPA','Always','HILLZ','40','4035','35','POD B Janine DA - HI' UNION
SELECT 'ALL','<=','PatientLastName','','','True','1','30','False','False','13','MOIB','Always','DACZ','40','4033','33','POD B Moices A-DA' UNION
SELECT 'ALL','=','MajorFinancialClassCode','','','False','1','1','False','True','5','','Always','SELF','30','3014','14','Self Pay' UNION
SELECT 'ALL','IN','CarrierCode','','','False','1','1','False','False','4','','Always','44799 , 18549 , 89693 , 89688 , 71601 , 89692 , 44581 , 18551 , 89691 , 89695 , 45331 , 89690 , 44221 , 89689 , 44451 , 44361','20','2022','22','Workers Comp' UNION
SELECT 'ALL','<>','AccountBalance','','','False','1','1','False','False','7','','Always','0','20','2013','13','Vendor' UNION
SELECT 'ALL','<=','AccountBalance','','','True','1','1','False','False','35','BAMA','Always','-0.01','10','1031','31','Self Pay Credits' UNION
SELECT 'ALL','>=','DischargeAge','','','True','1','1','False','False','35','BAMA','Always','0','10','1031','31','Self Pay Credits' UNION
SELECT 'ALL','IN','MajorFinancialClassCode','','','True','1','1','False','False','15','ANTA','Always','CHMO, COMM','10','1030','30','Commercial Credits' UNION
SELECT 'ALL','IN','MajorFinancialClassCode','','','True','1','1','False','False','14','KAMI','Always','CARE, MIL,MCAL, LHMO','10','1029','29','Government Credits' UNION
SELECT '','','','','','','','','','','','','','','','','',''
