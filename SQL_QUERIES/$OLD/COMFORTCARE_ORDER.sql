SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID	
,ORD.OrderedProcedureMnemonic
,AV.AccountNumber					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL'
AND ORD.OrderedProcedureMnemonic='COMFORT'
AND BV.DischargeDateTime IS NULL
AND AV.Status='ADM IN'
