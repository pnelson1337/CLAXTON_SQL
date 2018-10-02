
--;WITH SUMS AS (

SELECT

--BV.VisitID
 BV.AccountNumber
,BCHTXN.BillingID																
,SUM(BCHTXNITEM.Amount)															AS 'Receipts Total'
,SUM(RECAFTERBD.Amount)															AS 'Receipts After BadDebt'
,SUM(BCHTXNADJ.Amount)															AS 'Adjustment Total'
,SUM(BCHTXNITEMADJ.Amount)														AS 'Proc 299510 Total'


/*
,CASE WHEN BCH.DateTime > BVFD.BadDebtAgeDateTime								 
	THEN SUM(BCHTXNITEM.Amount) ELSE '' END										AS 'Receipt after Bad Debt'
,CONVERT(VARCHAR(10),BCH.DateTime,101)											AS 'Batch Date'
,CONVERT(VARCHAR(10),BVFD.BadDebtAgeDateTime,101)								AS 'BadDebt Date'
,CONVERT(VARCHAR(10),ISNULL(BV.ServiceDateTime,BV.AdmitDateTime),101)			AS 'Service/Admit Date'
,BCHTXNITEM.Type
,BCHTXNITEM.ProcedureID
*/


FROM		[Livedb].[dbo].[BarVisits]											AS BV
LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]								AS BVFD				ON BV.VisitID=BVFD.VisitID
INNER JOIN	[Livedb].[dbo].[BarBchTxns]											AS BCHTXN			ON BV.BillingID=BCHTXN.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchs]											AS BCH				ON BCH.BatchID=BCHTXN.BatchID AND BCH.Status!='DELETED'

LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]										AS BCHTXNITEM		ON BCHTXN.TxnNumberID=BCHTXNITEM.TxnNumberID AND BCHTXN.BatchID=BCHTXNITEM.BatchID AND BCHTXNITEM.Type='RCP' 
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]										AS RECAFTERBD		ON BCHTXN.TxnNumberID=RECAFTERBD.TxnNumberID AND BCHTXN.BatchID=RECAFTERBD.BatchID AND RECAFTERBD.Type='RCP' AND BCH.DateTime > BVFD.BadDebtAgeDateTime   
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]										AS BCHTXNITEMADJ	ON BCHTXN.TxnNumberID=BCHTXNITEMADJ.TxnNumberID AND BCHTXN.BatchID=BCHTXNITEMADJ.BatchID AND BCHTXNITEMADJ.ProcedureID='299510'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]										AS BCHTXNADJ		ON BCHTXN.TxnNumberID=BCHTXNADJ.TxnNumberID AND BCHTXN.BatchID=BCHTXNADJ.BatchID AND BCHTXNADJ.Type='ADJ' 


WHERE BCH.DateTime BETWEEN '2017-01-01' AND '2018-12-31'
--AND BCHTXNITEM.Type='RCP'
AND BVFD.BadDebtAgeDateTime IS NOT NULL
--AND BCH.DateTime > BVFD.BadDebtAgeDateTime	
--AND BVFD.CollectionAgency !='DECEASED'
--AND BV.AccountNumber='26230193'



GROUP BY BV.AccountNumber, BCHTXN.BillingID


/*
)
SELECT
SUM([Receipts After BadDebt])
,SUM([Receipts Total]) --OVER (PARTITION BY [Account Number])
,SUM([Adjustment Total])
,SUM([Proc 299510 Total])
FROM SUMS
*/



