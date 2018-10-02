SELECT

 PPEmp.[UniquePublicIdentifier]							AS 'Employee SSN'

,CASE
WHEN PPEPay.[EmployeeType]='FTHRL' THEN 'N'
WHEN PPEPay.[EmployeeType]='FTSAL' THEN 'Y'
WHEN PPEPay.[EmployeeType]='TFT'   THEN 'N'
WHEN PPEPay.[EmployeeType]='PTHRL' THEN 'N'
WHEN PPEPay.[EmployeeType]='PTSAL' THEN 'Y'

ELSE 'UNKNOWN' END										AS 'Salary(Y/N)'

,CASE
WHEN PPEPay.[JobCode]='225' THEN 'Y'
WHEN PPEPay.[JobCode]='232' THEN 'Y'
ELSE 'N' END											AS 'Physician(Y/N)'





FROM [Livedb].[dbo].[PpEmployees]						AS PPEmp
JOIN [Livedb].[dbo].[PpEmployeePayroll]					AS PPEPay ON PPEPay.EmployeeID=PPEmp.EmployeeID


WHERE PPEPay.[Status]='ACTIVE' 
AND PPEPay.EmployeeType!='PDIEM'
AND PPEPay.EmployeeType!='PPDM'

ORDER BY 'Salary(Y/N)' , 'Physician(Y/N)'
