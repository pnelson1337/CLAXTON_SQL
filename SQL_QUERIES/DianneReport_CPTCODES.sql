DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME

SET @STARTDATE='2018-01-04'
SET @ENDDATE  ='2018-01-04'

SELECT 

BV.AccountNumber
,BV.VisitID

,ISNULL(BVFD.ArChargeTotal,'0')																																			AS 'Total Charges'
,ISNULL(BVFD.ReceiptTotal,'0')																																			AS 'Total Receipts'
,ISNULL(BVFD.AdjustmentTotal,'0')																																		AS 'Total Adjustments'
,ISNULL(BVFD.RefundTotal,'0')																																			AS 'Total Refunds'
,ISNULL(BVFD.Balance,'0')																																				AS 'Account Balance'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),CONVERT(VARCHAR(10),BV.ServiceDateTime,101))																		AS 'Discharge/Service Date'
,BV.InpatientOrOutpatient																																				AS 'IN or OUT'
,BVFD.AccountType																																						AS 'Account Type'
,BV.FinancialClassID																																					AS 'Insurance Group'
,BCT.SINGLE_VALUE																																						AS 'Charge Procedures'


FROM		[Livedb].[dbo].[BarVisitFinancialData]																														AS BVFD
LEFT JOIN	[Livedb].[dbo].[BarVisits]																																	AS BV						ON BVFD.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[AdmVisits]																																	AS AV						ON BVFD.VisitID=AV.VisitID
LEFT JOIN	(SELECT BV.VisitID
			 ,STUFF((SELECT ', ' +TRA.Code
			 			FROM (SELECT [VisitID],ROW_NUMBER() OVER (PARTITION BY VisitID ORDER BY TransactionProcedureID DESC ) AS RowNum,[TransactionProcedureID],CPT.Code
			 					FROM	[Livedb].[dbo].[BarChargeTransactions]BCT
								LEFT JOIN
								(SELECT PD.ProcedureID,PD.Code,PD.EffectiveDateTime
									FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
										INNER JOIN ( SELECT TT.ProcedureID,MAX(TT.EffectiveDateTime)EffectiveDateTime
														FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]TT
														WHERE TT.TypeID='CPT-4'
														GROUP BY TT.ProcedureID)																						AS SS										ON PD.ProcedureID=SS.ProcedureID AND PD.EffectiveDateTime=SS.EffectiveDateTime
														WHERE TypeID='CPT-4')																							AS CPT										ON BCT.TransactionProcedureID=CPT.ProcedureID
			 					GROUP BY VisitID, TransactionProcedureID, CPT.Code)																						AS TRA
								WHERE (TRA.VisitID = BV.VisitID)
			 			FOR XML PATH (''),type).value('(./text())[1]','varchar(max)')
			 			, 1, 2,'')																																		AS SINGLE_VALUE
			 		FROM [Livedb].[dbo].[BarVisits]		AS BV
															
															)																											AS BCT						ON BVFD.VisitID=BCT.VisitID

WHERE (CAST(BV.AdmitDateTime AS DATE) BETWEEN @STARTDATE AND @ENDDATE OR (CAST(BV.ServiceDateTime AS DATE) BETWEEN @STARTDATE AND @ENDDATE))