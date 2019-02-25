SELECT

 PPEmp.Name																		AS 'Name'			
,PPEmp.UniquePublicIdentifier													AS 'SS#'
,CASE WHEN PPEPay.Status IN('LEAVE','TERM','LT DIS','W COMP','RETIRED','DECEASED') 
		THEN CONVERT(VARCHAR,PPEPay.[StatusDateTime],101)	ELSE ''
		END																		AS 'DOT'
,CONVERT(VARCHAR,PPEPay.HireDateTime,101)										AS 'DOH'
,PPEPay.YearlySalary															AS 'Salary'
,PPEPay.EmployeeType															AS 'Type'
,PPEPay.Status																	AS 'Status'	
,CONVERT(VARCHAR(10),PPEPay.StatusDateTime,101)									AS 'Status Date'
,PPEPay.Contract																AS 'Contract'





FROM [Livedb].[dbo].[PpEmployees] PPEmp
JOIN [Livedb].[dbo].[PpEmployeePayroll] PPEPay ON PPEPay.EmployeeID=PPEmp.EmployeeID

WHERE CAST(PPEPay.StatusDateTime AS DATE) BETWEEN @StartDate AND @EndDate
AND PPEPay.Status IN (@Status) 


ORDER BY PPEPay.StatusDateTime





