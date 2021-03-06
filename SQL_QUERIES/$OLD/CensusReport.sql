DECLARE @STARTDATE DATE, @ENDDATE DATE

SET @STARTDATE = '2015-09-01'

SELECT --TOP 10

BV.VisitID
,BV.Name
--,BV.InpatientOrOutpatient
,BV.AccountNumber

,BV.AdmitDateTime
,BV.DischargeDateTime
,AV.LocationID

FROM		[Livedb].[dbo].[BarVisits]			AS BV
LEFT JOIN	[Livedb].[dbo].[AdmVisits]			kAS AV		ON BV.VisitID=AV.VisitID


WHERE CONVERT(VARCHAR(10),BV.AdmitDateTime    ,101)<= @STARTDATE
AND  (CONVERT(VARCHAR(10),BV.DischargeDateTime,101)>= @STARTDATE OR BV.DischargeDateTime IS NULL)

AND BV.VisitID IS NOT NULL
AND BV.InpatientOrOutpatient = 'I'
AND BV.VisitID != '6009139242'


ORDER BY AV.LocationID