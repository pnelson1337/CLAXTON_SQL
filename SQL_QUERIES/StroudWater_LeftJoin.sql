SELECT 

CPT.Code
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('COM','COM-GHI','COM-PPO','COM-RMSCO','COM-SDEM','COM-UAS','HCOM','BC')	THEN BCT.Amount END)			,'')		AS 'Commercial'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('MCD','HMCD')																THEN BCT.Amount END)			,'')		AS 'Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='MCR'																		THEN BCT.Amount END)			,'')		AS 'Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.Amount END)			,'')		AS 'Managed Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.Amount END)			,'')		AS 'Employee Benefits'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='SLF'																		THEN BCT.Amount END)			,'')		AS 'Self-pay'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='WC'																			THEN BCT.Amount END)			,'')		AS 'Worker`s Comp'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.Amount END)			,'')		AS 'Out of State Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('HOTHR','OTHER','U','NF','STP','CHA')										THEN BCT.Amount END)			,'')		AS 'Other'
,ISNULL(SUM(BCT.Amount)																																	,'')		AS 'Grand Total'
,''																																									AS ' '
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('COM','COM-GHI','COM-PPO','COM-RMSCO','COM-SDEM','COM-UAS','HCOM','BC')	THEN BCT.TransactionCount END)	,'')		AS 'Commercial'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('MCD','HMCD')																THEN BCT.TransactionCount END)	,'')		AS 'Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='MCR'																		THEN BCT.TransactionCount END)	,'')		AS 'Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.TransactionCount END)	,'')		AS 'Managed Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.TransactionCount END)	,'')		AS 'Employee Benefits'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='SLF'																		THEN BCT.TransactionCount END)	,'')		AS 'Self-pay'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='WC'																			THEN BCT.TransactionCount END)	,'')		AS 'Worker`s Comp'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.TransactionCount END)	,'')		AS 'Out of State Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('HOTHR','OTHER','U','NF','STP','CHA')										THEN BCT.TransactionCount END)	,'')		AS 'Other'
,ISNULL(SUM(BCT.TransactionCount)																														,'')		AS 'Grand Total'

FROM		[Livedb].[dbo].[BarVisits]					AS BV				
LEFT JOIN	[Livedb].[dbo].[BarChargeTransactions]		AS BCT				ON BV.VisitID=BCT.VisitID
LEFT JOIN
(SELECT PD.ProcedureID,PD.Code,PD.EffectiveDateTime
	FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
		INNER JOIN ( SELECT TT.ProcedureID,MAX(TT.EffectiveDateTime)EffectiveDateTime
						FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]TT
						WHERE TT.TypeID='CPT-4'
						GROUP BY TT.ProcedureID)					AS SS										ON PD.ProcedureID=SS.ProcedureID AND PD.EffectiveDateTime=SS.EffectiveDateTime
							WHERE TypeID='CPT-4')					AS CPT										ON BCT.TransactionProcedureID=CPT.ProcedureID		





WHERE BV.ServiceDateTime BETWEEN '2017-01-01' AND '2018-01-01'
AND BCT.BatchDateTime BETWEEN '2017-01-01' AND '2018-01-01'
AND BCT.TransactionProcedureID IS NOT NULL
AND(BCT.TransactionProcedureID LIKE ('388%') OR
	BCT.TransactionProcedureID LIKE ('667%') OR
	BCT.TransactionProcedureID LIKE ('387%') OR
	BCT.TransactionProcedureID LIKE ('654%') OR
	BCT.TransactionProcedureID LIKE ('669%') OR
	BCT.TransactionProcedureID LIKE ('653%') OR
	BCT.TransactionProcedureID LIKE ('652%'))



GROUP BY CPT.Code

ORDER BY CPT.Code