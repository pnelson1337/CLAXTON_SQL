/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
 [LocationID]
,[Name]
FROM [CH_MTLIVE].[dbo].[DMisLocation]
WHERE Active='Y'

UNION ALL

SELECT

'CTC'					  AS 'LocationID'
,'Cancer Treatment Center' AS 'Name'