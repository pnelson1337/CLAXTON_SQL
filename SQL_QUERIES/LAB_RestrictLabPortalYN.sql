/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
Mnemonic
,Name
,PrintNumberID
,RestrictFromIapYn

  FROM [Livedb].[dbo].[DLabTest]

  WHERE Active='Y'

  AND RestrictFromIapYn IS NOT NULL