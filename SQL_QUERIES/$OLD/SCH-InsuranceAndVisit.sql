DECLARE @StartDate DATETIME, @EndDate DATETIME

SET @StartDate = '2018-01-01'
SET @EndDate = '2018-05-31'
SELECT 
       
AV.AccountNumber
,AV.PrimaryInsuranceID
,AV.Status
,SA.[DateTime]
,SA.MadeByUserName
,SA.AppointmentTypeID
--,SA.AppointmentID

FROM [Livedb].[dbo].[SchAppointments]								AS SA
LEFT JOIN [Livedb].[dbo].[AdmVisits]								AS AV		On SA.VisitID=AV.VisitID


WHERE CAST(SA.DateTime AS DATE) BETWEEN @StartDate AND @EndDate
AND CancelReasonID IS NULL
AND AV.Status LIKE '%SDC%'

--AND AV.AccountNumber='27001171'
