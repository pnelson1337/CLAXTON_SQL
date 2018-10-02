
--;WITH SUMS AS (

SELECT

--BV.VisitID
 BV.AccountNumber																AS 'Account Number'
--,SUM(BCHTXNITEM.Amount)															AS 'Receipt Total'
,CASE WHEN BCH.DateTime > BVFD.BadDebtAgeDateTime								 
	THEN SUM(BCHTXNITEM.Amount) ELSE '' END										AS 'Receipt after Bad Debt'
,CONVERT(VARCHAR(10),BCH.DateTime,101)											AS 'Batch Date'
,CONVERT(VARCHAR(10),BVFD.BadDebtAgeDateTime,101)								AS 'BadDebt Date'
,CONVERT(VARCHAR(10),ISNULL(BV.ServiceDateTime,BV.AdmitDateTime),101)			AS 'Service/Admit Date'


FROM		[Livedb].[dbo].[BarVisits]											AS BV
LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]								AS BVFD				ON BV.VisitID=BVFD.VisitID
INNER JOIN	[Livedb].[dbo].[BarBchTxns]											AS BCHTXN			ON BV.BillingID=BCHTXN.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchTxnItems]										AS BCHTXNITEM		ON BCHTXN.TxnNumberID=BCHTXNITEM.TxnNumberID AND BCHTXN.BatchID=BCHTXNITEM.BatchID  
INNER JOIN	[Livedb].[dbo].[BarBchs]											AS BCH				ON BCH.BatchID=BCHTXN.BatchID


WHERE BCH.DateTime BETWEEN '2017-01-01' AND '2017-12-31'
AND BCHTXNITEM.Type='RCP'
AND BVFD.BadDebtAgeDateTime IS NOT NULL
AND BCH.DateTime > BVFD.BadDebtAgeDateTime	
AND BVFD.CollectionAgency !='DECEASED'



GROUP BY BV.AccountNumber,BVFD.BadDebtAgeDateTime, BCH.DateTime,BV.ServiceDateTime,BV.AdmitDateTime
ORDER BY BCH.DateTime



/*

)
SELECT
SUM([Receipt after Bad Debt]) --OVER (PARTITION BY [Account Number])
FROM SUMS
*/


