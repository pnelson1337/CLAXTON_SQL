Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)

SELECT

BV.Name
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)				AS 'Admit Date'
,PROV.Name												AS 'Attending Physician'
,INS.Name												AS 'Primary Insurance'
,CONVERT(VARCHAR(10),LASTDIS.DischargeDateTime,101)		AS 'LastDischarge'
,LASTDISPROV.Name										AS 'LastDischargeAttending'


FROM		 [Livedb].[dbo].[BarVisits]					AS BV
LEFT JOIN	[Livedb].[dbo].[BarVisitProviders]			AS BVP			ON BV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
LEFT JOIN	[Livedb].[dbo].[DMisProvider]				AS PROV			ON BVP.ProviderID=PROV.ProviderID
LEFT JOIN	[Livedb].[dbo].[DMisInsurance]				AS INS			ON BV.PrimaryInsuranceID=INS.InsuranceID AND INS.Active='Y'


LEFT JOIN	(SELECT * FROM (
SELECT
ROW_NUMBER() OVER (PARTITION BY BV.UnitNumber ORDER BY BV.DischargeDateTime DESC )	AS RowNum
,BV.UnitNumber
,BV.Name
,BV.VisitID
,BV.DischargeDateTime
,BVP.ProviderID
FROM [Livedb].[dbo].[BarVisits]											AS BV
LEFT JOIN [Livedb].[dbo].[BarVisitProviders]							AS BVP	ON BV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
WHERE BV.DischargeDateTime IS NOT NULL
	AND BV.VisitID IS NOT NULL
	AND BV.UnitNumber IS NOT NULL
	AND BV.InpatientServiceID='MHC'
) AS X
WHERE X.RowNum='1')			AS LASTDIS			ON LASTDIS.UnitNumber=BV.UnitNumber
LEFT JOIN	[Livedb].[dbo].[DMisProvider]				AS LASTDISPROV		ON LASTDIS.ProviderID=LASTDISPROV.ProviderID

WHERE CAST(BV.AdmitDateTime AS DATE) BETWEEN @StartDate AND @EndDate 
AND BV.InpatientServiceID='MHC'

ORDER BY BV.Name