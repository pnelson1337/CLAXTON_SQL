SET NOCOUNT ON

/*
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2018-02-01'
Set @EndDate='2018-02-28'
*/

SELECT
 BV.AccountNumber																	AS 'EncounterID'
,BarDiag.DiagnosisCodeID															AS 'DiagnosisCode'
,ISNULL(BarDiag.PresentOnAdmit,'')													AS 'POAFlag'
,BarDiag.DiagnosisSeqID																AS 'CodeSequenceNumber'
,'ICD-10'																			AS 'DiagnosisCodeType'
,ISNULL(AV.LocationID,'')															AS 'Facility'


FROM				[CH_MTLIVE].[dbo].[AdmVisits]										AS AV								
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisits]										AS BV		 ON AV.VisitID = BV.VisitID	
INNER JOIN			[CH_MTLIVE].[dbo].[BarDiagnoses]									AS BarDiag	 ON BarDiag.BillingID=BV.BillingID
WHERE AV.InpatientOrOutpatient IN ('I','O')
--AND ((CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate) OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))
AND (BV.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0) AND BV.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) OR (BV.AdmitDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0) AND BV.AdmitDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) ))