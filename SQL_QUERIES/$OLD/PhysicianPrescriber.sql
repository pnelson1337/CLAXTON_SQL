SELECT
'PRESCRIBER' AS 'FACILITY TYPE'
,'NEC543' AS 'CLIENT ID'
-- START OF NAME SPLIT--
		   -- Start of First Name--    
          ,SUBSTRING(DProv.Name,CHARINDEX(',',DProv.Name)+1,(CASE WHEN CHARINDEX(' ',DProv.Name,CHARINDEX(',',DProv.Name)+1)=0 THEN LEN(DProv.Name)
		   ELSE CHARINDEX(' ',DProv.Name,CHARINDEX(',',DProv.Name)+1)-CHARINDEX(',',DProv.Name) END)) AS 'FIRST_NM'

		  		  --Start of Last Name--
	      ,CASE WHEN DProv.Name NOT LIKE '%,%' THEN DProv.Name ELSE LEFT(DProv.Name, CHARINDEX(',',DProv.Name)- 1)
		   END AS 'LAST_NM'
-- END OF NAME SPLIT--  
,DProv.[NationalProviderIdNumber] AS 'NPI'
--,DMisU.[UserID]
,CONVERT(DATE,PPEPay.HireDateTime,23) AS 'Start Date'
,(SELECT CONVERT(DATE,PPEPay.StatusDateTime,23)
		FROM [Livedb].[dbo].[PpEmployeePayroll] PPEPay
			JOIN [Livedb].[dbo].[PpEmployees] PPE ON PPE.EmployeeID=PPEPay.EmployeeID
		WHERE PPE.UserID=DMisU.UserID AND PPEPay.Status IN('LEAVE','TERM','LT DIS','W COMP','RETIRED','DECEASED')) AS 'End Date'

,DProv.[DeaNumber] AS 'DEA Number'
,DProv.[LicenseNumber] AS 'License Number'
,'FT' AS 'Employee Status' -- FT, PT, Ect.
,'' AS 'Taxonomy'
,'' AS 'Type of Prescriber'
,'' AS 'Class'
,DProv.[SpecialtyAbsServiceID] AS 'Specilization'
/*,(SELECT DProvQ.Response 
		FROM [Livedb].[dbo].[DMisProviderQuery] DProvQ
		WHERE (DProvQ.QueryID='EMPPHYS' ) AND  (DProvQ.Response='Y') AND DProv.ProviderID=DProvQ.ProviderID) AS 'Employed Physician'
*/


FROM [Livedb].[dbo].[DMisProvider] DProv
	JOIN [Livedb].[dbo].[DMisUsers] DMisU ON DProv.ProviderID=DMisU.ProviderID
	JOIN [Livedb].[dbo].[PpEmployees] PPE ON PPE.UserID=DMisU.UserID
	JOIN [Livedb].[dbo].[PpEmployeePayroll] PPEPay ON PPE.EmployeeID=PPEPay.EmployeeID
WHERE DProv.[Active]='Y'
		AND EXISTS (SELECT DProvQ.Response 
					FROM [Livedb].[dbo].[DMisProviderQuery] DProvQ
 					WHERE (DProvQ.QueryID='EMPPHYS' ) AND  (DProvQ.Response='Y') AND DProv.ProviderID=DProvQ.ProviderID)
ORDER BY PPEPay.HireDateTime
