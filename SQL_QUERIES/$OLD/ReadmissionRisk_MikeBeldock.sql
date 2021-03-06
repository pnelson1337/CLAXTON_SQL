DECLARE @StartDate DATETIME, 
		@EndDate DATETIME 

SET @StartDate ='2018-10-01'
SET @EndDate = '2018-12-31'

SELECT * FROM (

SELECT
 BV.AccountNumber
,BV.Name
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),
		CONVERT(VARCHAR(10),BV.ServiceDateTime,101))										AS 'Admit/Service Date'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')									AS 'Discharge Date'
--,ISNULL(RESPONSE.Response,'')																AS 'Response'
,CASE WHEN RESPONSE.Response IS NULL THEN 'N'
		ELSE RESPONSE.Response END															AS 'Response'
,AV.LocationID																				AS 'Location'
,AV.Status
,DISPO.DispositionID
,BV.DischargeDispositionID
,DISDISPO.Name																				AS 'Dispo Name'
,DATENAME(DW,BV.AdmitDateTime)																AS 'DateName'
,CASE WHEN DATENAME(DW,BV.AdmitDateTime) = 'Friday' AND DATEPART(HH,BV.AdmitDateTime) >= 11 AND DATEDIFF(HOUR,BV.AdmitDateTime,BV.DischargeDateTime) <= 71	 THEN 'Yes' END							AS 'Friday Admit After Hours'
--,OBSORD.Status		AS 'OBS'
--,AV.InpatientServiceID		AS 'Service'

FROM			[Livedb].[dbo].[AdmVisits]													AS AV
INNER JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON AV.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisitQueries]											AS INST										ON AV.VisitID=INST.VisitID AND INST.QueryID = 'INST'
LEFT JOIN		[Livedb].[dbo].[AdmPatDischargePlanData]									AS DISPO									ON BV.VisitID=DISPO.VisitID
LEFT JOIN		[Livedb].[dbo].[DMisDischargeDisposition]									AS DISDISPO									ON DISPO.DispositionID=DISDISPO.DispositionID AND DISDISPO.Active='Y'
LEFT JOIN		(SELECT NQR.VisitID,Response,MAX(NQR.DateTime)								AS 'MAX DATE'
					FROM [Livedb].[dbo].[NurQueryResults]									AS NQR
					WHERE NQR.QueryID='CMIDT037'			
					GROUP BY NQR.VisitID,NQR.Response)										AS RESPONSE									ON BV.VisitID=RESPONSE.VisitID
-----------------------------------------------------------------------------START ORDER SELECTIONS-------------------------------------------------------------------------------
-- LAST ORDER --
LEFT JOIN		(SELECT * FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID						
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL'
)																							AS X
WHERE X.OrderSeq='1')																		AS ORD										ON AV.VisitID=ORD.VisitID

-- SWING ORDER --				
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('INPTSWG','INPTSWGREC'))	AS SWINGORD									ON AV.VisitID=SWINGORD.VisitID

-- OBS ORDER --
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('OBSERVICU','OBSERVMS','OBSERVOB'))									AS OBSORD									ON AV.VisitID=OBSORD.VisitID

-- ALC ORDER --
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('ALC'))					AS ALCORD									ON AV.VisitID=ALCORD.VisitID

-- COMFORT CARE ORDER --
LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('COMFORT'))				AS CCORD									ON AV.VisitID=CCORD.VisitID

-------------------------------------------------------------------------------END ORDER SELECTIONS-------------------------------------------------------------------------------


WHERE AV.Status IN ('ADM IN', 'DIS IN')
AND BV.AdmitDateTime BETWEEN @StartDate AND @EndDate
AND INST.Response IN ('CLIFTON','CPH','HAMMOND','HEUV','HIGHLAND','KINNEY','MATCC','MMH','NONE','RHNH','SLPC','STJOEHM','STREG','SUNYCAN','UHACT','UHADULT','UHCNTN','UHNH','WADD','WALSH','WPAH')
AND (DISDISPO.DispositionID NOT IN ('REHAB','NBOTHER','ICF','HOSPHOME','HOSPCHMC','E','CHMCSWING','PSYCHMC','HPSY','AMA','PSY') OR DISDISPO.DispositionID IS NULL)
AND BV.DischargeDispositionID NOT IN ('E','AMA','CHMC')
AND ALCORD.OrderedProcedureMnemonic IS NULL
AND SWINGORD.OrderedProcedureMnemonic IS NULL
AND CCORD.OrderedProcedureMnemonic IS NULL	



) AS X


--WHERE X.Response IN (@Response)
--AND X.Location IN (@Location)


WHERE X.Response IN ('N','L','M','H')
AND X.Location IN ('2WEST','2EAST','ICU','2CENTRAL')
AND X.[Friday Admit After Hours] IS NULL
--AND X.AccountNumber='28197747'

ORDER BY [Dispo Name]




