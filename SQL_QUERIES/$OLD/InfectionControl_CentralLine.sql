SET NOCOUNT ON
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2017-12-01'
Set @EndDate='2017-12-31'

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
,INFECT.OrganismOrTestName
,CASE WHEN RESP.Name IS NOT NULL THEN 'YES' ELSE 'NO' END								AS 'CentralLine'
,UPPER(ISNULL(RESP.Name,'')	)															AS 'CentralLineType'
--,INFECT.VisitID

FROM [Livedb].[dbo].[LabInfectionControlData]											AS INFECT	
INNER JOIN [Livedb].[dbo].[BarVisits]													AS BV		ON	INFECT.VisitID=BV.VisitID
INNER JOIN [Livedb].[dbo].[AdmVisits]													AS AV		ON	INFECT.VisitID=AV.VisitID
LEFT JOIN (SELECT NQR1.VisitID,NQR1.Response,GR.Name,MAX(NQR1.DateTime)					AS 'Max Response Date' 
			FROM [NurQueryResults] AS NQR1
			INNER JOIN [DMisGroupResponseElements]										AS GR		ON GR.CodeID=NQR1.Response AND GR.GroupResponseID='CCICVC007'
			WHERE NQR1.QueryID='CCICVC007'
			GROUP BY NQR1.VisitID,NQR1.Response,GR.Name)								AS RESP		ON INFECT.VisitID=RESP.VisitID

--LEFT JOIN  [Livedb].[dbo].[MicSpecimens]												AS SPEC		ON	INFECT.VisitID=SPEC.VisitID
--LEFT JOIN  [Livedb].[dbo].[MicSpecimenOrgSensAntibiotics]								AS SPECANTI	ON	SPEC.SpecimenID=SPECANTI.SpecimenID
--LEFT JOIN	[Livedb].[dbo].[NurQueryResults]											AS NQR		ON INFECT.VisitID=NQR.VisitID AND NQR.QueryID='CCICVC007' AND MAX(NQR.DATETIME)		 




WHERE FirstLocationID NOT IN ('NPREV','LAB-RIVER','LAB-PNP')  
--AND ((CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate) OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))
AND (CONVERT(varchar(10),INFECT.FirstIsolatedDateTime,23) BETWEEN @StartDate AND @EndDate)


--AND INFECT.VisitID='6012015426'



  ORDER BY [CollectedDate]



