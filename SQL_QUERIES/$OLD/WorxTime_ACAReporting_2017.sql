SELECT 

'150559686'													AS 'CoFEIN'
,[Subscriber SSN]											AS 'EmpEIN'
,CASE WHEN [Subscriber SSN]	 = [Member SSN]	 THEN ''
	ELSE [Member SSN]	
	END														AS 'DepEIN'						
,[Member First Name]										AS 'FirstName'
,[Member Middle Initial]									AS 'MiddleName'
,[Member Last Name]											AS 'LastName'
,''															AS 'Suffix'
,CONVERT(VARCHAR(10),[Birth Date]	,101)					AS 'DOB'
,CONVERT(VARCHAR(10),MIN([Year Month Text])	,101)			AS 'StartDate'

,CASE 
 WHEN MAX([Year Month Text]) = '2017-01-01'	
 THEN '01/31/17'

 WHEN MAX([Year Month Text]) = '2017-02-01'	
 THEN '02/28/17'

 WHEN MAX([Year Month Text]) = '2017-03-01'	
 THEN '03/31/17'

 WHEN MAX([Year Month Text]) = '2017-04-01'	
 THEN '04/30/17'

 WHEN MAX([Year Month Text]) = '2017-05-01'	
 THEN '05/31/17'

 WHEN MAX([Year Month Text]) = '2017-06-01'	
 THEN '06/30/17'

 WHEN MAX([Year Month Text]) = '2017-07-01'	
 THEN '07/31/17'

 WHEN MAX([Year Month Text]) = '2017-08-01'	
 THEN '08/31/17'

 WHEN MAX([Year Month Text]) = '2017-09-01'	
 THEN '09/30/17'

 WHEN MAX([Year Month Text]) = '2017-10-01'	
 THEN '10/31/17'

 WHEN MAX([Year Month Text]) = '2017-11-01'	
 THEN '11/30/17'

 WHEN MAX([Year Month Text]) = '2017-12-01'	
 THEN '12/31/17'
 END														AS 'EndDate'
 ,CASE 
 WHEN [Relation Description] = 'Subscriber' THEN 'E'
 WHEN [Relation Description] = 'Wife'		THEN 'S'
 WHEN [Relation Description] = 'Husband'	THEN 'S'
 ELSE 'D' END												AS 'Relationship'				 		 
,'E'														AS 'EnrollStatus'
,''															AS 'OfferDate'




FROM [ACAReporting].[dbo].[2017]

GROUP BY 					
[Subscriber SSN],[Member SSN],[Member First Name],[Member Middle Initial],[Member Last Name],[Birth Date],[Relation Description]				
							
ORDER BY [EmpEIN], StartDate