SELECT
AV.Name

,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)														AS 'Admit Date'
,CONVERT(VARCHAR(5),BV.AdmitDateTime,108)														AS 'Admit Time'
,ISNULL(CONVERT(VARCHAR(5),FIRSTAM.DateTime,108),'')											AS '3AM CHECK'
,ISNULL(CONVERT(VARCHAR(5),SECONDAM.DateTime,108),'')											AS '7AM CHECK'
,ISNULL(CONVERT(VARCHAR(5),THIRDAM.DateTime,108),'')											AS '11AM CHECK'
,ISNULL(CONVERT(VARCHAR(5),FIRSTPM.DateTime,108),'')											AS '3PM CHECK'
,ISNULL(CONVERT(VARCHAR(5),SECONDPM.DateTime,108),'')											AS '7PM CHECK'
,ISNULL(CONVERT(VARCHAR(5),THIRDPM.DateTime,108),'')											AS '11PM CHECK'
--,AV.VisitID


FROM		[Livedb].[dbo].[AdmVisits]									AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]									AS BV ON AV.VisitID=BV.VisitID
LEFT JOIN (SELECT MAX(NQR.DateTime) AS 'DateTime', NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE  DATEPART(hh,NQR.DateTime) >= 00 AND DATEPART(hh,NQR.DateTime) <= 04
			AND CAST(NQR.DateTime AS DATE) = CAST(GETDATE()-@DAY AS DATE)		  
			  AND NQR.QueryID='CCPAIN066'
			  GROUP BY NQR.VisitID)								AS FIRSTAM			ON AV.VisitID=FIRSTAM.VisitID
			  
LEFT JOIN (SELECT MAX(NQR.DateTime) AS 'DateTime', NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE  DATEPART(hh,NQR.DateTime) >= 05 AND DATEPART(hh,NQR.DateTime) <= 09
			AND CAST(NQR.DateTime AS DATE) = CAST(GETDATE()-@DAY AS DATE)		  
			  AND NQR.QueryID='CCPAIN066'
			  GROUP BY NQR.VisitID)								AS SECONDAM			ON AV.VisitID=SECONDAM.VisitID
			  
LEFT JOIN (SELECT MAX(NQR.DateTime) AS 'DateTime', NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE  DATEPART(hh,NQR.DateTime) >= 10 AND DATEPART(hh,NQR.DateTime) <= 12
			AND CAST(NQR.DateTime AS DATE) = CAST(GETDATE()-@DAY AS DATE)		  
			  AND NQR.QueryID='CCPAIN066'
			  GROUP BY NQR.VisitID)								AS THIRDAM			ON AV.VisitID=THIRDAM.VisitID

LEFT JOIN (SELECT MAX(NQR.DateTime) AS 'DateTime', NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE  DATEPART(hh,NQR.DateTime) >= 12 AND DATEPART(hh,NQR.DateTime) <= 17
			AND CAST(NQR.DateTime AS DATE) = CAST(GETDATE()-@DAY AS DATE)		  
			  AND NQR.QueryID='CCPAIN066'
			  GROUP BY NQR.VisitID)								AS FIRSTPM			ON AV.VisitID=FIRSTPM.VisitID

LEFT JOIN (SELECT MAX(NQR.DateTime) AS 'DateTime', NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE  DATEPART(hh,NQR.DateTime) >= 18 AND DATEPART(hh,NQR.DateTime) <= 21
			AND CAST(NQR.DateTime AS DATE) = CAST(GETDATE()-@DAY AS DATE)		  
			  AND NQR.QueryID='CCPAIN066'
			  GROUP BY NQR.VisitID)								AS SECONDPM			ON AV.VisitID=SECONDPM.VisitID

LEFT JOIN (SELECT MAX(NQR.DateTime) AS 'DateTime', NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE  DATEPART(hh,NQR.DateTime) >= 22 AND DATEPART(hh,NQR.DateTime) <= 24
			AND CAST(NQR.DateTime AS DATE) = CAST(GETDATE()-@DAY AS DATE)		  
			  AND NQR.QueryID='CCPAIN066'
			  GROUP BY NQR.VisitID)								AS THIRDPM			ON AV.VisitID=THIRDPM.VisitID

WHERE AV.LocationID='3RD'
AND AV.Status='ADM IN'
ORDER BY Name
