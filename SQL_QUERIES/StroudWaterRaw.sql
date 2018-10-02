SELECT 

BCT.TransactionProcedureID
,BCT.Amount
,BV.ServiceDateTime
,BCT.BatchDateTime

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

	ORDER BY TransactionProcedureID
