SET NOCOUNT ON
/*
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2018-02-01'
Set @EndDate='2018-02-28'
*/

SELECT
 BV.AccountNumber																	AS 'EncounterID'
,BSP.Code																			AS 'ProcedureCode'
,ISNULL(CONVERT(VARCHAR(8), BSP.DateTime,112),'')									AS 'ProcedureServiceDate'
,BSP.SeqID																			AS 'CodeSequenceNumber'
,'ICD-10-PCS'																		AS 'ProcedureCodeType'
,ISNULL(AV.LocationID,'')															AS 'Facility'


FROM				[Livedb].[dbo].[AdmVisits]										AS AV								
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisits]										AS BV		 ON AV.VisitID = BV.VisitID
INNER JOIN			[Livedb].[dbo].[BarSurgicalProcedures]							AS BSP		 ON BV.BillingID=BSP.BillingID
--INNER JOIN			[Livedb].[dbo].[AbsDrgProcedures]								AS AbsProc	 ON BV.VisitID=AbsProc.VisitID				
WHERE AV.InpatientOrOutpatient IN ('I','O')
--AND ((CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate) OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))
AND (BV.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0) AND BV.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) OR (BV.AdmitDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0) AND BV.AdmitDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) ))