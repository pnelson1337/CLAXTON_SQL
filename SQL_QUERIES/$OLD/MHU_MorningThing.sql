SELECT 

 --BV.Name																														AS 'PT NAME'
CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END+','+' '+ SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 THEN LEN(BV.Name) 
	ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END))											AS 'PT NAME'



,BV.UnitNumber																													AS 'MR#'
,((0 + CONVERT(Char(8),GETDATE(),112) - CONVERT(Char(8),BV.BirthDateTime,112)) / 10000)											AS 'AGE'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)																						AS 'DOB'
,BV.Sex																															AS 'GEN'
,LEFT(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),5)																				AS 'ADMIT DATE'
,DATEDIFF(DAY,BV.AdmitDateTime,GETDATE())																						AS 'LOS'																
,CASE WHEN LGLORD.Response='TWO PC' THEN '2PC 60TH DAY' +' '+ LEFT(CONVERT(VARCHAR(10),DATEADD(DAY,60,BV.AdmitDateTime),101),5)
	  WHEN LGLORD.Response='9.39' AND TS6.Response='15DAY' THEN '9.39 15TH DAY' +' '+ LEFT(CONVERT(VARCHAR(10),DATEADD(DAY,15,BV.AdmitDateTime),101),5)
	  WHEN LGLORD.Response='9.39'   THEN '9.39 48*' +' '+ LEFT(CONVERT(VARCHAR(10),DATEADD(DAY,2,BV.AdmitDateTime),101),5)
	ELSE LGLORD.Response END																									AS 'LEGAL STATUS'
,CASE WHEN OBSORDDAY.Response = OBSORDNIGHT.Response THEN OBSORDDAY.Response
ELSE OBSORDDAY.Response+'/'+OBSORDNIGHT.Response END																			AS 'OBS LVL'
,ISNULL(TS1.Response,'')																										AS 'DX CODE'
,ISNULL(TS2.Response,'')																										AS 'CLINIC'
,ISNULL(CONVERT(VARCHAR(10),LASTDIS.DischargeDateTime,1),'/')																	AS' LAST DC'
,ISNULL(TS3.Response,'')																										AS 'LEGAL ISSUES'
,'  '																															AS 'D/C'
,ISNULL(TS5.Response,'')																										AS '>'
,LEFT(BV.PrimaryInsuranceID,7)																									AS 'INS'
,ISNULL(TS4.Response,'')																										AS 'TX. COOR.'
,CASE WHEN TS.Response='GREEN'	THEN '3-GREEN TEAM (RAJASEKARAN)'
	  WHEN TS.Response='BLUE'	THEN '2-BLUE TEAM (VARGAS)'
	  WHEN TS.Response='RED'    THEN '4-RED TEAM (NEW ADMISSIONS)'
	  WHEN TS.Response='SILVER' THEN '1-SILVER TEAM (MODI)'

ELSE 'RED TEAM (NEW ADMISSIONS)'		END																							AS 'TEAMORDER'

,CASE WHEN TS.Response='GREEN'	THEN 'GREEN TEAM (RAJASEKARAN)'
	  WHEN TS.Response='BLUE'	THEN 'BLUE TEAM (VARGAS)'
	  WHEN TS.Response='RED'    THEN 'RED TEAM (NEW ADMISSIONS)'
	  WHEN TS.Response='SILVER' THEN 'SILVER TEAM (MODI)'

ELSE 'RED TEAM (NEW ADMISSIONS)'		END																							AS 'TEAM'

FROM		[Livedb].[dbo].[BarVisits]																							AS BV
INNER JOIN	[Livedb].[dbo].[AdmVisits]																							AS AV										ON BV.VisitID=AV.VisitID
LEFT JOIN	[Livedb].[dbo].[BarDiagnoses]																						AS BD										ON BV.BillingID=BD.BillingID AND BD.DiagnosisSeqID='1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS										ON BV.VisitID=TS.VisitID  AND TS.QueryID='MHUTS'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS1										ON BV.VisitID=TS1.VisitID AND TS1.QueryID='MHUTS1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS2										ON BV.VisitID=TS2.VisitID AND TS2.QueryID='MHUTS2'	
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS3										ON BV.VisitID=TS3.VisitID AND TS3.QueryID='MHUTS3'	
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS4										ON BV.VisitID=TS4.VisitID AND TS4.QueryID='MHUTS4'	
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS5										ON BV.VisitID=TS5.VisitID AND TS5.QueryID='MHUTS5'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]																		AS TS6										ON BV.VisitID=TS6.VisitID AND TS6.QueryID='MHUTS6'
LEFT JOIN	(SELECT*FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY BV.UnitNumber ORDER BY BV.DischargeDateTime DESC )												AS RowNum
,BV.UnitNumber,BV.Name,BV.VisitID,BV.DischargeDateTime,BVP.ProviderID
FROM [Livedb].[dbo].[BarVisits]																									AS BV
LEFT JOIN [Livedb].[dbo].[BarVisitProviders]																					AS BVP										ON BV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
WHERE BV.DischargeDateTime IS NOT NULL AND BV.VisitID IS NOT NULL AND BV.UnitNumber IS NOT NULL AND BV.InpatientServiceID='MHC'
) AS X
WHERE X.RowNum='1')																												AS LASTDIS									ON LASTDIS.UnitNumber=BV.UnitNumber
LEFT JOIN	[Livedb].[dbo].[DMisProvider]																						AS LASTDISPROV								ON LASTDIS.ProviderID=LASTDISPROV.ProviderID

-- OBSERVATION LEVEL DAY ORDER --
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)															AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)										AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime,ORDQ.Response														
FROM			[Livedb].[dbo].[OeOrders]																						AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]																						AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]																						AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]																					AS PROV										ON ORD.ProviderID=PROV.ProviderID
LEFT JOIN		[Livedb].[dbo].[OeOrderQueries]																					AS ORDQ										ON ORD.OrderID=ORDQ.OrderID AND ORDQ.QueryID='OMMHUOBS'
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('OBSLVL'))													AS OBSORDDAY								ON AV.VisitID=OBSORDDAY.VisitID

-- OBSERVATION LEVEL DAY ORDER --
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)															AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)										AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime,ORDQ.Response														
FROM			[Livedb].[dbo].[OeOrders]																						AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]																						AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]																						AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]																					AS PROV										ON ORD.ProviderID=PROV.ProviderID
LEFT JOIN		[Livedb].[dbo].[OeOrderQueries]																					AS ORDQ										ON ORD.OrderID=ORDQ.OrderID AND ORDQ.QueryID='OMMHUOBS2'
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('OBSLVL'))													AS OBSORDNIGHT								ON AV.VisitID=OBSORDNIGHT.VisitID

-- LEGAL STATUS ORDER --
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)															AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)										AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime,ORDQ.Response					
FROM			[Livedb].[dbo].[OeOrders]																						AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]																						AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]																						AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]																					AS PROV										ON ORD.ProviderID=PROV.ProviderID
LEFT JOIN		[Livedb].[dbo].[OeOrderQueries]																					AS ORDQ										ON ORD.OrderID=ORDQ.OrderID AND ORDQ.QueryID='MHULGL.1'
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('LEGAL'))														AS LGLORD									ON AV.VisitID=LGLORD.VisitID		

WHERE AV.LocationID='3RD'
AND AV.Status='ADM IN'
AND( TS.Response IN ('RED','GREEN','BLUE','SILVER') OR TS.Response IS NULL)


ORDER BY TEAMORDER, BV.Name