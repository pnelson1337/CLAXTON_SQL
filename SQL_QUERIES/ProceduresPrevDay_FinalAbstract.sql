SET NOCOUNT ON
SELECT
 BV.AccountNumber																	AS 'Account Number'
,BV.UnitNumber																		AS 'Medical Record Number'
,ISNULL(AV.Sex,'')																	AS 'Gender'
,ISNULL(CONVERT(VARCHAR(10), BV.BirthDateTime,101),'')								AS 'BirthDate'

 --Start of First_Name--
,SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,
	(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 
	THEN LEN(BV.Name)
	ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)
	-CHARINDEX(',',BV.Name) END))													AS 'FirstName'
--Start of Middle Name-- 
,CASE 
	WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1) = 0 
	THEN ' ' 
	ELSE SUBSTRING(BV.Name,CHARINDEX(' ',BV.Name,
	CHARINDEX(',',BV.Name)+1)+1,1) END												AS 'MiddleName'
--Start of Last Name--
,CASE 
	WHEN BV.Name NOT LIKE '%,%' 
	THEN BV.Name 
	ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END								AS 'LastName'

,BSP.SeqID																			AS 'ProcedureCodeSequence'
,BSP.Code																			AS 'ProcedureCode'
,BSP.Description																	AS 'ProcedureDescription'
,ISNULL(CONVERT(VARCHAR(10), BSP.DateTime,101),'')									AS 'ProcedureServiceDate'

,ISNULL(BSP.ProviderID,'')															AS 'OperatingPhysicianID'
,ISNULL(BSPName.[Name],'')															AS 'OperatingPhysicianName'
-- START CPT CODE SELECTIONS --
,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '1') 
			AND (BV.VisitID = bcpt.VisitID)),'')									AS 'CPT4'
,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '2') 
			AND (BV.VisitID = bcpt.VisitID)),'')									AS 'CPT4_2'
,ISNULL((SELECT bcpt.Code FROM Livedb.dbo.BarCptCodes bcpt WHERE (bcpt.CptSeqID = '3') 
			AND (BV.VisitID = bcpt.VisitID)),'')									AS 'CPT4_3'
-- END CPT CODE SELECTIONS --
-- START DIAGNOSIS SELECTIONS --
,ISNULL((SELECT BD.DiagnosisCodeID FROM [Livedb].[dbo].[BarDiagnoses] BD WHERE (BD.DiagnosisSeqID = '1') 
			AND (BV.BillingID = BD.BillingID)),'')									AS 'Primary Diagnosis'
,ISNULL((SELECT BD.DiagnosisCodeID FROM [Livedb].[dbo].[BarDiagnoses] BD WHERE (BD.DiagnosisSeqID = '2') 
			AND (BV.BillingID = BD.BillingID)),'')									AS 'Secondary Diagnosis'
,ISNULL((SELECT BD.DiagnosisCodeID FROM [Livedb].[dbo].[BarDiagnoses] BD WHERE (BD.DiagnosisSeqID = '3') 
			AND (BV.BillingID = BD.BillingID)),'')									AS 'Tertiary Diagnosis'
-- END DIAGNOSIS SELECTIONS --


,ISNULL(CONVERT(VARCHAR(10), AD.AbstractStatusDateTime,101),'')						AS 'Abstract Date'
,AD.Status																			AS 'Abstract Status'




FROM				[Livedb].[dbo].[AdmVisits]										AS AV								
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisits]										AS BV		 ON AV.VisitID = BV.VisitID
LEFT OUTER JOIN		[Livedb].[dbo].[AbstractData]									AS AD		 ON AV.VisitID = AD.VisitID
INNER JOIN			[Livedb].[dbo].[BarSurgicalProcedures]							AS BSP		 ON BV.BillingID=BSP.BillingID
LEFT OUTER JOIN		[Livedb].[dbo].[DMisProvider]									AS BSPName	 ON BSP.ProviderID=BSPName.ProviderID			
WHERE AV.InpatientOrOutpatient IN ('I','O')
AND AD.AbstractStatusDateTime >= DATEADD(DAY,-1, CAST(GETDATE() AS DATE)) AND AD.AbstractStatusDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME)
AND AD.Status='FINAL'
AND BSP.ProviderID IN ('AGUHE','ANGM','BASPY','BEES','CAJOS','CHOJ','CONG','COME','MASHC','DICR','DIGR','DUND','HARJ','HERT','HILBK-CHMC','JAIM','KADA',
					   'MUSS','OSEKE','RICHE','SANG','SCAJ','SEIM','SHSA','TOMR','YOURY') 

ORDER BY BSP.ProviderID, BV.AccountNumber,BSP.DateTime