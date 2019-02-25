SET NOCOUNT ON
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2018-07-01'
Set @EndDate='2018-07-31'


SELECT


 ISNULL(MS.OrderLocationID,'')															AS 'UnitType'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)												AS 'DateOfBirth'
,BV.[Name]																				AS 'PatientName'
,BV.UnitNumber																			As 'MRNumber'
,COALESCE(CONVERT(VARCHAR(10),BV.ServiceDateTime,101), '') 
 + '' + 
 COALESCE(CONVERT(VARCHAR(10),BV.AdmitDateTime,101), '')								AS 'FacilityDate'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')									AS 'UnitAdmitDate'
,ISNULL(CONVERT(VARCHAR(10),MS.CollectionDateTime,101),'')								AS 'CollectedDate'
,''																						AS 'ReportedDate'
,DMP.Name																				AS 'TestName'
,CASE WHEN RESP.Name IS NOT NULL THEN 'YES' ELSE 'NO' END								AS 'CentralLine'
,UPPER(ISNULL(RESP.Name,'')	)															AS 'CentralLineType'
,'YES'																					AS 'Biofire?'

FROM		[Livedb].[dbo].[AdmVisits]																								AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																								AS BV			ON AV.VisitID=BV.VisitID	
LEFT JOIN	[Livedb].[dbo].[MicSpecimens]																							AS MS			ON AV.VisitID=MS.VisitID				AND MS.CancelledDateTime IS NULL
INNER JOIN	[Livedb].[dbo].[MicSpecimenProcedures]																					AS MSP			ON MS.SpecimenID=MSP.SpecimenID			--AND MSP.ProcedureID IN ('300.0202','300.0203','300.0204')
LEFT JOIN	[Livedb].[dbo].[DMicProcs]																								AS DMP			ON MSP.ProcedureID=DMP.ProcedureID		AND DMP.Active='Y'
LEFT JOIN (SELECT MSPR.ProcedureID,MSPR.SpecimenID
				  ,MAX(MSPR.ResultSeqID)																							AS 'MAXSEQ'
				  ,MAX(MSPR.PromptID)																								AS 'MAXPROMPT'
				  ,MAX(MSPR.ResultText)																								AS 'ResultText'
				  FROM [Livedb].[dbo].[MicSpecimenPromptResults]																	AS MSPR
				  GROUP BY MSPR.SpecimenID,MSPR.ProcedureID)																		AS MSPR2		ON MSP.SpecimenID=MSPR2.SpecimenID		AND MSP.ProcedureID=MSPR2.ProcedureID
LEFT JOIN (SELECT NQR1.VisitID,NQR1.Response,GR.Name,MAX(NQR1.DateTime)					AS 'Max Response Date' 
			FROM [NurQueryResults] AS NQR1
			INNER JOIN [DMisGroupResponseElements]										AS GR		ON GR.CodeID=NQR1.Response AND GR.GroupResponseID='CCICVC007'
			WHERE NQR1.QueryID='CCICVC007'
			GROUP BY NQR1.VisitID,NQR1.Response,GR.Name)								AS RESP		ON MS.VisitID=RESP.VisitID				  	

WHERE CONVERT(VarChar(10), MS.CollectionDateTime, 23) BETWEEN @StartDate AND @EndDate
AND MSPR2.ResultText = 'POSITIVE'
AND LocationID NOT IN ('NPREV','LAB-RIVER','LAB-PNP') 
AND AV.VisitID NOT IN ('6012062947','6012137629')
AND MS.CancelledDateTime IS NULL


UNION ALL

SELECT

INFECT.FirstLocationID																	AS 'UnitType'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)												AS 'DateOfBirth'
,BV.[Name]																				AS 'PatientName'
,BV.UnitNumber																			As 'MRNumber'
,COALESCE(CONVERT(VARCHAR(10),BV.ServiceDateTime,101), '') 
 + '' + 
 COALESCE(CONVERT(VARCHAR(10),BV.AdmitDateTime,101), '')								AS 'FacilityDate'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')									AS 'UnitAdmitDate'
,CONVERT(VARCHAR(10),INFECT.FirstIsolatedDateTime,101)									AS 'CollectedDate'
,CONVERT(VARCHAR(10),INFECT.FirstVerifiedDateTime,101)									AS 'ReportedDate'
,INFECT.OrganismOrTestName																AS 'TestName'
,CASE WHEN RESP.Name IS NOT NULL THEN 'YES' ELSE 'NO' END								AS 'CentralLine'
,UPPER(ISNULL(RESP.Name,'')	)															AS 'CentralLineType'
,'NO'																					AS 'Biofire?'


FROM [Livedb].[dbo].[LabInfectionControlData]											AS INFECT	
INNER JOIN [Livedb].[dbo].[BarVisits]													AS BV		ON	INFECT.VisitID=BV.VisitID
INNER JOIN [Livedb].[dbo].[AdmVisits]													AS AV		ON	INFECT.VisitID=AV.VisitID
LEFT JOIN (SELECT NQR1.VisitID,NQR1.Response,GR.Name,MAX(NQR1.DateTime)					AS 'Max Response Date' 
			FROM [NurQueryResults] AS NQR1
			INNER JOIN [DMisGroupResponseElements]										AS GR		ON GR.CodeID=NQR1.Response AND GR.GroupResponseID='CCICVC007'
			WHERE NQR1.QueryID='CCICVC007'
			GROUP BY NQR1.VisitID,NQR1.Response,GR.Name)								AS RESP		ON INFECT.VisitID=RESP.VisitID


WHERE FirstLocationID NOT IN ('NPREV','LAB-RIVER','LAB-PNP')  
AND (CONVERT(varchar(10),INFECT.FirstIsolatedDateTime,23) BETWEEN @StartDate AND @EndDate)


ORDER BY CollectedDate