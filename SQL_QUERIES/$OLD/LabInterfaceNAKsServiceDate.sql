Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()),-1)
SET @EndDate=   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -1)

SELECT 
	   AV.[AccountNumber]
	  ,CONVERT(varchar(10),AV.ServiceDateTime,23) AS 'Service Date'

-- START OF NAME SPLIT
		  --Start of Last Name--
	      ,CASE WHEN AV.Name NOT LIKE '%,%' THEN AV.Name ELSE LEFT(AV.Name, CHARINDEX(',',AV.Name)- 1)
		   END AS 'Last Name'

		 --Start of First_Name--
  		  ,SUBSTRING(AV.Name,CHARINDEX(',',AV.Name)+1,(CASE WHEN CHARINDEX(' ',AV.Name,CHARINDEX(',',AV.Name)+1)=0 THEN LEN(AV.Name)
		   ELSE CHARINDEX(' ',AV.Name,CHARINDEX(',',AV.Name)+1)-CHARINDEX(',',AV.Name) END)) AS 'First Name'

		 --Start of Middle Name-- 
		  ,CASE WHEN CHARINDEX(' ',AV.Name,CHARINDEX(',',AV.Name)+1) = 0 THEN ' 'ELSE SUBSTRING(AV.Name,CHARINDEX(' ',AV.Name,CHARINDEX(',',AV.Name)+1)+1,1) 
		   END AS 'Middle Name'
-- END OF NAME SPLIT-- 
   
	  ,CONVERT(varchar(10),AV.BirthDateTime,101) AS 'Date of Birth'
	  ,LSIAud.[Status]
      ,LSIAud.[Error]
      ,LSIAud.[InterfaceID]
	  ,(SELECT DISTINCT LS.SpecimenNumber
	   FROM [Livedb].[dbo].[LabSpecimens] LS
	   WHERE LS.SpecimenID=LSIAud.SpecimenID) AS 'Speciment Number'

  FROM [Livedb].[dbo].[LabSpecimenInterfaceAuds] LSIAud
  JOIN [Livedb].[dbo].[AdmVisits] AV ON AV.[VisitID]=LSIAud.VisitID
  WHERE CONVERT(varchar(10),AV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
  AND LSIAud.Status='NAK'
  ORDER BY AV.AccountNumber