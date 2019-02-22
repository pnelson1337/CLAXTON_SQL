Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)*/

SET @StartDate= DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)


SELECT

SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 THEN LEN(BV.Name)
	ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END))																					AS 'PatientNameGiven'
,CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END																		AS 'PatientNameFamily'   
,BV.[Address1]																																							AS 'AddressStreet1'
,BV.[City]																																								AS 'AddressCity'
,BV.[StateProvince]																																						AS 'AddressState'
,BV.[PostalCode]																																						AS 'AddressPostalCode'
,[CH_MTLIVE].[dbo].[StripNonNumerics](                     LEFT(BV.HomePhone,CHARINDEX(')',BV.HomePhone))                         )										AS 'PhoneAreaCityCode'    
,[CH_MTLIVE].[dbo].[StripNonNumerics]( CASE WHEN BV.HomePhone NOT LIKE '(___)%' THEN BV.HomePhone ELSE SUBSTRING(BV.HomePhone,6,(LEN(BV.HomePhone)-5)) END)				AS 'PhoneLocalNumber'
,BV.[UnitNumber]																																						AS 'MRN'
,CONVERT(varchar(10),BV.[BirthDateTime],101)																															AS 'DateOfBirth'
,BV.[Sex]																																								AS 'AdministrativeSex'
,CASE WHEN LANG.Response ='S'							THEN 'spa' ELSE 'eng' END																						AS 'PrimaryLanguage'																												
,CASE WHEN AV.RaceID IN ('A','AI','C','J','V','F')		THEN '2028-9'
	  WHEN AV.RaceID = 'K'								THEN '2040-4'
	  WHEN AV.RaceID IN ('CH','G','NH','OP','S')		THEN '2076-8'
	  WHEN AV.RaceID = 'B'								THEN '2024-5'
	  WHEN AV.RaceID = 'I'								THEN '1002-5'
	  WHEN AV.RaceID = 'O'								THEN '2131-1'
	  WHEN AV.RaceID = 'W'								THEN '2106-3'
	  WHEN AV.RaceID = 'H'								THEN '2133-2'
	  END																																								AS 'Race'	

,CASE WHEN ETH.Response IN ('C','CH','H','M','MA','PR') THEN 'H'
	  WHEN ETH.Response = 'NH'							THEN 'N'
	  WHEN ETH.Response = 'U'							THEN 'U'
	  END																																								AS 'EthnicGroup'
 ,CASE WHEN AV.MaritalStatusID = 'D'					THEN 'D'
	   WHEN AV.MaritalStatusID = 'L'					THEN 'A'
	   WHEN AV.MaritalStatusID = 'M'					THEN 'M'
	   WHEN AV.MaritalStatusID = 'S'					THEN 'S'
	   WHEN AV.MaritalStatusID = 'SNL'					THEN 'A'
	   WHEN AV.MaritalStatusID = 'W'					THEN 'W'
	   END																																								AS 'MaritalStatus'
,ISNULL(EMAIL.Email,'')																																					AS 'Email'
,AV.Status																																								AS 'PatientClass'
,''																																										AS 'FacilityNumber'
,AV.AccountNumber																																						AS 'VisitNumber'
,REPLACE(CONVERT(VARCHAR(8), BV.[ServiceDateTime], 112)+CONVERT(VARCHAR(8), BV.[ServiceDateTime], 114), ':','') 														AS 'AdmitDateTime'
,REPLACE(CONVERT(VARCHAR(8), BV.DischargeDateTime, 112)+CONVERT(VARCHAR(8), BV.DischargeDateTime, 114), ':','')															AS 'DischargeDateTime'
,ADMITSRC.Ub82Code																																						AS 'AdmitSource'
,DISDISPO.Ub82Code																																						AS 'DischargeStatus'
,AV.LocationID																																							AS 'LocationCriteria'
,AV.LocationID																																							AS 'Location'
,''																																										AS 'MSDRG'
,ISNULL(ONEDIAG.Diagnosis,'')																																			AS 'DiagnosisPrimaryICD10'
,ISNULL(TWODIAG.Diagnosis,'')																																			AS 'Diagnosis2ICD10'
,ISNULL(THREEDIAG.Diagnosis,'')																																			AS 'Diagnosis3ICD10'
,''																																										AS 'IsDeceased'
,''																																										AS 'ICU'
,''																																										AS 'EDAdmit'
,BV.PrimaryInsuranceID																																					AS 'PrimaryPayerID'
,INS.Name																																								AS 'PrimaryPayerName'
,SUBSTRING(PROV.Name,CHARINDEX(',',PROV.Name)+1,(CASE WHEN CHARINDEX(' ',PROV.Name,CHARINDEX(',',PROV.Name)+1)=0 THEN LEN(PROV.Name)
	ELSE CHARINDEX(' ',PROV.Name,CHARINDEX(',',PROV.Name)+1)-CHARINDEX(',',PROV.Name) END))																				AS 'AttendingDoctorNameGiven'
,''																																										AS 'AttendingDoctorNameSecondGiven'
,CASE WHEN PROV.Name NOT LIKE '%,%' THEN PROV.Name ELSE LEFT(PROV.Name, CHARINDEX(',',PROV.Name)- 1) END																AS 'AttendingDoctorNameFamily'
,''																																										AS 'AttendingDoctorNameSuffix' 
,''																																										AS 'AttendingDoctorDegree'  
,PROV.NationalProviderIdNumber																																			AS 'AttendingDoctorNPI'
,ISNULL(PROV.SpecialtyAbsServiceID,'')																																	AS 'AttendingDoctorSpecialty'
,ISNULL(CPTONE.Code,'')																																					AS 'ProcedurePrimaryCPT'
,ISNULL(CPTWO.Code,'')																																					AS 'Procedure2CPT'
,ISNULL(CPTHREE.Code,'')																																				AS 'Procedure3CPT'


FROM					[CH_MTLIVE].[dbo].[AdmVisits]							AS AV
LEFT JOIN				[CH_MTLIVE].[dbo].[BarVisits]							AS BV			ON AV.[AccountNumber]=BV.[AccountNumber]
LEFT JOIN				[CH_MTLIVE].[dbo].[AdmVisitPatientEmail]				AS EMAIL		ON AV.VisitID=EMAIL.VisitID
--ADM QUERIES--
LEFT JOIN				[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS INST			ON INST.VisitID = BV.VisitID AND INST.QueryID = 'INST'
LEFT JOIN				[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS LANG			ON LANG.VisitID = BV.VisitID AND LANG.QueryID = 'ADM.LANG'
LEFT JOIN				[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS MHUEVAL		ON MHUEVAL.VisitID = BV.VisitID AND MHUEVAL.QueryID = 'MHU EVAL'
LEFT JOIN				[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS ETH			ON ETH.VisitID = BV.VisitID AND ETH.QueryID = 'ETHNICITY'
--DICTIONARIES--
LEFT JOIN				[CH_MTLIVE].[dbo].[DMisAdmitSource]					AS ADMITSRC		ON BV.AdmitSourceID=ADMITSRC.AdmitSourceID
LEFT JOIN				[CH_MTLIVE].[dbo].[DMisDischargeDisposition]			AS DISDISPO		ON BV.DischargeDispositionID=DISDISPO.DispositionID
LEFT JOIN				[CH_MTLIVE].[dbo].[DMisInsurance]						AS INS			ON BV.PrimaryInsuranceID=INS.InsuranceID AND INS.Active='Y'
--DIAGNOSIS CODES--
LEFT JOIN				[CH_MTLIVE].[dbo].[AbsDrgDiagnoses]					AS ONEDIAG		ON BV.VisitID=ONEDIAG.VisitID AND ONEDIAG.DiagnosisSeqID='1'
LEFT JOIN				[CH_MTLIVE].[dbo].[AbsDrgDiagnoses]					AS TWODIAG		ON BV.VisitID=TWODIAG.VisitID AND TWODIAG.DiagnosisSeqID='2'
LEFT JOIN				[CH_MTLIVE].[dbo].[AbsDrgDiagnoses]					AS THREEDIAG	ON BV.VisitID=THREEDIAG.VisitID AND THREEDIAG.DiagnosisSeqID='3'
--CPT CODES--
LEFT JOIN				[CH_MTLIVE].[dbo].[BarCptCodes]						AS CPTONE		ON BV.VisitID=CPTONE.VisitID AND CPTONE.CptSeqID='1'
LEFT JOIN				[CH_MTLIVE].[dbo].[BarCptCodes]						AS CPTWO		ON BV.VisitID=CPTWO.VisitID AND CPTWO.CptSeqID='2'
LEFT JOIN				[CH_MTLIVE].[dbo].[BarCptCodes]						AS CPTHREE		ON BV.VisitID=CPTHREE.VisitID AND CPTHREE.CptSeqID='3'
--PROVIDERS--
LEFT OUTER JOIN			[CH_MTLIVE].[dbo].[BarVisitProviders]					AS EMERG		ON BV.VisitID=EMERG.VisitID	AND EMERG.VisitProviderTypeID='Emergency'
LEFT JOIN				[CH_MTLIVE].[dbo].[DMisProvider]						AS PROV			ON EMERG.ProviderID=PROV.ProviderID AND PROV.Active='Y'										




WHERE CAST(BV.DischargeDateTime AS DATE) BETWEEN @StartDate AND @EndDate 
AND BV.PrimaryInsuranceID!='WEXFORD'
AND AV.Status LIKE 'DEP ER'
AND MHUEVAL.Response ='N'
			 
ORDER BY BV.ServiceDateTime