/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
ProviderID																													AS 'Facility Provider ID (mnemonic)'
-- START OF NAME SPLIT--
		 --Start of First_Name--
  		  ,SUBSTRING(Name,CHARINDEX(',',Name)+1,(CASE WHEN CHARINDEX(' ',Name,CHARINDEX(',',Name)+1)=0 THEN LEN(Name)
		   ELSE CHARINDEX(' ',Name,CHARINDEX(',',Name)+1)-CHARINDEX(',',Name) END))											AS 'Provider First Name'

		  --Start of Last Name--
	      ,CASE WHEN Name NOT LIKE '%,%' THEN Name ELSE LEFT(Name, CHARINDEX(',',Name)- 1)
		   END																												AS 'Provider Last Name'
-- END OF NAME SPLIT-- 
,NationalProviderIdNumber																						AS 'NPI#'
,ISNULL(LicenseNumber,'')																									AS 'Provider License Number (if available, not mandatory) '      

  FROM [Livedb].[dbo].[DMisProvider]

  WHERE NationalProviderIdNumber IS NOT NULL