DECLARE @STARTDATE varchar(10) = '2018-01-01'
DECLARE @ENDDATE varchar(10) = '2018-12-31'


SELECT 
(SUM(CASE WHEN X.[DisOrderBefore10?]='Y' THEN 1 ELSE 0 END))								AS 'DisBefore10'
,COUNT(X.AccountNumber)																		AS 'TotalDis'
FROM(
SELECT
 BV.AccountNumber
,BV.DischargeDateTime																		AS 'DischargeDateTime'
,DISORD.OrderDate																			AS 'DischargeOrderDateTime'
,CASE WHEN CONVERT(TIME,DISORD.[OrderDate]) < '10:00:00'				THEN 'Y'
      WHEN DATEDIFF(DAY,DISORD.[OrderDate],BV.DischargeDateTime) >= 1	THEN 'Y'
																		ELSE 'N'END			AS 'DisOrderBefore10?'

FROM		[Livedb].[dbo].[BarVisits]														AS BV
LEFT JOIN	[Livedb].[dbo].[AdmVisits]														AS AV			ON BV.VisitID=AV.VisitID

  -- COMFORT CARE ORDER --
LEFT JOIN (SELECT * FROM (
SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,ORD.OrderDateTime	AS 'OrderDate'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime,PROV.ProviderGroupID,PROV.ProviderID					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('DISCH'))					AS X
WHERE X.OrderSeq='1')																		AS DISORD									ON BV.VisitID=DISORD.VisitID

LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('INPTSWG','INPTSWGREC'))	AS SWINGORD									ON AV.VisitID=SWINGORD.VisitID

LEFT JOIN (SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('ALC'))					AS ALCORD									ON AV.VisitID=ALCORD.VisitID




WHERE DischargeDateTime BETWEEN @STARTDATE AND @ENDDATE
AND DISORD.ProviderGroupID='HOSP'
AND AV.Status='DIS IN'
AND ALCORD.OrderedProcedureMnemonic IS NULL
AND SWINGORD.OrderedProcedureMnemonic IS NULL


) AS X
