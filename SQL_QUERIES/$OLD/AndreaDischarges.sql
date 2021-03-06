Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)

SELECT

--CHANGE

BV.Name
,CONVERT(VARCHAR(10),BV.DischargeDateTime,101)				AS DischargeDate		

FROM [Livedb].[dbo].[BarVisits]		AS BV
WHERE BV.InpatientServiceID='MHC'
AND CAST(BV.DischargeDateTime AS DATE) BETWEEN @StartDate AND @EndDate 

