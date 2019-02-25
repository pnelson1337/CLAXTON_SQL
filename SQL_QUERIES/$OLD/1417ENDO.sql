SELECT 

BCT.TransactionProcedureID
,BCT.Amount
,BV.ServiceDateTime
,BCT.BatchDateTime
,DBPROC.ChargeDeptID

FROM		[Livedb].[dbo].[BarVisits]					AS BV				
LEFT JOIN	[Livedb].[dbo].[BarChargeTransactions]		AS BCT				ON BV.VisitID=BCT.VisitID
LEFT JOIN	[Livedb].[dbo].[DBarProcedures]				AS DBPROC			ON BCT.TransactionProcedureID=DBPROC.ProcedureID AND DBPROC.Active='Y'
LEFT JOIN
(SELECT PD.ProcedureID,PD.Code,PD.EffectiveDateTime
	FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
		INNER JOIN ( SELECT TT.ProcedureID,MAX(TT.EffectiveDateTime)EffectiveDateTime
						FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]TT
						WHERE TT.TypeID='CPT-4'
						GROUP BY TT.ProcedureID)					AS SS										ON PD.ProcedureID=SS.ProcedureID AND PD.EffectiveDateTime=SS.EffectiveDateTime
							WHERE TypeID='CPT-4')					AS CPT										ON BCT.TransactionProcedureID=CPT.ProcedureID		





WHERE BV.ServiceDateTime BETWEEN '2018-08-01' AND '2018-08-31'
AND BCT.BatchDateTime BETWEEN '2018-08-01' AND '2018-08-30'
AND BCT.TransactionProcedureID LIKE '417%'
--AND DBPROC.ChargeDeptID='1417'
--AND Amount > 1000

	ORDER BY TransactionProcedureID
