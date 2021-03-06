/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

BV.AccountNumber
,BVFD.ChargeTotal
,BV.ServiceDateTime

  FROM		[Livedb].[dbo].[BarVisits]					AS BV
  LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]		AS BVFD		ON BV.VisitID=BVFD.VisitID

  WHERE ServiceDateTime BETWEEN '2018-08-13' AND '2018-09-01'
  AND OutpatientLocationID = 'WOUND'

  ORDER BY BV.ServiceDateTime, BVFD.ChargeTotal