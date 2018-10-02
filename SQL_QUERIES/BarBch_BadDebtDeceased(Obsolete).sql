
--;WITH SUMS AS (

SELECT


 MAX(BV.AccountNumber)																AS 'Account Number'
 ,MAX(BV.VisitID)
 ,MAX(BV.BillingID)					
 ,ISNULL(SUM(RCP.Amount),'')														AS 'Receipts Total'
 ,ISNULL(SUM(BDRCP.Amount),'')														AS 'BadDebt Receipts'
 ,ISNULL(SUM(ADJ.Amount),'')														AS 'Adj Total'
 ,ISNULL(SUM(ADJPROC.Amount),'')													AS '299510 Adj Total'

 ,MAX(BVFD.CollectionAgency)														AS 'Collection Agency'
,MAX(CONVERT(VARCHAR(10),BVFD.BadDebtAgeDateTime,101))								AS 'BadDebt Date'
,MAX(CONVERT(VARCHAR(10),ISNULL(BV.ServiceDateTime,BV.AdmitDateTime),101))			AS 'Service/Admit Date'


FROM		[Livedb].[dbo].[BarVisits]												AS BV
LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]									AS BVFD				ON BV.VisitID=BVFD.VisitID
INNER JOIN	[Livedb].[dbo].[BarBchTxns]												AS BCHTXN			ON BV.BillingID=BCHTXN.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchTxnItems]											AS BCHTXNITEM		ON BCHTXN.TxnNumberID=BCHTXNITEM.TxnNumberID AND BCHTXN.BatchID=BCHTXNITEM.BatchID  
INNER JOIN	[Livedb].[dbo].[BarBchs]												AS BCH				ON BCH.BatchID=BCHTXN.BatchID AND BCH.Status!='DELETED'

LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]											AS RCP				ON BCHTXN.TxnNumberID=RCP.TxnNumberID AND BCHTXN.BatchID=RCP.BatchID AND RCP.Type='RCP' AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]											AS BDRCP			ON BCHTXN.TxnNumberID=BDRCP.TxnNumberID AND BCHTXN.BatchID=BDRCP.BatchID AND BDRCP.Type='RCP' AND BCH.DateTime > BVFD.BadDebtAgeDateTime   AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]											AS ADJPROC			ON BCHTXN.TxnNumberID=ADJPROC.TxnNumberID AND BCHTXN.BatchID=ADJPROC.BatchID AND ADJPROC.ProcedureID='299510' AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]											AS ADJ				ON BCHTXN.TxnNumberID=ADJ.TxnNumberID AND BCHTXN.BatchID=ADJ.BatchID AND ADJ.Type='ADJ' AND BCH.Status!='DELETED'


WHERE BCH.DateTime BETWEEN '2017-01-01' AND '2017-12-31'
--AND BCHTXNITEM.Type='RCP'
AND BVFD.BadDebtAgeDateTime IS NOT NULL
--AND BCH.DateTime > BVFD.BadDebtAgeDateTime	
AND BVFD.CollectionAgency ='DECEASED'
AND BV.AccountNumber='24348518'



GROUP BY BV.AccountNumber--,BVFD.BadDebtAgeDateTime, BCH.DateTime,BV.ServiceDateTime,BV.AdmitDateTime
--ORDER BY BCH.DateTime



/*

)
SELECT
SUM([Receipt after Bad Debt]) --OVER (PARTITION BY [Account Number])
FROM SUMS
*/


