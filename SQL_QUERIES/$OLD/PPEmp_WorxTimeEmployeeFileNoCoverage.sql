SELECT * FROM (

SELECT
'150559686'																		AS 'CoFEIN'
,''																				AS 'Client_EEId'
,REPLACE(PPEmp.[UniquePublicIdentifier],'-','')									AS 'TIN(SSN)'

-- START OF NAME SPLIT--
		  --Start of Last Name--
		 ,CASE WHEN PPEmp.SortName NOT LIKE '%,%' THEN PPEmp.SortName ELSE LEFT(PPEmp.SortName, CHARINDEX(',',PPEmp.SortName)- 1)
		   END AS 'LastName'
		 
		 --Start of First_Name--
  		  ,SUBSTRING(PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1,(CASE WHEN CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1)=0 THEN LEN(PPEmp.SortName)
		   ELSE CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1)-CHARINDEX(',',PPEmp.SortName) END)) 
			   AS 'FirstName'

		 --Start of Middle Name-- 
		  ,CASE WHEN CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1) = 0 THEN ' 'ELSE SUBSTRING(PPEmp.SortName,CHARINDEX(' ',PPEmp.SortName,CHARINDEX(',',PPEmp.SortName)+1)+1,1) 
		   END AS 'MiddleName'

		 
-- END OF NAME SPLIT--  
,''																				AS 'Suffix'
,CONVERT(VARCHAR,PPEmp.[BirthDateTime],101)										AS 'DateofBirth'
,PPEmp.[Address1]																AS 'Address1'
,ISNULL(PPEmp.[Address2],'')													AS 'Address2'
,PPEmp.[City]																	AS 'City'
,PPEmp.[State]																	AS 'State'
,CASE WHEN PPEmp.[State]='ON' THEN 'CAN' ELSE 'US' END							AS 'Country'
,PPEmp.[PostalCode]																AS 'PostalCode'
,CONVERT(VARCHAR,PPEPay.HireDateTime,101)										AS 'OriginalHireDate'

,CASE WHEN PPEPay.Status IN('LEAVE','TERM','LT DIS','W COMP','RETIRED','DECEASED') 
		THEN CONVERT(VARCHAR,PPEPay.[StatusDateTime],101)	ELSE ''
		END																		AS 'TermDate'

,''																				AS 'RehireDate'
,CASE WHEN PPEPay.EmployeeType IN ('FTSAL','FTHRL','TFT') 
	THEN 'FTE' 
	ELSE 'VHE' END															    AS 'EmpType'
,'CH RG'																		AS 'MeasurementGroup'
,'MONTHLY'																		AS 'PayPeriodName'
,''																				AS 'EmployeeGroupName'
,''																				AS 'EEStatusDate'







FROM [Livedb].[dbo].[PpEmployees] PPEmp
JOIN [Livedb].[dbo].[PpEmployeePayroll] PPEPay ON PPEPay.EmployeeID=PPEmp.EmployeeID
LEFT JOIN [Livedb].[dbo].[PpEmployeeWithholdings] PPEWITH31	ON PPEmp.EmployeeID=PPEWITH31.EmployeeID



) AS X




ORDER BY TermDate




