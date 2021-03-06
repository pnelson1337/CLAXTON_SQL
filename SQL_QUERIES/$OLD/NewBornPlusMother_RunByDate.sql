SELECT

/** START BABY SELECTION **/
 BV.Name																AS 'Baby’s Name'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)								AS 'Baby’s DOB'
,BV.AccountNumber														AS 'Baby’s Account'
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)								AS 'Baby’s Admit Date'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,101)							AS 'Baby’s Discharge Date'
/** START MOTHER'S DEMOGRAPHICS **/
,ISNULL(BV1.Name,'')													AS 'Mother’s Name'
,ISNULL(BV1.AccountNumber,'')											AS 'Mother’s Account'
,CONVERT(VARCHAR(10),BV1.BirthDateTime,101)								AS 'Mother’s DOB'
,CONVERT(VARCHAR(10),BV1.AdmitDateTime,101)								AS 'Mother’s Admit Date'
,CONVERT(VARCHAR(10),BV1.DischargeDateTime,101)							AS 'Mother’s Discharge Date'
/** START INSURANCE SELECTION **/
,ISNULL((SELECT BI.InsuranceID 
                 FROM [Livedb].[dbo].[BarInsuranceOrder]BI
                 WHERE BI.InsuranceOrderID='1' 
                 AND BV1.VisitID=BI.VisitID),'')						AS 'Primary Insurance'

,ISNULL((SELECT BI.InsuranceID 
                 FROM [Livedb].[dbo].[BarInsuranceOrder]BI
                 WHERE BI.InsuranceOrderID='2' 
                 AND BV1.VisitID=BI.VisitID),'')						AS 'Secondary Insurance'

,ISNULL((SELECT BI.InsuranceID 
                 FROM [Livedb].[dbo].[BarInsuranceOrder]BI
                 WHERE BI.InsuranceOrderID='3' 
                 AND BV1.VisitID=BI.VisitID),'')						AS 'Tertiary Insurance'

,ISNULL((SELECT BI.InsuranceID 
                 FROM [Livedb].[dbo].[BarInsuranceOrder]BI
                 WHERE BI.InsuranceOrderID='4' 
                 AND BV1.VisitID=BI.VisitID),'')						AS 'Fourth Insurance'

  

FROM [Livedb].[dbo].[AbsNewbornData]									AS NB
LEFT JOIN [Livedb].[dbo].[BarVisits]									AS BV		ON NB.VisitID=BV.VisitID
LEFT JOIN [Livedb].[dbo].[BarVisits]									AS BV1		ON BV.MothersVisitID=BV1.VisitID

WHERE BV.DischargeDateTime BETWEEN @StartDate AND @EndDate

ORDER BY BV.DischargeDateTime