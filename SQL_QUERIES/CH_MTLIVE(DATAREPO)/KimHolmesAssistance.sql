DECLARE @STARTDATE VARCHAR(10) = '2019-01-01'
DECLARE @ENDDATE VARCHAR(10) = '2019-01-31'

SELECT

AV.Name
,AV.UnitNumber
,AV.AccountNumber
,AV.LocationID
,CAST(ISNULL(BV.ServiceDateTime,BV.AdmitDateTime) AS DATE)		AS 'Adm/Ser Date'
,ISNULL(DEAF.Response,'')										AS 'Telecom Device Needed?'
,ISNULL(LANG.Response,'')										AS 'Lanauge Service Needed?'
,ISNULL(PLNAME.Name,PLNAME1.Name)								AS 'Preferred Lanauge'
,ISNULL(BLIND.Response,'')										AS 'Legally Blind?'



FROM		[CH_MTLIVE].[dbo].[AdmVisits]						AS AV
LEFT JOIN	[CH_MTLIVE].[dbo].[BarVisits]						AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN	[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS DEAF			ON AV.VisitID=DEAF.VisitID AND DEAF.QueryID='ADM.DEAF'
LEFT JOIN	[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS LANG			ON AV.VisitID=LANG.VisitID AND LANG.QueryID='ADM.LANG.L'
LEFT JOIN	[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS PREFLANG		ON AV.VisitID=PREFLANG.VisitID AND PREFLANG.QueryID='ADM.LANG'
LEFT JOIN	[CH_MTLIVE].[dbo].[DMisGroupResponseElements]		AS PLNAME		ON PREFLANG.Response=PLNAME.CodeID AND PLNAME.GroupResponseID='ADM.LANG'
LEFT JOIN	[CH_MTLIVE].[dbo].[DMisGroupResponseElements]		AS PLNAME1		ON PREFLANG.Response=PLNAME1.Name AND PLNAME1.GroupResponseID='ADM.LANG'
LEFT JOIN	[CH_MTLIVE].[dbo].[AdmVisitQueries]					AS BLIND		ON AV.VisitID=BLIND.VisitID AND BLIND.QueryID='LGLBLIND'



WHERE (DEAF.Response='Y'OR LANG.Response='Y' OR BLIND.Response='Y')
AND CAST(ISNULL(BV.ServiceDateTime,BV.AdmitDateTime) AS DATE) BETWEEN @STARTDATE AND @ENDDATE	
ORDER BY [Adm/Ser Date]
