SELECT 
[InventoryID]							AS 'Cost Center'
,'1431'									AS 'Revenue Center'

FROM [CH_MTLIVE].[dbo].[DMmInventories]
WHERE SourceID='ABH' AND Active='Y'