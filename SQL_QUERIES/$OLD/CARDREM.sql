SELECT DISTINCT
BV.AccountNumber
,BVFD.Balance
,BVFD.CollectionAgency


FROM			[Livedb].[dbo].[BarVisits]						AS BV			
LEFT JOIN		[Livedb].[dbo].[BarCollectionTransactions]		AS BCT		ON BV.VisitID=BCT.VisitID
LEFT JOIN		[Livedb].[dbo].[BarVisitFinancialData]			AS BVFD		ON BV.VisitID=BVFD.VisitID

WHERE Comment LIKE '%CARDREM%'
AND BVFD.PatientBalance > '6'
AND BVFD.CollectionAgency='CARDREM'

ORDER BY CollectionAgency