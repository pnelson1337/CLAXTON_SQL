Set NOCOUNT ON;
SELECT

CASE WHEN OBSORDDAY.Response = OBSORDNIGHT.Response THEN OBSORDDAY.Response
ELSE OBSORDDAY.Response+'/'+OBSORDNIGHT.Response END																			AS 'OBS LVL'


FROM		[Livedb].[dbo].[AdmVisits]					AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]					AS BV		ON AV.VisitID=BV.VisitID
-- OBSERVATION LEVEL DAY ORDER --
LEFT JOIN (SELECT * FROM(
SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)															AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)										AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime,ORDQ.Response														
FROM			[Livedb].[dbo].[OeOrders]																						AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]																						AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]																						AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]																					AS PROV										ON ORD.ProviderID=PROV.ProviderID
LEFT JOIN		[Livedb].[dbo].[OeOrderQueries]																					AS ORDQ										ON ORD.OrderID=ORDQ.OrderID AND ORDQ.QueryID='OMMHUOBS'
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('OBSLVL')
) AS X WHERE X.OrderSeq='1')																									AS OBSORDDAY								ON AV.VisitID=OBSORDDAY.VisitID

-- OBSERVATION LEVEL DAY ORDER --
LEFT JOIN (SELECT * FROM(
SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)															AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)										AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime,ORDQ.Response														
FROM			[Livedb].[dbo].[OeOrders]																						AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]																						AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]																						AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]																					AS PROV										ON ORD.ProviderID=PROV.ProviderID
LEFT JOIN		[Livedb].[dbo].[OeOrderQueries]																					AS ORDQ										ON ORD.OrderID=ORDQ.OrderID AND ORDQ.QueryID='OMMHUOBS2'
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('OBSLVL')
) AS X WHERE X.OrderSeq='1')																									AS OBSORDNIGHT								ON AV.VisitID=OBSORDNIGHT.VisitID




WHERE BV.InpatientServiceID='MHC'
AND  AV.Status='ADM IN'

ORDER BY [OBS LVL]