SELECT

 PPEmp.[UniquePublicIdentifier]							AS 'Employee SSN'
,PPEmp.[Number]											AS 'EID'
,''								AS 'Prefix'
-- START OF NAME SPLIT--
		 --Start of First_Name--
  		  ,SUBSTRING(PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1,(CASE WHEN CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1)=0 THEN LEN(PPEmp.SortName)
		   ELSE CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1)-CHARINDEX(',',PPEmp.SortName) END)) AS First

		 --Start of Middle Name-- 
		  ,CASE WHEN CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1) = 0 THEN ' 'ELSE SUBSTRING(PPEmp.SortName,CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1)+1,1) 
		   END AS Middle

		  --Start of Last Name--
	      ,CASE WHEN PPEmp.SortName NOT LIKE '%,%' THEN PPEmp.SortName ELSE LEFT(PPEmp.SortName, CHARINDEX(',',PPEmp.SortName)- 1)
		   END AS 'Last'
-- END OF NAME SPLIT--  
,'' AS 'Suffix'
,CONVERT(DATE,PPEmp.[BirthDateTime],23) AS 'DOB'
,PPEmp.[Sex] AS 'Sex'
,ISNULL(PPEmp.[MaritalStatusID],'') AS 'Marital Status'
,CASE WHEN PPEmp.[State]='ON' THEN 'CAN' ELSE 'US' END AS 'Country'
,PPEmp.[Address1] AS 'Address 1'
,ISNULL(PPEmp.[Address2],'') AS 'Address 2'
,PPEmp.[City] AS 'City'
,PPEmp.[State] AS 'State'
,PPEmp.[PostalCode] AS 'Zip'
,ISNULL(PPEmp.[HomePhone],'') AS 'Home Phone'
,'' AS 'Work Phone'
,ISNULL(UPPER(PPEmp.[EmailAddress]),'') AS 'Email'
,'26' AS 'Payroll Frequency'
,'24' AS 'Deduction Frequency'
,PPEPay.[YearlySalary] AS 'Gross Salary'
,PPEPay.[Dept] AS 'Location Number'

,(SELECT temp.Name
  FROM [Livedb].[dbo].[DMisGlComponentValue] temp
  WHERE PPEPay.Dept=temp.ValueID AND temp.ComponentID='DPT' ) AS 'Location'


  ,PPEPay.[Contract] AS 'Contract'
,PPEPay.[EmployeeType] AS 'Type'

,CASE 
WHEN PPEPay.[Contract] ='L200' AND PPEPay.[EmployeeType]='FTHRL' THEN '1199 Full Time Active'
WHEN PPEPay.[Contract] ='L200' AND PPEPay.[EmployeeType]='FTSAL' THEN '1199 Full Time Active'
WHEN PPEPay.[Contract] ='L200' AND PPEPay.[EmployeeType]='TFT'	 THEN '1199 Full Time Active'
WHEN PPEPay.[Contract] ='L200' AND PPEPay.[EmployeeType]='PTHRL' THEN '1199 Part Time Active'
WHEN PPEPay.[Contract] ='L200' AND PPEPay.[EmployeeType]='PTSAL' THEN '1199 Part Time Active'

WHEN PPEPay.[Contract] ='L721' AND PPEPay.[EmployeeType]='FTHRL' THEN 'LPN Full Time Active'
WHEN PPEPay.[Contract] ='L721' AND PPEPay.[EmployeeType]='FTSAL' THEN 'LPN Full Time Active'
WHEN PPEPay.[Contract] ='L721' AND PPEPay.[EmployeeType]='TFT'	 THEN 'LPN Full Time Active'
WHEN PPEPay.[Contract] ='L721' AND PPEPay.[EmployeeType]='PTHRL' THEN 'LPN Part Time Active'
WHEN PPEPay.[Contract] ='L721' AND PPEPay.[EmployeeType]='PTSAL' THEN 'LPN Part Time Active'

WHEN PPEPay.[Contract] ='RN' AND PPEPay.[EmployeeType]='FTHRL' THEN 'NYSNA Full Time Active'
WHEN PPEPay.[Contract] ='RN' AND PPEPay.[EmployeeType]='FTSAL' THEN 'NYSNA Full Time Active'
WHEN PPEPay.[Contract] ='RN' AND PPEPay.[EmployeeType]='TFT'	 THEN 'NYSNA Full Time Active'
WHEN PPEPay.[Contract] ='RN' AND PPEPay.[EmployeeType]='PTHRL' THEN 'NYSNA Part Time Active'
WHEN PPEPay.[Contract] ='RN' AND PPEPay.[EmployeeType]='PTSAL' THEN 'NYSNA Part Time Active'

WHEN PPEPay.[EmployeeType]='FTHRL' THEN 'Non-Bargaining Full Time Active'
WHEN PPEPay.[EmployeeType]='FTSAL' THEN 'Non-Bargaining Full Time Active'
WHEN PPEPay.[EmployeeType]='TFT'   THEN 'Non-Bargaining Full Time Active'
WHEN PPEPay.[EmployeeType]='PTHRL' THEN 'Non-Bargaining Part Time'
WHEN PPEPay.[EmployeeType]='PTSAL' THEN 'Non-Bargaining Part Time'

ELSE 'UNKNOWN' END														AS 'Job Class'








,PPEPay.Payroll AS 'Pay Group'
,PPEPay.[Dept] AS 'Department Number'

,(SELECT temp.Name
  FROM [Livedb].[dbo].[DMisGlComponentValue] temp
  WHERE PPEPay.Dept=temp.ValueID AND temp.ComponentID='DPT' ) AS 'Department'

,(SELECT temp.Title
  FROM [Livedb].[dbo].[DPpPositions] temp
  WHERE PPEPay.PositionNumber=temp.PositionID ) AS 'Title' 

,CASE WHEN PPEPay.EmployeeType IN ('FTSAL','FTHRL','TFT') THEN 'Y' ELSE 'N' END AS 'FTE'

,PPEPay.[HoursPerPeriod] / 2 AS 'Hours Per Week' 
,CONVERT(DATE,PPEPay.HireDateTime,23) AS 'Hire date'
,'' AS 'Eligibility Date'
,PPEPay.[Status] AS 'Status'
,'' AS 'Enrollment Status'
,(SELECT PPEPay.[StatusDateTime]
  FROM [Livedb].[dbo].[PpEmployeePayroll] PPEPay 
   WHERE PPEPay.EmployeeID=PPEmp.EmployeeID AND PPEPay.Status IN('LEAVE','TERM','LT DIS','W COMP','RETIRED','DECEASED')) AS 'Termination Date'

--,PPEPay.[Contract] AS 'Contract'
--,PPEPay.[EmployeeType] AS 'Type'


FROM [Livedb].[dbo].[PpEmployees] PPEmp
JOIN [Livedb].[dbo].[PpEmployeePayroll] PPEPay ON PPEPay.EmployeeID=PPEmp.EmployeeID

--WHERE PPEPay.BeingPaid='Y'
--WHERE PPEmp.Number='2954'
WHERE PPEPay.[Status]='ACTIVE' 
AND PPEPay.EmployeeType!='PDIEM'
--ORDER BY PPEPay.[HireDateTime]
ORDER BY [Job Class] 
