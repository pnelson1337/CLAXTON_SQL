SELECT 

	  bv.[AccountNumber] AS 'Account Number'
      ,CONVERT(varchar(10),bv.[ServiceDateTime],23) AS 'Service Date'

-- START OF NAME SPLIT--
	  		  --Start of Last Name--
	    ,CASE WHEN bv.Name NOT LIKE '%,%' THEN bv.Name ELSE LEFT(bv.Name, CHARINDEX(',',bv.Name)- 1)
		 END AS 'LName'

		 --Start of First_Name--
  		 ,SUBSTRING(bv.Name,CHARINDEX(',',bv.Name)+1,(CASE WHEN CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)=0 THEN LEN(bv.Name)
		  ELSE CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)-CHARINDEX(',',bv.Name) END)) AS FName

		 --Start of Middle Name-- 
		 ,CASE WHEN CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1) = 0 THEN ' 'ELSE SUBSTRING(bv.Name,CHARINDEX(' ',bv.Name,CHARINDEX(',',bv.Name)+1)+1,1) 
		  END AS Middle
-- END OF NAME SPLIT--
	  ,bv.[OutpatientLocationID] AS 'Location'
	  ,bv.[PrimaryInsuranceID] AS 'Primary Insurance'
	  ,bvfd.[BarStatus] AS 'Bar Status'
	  ,u.[Name] AS 'Registered By'
 
  FROM [Livedb].[dbo].[BarVisits] bv 
   JOIN [Livedb].[dbo].AdmVisitEvents ave ON bv.[VisitID]=ave.[VisitID]
   JOIN [Livedb].[dbo].DMisUsers u ON ave.[EventUserID]=u.[UserID]
   JOIN [Livedb].[dbo].[BarVisitFinancialData] bvfd ON bv.VisitID=bvfd.VisitID
  WHERE CONVERT(varchar(10),bv.[ServiceDateTime],23) BETWEEN '2017-09-01' AND '2017-09-05' AND bv.[OutpatientLocationID] IN ('DIAL','DIET','INFUSION','LAB-PNP') 
  		  AND (ave.[EventSeqID] = 1)
	      AND (ave.[Code] LIKE 'ENREG%')
  ORDER BY bv.[ServiceDateTime]
		  