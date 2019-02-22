DECLARE @STARTDATE VARCHAR(10) = '2017-04-01'
DECLARE @ENDDATE VARCHAR(10) = '2018-12-31'

SELECT


BV.AccountNumber
,BCH.DateTime
,BCTI.Amount




FROM		[Livedb].[dbo].[BarVisits]			AS		BV			
INNER JOIN	[Livedb].[dbo].[BarBchTxns]			AS		BCT			ON BV.BillingID=BCT.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchs]			AS		BCH			ON BCH.BatchID=BCT.BatchID AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]		AS		BCTI		ON BCT.BatchID=BCTI.BatchID AND BCT.TxnNumberID=BCTI.TxnNumberID


WHERE BCH.DateTime BETWEEN @STARTDATE AND @ENDDATE
AND BCTI.Type IN ('RCP')
AND BCT.InsuranceID='WEXFORD'
ORDER BY BCH.DateTime
