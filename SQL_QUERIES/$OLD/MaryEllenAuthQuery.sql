/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
 SA.VisitID
 ,SA.PatientID
 ,AV.Name
,AV.AccountNumber
,AV.UnitNumber
,SA.DateTime
,SA.AppointmentTypeID
,SA.AppointmentID
,AA.InsuranceAuthNumber
,AA.ExpireDateTime
,SA.LocationID
,SA.AuthID
,SA.Auth2ID



FROM		[Livedb].[dbo].[SchAppointments]				AS SA
LEFT JOIN	[Livedb].[dbo].[ArmAuthServiceScheduledUnits]	AS AASCH	ON SA.AppointmentID=AASCH.AppointmentID AND SA.AppointmentTypeID=AASCH.AppointmentTypeID
LEFT JOIN	[Livedb].[dbo].[ArmAuths]						AS AA		ON SA.PatientID=AA.PatientID --AND SA.AuthID=AA.AuthID

LEFT JOIN	[Livedb].[dbo].[AdmVisits]						AS AV		ON SA.VisitID=AV.VisitID


WHERE SA.DateTime BETWEEN '2018-08-20' AND '2018-08-23'
--AND SA.LocationID IN ('RAD','WHS','ASUR','CARD REHAB','CARD'
AND  SA.LocationID NOT IN ('CAN','CHHC','LIS','HEUV','WADD','OPS','MAD','WELL','LAB','WOUND','MOB')
AND SA.AppointmentTypeID NOT IN ('DMAMBR')
AND SA.CancelReasonID IS NULL


--LEFT JOIN	[Livedb].[dbo].[BarVisits]			AS BV		ON SA.PatientID