/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 

BV.AccountNumber
,ContractAmount									AS 'ContractAmount'
,CAST(ContractDateTime AS DATE)					AS 'ContractDate'
,ISNULL(InsuranceBalance,'')					AS 'InsuranceBalance'							
,PatientBalance									AS 'PatientBalance'
,Balance										AS 'AccountBalance'	
,CollectionAgency								AS 'AssignedAgency'
,ISNULL(CAST(LastPayDateTime AS DATE),'')		AS 'LastPayDate'
  FROM		[CH_MTLIVE].[dbo].[BarVisitFinancialData]		 AS BVFD	
  LEFT JOIN [CH_MTLIVE].[dbo].[BarVisits]					 AS BV			ON BVFD.VisitID=BV.VisitID

  WHERE ContractAmount IS NOT NULL
  AND Balance > 0
  AND CollectionAgency='MASC'

  ORDER BY CollectionAgency