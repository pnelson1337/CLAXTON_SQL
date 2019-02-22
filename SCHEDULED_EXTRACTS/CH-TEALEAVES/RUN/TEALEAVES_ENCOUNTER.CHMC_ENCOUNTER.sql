SET NOCOUNT ON

/*
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2018-02-01'
Set @EndDate='2018-02-28'
*/


SELECT 
'EMR'																				AS 'DataSource'
,CASE 
	WHEN AV.Status='ADM IN'				THEN 'I'
	WHEN AV.Status='DIS IN'				THEN 'I'
	WHEN AV.Status='DEP ER'				THEN 'E'
	WHEN AV.Status='REG ER'				THEN 'E'
	WHEN AV.Status='DIS ER'				THEN 'E'
	WHEN AV.Status='REG CLI'			THEN 'C'
	WHEN AV.Status='DEP CLI'			THEN 'C'
	WHEN AV.Status='DIS CLI'			THEN 'C'
	ELSE 'O'
	END																				AS 'PatientType'
,ISNULL(AV.LocationID,'')															AS 'Facility'
,ISNULL(AV.AccountNumber,'')														AS 'EncounterID'
,ISNULL(AV.UnitNumber,'')															AS 'PatientID'
,''																					AS 'NamePrefix'
--Start of First_Name--
,SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,
	(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 
	THEN LEN(BV.Name)
	ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)
	-CHARINDEX(',',BV.Name) END))													AS 'FirstName'
--Start of Middle Name-- 
,CASE 
	WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1) = 0 
	THEN ' ' 
	ELSE SUBSTRING(BV.Name,CHARINDEX(' ',BV.Name,
	CHARINDEX(',',BV.Name)+1)+1,1) END												AS 'MiddleName'
--Start of Last Name--
,CASE 
	WHEN BV.Name NOT LIKE '%,%' 
	THEN BV.Name 
	ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END								AS 'LastName'
,''																					AS 'NameSuffix'
,REPLACE(ISNULL(BV.Address1,''),'\','/')											AS 'StreetAddress'
,REPLACE(ISNULL(BV.Address2,''),'\','/')											AS 'StreetAddress2'
,ISNULL(BV.City,'')																	AS 'City'
,ISNULL(BV.StateProvince,'')														AS 'State'
,ISNULL(BV.PostalCode,'')															AS 'ZipCode'
,ISNULL(CONVERT(VARCHAR(8), BV.BirthDateTime,112),'')								AS 'BirthDate'
,ISNULL(AV.Sex,'')																	AS 'Gender'
,COALESCE(CONVERT(varchar(8),BV.ServiceDateTime,112), '') 
 + '' + 
 COALESCE(CONVERT(varchar(8),BV.AdmitDateTime,112), '')								AS 'EncounterDate'
,ISNULL(CONVERT(VARCHAR(8), BV.DischargeDateTime	,112),'')						AS 'DischargeDate'
,ISNULL(BV.InpatientServiceID,'')													AS 'TypeOfVisit'
,ISNULL(DMAS.Ub82Code,'')															AS 'SourceOfVisit'
,ISNULL(DMDD.Ub82Code,'')															AS 'DischargeStatusCode'
,ISNULL(CAST(BVF.ChargeTotal AS INT), 0)											AS 'Charges'
,CASE 
	WHEN AV.FinancialClassID = 'BC'			THEN '12'
	WHEN AV.FinancialClassID = 'CHA'		THEN '02'
	WHEN AV.FinancialClassID = 'WC'			THEN '08'
	WHEN AV.FinancialClassID = 'SLF'		THEN '04'
	WHEN AV.FinancialClassID = 'COM'		THEN '05'
	WHEN AV.FinancialClassID = 'COM-GHI'	THEN '05'
	WHEN AV.FinancialClassID = 'COM-PPO'	THEN '05'
	WHEN AV.FinancialClassID = 'COM-RMSCO'	THEN '05'
	WHEN AV.FinancialClassID = 'COM-SDEM'	THEN '05'
	WHEN AV.FinancialClassID = 'COM-UAS'	THEN '05'
	WHEN AV.FinancialClassID = 'HCOM'		THEN '05'
	WHEN AV.FinancialClassID = 'HMCD'		THEN '09'
	WHEN AV.FinancialClassID = 'HOTHR'		THEN '05'
	WHEN AV.FinancialClassID = 'MCD'		THEN '03'
	WHEN AV.FinancialClassID = 'MCR'		THEN '02'
	WHEN AV.FinancialClassID = 'NF'			THEN '13'
	WHEN AV.FinancialClassID = 'U'			THEN '11'
	WHEN AV.FinancialClassID = 'OTHERC'		THEN '11'
	WHEN AV.FinancialClassID = 'STP'		THEN '06'
	ELSE '11' END																	AS 'FinancialClassCode'
,DMFC.[Name]																		AS 'FinancialClassName'
,ISNULL(BV.PrimaryInsuranceID,'')													AS 'InsurancePlanCode'
,DMI.[Name]																			AS 'InsurancePlanName'
,''																					AS 'ICD-9PrimaryDiagnosisCode'
,ISNULL(BarDiag.DiagnosisCodeID,'')													AS 'ICD-10PrimaryDiagnosisCode'
,ISNULL(BarDiag.PresentOnAdmit,'')													AS 'PresentOnAdmissionFlag'
,''																					AS 'ICD-9PrincipalProcedureCode'
,ISNULL(AbsProc.DrgProcedure,'')													AS 'ICD-10PrincipalProcedureCode'				
,ISNULL(COALESCE(ADMIT.[ProviderID],PROV.AdmitID),'')								AS 'AdmittingPhysicianID'
,ISNULL(ADMIT.[Name],'')															AS 'AdmittingPhysicianName'
,ISNULL(COALESCE
 (ATTEND.[ProviderID],EMERG.[ProviderID],PROV.AttendID,PROV.EmergencyID),'')		AS 'AttendingPhysicianID'
,COALESCE(ATTEND.[Name],EMERG.[Name])												AS 'AttendingPhysicianName'
,ISNULL(BSP.ProviderID,'')															AS 'OperatingPhysicianID'
,ISNULL(BSPName.[Name],'')															AS 'OperatingPhysicianName'				
,ISNULL(COALESCE(REFER.[ProviderID],PROV.ReferID),'')								AS 'ReferringPhysicianID'
,ISNULL(REFER.[Name],'')															AS 'ReferringPhysicianName'
,ISNULL(COALESCE(FAMILY.[ProviderID],PROV.FamilyID),'')								AS 'PrimaryCarePhysicianID'
,ISNULL(FAMILY.[Name],'')															AS 'PrimaryCarePhysicianName'
,''																					AS 'PlaceOfServiceCode'
,ISNULL(AbsDrg.AdmitDrg,'')															AS 'MSDRGCode'
,''																					AS 'Cost'
,ISNULL(CAST(BVF.ReceiptTotal AS INT), 0)											AS 'Payment'
,ISNULL(BV.MaritalStatusID,'')														AS 'MaritalStatus'
,CASE WHEN LANG.Response IN ('C','Chinese') THEN 'CHINESE'
	  WHEN LANG.Response IN ('E','English') THEN 'ENGLISH'
	  WHEN LANG.Response IN ('F','French')	THEN 'FRENCH'
	  WHEN LANG.Response IN ('O','Other')	THEN 'OTHER'
	  WHEN LANG.Response IN ('S','Spanish') THEN 'SPANISH'
	  ELSE 'UNKNOWN' END															AS 'SpokenLanguage'
,ETH.Response																		AS 'RaceCode'
,ISNULL(BE.EmployerID,'')															AS 'EmployerCode'												
,ISNULL(AV.Email,'')																AS 'EmailAddress'
,ISNULL(BV.HomePhone,'')															AS 'HomePhone'
,''																					AS 'CellPhone'


FROM				[CH_MTLIVE].[dbo].[AdmVisits]										AS AV								
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisits]										AS BV		 ON AV.VisitID = BV.VisitID	
INNER JOIN		    [CH_MTLIVE].[dbo].[BarVisitFinancialData]							AS BVF		 ON AV.VisitID = BVF.VisitID 
INNER JOIN			[CH_MTLIVE].[dbo].[AbsDrgData]										AS AbsDrg	 ON AbsDrg.VisitID=BV.VisitID
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarSurgicalProcedures]							AS BSP		 ON BV.BillingID=BSP.BillingID						AND BSP.SeqID='1'
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[DMisProvider]									AS BSPName	 ON BSP.ProviderID=BSPName.ProviderID
INNER JOIN			[CH_MTLIVE].[dbo].[BarEmployers]									AS BE		 ON BV.VisitID=BE.VisitID
INNER JOIN			[CH_MTLIVE].[dbo].[BarDiagnoses]									AS BarDiag	 ON BarDiag.BillingID=BV.BillingID					AND BarDiag.DiagnosisSeqID='1'
INNER JOIN			[CH_MTLIVE].[dbo].[DMisInsurance]									AS DMI		 ON BV.PrimaryInsuranceID=DMI.InsuranceID
INNER JOIN			[CH_MTLIVE].[dbo].[DMisFinancialClass]								AS DMFC		 ON	AV.FinancialClassID=DMFC.ClassID
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[AbsDrgProcedures]								AS AbsProc	 ON BV.VisitID=AbsProc.VisitID						AND AbsProc.ProcedureSeqID='1'
INNER JOIN			[CH_MTLIVE].[dbo].[AdmVisitQueries]								AS ETH		 ON	AV.VisitID=ETH.VisitID							AND ETH.QueryID='ETHNICITY'
INNER JOIN			[CH_MTLIVE].[dbo].[AdmVisitQueries]								AS LANG		 ON	AV.VisitID=LANG.VisitID							AND LANG.QueryID='ADM.LANG'
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[DMisDischargeDisposition]						AS DMDD		 ON BV.DischargeDispositionID=DMDD.DispositionID
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[DMisAdmitSource]								AS DMAS		 ON BV.AdmitSourceID=DMAS.AdmitSourceID
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisitProviders]								AS ADMIT	 ON BV.VisitID=ADMIT.VisitID						AND ADMIT.VisitProviderTypeID='Admitting'
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisitProviders]								AS ATTEND	 ON BV.VisitID=ATTEND.VisitID						AND ATTEND.VisitProviderTypeID='Attending'
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisitProviders]								AS EMERG	 ON BV.VisitID=EMERG.VisitID						AND EMERG.VisitProviderTypeID='Emergency'										
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisitProviders]								AS REFER	 ON BV.VisitID=REFER.VisitID						AND REFER.VisitProviderTypeID='Referring'
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[BarVisitProviders]								AS FAMILY	 ON BV.VisitID=FAMILY.VisitID						AND FAMILY.VisitProviderTypeID='Family'
LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[AdmProviders]									AS PROV		 ON BV.VisitID=PROV.VisitID					
--LEFT OUTER JOIN		[CH_MTLIVE].[dbo].[AbsOperationSurgeons]							AS SURGEON	 ON BV.VisitID=SURGEON.VisitID						AND SURGEON.ProviderSeqID='1' AND SURGEON.OperationSeqID='1'

WHERE AV.InpatientOrOutpatient IN ('I','O')
--AND ((CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate) OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))


AND (BV.ServiceDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0) AND BV.ServiceDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) OR (BV.AdmitDateTime>= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0) AND BV.AdmitDateTime < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) ))


ORDER BY EncounterDate, BV.AccountNumber
