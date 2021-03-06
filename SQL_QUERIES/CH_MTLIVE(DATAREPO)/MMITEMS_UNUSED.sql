/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

--ITEMS.ItemID
ITEMS.Number
,ITEMS.Description
--,ITEMSUSED.ItemID


  FROM [CH_MTLIVE].[dbo].[DMmItems]										AS ITEMS
  LEFT JOIN (SELECT DISTINCT POL.ItemID
	FROM			[CH_MTLIVE].[dbo].[MmPurchaseOrders]				AS PO
	LEFT JOIN		[CH_MTLIVE].[dbo].[MmPurchaseOrderLines]			AS POL		ON PO.PurchaseOrderID=POL.PurchaseOrderID
	WHERE CAST(PO.OrderDateTime AS DATE) BETWEEN '1991-01-01' AND '2019-01-31'
	AND PO.SourceID='ABH'							 )					AS ITEMSUSED		ON	ITEMS.ItemID=ITEMSUSED.ItemID

WHERE ITEMSUSED.ItemID IS NULL
AND ITEMS.SourceID='ABH'
AND ITEMS.Active='Y'
AND ITEMS.Number IS NOT NULL

ORDER BY ITEMS.Number