SELECT 
 BV.Name
--,OEO.[VisitID]
,BV.AccountNumber
,CONVERT(VARCHAR(10),OEO.ServiceDateTime,101)		AS 'Service Date' 
,OEO.OrderedProcedure
,OEO.OrderedProcedureMnemonic
,OEO.OrderedProcedureName

FROM [Livedb].[dbo].[OeOrders]						AS OEO
LEFT JOIN [Livedb].[dbo].[BarVisits]				AS BV			ON OEO.VisitID=BV.VisitID

WHERE Category IN ('OTC','PTC','STC')
AND CAST(OEO.RowUpdateDateTime AS DATE)  = DATEADD(DAY,-1,CONVERT(DATE, GETDATE()))

ORDER BY BV.AccountNumber,OEO.OrderedProcedure
