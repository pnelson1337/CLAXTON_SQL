SELECT

COUNT(AccountNumber)					AS 'Total Cases'
,SUM([Total OR Time]) /	COUNT(AccountNumber)				AS 'AVG OR TIME'				
,SUM([ACU Time])	/ COUNT(AccountNumber)					AS 'AVG ACU TIME'			

FROM 
(
5326
SELECT 

SCHOR.AccountNumber
,BV.UnitNumber
,CAST(SCHOR.OperationDateTime AS DATE)						AS 'Operation Date'
,ORTIME1.[Pre1DateTime]										AS 'ARRIVAL TO ACU'
,ORTIME2.Op2DateTime										AS 'IN OR'
,ORTIME3.Op6DateTime										AS 'OUT OF OR'
,ORTIME4.[Phase22DateTime]									AS 'DISCHARGE'

,DATEDIFF(MINUTE,ORTIME2.Op2DateTime,ORTIME3.Op6DateTime)																			AS 'Total OR Time'
,DATEDIFF(MINUTE,ORTIME1.[Pre1DateTime],ORTIME4.[Phase22DateTime]) - DATEDIFF(MINUTE,ORTIME2.Op2DateTime,ORTIME3.Op6DateTime)		AS 'ACU Time'
,DATEDIFF(MINUTE,ORTIME1.[Pre1DateTime],ORTIME4.[Phase22DateTime])																	AS 'Total Visit Time'

FROM		[CH_MTLIVE].[dbo].[SchOrPatCases]						AS SCHOR
LEFT JOIN	[CH_MTLIVE].[dbo].[BarVisits]							AS BV			ON SCHOR.VisitID=BV.VisitID
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesPre]				AS ORTIME1		ON SCHOR.PatientCaseID=ORTIME1.CaseID
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesOp1]				AS ORTIME2		ON SCHOR.PatientCaseID=ORTIME2.CaseID	
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesOp2]				AS ORTIME3		ON SCHOR.PatientCaseID=ORTIME3.CaseID	
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesPhase2]				AS ORTIME4		ON SCHOR.PatientCaseID=ORTIME4.CaseID		

			
WHERE CAST(SCHOR.OperationDateTime AS DATE)		BETWEEN '2018-01-01' AND '2018-12-31'
AND SCHOR.CompleteCharge='Y'
AND ORTIME1.[Pre1DateTime]	    IS NOT NULL
AND ORTIME4.[Phase22DateTime]	IS NOT NULL
AND ORTIME2.Op2DateTime			IS NOT NULL
AND ORTIME3.Op6DateTime			IS NOT NULL
AND DATEDIFF(MINUTE,ORTIME2.Op2DateTime,ORTIME3.Op6DateTime) > 0
AND DATEDIFF(MINUTE,ORTIME1.[Pre1DateTime],ORTIME4.[Phase22DateTime]) - DATEDIFF(MINUTE,ORTIME2.Op2DateTime,ORTIME3.Op6DateTime) > 0


) AS X
