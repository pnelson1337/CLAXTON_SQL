SELECT 
BV.AccountNumber
,STUFF((SELECT ',' + BCT.TransactionProcedureID 
    FROM [Livedb].[dbo].[BarChargeTransactions]				AS	BCT
	INNER JOIN	[Livedb].[dbo].[BarBchs]					AS	BCH		ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime
    WHERE BCT.VisitID = BV.VisitID
	AND BCH.Comment='Charge from eCW Interface'
    FOR XML PATH('')),1,1,'') [MeditechProcedureCodes]
FROM [Livedb].[dbo].[BarVisits]								AS BV

WHERE BV.ServiceDateTime BETWEEN '2018-08-22' AND '2018-08-23'
GROUP BY BV.VisitID, BV.AccountNumber
ORDER BY 1