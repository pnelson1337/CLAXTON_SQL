SELECT

SA.VisitID
,BOOK.AppointmentID
,AV.AccountNumber
,AV.Name
,AV.PrimaryInsuranceID
,SA.DateTime
,BOOK.ActualEventDateTime
,BOOK.EventUserID
,SA.AppointmentTypeID




/*
SELECT PD.ProcedureID,PD.Code,PD.EffectiveDateTime
	FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
		INNER JOIN ( SELECT TT.ProcedureID,MAX(TT.EffectiveDateTime)EffectiveDateTime
						FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]TT
						WHERE TT.TypeID='CPT-4'
						GROUP BY TT.ProcedureID)					AS SS										ON PD.ProcedureID=SS.ProcedureID AND PD.EffectiveDateTime=SS.EffectiveDateTime
							WHERE TypeID='CPT-4')					AS CPT										ON DBP.ProcedureID=CPT.ProcedureID		
*/



FROM [Livedb].[dbo].[SchAppointments]			AS SA
LEFT JOIN [Livedb].[dbo].[AdmVisits]			AS AV			 ON SA.VisitID=AV.VisitID
LEFT JOIN (
SELECT SAE.ActualEventDateTime, SAE.EventUserID, SAE.AppointmentID
FROM [Livedb].[dbo].[SchAppointmentEvents]	AS SAE
INNER JOIN (SELECT TT.AppointmentID, MIN(TT.ActualEventDateTime)	AS 'ActualEventDateTime'
			FROM [Livedb].[dbo].[SchAppointmentEvents]	AS TT
			WHERE TT.Type='BOOK'
			GROUP BY TT.AppointmentID)					AS SS			ON SAE.AppointmentID=SS.AppointmentID AND SAE.EventDateTime=SS.ActualEventDateTime
				WHERE SAE.Type='BOOK')					AS BOOK			ON SA.AppointmentID=BOOK.AppointmentID




WHERE SA.DateTime BETWEEN '2018-10-09' AND '2018-10-11'