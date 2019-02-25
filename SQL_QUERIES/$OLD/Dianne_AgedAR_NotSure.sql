SELECT 

BV.AccountNumber
,BV.VisitID
,ISNULL(BVFD.ArChargeTotal,0)										AS 'TotalChargeAR'
,TOTALREC.[TotalReceived]											AS 'TotalReceived'
,(ISNULL(BVFD.ArChargeTotal,0)-TOTALREC.[TotalReceived])			AS 'TotalAR'
,BVFD.PatientBalance
,BVFD.InsuranceBalance

,BVFD.ReceiptTotal
,BVFD.RefundTotal
,BVFD.AdjustmentTotal
,BVFD.BarStatus
,BVFD.AccountTypeID
,BVFD.AccountType
,BVFD.UsualInsurances
,BIBL.InsuranceID
,BIBL.Balance






FROM		[Livedb].[dbo].[BarVisitFinancialData]														AS BVFD
LEFT JOIN	[Livedb].[dbo].[BarVisits]																	AS BV		ON BVFD.VisitID=BV.VisitID
LEFT JOIN	(SELECT VisitID,ISNULL(AdjustmentTotal,0) + ISNULL(ReceiptTotal,0) + ISNULL(RefundTotal,0)	AS 'TotalReceived'
FROM		[Livedb].[dbo].[BarVisitFinancialData])														AS TOTALREC	ON BVFD.VisitID=TOTALREC.VisitID

LEFT JOIN [Livedb].[dbo].[BarInsuranceLedger]					AS BIBL								ON BVFD.VisitID=BIBL.VisitID



WHERE BalanceBecameZeroDateTime IS NULL