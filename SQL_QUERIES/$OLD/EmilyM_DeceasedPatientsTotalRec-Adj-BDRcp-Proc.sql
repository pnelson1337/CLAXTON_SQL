SELECT

BV.AccountNumber
,ISNULL(SUM(CASE WHEN BCTI.Type='RCP' THEN BCTI.Amount END),'')												AS 'Total Receipts'
,ISNULL(SUM(CASE WHEN BCTI.Type='RCP' AND BCH.DateTime > BVFD.BadDebtAgeDateTime THEN BCTI.Amount END),'')	AS 'Total Receipts after BadDebt'			
,ISNULL(SUM(CASE WHEN BCTI.Type='ADJ' THEN BCTI.Amount END),'')												AS 'Total Adjustments'
,ISNULL(SUM(CASE WHEN BCTI.Type='ADJ' AND BCH.DateTime > BVFD.BadDebtAgeDateTime THEN BCTI.Amount END),'')	AS 'Total Adjustments after BadDebt'
,ISNULL(SUM(CASE WHEN BCTI.Type='ADJ' AND BCTI.ProcedureID='299510' THEN BCTI.Amount END),'')				AS 'Total 299510'
,MAX(CONVERT(VARCHAR(10),BVFD.BadDebtAgeDateTime,101))														AS 'Bad Debt Date'
,MAX(CONVERT(VARCHAR(10),ISNULL(BV.ServiceDateTime,BV.AdmitDateTime),101))									AS 'Service/Admit Date'

FROM [Livedb].[dbo].[BarVisits]																				AS		BV			
INNER JOIN [Livedb].[dbo].[BarBchTxns]																		AS		BCT			ON BV.BillingID=BCT.BillingID
LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]															AS		BVFD		ON BV.VisitID=BVFD.VisitID
LEFT JOIN	[Livedb].[dbo].[BarBchs]																		AS		BCH			ON BCT.BatchID=BCH.BatchID       AND BCH.Status!='DELETED'
LEFT JOIN [Livedb].[dbo].[BarBchTxnItems]																	AS		BCTI		ON BCT.BatchID=BCTI.BatchID   AND BCT.TxnNumberID=BCTI.TxnNumberID 

WHERE BCH.DateTime BETWEEN '2017-01-01' AND '2017-12-31'
AND BVFD.BadDebtAgeDateTime IS NOT NULL
AND BVFD.CollectionAgency ='DECEASED'

--AND BV.AccountNumber='24621096'
--AND BCT.BillingID='2959265'
GROUP BY BV.AccountNumber
--GROUP BY BCT.BillingID