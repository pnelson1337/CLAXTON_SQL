SELECT

 BCT.BillingID
,BCTI.Amount
,BCTI.Type
,BCTI.BatchID
,BCH.DateTime
,BCH.Number



FROM		[Livedb].[dbo].[BarVisits]		AS		BV			
INNER JOIN	[Livedb].[dbo].[BarBchTxns]		AS		BCT			ON BV.BillingID=BCT.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchs]		AS		BCH			ON BCH.BatchID=BCT.BatchID --AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]	AS		BCTI		ON BCT.BatchID=BCTI.BatchID AND BCT.TxnNumberID=BCTI.TxnNumberID


  
--WHERE BCT.BillingID='2959265'
--WHERE BCT.BillingID='2994102'
--WHERE BV.ServiceDateTime BETWEEN '2017-01-01' AND '2017-12-31'


WHERE BV.AccountNumber='27822717'
AND BCTI.Type IN ('CHG')

ORDER BY BCTI.Type
