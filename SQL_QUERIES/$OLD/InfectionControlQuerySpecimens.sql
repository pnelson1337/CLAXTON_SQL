
SET NOCOUNT ON
Declare @StartDate DateTime,@EndDate DateTime
Set @StartDate='2017-01-01'
Set @EndDate='2017-10-31'




SELECT

BV.[Name]																					AS 'PatientName'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)													AS 'DateOfBirth'
,BV.UnitNumber																				As 'MedicalRecord#'
,BV.AccountNumber


,COALESCE(CONVERT(VARCHAR(10),BV.ServiceDateTime,101), '') 
 + '' + 
 COALESCE(CONVERT(VARCHAR(10),BV.AdmitDateTime,101), '')									AS 'FacilityDate'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')										AS 'AdmitDate'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')									AS 'DischargeDate'
,SPEC.SpecimenNumber
,SPEC.Source																				AS 'SourceID'
,DMicSrc.Name																				AS 'SourceName'
,CONVERT(VARCHAR(10),SPEC.CollectionDateTime,101)											AS 'CollectedDate'
,SPEC.OrderLocationID																		AS 'CollectedLocation'
,ISNULL((SELECT INFECT.FirstVerifiedDateTime
	FROM [Livedb].[dbo].[LabInfectionControlData] AS INFECT
	WHERE SPEC.VisitID=INFECT.VisitID 
	AND SPEC.SpecimenNumber=INFECT.FirstSpecimen 
	AND MIC1.Name=INFECT.OrganismOrTestName),'')											AS 'Reported Date'
,MIC1.OrganismID
,ISNULL(MIC1.Name,'')																		AS 'OrganismName'
,AV.LocationID																				AS 'LastLocation'
,CASE 
	WHEN RESP.Name IS NOT NULL 
	THEN 'YES' ELSE 'NO' END																AS 'CentralLine(Y/N)'
,UPPER(ISNULL(RESP.Name,'')	)																AS 'CentralLineType'

,CASE
	WHEN (SELECT TOP 1 NQR.VisitID
			FROM [NurQueryResults]NQR 
			WHERE NQR.QueryID='CCIUC021' AND NQR.VisitID=SPEC.VisitID) IS NOT NULL 
	THEN 'YES' ELSE 'NO' END																AS 'UrinaryCatheter(Y/N)'


FROM		[Livedb].[dbo].[MicSpecimens]													AS SPEC
LEFT JOIN	[Livedb].[dbo].[BarVisits]														AS BV						ON	SPEC.VisitID=BV.VisitID	
LEFT JOIN	[Livedb].[dbo].[AdmVisits]														AS AV						ON  SPEC.VisitID=AV.VisitID
LEFT JOIN (SELECT MIC.OrganismID,MIC.SpecimenID,ORGNAME.Name,MAX(MIC.ResultSeqID)			AS 'Max Sequence Number' 
			FROM [MicSpecimenOrganisms] AS MIC
			LEFT JOIN [DMicOrganisms]	AS ORGNAME	ON ORGNAME.OrganismID=MIC.OrganismID	
			GROUP BY MIC.OrganismID,MIC.SpecimenID,ORGNAME.Name)							AS MIC1						ON MIC1.SpecimenID=SPEC.SpecimenID	
LEFT JOIN (SELECT NQR1.VisitID,NQR1.Response,GR.Name,MAX(NQR1.DateTime)						AS 'Max Response Date' 
			FROM [NurQueryResults] AS NQR1
			INNER JOIN [DMisGroupResponseElements]											AS GR						ON GR.CodeID=NQR1.Response AND GR.GroupResponseID='CCICVC007'
			WHERE NQR1.QueryID='CCICVC007'
			GROUP BY NQR1.VisitID,NQR1.Response,GR.Name)									AS RESP						ON SPEC.VisitID=RESP.VisitID
LEFT JOIN (SELECT AVE.VisitID,MAX(AVE.EffectiveDateTime)									AS 'MaxAdmissionDate'
			FROM [Livedb].[dbo].[AdmVisitEvents] AS AVE
			WHERE AVE.Code='ENADMIN'
			GROUP BY AVE.VisitID)															AS ADMITDATE				ON BV.VisitID=ADMITDATE.VisitID
LEFT JOIN [Livedb].[dbo].[DMicSources]														AS DMicSrc					ON SPEC.Source=DMicSrc.MicSourceID

WHERE (CONVERT(varchar(10),SPEC.CollectionDateTime,23) BETWEEN @StartDate AND @EndDate)
AND AV.LocationID NOT IN ('NPREV','LAB-RIVER','LAB-PNP') 
AND MIC1.SpecimenID IS NOT NULL 



ORDER BY BV.AccountNumber,SPEC.CollectionDateTime









