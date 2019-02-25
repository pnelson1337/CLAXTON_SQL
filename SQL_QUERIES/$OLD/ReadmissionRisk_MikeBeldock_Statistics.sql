
DECLARE @StartDate DATETIME, @EndDate DATETIME, @Response VARCHAR, @Location VARCHAR
SET @StartDate ='2018-10-01'
SET @EndDate = '2018-10-31'




;WITH SUMS AS (


SELECT

ISNULL(RESPONSE.Response,'N')																AS 'Response'
,(COUNT(RESPONSE.Response) * 100 / 

(SELECT COUNT(*)			

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
AND (DISDISPO.DispositionID NOT IN ('REHAB','NBOTHER','ICF','HOSPHOME','HOSPCHMC','E','CHMCSWING') OR DISDISPO.DispositionID IS NULL)
AND ALCORD.OrderedProcedureMnemonic IS NULL
AND SWINGORD.OrderedProcedureMnemonic IS NULL
AND CCORD.OrderedProcedureMnemonic IS NULL
AND AV.LocationID IN ('2WEST','2EAST','ICU','2CENTRAL')	


))																							AS ResponseRate


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
AND (DISDISPO.DispositionID NOT IN ('REHAB','NBOTHER','ICF','HOSPHOME','HOSPCHMC','E','CHMCSWING') OR DISDISPO.DispositionID IS NULL)
AND ALCORD.OrderedProcedureMnemonic IS NULL
AND SWINGORD.OrderedProcedureMnemonic IS NULL
AND CCORD.OrderedProcedureMnemonic IS NULL	

AND RESPONSE.Response IN ('H')
AND AV.LocationID IN ('2WEST','2EAST','ICU','2CENTRAL')

GROUP BY RESPONSE.Response

)

SELECT 
Response
,ResponseRate

FROM SUMS

