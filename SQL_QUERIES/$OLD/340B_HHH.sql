Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)

SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, DAY(GETDATE())-1)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, DAY(GETDATE())-1)
*/
SET @StartDate= DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()),-56)
SET @EndDate=   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -49)

SELECT
        'CLAXTONHEPBURN' AS 'HHHN Client ID'      
	   ,av.UnitNumber AS 'Medical Record Code'

-- START OF NAME SPLIT--
		 --Start of First_Name--
  		  ,SUBSTRING(av.Name,CHARINDEX(',',av.Name)+1,(CASE WHEN CHARINDEX(' ',av.Name,CHARINDEX(',',av.Name)+1)=0 THEN LEN(av.Name)
		   ELSE CHARINDEX(' ',av.Name,CHARINDEX(',',av.Name)+1)-CHARINDEX(',',av.Name) END)) AS 'First Name'

		  --Start of Last Name--
	      ,CASE WHEN av.Name NOT LIKE '%,%' THEN av.Name ELSE LEFT(av.Name, CHARINDEX(',',av.Name)- 1)
		   END AS 'Last Name'
-- END OF NAME SPLIT--

	  ,convert(varchar(10),av.BirthDateTime,101) AS 'Birth Date'
	  ,av.Sex AS  'Sex'
	  ,av.City AS 'City'
	  ,av.StateProvince AS 'State'
	  ,av.PostalCode AS 'Postal Code'
	  ,av.LocationID AS 'Location'
	  ,convert(varchar(10),bv.ServiceDateTime,101) AS 'Visit Date'
	  ,prov.NationalProviderIdNumber AS 'Prescriber NPI'
	  ,prov.DeaNumber AS 'Prescriber DEA'
	  ,'' 'Pharmacy NPI'
	  ,'' 'eRX Number'
	  ,prov.[Name] AS 'Prescriber Last, First'
	  ,(SELECT dloc.[Name] FROM Livedb.dbo.DMisLocation dloc 
		WHERE (dloc.LocationID = av.LocationID)) AS 'Location Code Name'
	  ,av.Status AS 'Encounter Type'
	  ,av.InpatientOrOutpatient AS 'Inpatient or Outpatient'
-- START OF NAME SPLIT--
		 --Start of First_Name--
  		  ,SUBSTRING(prov.[Name],CHARINDEX(',',prov.[Name])+1,(CASE WHEN CHARINDEX(' ',prov.[Name],CHARINDEX(',',prov.[Name])+1)=0 THEN LEN(prov.[Name])
		   ELSE CHARINDEX(' ',prov.[Name],CHARINDEX(',',prov.[Name])+1)-CHARINDEX(',',prov.[Name]) END)) AS 'FIRST NAME OF PROVIDER'


		  --Start of Last Name--
	      ,CASE WHEN prov.[Name] NOT LIKE '%,%' THEN prov.[Name] ELSE LEFT(prov.[Name], CHARINDEX(',',prov.[Name])- 1)
		   END AS 'LAST NAME OF PROVIDER'
-- END OF NAME SPLIT--  
	  ,'10' AS 'DIAGNOSIS CODE QUALIFIER'
	  		
-- START DIAGNOSIS CODES IN A SINGLE CELL PER PATIENT ENCOUNTER--
				,ISNULL ((SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '1') AND (bv.VisitID = absdd.VisitID))  +
				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '2')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '2')  AND (bv.VisitID = absdd.VisitID)) END +

				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '3')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '3')  AND (bv.VisitID = absdd.VisitID)) END +

				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '4')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '4')  AND (bv.VisitID = absdd.VisitID)) END +

				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '5')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '5')  AND (bv.VisitID = absdd.VisitID)) END +

				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '6')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '6')  AND (bv.VisitID = absdd.VisitID)) END +
		 				
				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '7')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '7')  AND (bv.VisitID = absdd.VisitID)) END +

				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '8')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '8')  AND (bv.VisitID = absdd.VisitID)) END +
						
				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '9')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '9')  AND (bv.VisitID = absdd.VisitID)) END +								

				CASE 
				WHEN (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '10')  AND (bv.VisitID = absdd.VisitID)) IS NULL THEN '' 
				ELSE + '*' + (SELECT absdd.Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses] absdd WHERE (absdd.DiagnosisSeqID = '10')  AND (bv.VisitID = absdd.VisitID)) END 
				,'')
				 AS 'Diagnosis Codes ICD10'
--END DIAGNOSIS IN SINGLE CELL--

	  ,av.[AccountNumber] AS 'Encounter ID'


  FROM [Livedb].[dbo].[AdmVisits] av
  JOIN [Livedb].[dbo].[BarVisits] bv ON av.VisitID=bv.VisitID
  JOIN [Livedb].[dbo].[BarVisitProviders]bvp ON bv.VisitID=bvp.VisitID AND bvp.VisitProviderTypeID='Attending'
  JOIN [Livedb].[dbo].[DMisProvider]prov on bvp.ProviderID=prov.ProviderID
  		  

 WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
 AND av.[Status] IN ('ADM IN', 'REG CLI', 'DIS IN')
 AND prov.DeaNumber IS NOT NULL
 ORDER BY bv.ServiceDateTime

