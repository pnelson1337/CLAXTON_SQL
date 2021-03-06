
SELECT 

 LEFT(POLINE.GLAccountID,4)													AS 'GLAccount'
 ,ISNULL(POLINE.ItemExpenseObjectCode,'')									AS 'EOC'
---,PO.PurchaseOrderID
,PO.Number																	AS 'PO#'
,POLINE.LineID																AS 'POLine#'
,ISNULL(POLINE.Inventory,'')												AS 'Inventory'
,POLINE.ItemCategory
,POLINE.CostUp
,POLINE.UnitOfPurchase
,POLINE.OrderQuantity
,POLINE.PoUpWithUs
,ISNULL(CAST(POLINE.TotalOrdered AS VARCHAR),'')							AS 'TotalOrdered'
,ISNULL(CAST(POLINE.TotalReceived AS VARCHAR),'')							AS 'TotalReceived'
,POLINE.ItemNumber
,ISNULL(POLINE.ItemName,'')													AS 'ItemName'
,ISNULL(POREQLINEVEND.Name,POVEND.Name)										AS 'VendorName'
,ISNULL(ISNULL(POREQLINE.VendorCatalog,POLINE.Catalogue),'')				AS 'Vendor#'
,ISNULL(MANUFACT.Name,'')													AS 'ManufacturerName'
,ISNULL(POLINE.ManufacturerCatalogue,'')									AS 'Manufacturer#'
,CONVERT(VARCHAR(10),PO.OrderDateTime,101)									AS 'OrderDate'
--,ISNULL(POREQ.Number,'')													AS 'Req#'


FROM		[Livedb].[dbo].[MmPurchaseOrderLines]							AS POLINE
LEFT JOIN	[Livedb].[dbo].[MmPurchaseOrders]								AS PO				ON POLINE.PurchaseOrderID=PO.PurchaseOrderID
LEFT JOIN	[Livedb].[dbo].[DMisManufacturer]								AS MANUFACT			ON POLINE.ManufacturerID=MANUFACT.ManufacturerID AND MANUFACT.Active='Y'
LEFT JOIN	[Livedb].[dbo].[MmPoReqLines]									AS POREQLINE		ON POLINE.PurchaseOrderID=POREQLINE.PurchaseOrderID AND POLINE.LineID=POREQLINE.PurchaseOrderLnNumber
--LEFT JOIN	[Livedb].[dbo].[MmPoReqs]										AS POREQ			ON POREQLINE.RequisitionID=POREQ.RequisitionID
LEFT JOIN	[Livedb].[dbo].[DMisVendors]									AS POREQLINEVEND	ON POREQLINE.VendorID=POREQLINEVEND.VendorID AND POREQLINEVEND.Active='Y'
LEFT JOIN	[Livedb].[dbo].[DMisVendors]									AS POVEND			ON PO.VendorID=POVEND.VendorID AND POVEND.Active='Y'

--WHERE GLAccountID LIKE '%1497%'
--AND ItemExpenseObjectCode IN ('607','608','609')
--Item Number
--Vendor Name
-- Man Name
-- First Time Receipt Date
WHERE CAST(PO.OrderDateTime AS DATE) BETWEEN '2018-01-01' AND '2018-11-14'
AND PO.CancelDateTime IS NULL
AND POLINE.TotalCanceled IS NULL

ORDER BY [OrderDate], PO.Number, POLINE.LineID