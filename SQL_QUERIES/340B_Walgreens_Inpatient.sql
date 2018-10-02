Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)*/

SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, DAY(GETDATE())-1)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, DAY(GETDATE())-1)

SELECT

		  bv.[AccountNumber] AS 'PATIENT_ID'
		  
-- START OF NAME SPLIT--
		  		  --Start of Last Name--
	      ,CASE WHEN bv.Name NOT LIKE '%,%' THEN bv.Name ELSE LEFT(bv.Name, CHARINDEX(',',bv.Name)- 1)
		   END AS 'LAST_NM'

		   -- Start of First Name--    
          ,SUBSTRING(bv.Name,CHARINDEX(',',bv.Name)+1,(CASE WHEN CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)=0 THEN LEN(bv.Name)
		   ELSE CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)-CHARINDEX(',',bv.Name) END)) AS 'FIRST_NM'
-- END OF NAME SPLIT--  
		  ,CONVERT(varchar(10),bv.[BirthDateTime],120) AS 'DOB'
		  ,prm.DrugID AS 'ORDER_ID'
	      ,adv.[LocationID] AS 'LOCATION_ID'
		  ,(SELECT prov.[NationalProviderIdNumber]
		    FROM [Livedb].[dbo].[DMisProvider] prov  
		    WHERE pr.[ProviderID]=prov.[ProviderID]) AS 'NPI'

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
				 AS 'DIAGNOSIS_CD'
--END DIAGNOSIS IN SINGLE CELL--
		  ,'ICD-10' AS DIAGNOSIS_CD_TYP
		  ,CONVERT(varchar(10),pr.[EnterDateTime],120) AS 'COV_EFFECTIVE_DT'
		  ,dpdd.GenericID AS 'GPI'
		  --GCN--




		  FROM [Livedb].[dbo].[AdmVisits] adv
		  JOIN [Livedb].[dbo].[BarVisits] bv ON adv.[AccountNumber]=bv.[AccountNumber]
		  JOIN [Livedb].[dbo].[PhaRx] pr ON adv.[VisitID]=pr.[VisitID]
		  --JOIN [Livedb].[dbo].[DMisProvider] prov ON  pr.[ProviderID]=prov.[ProviderID]
		  JOIN [Livedb].[dbo].[PhaRxMedications] prm ON pr.PrescriptionID=prm.PrescriptionID
		  JOIN [Livedb].[dbo].[DPhaDrugData] dpdd ON prm.DrugID=dpdd.DrugID

		  WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
		  AND adv.[Status] IN ('DIS IN', 'ADM IN')
		  --AND bv.VisitID='6011922139'
		  ORDER BY bv.[ServiceDateTime]
		  