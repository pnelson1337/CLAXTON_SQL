/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 

	   MMPOLINE.ItemNumber										AS 'Item Number'
	  ,ISNULL(MMPOLINE.Dept,MMPOLINE.Inventory)					AS 'Cost Center'
	  ,DMMITEM.Description										AS 'Item Description'
	  ,DMISVEN.Name												AS 'Vendor Name' 
	  ,MMPOLINE.Catalogue										AS 'Vendor Catalog ID'
	  ,MMPOLINE.UnitOfPurchase									AS 'Purchase Unit of Measure (UoM)'
	  ,CONVERT(NUMERIC(10,2),MMPOLINE.CostUp)					AS 'Unit Purchase Cost (Price)'
	  ,CONVERT(NUMERIC(10,2),
		(MMPOLINE.CostUp * MMPOLINE.OrderQuantity))				AS 'Total Cost (Invoice Cost)'
	  ,CONVERT(NUMERIC(10,2),
		(MMPOLINE.TotalReceived / MMPOLINE.PoUpUs))				AS 'Received Quantity/ Volume'
	  ,CONVERT(VARCHAR(10),MMSRT.ReceiveDateTime,101)			AS 'Received Date'
	  ,MMSRT.PoNumber											AS 'PO Number'
	  ,MMPOLINE.ManufacturerCatalogue							AS 'Manufacturer Catalog ID'							
	  ,MMPOLINE.ItemCategory									AS 'Item Category'
	  --CAT DESC												






FROM			[CH_MTLIVE].[dbo].[MmStockReceiveTransactions]		AS	MMSRT
LEFT JOIN		[CH_MTLIVE].[dbo].[MmPurchaseOrders]				AS MMPO			ON MMSRT.PoNumber=MMPO.Number
INNER JOIN		[CH_MTLIVE].[dbo].[MmPurchaseOrderLines]			AS MMPOLINE		ON MMPOLINE.PurchaseOrderID=MMPO.PurchaseOrderID AND MMSRT.PoLineID=MMPOLINE.LineID
LEFT JOIN		[CH_MTLIVE].[dbo].[DMisVendors]					AS DMISVEN		ON MMPO.VendorID=DMISVEN.VendorID AND DMISVEN.Active='Y'
LEFT JOIN		[CH_MTLIVE].[dbo].[DMmItems]						AS DMMITEM		ON MMPOLINE.ItemNumber=DMMITEM.Number AND DMMITEM.Active='Y' AND DMMITEM.SourceID='ABH'


WHERE ReceiveDateTime BETWEEN '2017-01-01' AND '2017-12-31'
AND MMSRT.SourceID !='PHA'
AND MMSRT.TypeName='RECEIVE FROM PO'

 --AND DMMSTOCK.ItemID IS NULL

 ORDER BY [Cost Center]


