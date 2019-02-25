Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE

/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)

SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, DAY(GETDATE())-1)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, DAY(GETDATE())-1)
*/

SET @StartDate= DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()),-12)
SET @EndDate=   DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -5)

SELECT
    
  	   SUBSTRING(av.Name,CHARINDEX(',',av.Name)+1,(CASE WHEN CHARINDEX(' ',av.Name,CHARINDEX(',',av.Name)+1)=0 THEN LEN(av.Name)
	   ELSE CHARINDEX(' ',av.Name,CHARINDEX(',',av.Name)+1)-CHARINDEX(',',av.Name) END)) AS 'First Name'

	  ,CASE WHEN av.Name NOT LIKE '%,%' THEN av.Name ELSE LEFT(av.Name, CHARINDEX(',',av.Name)- 1) END AS 'Last Name'
	  ,av.VisitID
	  

	  ,convert(varchar(10),av.BirthDateTime,101) AS 'Birth Date'
	  ,av.Sex AS  'Gender'
	  ,av.Address1 AS 'Address'
	  ,av.City AS 'City'
	  ,av.StateProvince AS 'State'
	  ,av.PostalCode AS 'Postal Code'
	  ,av.UnitNumber AS 'Medical Record Code'
	  ,av.AccountNumber AS 'Visit Code'
	  ,CASE WHEN av.InpatientOrOutpatient='O' THEN 'OUT' ELSE 'IN' END AS 'Outpatient'
	  ,'' AS 'Enterprise'
	  ,'' AS 'Corporation'
	  , CASE WHEN av.LocationID='CAN'  THEN 'SCH330211-04'
	         WHEN av.LocationID='HAMM' THEN 'SCH330211-02'
	         WHEN av.LocationID='CHHC' THEN 'SCH330211-01'
	         WHEN av.LocationID='HEUV' THEN 'SCH330211-03'
	         WHEN av.LocationID='MAD'  THEN 'SCH330211-06'
	         WHEN av.LocationID='WADD' THEN 'SCH330211-07'			 			 			 	  
			 ELSE 'SCH330211-00' END
			 AS 'Facility Code'
	  ,UPPER((SELECT dloc.[Name] FROM Livedb.dbo.DMisLocation dloc 
		WHERE (dloc.LocationID = av.LocationID))) AS 'Site'

	  ,av.LocationID AS 'Location'
	  ,'' AS 'Location Type'
	  ,'' AS 'Facility Sub'
	  ,'' AS 'Service Date'

	  ,(SELECT ave.EffectiveDateTime
		FROM AdmVisitEvents ave
		RIGHT JOIN AdmVisits av ON ave.Status=av.Status 
		WHERE ave.VisitID=av.VisitID
		AND ave.Code LIKE 'EN%'
		) AS 'Visit Date'
	  
	  ,av.ServiceDateTime
	  ,'NEC543' AS 'Client Code'
	  
	  


  FROM [Livedb].[dbo].[AdmVisits] av
  --JOIN [Livedb].[dbo].[BarVisits] bv ON av.VisitID=bv.VisitID
  		  

 WHERE CONVERT(varchar(10),av.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
 AND av.VisitID='6011976603'

--WHERE CONVERT(varchar(10),av.ServiceDateTime,23) BETWEEN '2017-10-02' AND '2017-10-08'
 --WHERE av.AccountNumber='26177394'
ORDER BY av.AccountNumber
