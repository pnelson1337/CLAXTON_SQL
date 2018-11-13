/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
 [LocationID]
,[Name]
FROM [Livedb].[dbo].[DMisLocation]
WHERE Active='Y'

UNION ALL

SELECT

'CTC'					  AS 'LocationID'
,'Cancer Treatment Center' AS 'Name'