DECLARE @STARTDATE DATE, @ENDDATE DATE

SET @STARTDATE	= '2018-07-01'
SET @ENDDATE	= '2018-07-31'

SELECT 

SSPROV.ProviderID
,SUM(SSPROV.TimeAllocated)									AS 'Total Allocated (MIN)'
,SUM(CASE WHEN SSPROV.ProviderID IN ('BASPY','HEIG') THEN (SSPROV.TimeAllocated / 3) 
		  WHEN SSPROV.ProviderID IN ('KETS')		 THEN SSPROV.TimeAllocated - (CASE WHEN SSPROV.ProviderID IN ('HEIG') THEN (SSPROV.TimeAllocated / 3) END)  
		ELSE SSPROV.TimeAllocated END)	'TOTAL ALLOCATED CONVERTED'

,SUM(SSPROV.TimeOther)										AS 'Total Other (MIN)'
,SUM(SSPROV.TimeUsed)										AS 'Total Used (MIN)'
FROM [Livedb].[dbo].[SchStatsProfileProvs]					AS SSPROV


WHERE CONVERT(VARCHAR(10),SSPROV.DateTime,101) BETWEEN @STARTDATE AND @ENDDATE


GROUP BY ProviderID,ProviderGroupID