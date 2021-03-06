/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
 ORTIME1.[Pre1DateTime]										AS 'ARRIVAL TO ACU'
,ORTIME1.[Pre2DateTime]										AS 'TO RADIOLOGY'
,ORTIME1.[Pre3DateTime]										AS 'RET RADIOLOGY'
,ORTIME1.[Pre4DateTime]										AS 'READY OR'

,ORTIME2.Op1DateTime										AS 'ANESTHESIA START'
,ORTIME2.Op2DateTime										AS 'IN OR'
,ORTIME2.Op3DateTime										AS 'ANTIBIO START'
,ORTIME2.Op4DateTime										AS 'INCISION START'		

,ORTIME3.Op5DateTime										AS 'SKIN/DRSG/END'
,ORTIME3.Op6DateTime										AS 'OUT OF OR'
--,ORTIME3.Op7DateTime										AS 'ANESTHESIA END'
--,ORTIME3.Op8DateTime										AS 'INTO PACU'			

,ORTIME4.[Phase21DateTime]									AS 'IN ACU'
,ORTIME4.[Phase22DateTime]									AS 'DISCHARGE'

FROM		[CH_MTLIVE].[dbo].[SchOrPatCases]						AS SCHOR
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesPre]				AS ORTIME1		ON SCHOR.PatientCaseID=ORTIME1.CaseID
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesOp1]				AS ORTIME2		ON SCHOR.PatientCaseID=ORTIME2.CaseID	
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesOp2]				AS ORTIME3		ON SCHOR.PatientCaseID=ORTIME3.CaseID	
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesPhase2]				AS ORTIME4		ON SCHOR.PatientCaseID=ORTIME4.CaseID		


				
WHERE SCHOR.PatientCaseID='84022'