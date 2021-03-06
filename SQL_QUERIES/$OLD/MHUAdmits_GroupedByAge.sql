/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

((0 + CONVERT(Char(8),GETDATE(),112) - CONVERT(Char(8),BV.BirthDateTime,112)) / 10000) - DATEDIFF(YEAR,BV.AdmitDateTime,GETDATE())  AS 'Age'
,COUNT(BV.VisitID)																	 AS 'Total Admits'


FROM		[Livedb].[dbo].[BarVisits]			AS BV
LEFT JOIN	[Livedb].[dbo].[AdmVisits]			AS AV		ON BV.VisitID=AV.VisitID

WHERE BV.AdmitDateTime BETWEEN '2017-01-01' AND '2017-12-31'
AND AV.LocationID='3RD'

GROUP BY ((0 + CONVERT(Char(8),GETDATE(),112) - CONVERT(Char(8),BV.BirthDateTime,112)) / 10000) - DATEDIFF(YEAR,BV.AdmitDateTime,GETDATE())

ORDER BY Age
