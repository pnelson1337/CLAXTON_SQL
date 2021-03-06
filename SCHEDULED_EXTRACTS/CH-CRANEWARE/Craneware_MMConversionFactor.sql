/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
		
ITEM.Number											AS 'Item Number'
/*
,ITEM.ItemID
 ITEMFACVEN.CatalogNumber							AS 'Vendor Catalog Number/ ID' 
,ITEMUNIT.[PackageSize]								AS 'Unit of Measure Name (UoM)*'
,ITEMUNIT.[ConversionFactor]						AS 'Unit of Measure Usage*'
*/
      ,ITEMUNIT.[PackingNumberID]
      ,ITEMUNIT.[SizeID]
      ,ITEMUNIT.[ConversionFactor]
      ,ITEMUNIT.[PackageSize]
      ,ITEMUNIT.[UnitsPer]
	   ,ITEMFACVEN.CatalogNumber							AS 'Vendor Catalog Number/ ID' 

	 


FROM		[CH_MTLIVE].[dbo].[DMmItemUnits]				AS	ITEMUNIT
LEFT JOIN	[CH_MTLIVE].[dbo].[DMmItems]					AS	ITEM		ON ITEMUNIT.ItemID=ITEM.ItemID	AND ITEM.Active='Y' AND ITEM.SourceID='ABH'
LEFT JOIN	[CH_MTLIVE].[dbo].[DMmItemFacilityVendors]		AS	ITEMFACVEN	ON ITEMUNIT.ItemID=ITEMFACVEN.ItemID AND ITEMFACVEN.Active='Y' AND ITEMFACVEN.SourceID='ABH'




WHERE ITEM.Number = '70111'

ORDER BY [Vendor Catalog Number/ ID]

