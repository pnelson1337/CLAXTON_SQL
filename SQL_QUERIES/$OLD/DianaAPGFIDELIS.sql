/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

BV.AccountNumber
,ISNULL(BVFD.ReceiptTotal,'0')													AS 'Total Receipts'
,ISNULL(APG.ClaimAddonPayment + APG.ClaimPayment,'0')							AS 'Total Claim Payment'
--,ISNULL((APG.ClaimAddonPayment + APG.ClaimPayment) - BVFD.ReceiptTotal,'0')		AS 'Difference'
,CAST(BV.ServiceDateTime AS DATE)									AS 'Service Date'
,BV.PrimaryInsuranceID


  FROM		[Livedb].[dbo].[BarVisits]					AS BV			
  LEFT JOIN [Livedb].[dbo].[AdmVisits]					AS AV				ON BV.VisitID=AV.VisitID
  LEFT JOIN [Livedb].[dbo].[BarVisitFinancialData]		AS BVFD				ON BVFD.VisitID=BV.VisitID			
  LEFT JOIN [Livedb].[dbo].[BarPatApgDetails]			AS APG				ON BVFD.VisitID=APG.VisitID


WHERE CAST(BV.ServiceDateTime AS DATE) BETWEEN '2018-06-01' AND '2018-12-12'
AND BV.PrimaryInsuranceID='FIDELIS'
AND AV.LocationID='ER'

ORDER BY [Service Date]