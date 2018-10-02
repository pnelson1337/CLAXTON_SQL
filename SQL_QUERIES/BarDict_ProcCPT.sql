
SELECT 

DBP.ProcedureID
,CPT.Code


FROM [Livedb].[dbo].[DBarProcedures]			 DBP

LEFT JOIN (SELECT PD.ProcedureID,PD.Code,PD.EffectiveDateTime
	FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
		INNER JOIN ( SELECT TT.ProcedureID,MAX(TT.EffectiveDateTime)EffectiveDateTime
						FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]TT
						WHERE TT.TypeID='CPT-4'
						GROUP BY TT.ProcedureID)					AS SS										ON PD.ProcedureID=SS.ProcedureID AND PD.EffectiveDateTime=SS.EffectiveDateTime
							WHERE TypeID='CPT-4')					AS CPT										ON DBP.ProcedureID=CPT.ProcedureID		

WHERE DBP.Active='Y'

ORDER BY DBP.ProcedureID

