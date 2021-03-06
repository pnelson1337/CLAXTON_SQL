SELECT * FROM (
SELECT 
--SA.AppointmentID
--,SA.VisitID
AV.Name
,AV.AccountNumber
,DPROV.Name																								AS 'Surgeon Name'
,SOR.ServiceID																					
,SA.ResourceGroup
,SA.AppointmentTypeID
,CONVERT(VARCHAR(10),SA.DateTime,101)																	AS 'AppointmentDate'
,SA.CancelReasonID																						AS 'CancelReason'
,CONVERT(VARCHAR(10),SACAN.DateTime,101)																AS 'CancelDate'
,SACAN.TimeCanceled																						AS 'CancelTime'
,CASE WHEN CONVERT(VARCHAR(10),SA.DateTime,101) = CONVERT(VARCHAR(10),SACAN.DateTime,101) 
	THEN 'FILTER' ELSE '' END																			AS 'FILTER'
,SA.DateTime																							AS 'RunDate'


FROM			[Livedb].[dbo].[SchAppointments]					AS SA
INNER JOIN		[Livedb].[dbo].[SchOrPatCases]						AS SOR			ON SA.AppointmentID=SOR.AppointmentID
LEFT JOIN		[Livedb].[dbo].[SchAppointmentCancelReasons]		AS SACAN		ON SA.AppointmentID=SACAN.AppointmentID AND SACAN.Event='CANCEL'
LEFT JOIN		[Livedb].[dbo].[AdmVisits]							AS AV			ON SA.VisitID=AV.VisitID
LEFT JOIN		[Livedb].[dbo].[DMisProvider]						AS DPROV		ON SOR.SurgeonID=DPROV.ProviderID

WHERE SOR.ServiceID != 'PAIN'
) AS X

WHERE X.FILTER='FILTER'
--AND X.[RunDate] BETWEEN @StartDate AND @EndDate
AND X.[RunDate] BETWEEN '2018-01-01' AND '2018-12-31'
--AND X.[Appointment Date] BETWEEN '01/01/2017' AND '12/31/2017'

ORDER BY X.[AppointmentDate]