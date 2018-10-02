SELECT


DProv.Name									AS 'Provider Name'
,DProv.[NationalProviderIdNumber]			AS 'NPI'
,''											AS 'Credential'
,DProv.[SpecialtyAbsServiceID]				AS 'Speciality'
,''											AS 'Provider Primary Site Name (from Org Info tab)'
,''											AS 'Additional Site Name'
,''											AS 'Additional Site'
,''											AS 'Additional Site'
,''											AS 'Additional Site'
,ISNULL(CASE WHEN (SELECT CONVERT(DATE,PPEPay.StatusDateTime,23)
		FROM [Livedb].[dbo].[PpEmployeePayroll] PPEPay
			JOIN [Livedb].[dbo].[PpEmployees] PPE ON PPE.EmployeeID=PPEPay.EmployeeID
		WHERE PPE.UserID=DMisU.UserID AND PPEPay.Status IN('LEAVE','TERM','LT DIS','W COMP','RETIRED','DECEASED')) IS NOT NULL THEN 'No Longer Employed'
		END,'')									AS 'No Longer Employed'







FROM [Livedb].[dbo].[DMisProvider] DProv
	JOIN [Livedb].[dbo].[DMisUsers] DMisU ON DProv.ProviderID=DMisU.ProviderID
	JOIN [Livedb].[dbo].[PpEmployees] PPE ON PPE.UserID=DMisU.UserID
	JOIN [Livedb].[dbo].[PpEmployeePayroll] PPEPay ON PPE.EmployeeID=PPEPay.EmployeeID
WHERE DProv.[Active]='Y'
		AND EXISTS (SELECT DProvQ.Response 
					FROM [Livedb].[dbo].[DMisProviderQuery] DProvQ
 					WHERE (DProvQ.QueryID='EMPPHYS' ) AND  (DProvQ.Response='Y') AND DProv.ProviderID=DProvQ.ProviderID)
ORDER BY PPEPay.HireDateTime
