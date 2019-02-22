SELECT 
CASE WHEN BV.Sex='M' THEN 'Mr.'
	 WHEN BV.Sex='F' THEN 'Ms.'
	 ELSE '' END																																		AS 'Title'
,SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 THEN LEN(BV.Name)
ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END))																		AS 'First Name'
,CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END														AS 'Last Name'
,CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1) = 0 THEN ' 'ELSE SUBSTRING(BV.Name,CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)+1,1) END	AS 'Middle'
,''																																						AS 'Suffix'
,''																																						AS 'Salutation'
,''																																						AS 'Optional'
,BV.Address1																																			AS 'Address'
,ISNULL(BV.Address2,'')																																	AS 'Address2'
,BV.City																																				AS 'City (CITY)'
,BV.StateProvince																																		AS 'State'
,BV.PostalCode																																			AS 'Zip'
,ISNULL(EMAIL.Email,'')																																	AS 'Email'
,UNI.UnitNumber																																			AS 'MedicalRecordNumber'
,CAST(UNI.SerAdmitDate AS DATE)																															AS 'MostRecentVisit'
,AV.LocationID																																			AS 'MostRecentService'


--,CASE WHEN BV.Sex='M' THEN 'MR.' ELSE 'MS.' END				AS 'Title'




FROM		[Livedb].[dbo].[AdmVisits]				AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]				AS BV		ON AV.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[AdmVisitPatientEmail]	AS EMAIL	ON AV.VisitID=EMAIL.VisitID AND EMAIL.Usable='Y'
INNER JOIN (SELECT * FROM (SELECT * ,ROW_NUMBER() OVER (PARTITION BY X.UnitNumber ORDER BY X.SerAdmitDate DESC)	AS 'Seq'
			FROM (SELECT AV.VisitID	AS 'VisitID',AV.AccountNumber AS 'AccountNumber',AV.UnitNumber				AS 'UnitNumber'
			,ISNULL(BV.ServiceDateTime,BV.AdmitDateTime)														AS 'SerAdmitDate'
			FROM	  [Livedb].[dbo].[AdmVisits]	AS AV
			LEFT JOIN [Livedb].[dbo].[BarVisits]	AS BV		ON AV.VisitID=BV.VisitID
			) AS X WHERE X.UnitNumber IS NOT NULL)	AS Y WHERE Y.Seq='1' AND Y.SerAdmitDate IS NOT NULL)		AS UNI				ON UNI.VisitID=AV.VisitID


WHERE BV.Address1 IS NOT NULL
AND BV.PostalCode IS NOT NULL
AND UNI.SerAdmitDate > '2009-01-01'



ORDER BY Address