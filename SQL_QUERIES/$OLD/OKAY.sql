
SELECT 

-- START OF NAME SPLIT--
		 --Start of First_Name--
  		   SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 THEN LEN(BV.Name)
		   ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END)) AS 'firstname'

		  --Start of Last Name--
	      ,CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1)
		   END AS 'lastname'
-- END OF NAME SPLIT--  	

,BV.UnitNumber																	AS 'medrecno'
,''																				AS 'organization'
,BV.Address1																	AS 'address1'
,BV.Address2																	AS 'address2'
,BV.City																		AS 'city'
,BV.StateProvince																AS 'state'
,BV.PostalCode																	AS 'zipcode'
,BV.HomePhone																	AS 'phone'
,AV.Email																		AS 'email'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)										AS 'dob'
,BV.Sex																			AS 'gender'

FROM [Livedb].[dbo].[BarVisits]													AS BV
LEFT JOIN	[Livedb].[dbo].[AdmVisits]											AS AV		ON BV.VisitID=AV.VisitID
WHERE CAST(BV.DischargeDateTime AS DATE) BETWEEN '2018-03-01' AND '2018-03-01'
FOR XML PATH ('Client')