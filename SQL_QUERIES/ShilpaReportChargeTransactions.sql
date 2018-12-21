DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME

SET @STARTDATE='2018-01-01'
SET @ENDDATE  ='2018-10-31'
SELECT * FROM (
SELECT 

BV.AccountNumber
,BV.VisitID
,BCT.SINGLE_VALUE																																						AS 'Charge Procedures'
,ISNULL(BVFD.ArChargeTotal,'0')																																			AS 'Total Charges'
,ISNULL(BVFD.ReceiptTotal,'0')																																			AS 'Total Receipts'
,ISNULL(BVFD.AdjustmentTotal,'0')																																		AS 'Total Adjustments'
,ISNULL(BVFD.RefundTotal,'0')																																			AS 'Total Refunds'
,ISNULL(BVFD.Balance,'0')																																				AS 'Account Balance'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),CONVERT(VARCHAR(10),BV.ServiceDateTime,101))																		AS 'Discharge/Service Date'
,BV.InpatientOrOutpatient																																				AS 'IN or OUT'
,BVFD.AccountType																																						AS 'Account Type'
,BV.FinancialClassID																																					AS 'Insurance Group'
--,SELECTSplit3(BCT.SINGLE_VALUE)

--,dbo.Z
FROM		[Livedb].[dbo].[BarVisitFinancialData]																														AS BVFD
LEFT JOIN	[Livedb].[dbo].[BarVisits]																																	AS BV						ON BVFD.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[AdmVisits]																																	AS AV						ON BVFD.VisitID=AV.VisitID
LEFT JOIN	(SELECT BV.VisitID
			 ,STUFF((SELECT ', ' + TRA.TransactionProcedureID
			 			FROM (SELECT [VisitID],ROW_NUMBER() OVER (PARTITION BY VisitID ORDER BY TransactionProcedureID DESC ) AS RowNum,[TransactionProcedureID]
			 					FROM	[Livedb].[dbo].[BarChargeTransactions]
			 					GROUP BY VisitID, TransactionProcedureID)																								AS TRA
								WHERE (TRA.VisitID = BV.VisitID)
			 			FOR XML PATH (''),type).value('(./text())[1]','varchar(max)')
			 			, 1, 2,'')																																		AS SINGLE_VALUE
			 		FROM [Livedb].[dbo].[BarVisits]		AS BV
															
															)																											AS BCT						ON BVFD.VisitID=BCT.VisitID



WHERE (CAST(BV.AdmitDateTime AS DATE) BETWEEN @STARTDATE AND @ENDDATE OR (CAST(BV.ServiceDateTime AS DATE) BETWEEN @STARTDATE AND @ENDDATE))
AND BV.FinancialClassID IN ('MCR')
AND EXISTS (
			SELECT * FROM [Livedb].[dbo].[BarChargeTransactions] AS SELBCT WHERE SELBCT.TransactionProcedureID IN ('471409')
			AND SELBCT.VisitID=BV.VisitID
			)
) AS X

WHERE X.[Account Type] IN ('OPV')


ORDER BY [Discharge/Service Date]
		