SELECT

 BCT.BillingID
,BCTI.Amount
,BCTI.Type
,BCTI.BatchID
,BCH.DateTime



FROM [Livedb].[dbo].[BarVisits]				AS		BV			
INNER JOIN [Livedb].[dbo].[BarBchTxns]		AS		BCT			ON BV.BillingID=BCT.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchs]		AS		BCH			ON BCH.BatchID=BCT.BatchID AND BCH.Status!='DELETED'
LEFT JOIN [Livedb].[dbo].[BarBchTxnItems]	AS		BCTI		ON BCT.BatchID=BCTI.BatchID AND BCT.TxnNumberID=BCTI.TxnNumberID


  
WHERE BCT.BillingID='2959265'
AND BCTI.Type IN ('ADJ','RCP')
AND BCH.DateTime > '2017-01-01'

ORDER BY BCTI.Type
