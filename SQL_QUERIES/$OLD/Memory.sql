SELECT

COUNT(SA.AppointmentTypeID)		AS 'Count'
,CASES.SurgeonID
,SA.AppointmentTypeID


FROM		[Livedb].[dbo].[SchOrPatCases]		AS CASES
LEFT JOIN	[Livedb].[dbo].[SchAppointments]	AS SA		ON CASES.AppointmentID=SA.AppointmentID

WHERE CASES.CompleteDateTime > '2018-01-01'
AND SA.CancelReasonID IS NULL

GROUP BY CASES.SurgeonID, SA.AppointmentTypeID


ORDER BY SurgeonID