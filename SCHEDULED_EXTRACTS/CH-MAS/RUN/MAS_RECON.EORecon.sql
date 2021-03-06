/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 

 BV.AccountNumber
,ISNULL(BVFD.PatientBalance,'')														AS 'PatientBalance'
,ISNULL(BVFD.InsuranceBalance,'')													AS 'InsuranceBalance'
,ISNULL(BVFD.Balance,'')															As 'AccountBalance'
,CASE WHEN BVFD.PatientBalance != BVFD.Balance THEN 'NO' ELSE 'YES' END				AS 'PB=AB(Y/N)?'
FROM		[CH_MTLIVE].[dbo].[BarVisitFinancialData]				AS BVFD
LEFT JOIN	[CH_MTLIVE].[dbo].[BarVisits]							AS BV				ON BVFD.VisitID=BV.VisitID


WHERE CollectionAgency='MASC'
ORDER BY [PB=AB(Y/N)?],AccountNumber


