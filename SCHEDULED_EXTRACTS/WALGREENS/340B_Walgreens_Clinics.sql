Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)*/

SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, DAY(GETDATE())-1)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) /*ADD -X HERE TO REMOVE X DAYS */ , 0)

--SET @StartDate = '2018-01-01'
--SET @EndDate   = '2018-01-15'

SELECT

		  bv.UnitNumber																																												AS 'Patient_ID'
,CASE WHEN bv.Name NOT LIKE '%,%' THEN bv.Name ELSE LEFT(bv.Name, CHARINDEX(',',bv.Name)- 1) END																									AS 'Patient_NM'
,SUBSTRING(bv.Name,CHARINDEX(',',bv.Name)+1,(CASE WHEN CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)=0 THEN LEN(bv.Name) 
	ELSE CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)-CHARINDEX(',',bv.Name) END))																												AS 'First_NM'
,CONVERT(varchar(10),bv.[BirthDateTime],120)																																						AS 'DOB'
,''																																																	AS 'Order_ID'
,adv.[LocationID]																																													AS 'Location_ID'
,PROV.NationalProviderIdNumber																																										AS 'NPI'																																																		

																																																

  
-- START DIAGNOSIS CODES IN A SINGLE CELL PER PATIENT ENCOUNTER--
,ISNULL ((SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '1') AND (bv.VisitID = absdd.VisitID))  +
CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '2')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '2')  AND (bv.VisitID = absdd.VisitID)) END +

CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '3')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '3')  AND (bv.VisitID = absdd.VisitID)) END +

CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '4')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '4')  AND (bv.VisitID = absdd.VisitID)) END +

CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '5')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '5')  AND (bv.VisitID = absdd.VisitID)) END +

CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '6')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '6')  AND (bv.VisitID = absdd.VisitID)) END +
 		
CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '7')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '7')  AND (bv.VisitID = absdd.VisitID)) END +

CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '8')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '8')  AND (bv.VisitID = absdd.VisitID)) END +
		
CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '9')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '9')  AND (bv.VisitID = absdd.VisitID)) END +								

CASE 
	WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '10')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
	ELSE + ';' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '10')  AND (bv.VisitID = absdd.VisitID)) END 
,'')
																																																AS 'Diagnosis_CD'
,'ICD-10'																																														AS 'Diagnosis_CD_TYP'
,CONVERT(varchar(10),bv.ServiceDateTime,120)																																					AS 'COV_EFFECTIVE_DT'
,''																																																AS 'GPI'
,''																																																AS 'GCN'

FROM		[Livedb].[dbo].[AdmVisits]													AS adv
LEFT JOIN [Livedb].[dbo].[BarVisits]													AS bv									ON adv.[AccountNumber]=bv.[AccountNumber]
LEFT JOIN [Livedb].[dbo].[BarVisitProviders]											AS BVP									ON bv.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
LEFT JOIN [Livedb].[dbo].[DMisProvider]													AS PROV									ON BVP.ProviderID=PROV.ProviderID								

		 
WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate

AND adv.LocationID IN ('LIS','WADD','MAD','CAN','HEUV','HAMM','OHC','HHC','CHHC')
ORDER BY bv.[ServiceDateTime], Location_ID
		  