SELECT

--SA.VisitID
AV.AccountNumber
,AV.Name
,AV.PrimaryInsuranceID
,CONVERT(VARCHAR(10),SA.DateTime,101)													AS 'Appointment Date'
,CONVERT(VARCHAR(10),ORIGBOOK.ActualEventDateTime,101)									AS 'Original Book Date'
,ORIGBOOK.EventUserID																	AS 'Original Book User'
,ORIGBOOK.Name																			AS 'Original Book Name'
,CONVERT(VARCHAR(10),RECENTBOOK.ActualEventDateTime,101)								AS 'Most Recent Book Date'
,RECENTBOOK.EventUserID																	AS 'Most Recent Book User'
,RECENTBOOK.Name																		AS 'Most Recent Book Name'
,SA.AppointmentTypeID
,APTNAME.Description																	AS 'Appointment Description'
,SAQ.Response																			AS 'SCH AUTH#'
,AV.LocationID
,AUTHS.InsuranceAuthNumber																AS 'ARM AUTH#'
,CONVERT(VARCHAR(10),AUTHS.ExpireDateTime,101)											AS 'ARM AUTH EXPIRE'



FROM		[Livedb].[dbo].[SchAppointments]				AS SA
LEFT JOIN	[Livedb].[dbo].[AdmVisits]						AS AV			ON SA.VisitID=AV.VisitID
LEFT JOIN	[Livedb].[dbo].[SchAppointmentQueries]			AS SAQ			ON SA.AppointmentID=SAQ.AppointmentID AND SAQ.QueryID IN ('SCHMRI07','SCHCT07','SCHUS04','SCHACU26')
LEFT JOIN	[Livedb].[dbo].[ArmPatients]					AS ARMPAT		ON SA.PatientID=ARMPAT.PatientID
LEFT JOIN	[Livedb].[dbo].[ArmAuthServiceScheduledUnits]	AS ARMSCH		ON SA.AppointmentID=ARMSCH.AppointmentID
LEFT JOIN	[Livedb].[dbo].[ArmAuths]						AS AUTHS		ON ARMSCH.AuthID=AUTHS.AuthID
LEFT JOIN	[Livedb].[dbo].[DSchApptTypes]					AS APTNAME		ON SA.AppointmentTypeID=APTNAME.AppointmentTypeID AND APTNAME.Active='Y'
LEFT JOIN (
SELECT * FROM(
SELECT SAE.ActualEventDateTime, SAE.EventUserID, SAE.AppointmentID, RBNAME.Name
,ROW_NUMBER() OVER (PARTITION BY SAE.AppointmentID ORDER BY SAE.ActualEventDateTime ASC)						AS ApptSeq
FROM [Livedb].[dbo].[SchAppointmentEvents]	AS SAE
LEFT JOIN	[Livedb].[dbo].[DMisUsers]						AS RBNAME	ON SAE.EventUserID=RBNAME.UserID		
WHERE SAE.Type='BOOK'
) AS X
WHERE X.ApptSeq='1')					AS ORIGBOOK			ON SA.AppointmentID=ORIGBOOK.AppointmentID

LEFT JOIN (
SELECT * FROM(
SELECT SAE.ActualEventDateTime, SAE.EventUserID, SAE.AppointmentID, RBNAME.Name
,ROW_NUMBER() OVER (PARTITION BY SAE.AppointmentID ORDER BY SAE.ActualEventDateTime DESC)						AS ApptSeq
FROM [Livedb].[dbo].[SchAppointmentEvents]	AS SAE
LEFT JOIN	[Livedb].[dbo].[DMisUsers]		AS RBNAME	ON SAE.EventUserID=RBNAME.UserID		
WHERE SAE.Type='BOOK'
) AS X
WHERE X.ApptSeq='1')					AS RECENTBOOK			ON SA.AppointmentID=RECENTBOOK.AppointmentID




WHERE CAST(SA.DateTime AS DATE) BETWEEN '2018-10-22' AND '2018-10-22'
AND SA.CancelReasonID IS NULL
AND SA.LocationID IN ('RAD')



/*
WHERE CAST(SA.DateTime AS DATE) BETWEEN @STARTDATE AND @ENDDATE
AND SA.CancelReasonID IS NULL
AND SA.LocationID IN (@LOCATION)
*/
--AND AppointmentTypeID LIKE '%MRI%'
--AND SA.AppointmentID='1680644'

ORDER BY AV.LocationID
