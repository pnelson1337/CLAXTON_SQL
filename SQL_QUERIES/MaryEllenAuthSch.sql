SELECT

SA.VisitID


,AV.AccountNumber
,AV.Name
,AV.PrimaryInsuranceID
,CONVERT(VARCHAR(10),SA.DateTime,101)													AS 'Appointment Date'
,CONVERT(VARCHAR(10),ORIGBOOK.ActualEventDateTime,101)									AS 'Original Book Date'
,ORIGBOOK.EventUserID											AS 'Original Book User'

,CONVERT(VARCHAR(10),RECENTBOOK.ActualEventDateTime,101)									AS 'Most Recent Book Date'
,RECENTBOOK.EventUserID											AS 'Most Recent Book User'


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
SELECT * FROM(
SELECT SAE.ActualEventDateTime, SAE.EventUserID, SAE.AppointmentID
,ROW_NUMBER() OVER (PARTITION BY SAE.AppointmentID ORDER BY SAE.ActualEventDateTime ASC)						AS ApptSeq
FROM [Livedb].[dbo].[SchAppointmentEvents]	AS SAE
WHERE SAE.Type='BOOK'
) AS X
WHERE X.ApptSeq='1')					AS ORIGBOOK			ON SA.AppointmentID=ORIGBOOK.AppointmentID

LEFT JOIN (
SELECT * FROM(
SELECT SAE.ActualEventDateTime, SAE.EventUserID, SAE.AppointmentID
,ROW_NUMBER() OVER (PARTITION BY SAE.AppointmentID ORDER BY SAE.ActualEventDateTime DESC)						AS ApptSeq
FROM [Livedb].[dbo].[SchAppointmentEvents]	AS SAE
WHERE SAE.Type='BOOK'
) AS X
WHERE X.ApptSeq='1')					AS RECENTBOOK			ON SA.AppointmentID=RECENTBOOK.AppointmentID




WHERE CAST(SA.DateTime AS DATE) BETWEEN '2018-10-09' AND '2018-10-09'
AND SA.AppointmentID='1680644'

