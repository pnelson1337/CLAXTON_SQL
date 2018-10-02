
DECLARE @StartDate DATETIME, 
		@EndDate DATETIME, 
		@Location VARCHAR(255)

SET @StartDate ='2018-02-01'
SET @EndDate = '2018-02-28'
--SET @Location = '2WEST,2EAST,ICU'

SELECT * FROM (

SELECT
 BV.AccountNumber
,BV.Name
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),
		CONVERT(VARCHAR(10),BV.ServiceDateTime,101))					AS 'Admit/Service Date'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')				AS 'Discharge Date'
--,ISNULL(RESPONSE.Response,'')											AS 'Response'
,CASE WHEN RESPONSE.Response IS NULL THEN 'N'
		ELSE RESPONSE.Response END										AS 'Response'
,AV.LocationID															AS 'Location'
,AV.Status



FROM			[Livedb].[dbo].[AdmVisits]								AS AV
INNER JOIN		[Livedb].[dbo].[BarVisits]								AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN		(SELECT NQR.VisitID,Response,MAX(NQR.DateTime)			AS 'MAX DATE'
					FROM [Livedb].[dbo].[NurQueryResults]				AS NQR
					WHERE NQR.QueryID='CMIDT037'			
					GROUP BY NQR.VisitID,NQR.Response)					AS RESPONSE		ON BV.VisitID=RESPONSE.VisitID


WHERE BV.InpatientOrOutpatient='I'
AND AV.Status NOT IN ('PRE IN','CAN IN')
AND BV.AdmitDateTime BETWEEN @StartDate AND @EndDate



--ORDER BY BV.AdmitDateTime, RESPONSE.Response

) AS X

/*
WHERE X.Response IN (@Response)
AND X.Location IN (@Location)
*/

WHERE X.Response IN ('N')
AND X.Location IN ('2WEST','2EAST','ICU')





