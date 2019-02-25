/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 

MMPOLINE.ItemNumber										AS 'Item #'
,DMMITEM.Description									AS 'Description'
,DMISVEN.Name											AS 'Vendor'
--MFG--
,MMPOLINE.Catalogue										AS 'Vendor Catalog #'
,MMPOLINE.ManufacturerCatalogue							AS 'Manufacturer Catalog #'
,MMPOLINE.UnitOfPurchase								AS 'Vendor UOP'
--LARGEST COMMON UNIT--
--SMALLEST UNIT--
,DMMITEM.CurrentPackaging								AS 'Packaging'
,CONVERT(NUMERIC(10,2),MMPOLINE.CostUp)					AS 'UOP Price'
,CASE WHEN MMPOLINE.StockID IS NULL THEN 'N'
		ELSE 'Y' END									AS 'Stocked (Y/N)'	
,CONVERT(NUMERIC(10,2),
		(MMPOLINE.CostUp * MMPOLINE.OrderQuantity))		AS 'UOI Price'
--UOI--
,CONVERT(VARCHAR(10),MMPO.CloseDateTime,101)			AS 'Date of Transaction (Close Date)'
	  
,ISNULL(MMPOLINE.Dept,MMPOLINE.Inventory)				AS 'Cost Center'
,MMPO.PurchaseOrderID



FROM			[Livedb].[dbo].[MmPurchaseOrderLines]			AS MMPOLINE
LEFT JOIN		[Livedb].[dbo].[MmPurchaseOrders]				AS MMPO			ON MMPOLINE.PurchaseOrderID=MMPO.PurchaseOrderID	AND MMPO.SourceID='ABH'
--LEFT JOIN		[Livedb].[dbo].[MmPurchaseOrderTransactions]	AS MMPOTXN		ON MMPOLINE.PurchaseOrderID=MMPOTXN.PurchaseOrderID	AND MMPOLINE.LineID=MMPOTXN.LineID	AND MMPOTXN.SourceID='ABH'
--LEFT JOIN		[Livedb].[dbo].[MmStockReceiveTransactions]		AS MMSRT		ON MMPO.Number=MMSRT.PoNumber						AND MMSRT.SourceID='ABH'
LEFT JOIN		[Livedb].[dbo].[DMisVendors]					AS DMISVEN		ON MMPO.VendorID=DMISVEN.VendorID					AND DMISVEN.Active='Y'
LEFT JOIN		[Livedb].[dbo].[DMmItems]						AS DMMITEM		ON MMPOLINE.ItemNumber=DMMITEM.Number				AND DMMITEM.Active='Y'				AND DMMITEM.SourceID='ABH'




WHERE MMPOLINE.SourceID='ABH'
--AND MMPO.PurchaseOrderID='107230'
AND MMPO.CloseDateTime BETWEEN '2018-01-01' AND '2018-04-05'



ORDER BY CloseDateTime
