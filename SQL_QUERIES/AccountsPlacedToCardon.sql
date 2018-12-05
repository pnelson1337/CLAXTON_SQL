SELECT

YEAR(BCH.DateTime)										AS 'YEAR'	
,MONTH(BCH.DateTime)									AS 'MONTH'
,COUNT(BCT.BillingID)									AS 'COUNT'






FROM		[Livedb].[dbo].[BarVisits]		AS	BV	
INNER JOIN	[Livedb].[dbo].[BarBchTxns]		AS	BCT		ON BV.BillingID=BCT.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchs]		AS	BCH		ON BCH.BatchID=BCT.BatchID AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]	AS BVFD	ON BV.BillingID=BVFD.BillingID
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]	AS	BCTI	ON BCT.BatchID=BCTI.BatchID AND BCT.TxnNumberID=BCTI.TxnNumberID
LEFT JOIN	[Livedb].[dbo].[DBarProcedures]	AS	DBPROC	ON BCTI.ProcedureID=DBPROC.ProcedureID AND DBPROC.Active='Y'


WHERE CAST(BCH.DateTime AS DATE) BETWEEN '2017-01-01' AND '2018-10-31'
AND BCTI.Type='XFR'
AND BCTI.Comment = 'From FB to Agency CARDON'



GROUP BY MONTH(BCH.DateTime), YEAR(BCH.DateTime)
ORDER BY  YEAR(BCH.DateTime),MONTH(BCH.DateTime)