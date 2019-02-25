Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2017-07-01'
Set @EndDate='2017-09-30'
SELECT
BV.AccountNumber
,BV.[Name]
,BV.UnitNumber
,BV.AdmitDateTime
,BV.DischargeDateTime
,ATTEND.ProviderID
,BV.InpatientOrOutpatient

FROM [Livedb].[dbo].[BarVisits] BV
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisitProviders]								AS ATTEND	 ON BV.VisitID=ATTEND.VisitID						AND ATTEND.VisitProviderTypeID='Attending'
WHERE BV.InpatientOrOutpatient='I'
AND ATTEND.ProviderID='SEIM'
AND ((CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate) OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))
