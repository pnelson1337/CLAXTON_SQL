DECLARE @StartDate DateTime,@EndDate DateTime

SET @StartDate='2018-01-01'
SET @EndDate='2018-12-31'

SELECT

 --AV.VisitID
 ISNULL(LS.OrderLocationID,'')																										AS 'Location'
,AV.UnitNumber																														AS 'MR Number'
,AV.Name																															AS 'Patient Name'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')																				AS 'Adm Date'
,ISNULL(CONVERT(VARCHAR(10),LS.CollectionDateTime,101),'')																			AS 'Specimen Date'
,AV.AccountNumber																													AS 'AccountNumber'
,DLT.Name					
,CASE WHEN LST.ResultRW = 'DETECTED' THEN 'POSITIVE' 
	  ELSE 'NEGATIVE'	END																											AS 'Result'
,'NO'																																AS 'BioFire?'
,ISNULL((SELECT TOP 1 * FROM (
				SELECT TOP 2 
				CONVERT(VARCHAR(10),BV1.DischargeDateTime,101)																		AS 'DateTme' 
				FROM	  [Livedb].[dbo].[BarVisits]																				AS BV1 
				LEFT JOIN [Livedb].[dbo].[AdmVisits]																				AS AV1 ON BV1.VisitID=AV1.VisitID
				WHERE BV1.UnitNumber=BV.UnitNumber
				AND AV1.Status = 'DIS IN'
				AND ((CONVERT(VarChar(10), BV1.DischargeDateTime, 23)) < (CONVERT(VarChar(10), LS.CollectionDateTime, 23)))
				ORDER BY BV1.DischargeDateTime DESC)																				AS TMP
				),'')																												AS 'Last Discharge Date'

/*,ISNULL((SELECT TOP 1 * FROM (
				SELECT TOP 10 
				CONVERT(VARCHAR(10),LS1.CollectionDateTime,101)																		AS 'DateTme' 
				FROM		[Livedb].[dbo].[AdmVisits]																				AS AV1
				LEFT JOIN	[Livedb].[dbo].[BarVisits]																				AS BV1			ON AV1.VisitID=BV1.VisitID	
				LEFT JOIN	[Livedb].[dbo].[LabSpecimens]																			AS LS1			ON AV1.VisitID=LS1.VisitID AND LS1.CancelledDateTime IS NULL
				INNER JOIN	[Livedb].[dbo].[LabSpecimenTests]																		AS LST1			ON LS1.SpecimenID=LST1.SpecimenID AND LST1.TestPrintNumberID='800.2020'
				LEFT JOIN	[Livedb].[dbo].[DLabTest]																				AS DLT1			ON LST1.TestPrintNumberID=DLT1.PrintNumberID AND DLT1.Active='Y'
				WHERE BV1.UnitNumber=BV.UnitNumber
				AND ((CONVERT(VarChar(10), LS1.CollectionDateTime, 23)) < (CONVERT(VarChar(10), LS.CollectionDateTime, 23)))
				ORDER BY LS1.CollectionDateTime DESC)																				AS TMP
				),'')																												AS 'Last Specimen Date'
*/
,''																																	AS 'Last Specimen Date'


FROM		[Livedb].[dbo].[AdmVisits]																								AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																								AS BV			ON AV.VisitID=BV.VisitID	
LEFT JOIN	[Livedb].[dbo].[LabSpecimens]																							AS LS			ON AV.VisitID=LS.VisitID AND LS.CancelledDateTime IS NULL
INNER JOIN	[Livedb].[dbo].[LabSpecimenTests]																						AS LST			ON LS.SpecimenID=LST.SpecimenID AND LST.TestPrintNumberID='800.2020'
LEFT JOIN	[Livedb].[dbo].[DLabTest]																								AS DLT			ON LST.TestPrintNumberID=DLT.PrintNumberID AND DLT.Active='Y'
				
WHERE CONVERT(VarChar(10), LS.CollectionDateTime, 23) BETWEEN @StartDate AND @EndDate
AND LST.ResultRW = 'DETECTED'
AND LocationID NOT IN ('LAB-RIVER')
AND AV.VisitID NOT IN ('6012062947','6012137629')
AND LS.CancelledDateTime IS NULL

UNION ALL	


SELECT

 --AV.VisitID
 ISNULL(MS.OrderLocationID,'')																										AS 'Location'
,AV.UnitNumber																														AS 'MR Number'
,AV.Name																															AS 'Patient Name'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')																				AS 'Adm Date'
,ISNULL(CONVERT(VARCHAR(10),MS.CollectionDateTime,101),'')																			AS 'Specimen Date'
,AV.AccountNumber																													AS 'AccountNumber'
,DMP.Name	
				
,CASE WHEN MSPR2.ResultText = 'POSITIVE' THEN 'POSITIVE' 
	  ELSE 'NEGATIVE'	END																											AS 'Result'
,'YES'																																AS 'BioFire?'
,ISNULL((SELECT TOP 1 * FROM (
				SELECT TOP 2 
				CONVERT(VARCHAR(10),BV1.DischargeDateTime,101)																		AS 'DateTme' 
				FROM	  [Livedb].[dbo].[BarVisits]																				AS BV1 
				LEFT JOIN [Livedb].[dbo].[AdmVisits]																				AS AV1 ON BV1.VisitID=AV1.VisitID
				WHERE BV1.UnitNumber=BV.UnitNumber
				AND AV1.Status = 'DIS IN'
				AND ((CONVERT(VarChar(10), BV1.DischargeDateTime, 23)) < (CONVERT(VarChar(10), MS.CollectionDateTime, 23)))
				ORDER BY BV1.DischargeDateTime DESC)																				AS TMP
				),'')																												AS 'Last Discharge Date'

/*,ISNULL((SELECT TOP 1 * FROM (
				SELECT TOP 10 
				CONVERT(VARCHAR(10),MS1.CollectionDateTime,101)	AS 'DateTme' 
				FROM		[Livedb].[dbo].[AdmVisits]																				AS AV1
				LEFT JOIN	[Livedb].[dbo].[BarVisits]																				AS BV1			ON AV1.VisitID=BV1.VisitID	
				LEFT JOIN	[Livedb].[dbo].[MicSpecimens]																			AS MS1			ON AV1.VisitID=MS1.VisitID				AND MS1.CancelledDateTime IS NULL
				INNER JOIN	[Livedb].[dbo].[MicSpecimenProcedures]																	AS MSP1			ON MS1.SpecimenID=MSP1.SpecimenID		AND MSP1.ProcedureID IN ('300.0202','300.0203','300.0204')
				LEFT JOIN	[Livedb].[dbo].[DMicProcs]																				AS DMP1			ON MSP1.ProcedureID=DMP1.ProcedureID	AND DMP1.Active='Y'	
				LEFT JOIN (SELECT MSPR.ProcedureID,MSPR.SpecimenID
				  ,MAX(MSPR.ResultSeqID)																							AS 'MAXSEQ'
				  ,MAX(MSPR.PromptID)																								AS 'MAXPROMPT'
				  ,MAX(MSPR.ResultText)																								AS 'ResultText'
				  FROM [Livedb].[dbo].[MicSpecimenPromptResults]																	AS MSPR
				  WHERE MSPR.PromptID='TOXCDIFF'
				  GROUP BY MSPR.SpecimenID,MSPR.ProcedureID)																		AS MSPR3		ON MSP1.SpecimenID=MSPR3.SpecimenID		AND MSP1.ProcedureID=MSPR3.ProcedureID	
				WHERE BV1.UnitNumber=BV.UnitNumber
				AND ((CONVERT(VarChar(10), MS1.CollectionDateTime, 23)) < (CONVERT(VarChar(10), MS.CollectionDateTime, 23)))
				ORDER BY MS1.CollectionDateTime DESC)																				AS TMP
				),'')																												AS 'Last Specimen Date'
*/
,''																																	AS 'Last Specimen Date'

FROM		[Livedb].[dbo].[AdmVisits]																								AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																								AS BV			ON AV.VisitID=BV.VisitID	
LEFT JOIN	[Livedb].[dbo].[MicSpecimens]																							AS MS			ON AV.VisitID=MS.VisitID				AND MS.CancelledDateTime IS NULL
INNER JOIN	[Livedb].[dbo].[MicSpecimenProcedures]																					AS MSP			ON MS.SpecimenID=MSP.SpecimenID			AND MSP.ProcedureID IN ('300.0202','300.0203','300.0204')
LEFT JOIN	[Livedb].[dbo].[DMicProcs]																								AS DMP			ON MSP.ProcedureID=DMP.ProcedureID		AND DMP.Active='Y'
LEFT JOIN (SELECT MSPR.ProcedureID,MSPR.SpecimenID
				  ,MAX(MSPR.ResultSeqID)																							AS 'MAXSEQ'
				  ,MAX(MSPR.PromptID)																								AS 'MAXPROMPT'
				  ,MAX(MSPR.ResultText)																								AS 'ResultText'
				  FROM [Livedb].[dbo].[MicSpecimenPromptResults]																	AS MSPR
				  WHERE MSPR.PromptID='TOXCDIFF'
				  GROUP BY MSPR.SpecimenID,MSPR.ProcedureID)																		AS MSPR2		ON MSP.SpecimenID=MSPR2.SpecimenID		AND MSP.ProcedureID=MSPR2.ProcedureID	

WHERE CONVERT(VarChar(10), MS.CollectionDateTime, 23) BETWEEN @StartDate AND @EndDate
AND MSPR2.ResultText = 'POSITIVE'
AND LocationID NOT IN ('LAB-RIVER')
AND AV.VisitID NOT IN ('6012062947','6012137629')
AND MS.CancelledDateTime IS NULL

ORDER BY [Specimen Date]

