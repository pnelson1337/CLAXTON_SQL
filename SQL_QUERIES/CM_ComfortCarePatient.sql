DECLARE @StartDate DATETIME, 
		@EndDate DATETIME 

SET @StartDate ='2018-10-01'
SET @EndDate = '2018-12-31'

SELECT * FROM (

SELECT
 BV.AccountNumber
,BV.Name
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),
		CONVERT(VARCHAR(10),BV.ServiceDateTime,101))										AS 'Admit/ServiceDate'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')									AS 'DischargeDate'
,AV.LocationID																				AS 'Location'
,AV.Status
,CCORD.OrderedProcedureName																	AS 'OrderName'
,DATEDIFF(DAY,CCORD.[Order Date],BV.DischargeDateTime)										AS 'LOS'
,BIO1.InsuranceID																			AS 'PrimaryInsurance'
,ISNULL(BIO2.InsuranceID,'')																AS 'SecondaryInsurance'


FROM			[Livedb].[dbo].[AdmVisits]													AS AV
INNER JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON AV.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[BarInsuranceOrder]											AS BIO1										ON AV.VisitID=BIO1.VisitID AND BIO1.InsuranceOrderID='1'
LEFT JOIN		[Livedb].[dbo].[BarInsuranceOrder]											AS BIO2										ON AV.VisitID=BIO2.VisitID AND BIO2.InsuranceOrderID='2'

-- COMFORT CARE ORDER --
LEFT JOIN (SELECT * FROM (
SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID,ORD.OrderedProcedureMnemonic,AV.AccountNumber,BV.AdmitDateTime					
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON ORD.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[AdmVisits]													AS AV										ON ORD.VisitID=AV.VisitID
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL' AND ORD.OrderedProcedureMnemonic IN ('COMFORT'))				AS X
WHERE X.OrderSeq='1')																		AS CCORD									ON AV.VisitID=CCORD.VisitID

-------------------------------------------------------------------------------END ORDER SELECTIONS-------------------------------------------------------------------------------


WHERE AV.Status IN ('ADM IN', 'DIS IN')
AND BV.AdmitDateTime BETWEEN @StartDate AND @EndDate
AND CCORD.OrderedProcedureMnemonic IS NOT NULL	

) AS X
--WHERE X.Location IN (@Location)
WHERE X.Location IN ('2WEST','2EAST','ICU','2CENTRAL')
ORDER BY [Admit/ServiceDate]
