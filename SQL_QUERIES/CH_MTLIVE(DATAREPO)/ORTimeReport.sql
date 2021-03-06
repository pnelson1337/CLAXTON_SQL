/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

DATEDIFF(MINUTE,SCHORTIME1.Op3DateTime,SCHORTIME2.Op7DateTime)
,SCHORTIME1.Op3DateTime


  FROM		[CH_MTLIVE].[dbo].[SchOrPatCases]					AS SCHOR
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesOp1]			AS SCHORTIME1	ON SCHOR.PatientCaseID=SCHORTIME1.CaseID
LEFT JOIN	[CH_MTLIVE].[dbo].[SchPatOrCaseTimesOp2]			AS SCHORTIME2	ON SCHOR.PatientCaseID=SCHORTIME2.CaseID

  WHERE CAST(SCHOR.CompleteDateTime AS DATE) BETWEEN '2018-01-01' AND '2018-12-31'