
/*
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2018-04-01'
Set @EndDate='2018-06-30'
*/

SELECT DISTINCT

 BV.Name											AS 'Patient(s) Name'
,BV.AccountNumber									AS 'Account Number'		
,BV.UnitNumber										AS 'MR Number'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)			AS 'BirthDate'
,AV.LocationID										AS 'Location'


FROM			[Livedb].[dbo].[BarVisits]			AS BV		
INNER JOIN		[Livedb].[dbo].[BarDiagnoses]		AS BD		ON BD.BillingID=BV.BillingID
INNER JOIN		[Livedb].[dbo].[AdmVisits]			AS AV		ON BV.VisitID=AV.VisitID	


WHERE
((CONVERT(VARCHAR(10),BV.DischargeDateTime,23)BETWEEN @StartDate AND @EndDate) OR
 (CONVERT(VARCHAR(10),BV.ServiceDateTime,23)  BETWEEN @StartDate AND @EndDate))	
AND CAST(BD.DiagnosisCodeID AS VARCHAR) IN (UPPER(@Diagnosis))
