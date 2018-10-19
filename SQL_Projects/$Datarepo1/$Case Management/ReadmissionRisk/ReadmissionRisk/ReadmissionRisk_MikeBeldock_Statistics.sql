/*
DECLARE @StartDate DATETIME, @EndDate DATETIME
SET @StartDate ='2017-11-01'
SET @EndDate = '2017-11-30'
*/



;WITH SUMS AS (


SELECT

ISNULL(RESPONSE.Response,'')											AS 'Response'
,(COUNT(RESPONSE.Response) * 100 / (SELECT COUNT(*) FROM			

[Livedb].[dbo].[AdmVisits]								AS AV
INNER JOIN		[Livedb].[dbo].[BarVisits]								AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN		(SELECT NQR.VisitID,Response,MAX(NQR.DateTime)			AS 'MAX DATE'
					FROM [Livedb].[dbo].[NurQueryResults]				AS NQR
					WHERE NQR.QueryID='CMIDT037'			
					GROUP BY NQR.VisitID,NQR.Response)					AS RESPONSE		ON BV.VisitID=RESPONSE.VisitID

WHERE BV.InpatientOrOutpatient='I'
AND AV.Status NOT IN ('PRE IN','CAN IN')
AND AV.LocationID IN (@Location)
AND BV.AdmitDateTime BETWEEN @StartDate AND @EndDate
))																		AS ResponseRate


FROM			[Livedb].[dbo].[AdmVisits]								AS AV
INNER JOIN		[Livedb].[dbo].[BarVisits]								AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN		(SELECT NQR.VisitID,Response,MAX(NQR.DateTime)			AS 'MAX DATE'
					FROM [Livedb].[dbo].[NurQueryResults]				AS NQR
					WHERE NQR.QueryID='CMIDT037'			
					GROUP BY NQR.VisitID,NQR.Response)					AS RESPONSE		ON BV.VisitID=RESPONSE.VisitID


WHERE BV.InpatientOrOutpatient='I'
AND AV.Status NOT IN ('PRE IN','CAN IN')
AND RESPONSE.Response IN (@Response)
AND AV.LocationID IN (@Location)
AND BV.AdmitDateTime BETWEEN @StartDate AND @EndDate


GROUP BY RESPONSE.Response

)

SELECT 
SUM(ResponseRate)
FROM SUMS
