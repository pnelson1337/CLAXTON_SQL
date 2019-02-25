SELECT --DISTINCT

 PPEmp.Name																		AS 'Name'
,PPEPay.Dept																	AS 'Department Number'
,DEPT.ValueID +' ' + '-' +' ' +  DEPT.Name										AS 'Department Full'		
,PPPOS.Title																	AS 'Job Title'

FROM [Livedb].[dbo].[PpEmployees] PPEmp
JOIN		[Livedb].[dbo].[PpEmployeePayroll]		AS PPEPay		ON PPEPay.EmployeeID=PPEmp.EmployeeID
LEFT JOIN	[Livedb].[dbo].[DPpPositions]			AS PPPOS		ON PPEPay.PositionNumber=PPPOS.PositionID AND Active='Y'
LEFT JOIN	[Livedb].[dbo].[DMisGlComponentValue]	AS DEPT			ON	PPEPay.Dept=DEPT.ValueID AND DEPT.ComponentID='DPT' and DEPT.Active='Y'

WHERE PPEPay.Status IN ('ACTIVE')
--AND PPEmp.Name LIKE ('%NELSON%')






