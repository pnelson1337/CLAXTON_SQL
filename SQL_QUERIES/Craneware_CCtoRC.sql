SELECT 
[InventoryID]							AS 'Cost Center'
,'1431'									AS 'Revenue Center'

FROM [Livedb].[dbo].[DMmInventories]
WHERE SourceID='ABH' AND Active='Y'