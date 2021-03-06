Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)
*/

SET @StartDate= '2017-11-21'					--DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, DAY(GETDATE())-1)
SET @EndDate=	'2017-11-21'					--DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + -1, DAY(GETDATE())-1)


SELECT 

 AV.PostalCode																											AS 'ZipCode'
,(0 + CONVERT(Char(8),GETDATE(),112) - CONVERT(Char(8),AV.BirthDateTime,112)) / 10000									AS 'Age'
,AVQ.Response																											AS 'Response'
,RESPDESC.Name																											AS 'Description'
,BVFD.ChargeTotal																										AS 'Total Charges'
,COALESCE(CONVERT(varchar(10),BV.ServiceDateTime,23), '') + '' + COALESCE(CONVERT(varchar(10),BV.AdmitDateTime,23), '') AS 'Service Date'
,AV.LocationID																											AS 'LocationID'

FROM			[Livedb].[dbo].[AdmVisitQueries]																		AS AVQ
INNER JOIN		[Livedb].[dbo].[AdmVisits]																				AS AV		ON AVQ.VisitID=AV.VisitID
LEFT OUTER JOIN [Livedb].[dbo].[BarVisits]																				AS BV		ON AVQ.VisitID=BV.VisitID
LEFT OUTER JOIN [Livedb].[dbo].[DMisGroupResponseElements]																AS RESPDESC	ON AVQ.Response=RESPDESC.CodeID AND RESPDESC.GroupResponseID='MARKET17'
LEFT OUTER JOIN	[Livedb].[dbo].[BarVisitFinancialData]																	AS BVFD		ON AVQ.VisitID=BVFD.VisitID
WHERE AVQ.QueryID='MARKET17Q'
AND (CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate 
	OR CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate)

ORDER BY [Service Date], LocationID