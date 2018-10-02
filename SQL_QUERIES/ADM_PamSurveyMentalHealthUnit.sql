SELECT DISTINCT

 AV.AccountNumber
--,AV.VisitID
,AV.Name
,AV.LocationID
,CONVERT(VARCHAR,BV.AdmitDateTime,101)						AS 'Admit Date'
,CASE	WHEN PAMREF.Response='Y'
		THEN 'REFUSED' 
		ELSE PAMCOMP.Response END							AS 'Pam Survey Completed?'  										
,ISNULL(PAMCOMPDATE.Response,'')							AS 'Pam Survey Completed Date?'



,CASE	WHEN PAMREF.Response='Y'
		THEN 'REFUSED' 
		ELSE PAMREL.Response END							AS 'Pam Release Signed?'  										
,ISNULL(PAMRELDATE.Response,'')								AS 'Pam Release Signed Date?'



,CASE	WHEN PAMREF.Response='Y'
		THEN 'REFUSED' 
		ELSE PAMREF.Response END							AS 'Pam Refused?'  										
,ISNULL(PAMREFDATE.Response,'')								AS 'Pam Refused Date?'

--,AVE.EventUserID											AS 'Registering Clerk'




FROM			[Livedb].[dbo].[AdmVisits]					AS AV
LEFT OUTER JOIN	[Livedb].[dbo].[BarVisits]					AS BV			ON AV.VisitID=BV.VisitID	
LEFT OUTER JOIN	[Livedb].[dbo].[AdmInsuranceQueries]		AS PAMCOMP		ON AV.VisitID=PAMCOMP.VisitID AND PAMCOMP.QueryID='MCDPAMCMPT'
LEFT OUTER JOIN	[Livedb].[dbo].[AdmInsuranceQueries]		AS PAMCOMPDATE	ON AV.VisitID=PAMCOMPDATE.VisitID AND PAMCOMPDATE.QueryID='MCDPAMCMPD'
LEFT OUTER JOIN	[Livedb].[dbo].[AdmInsuranceQueries]		AS PAMREL		ON AV.VisitID=PAMREL.VisitID AND PAMREL.QueryID='MCDPAMYN'
LEFT OUTER JOIN	[Livedb].[dbo].[AdmInsuranceQueries]		AS PAMRELDATE	ON AV.VisitID=PAMRELDATE.VisitID AND PAMRELDATE.QueryID='MCDPAMDATE'
INNER JOIN		[Livedb].[dbo].[AdmInsuranceQueries]		AS PAMREF		ON AV.VisitID=PAMREF.VisitID AND PAMREF.QueryID='MCDPAMREFS'
LEFT OUTER JOIN	[Livedb].[dbo].[AdmInsuranceQueries]		AS PAMREFDATE	ON AV.VisitID=PAMREFDATE.VisitID AND PAMREFDATE.QueryID='MCDPAMREFD'
--LEFT OUTER JOIN	[Livedb].[dbo].[AdmVisitEvents]				AS AVE			ON AV.VisitID=AVE.VisitID AND AVE.Code='ENADMIN' 



WHERE AV.LocationID='3RD'
AND BV.AdmitDateTime >= DATEADD(DAY,-1, CAST(GETDATE() AS DATE)) AND BV.AdmitDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME)
ORDER BY [Admit Date]
