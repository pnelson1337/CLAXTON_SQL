/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
		
      ITEM.Number										AS 'Item Number'
	 ,ITEM.Description									AS 'Description'
	 ,VENDOR.Name										AS 'Vendor Name'
	 ,ITEMFACVEN.CatalogNumber							AS 'Vendor Catalog Number' 
	 ,ITEMFACVEN.ManufacturerCatalogNumber				AS 'Manufacture Catalog #'
     ,ITEMUNIT.[PackageSize]							AS 'Unit of Measure Name (UoM)'
	 ,ITEMUNIT.[ConversionFactor]						AS 'Unit of Measure Usage'

	 


  FROM [Livedb].[dbo].[DMmItemUnits]					AS	ITEMUNIT
  LEFT JOIN	[Livedb].[dbo].[DMmItems]					AS	ITEM		ON ITEMUNIT.ItemID=ITEM.ItemID	AND ITEM.Active='Y' AND ITEM.SourceID='ABH'
  LEFT JOIN [Livedb].[dbo].[DMmItemFacilityVendors]		AS	ITEMFACVEN	ON ITEMUNIT.ItemID=ITEMFACVEN.ItemID AND ITEMFACVEN.Active='Y' AND ITEMFACVEN.SourceID='ABH'
  LEFT JOIN	[Livedb].[dbo].[DMisVendors]				AS	VENDOR		ON ITEMFACVEN.VendorID=VENDOR.VendorID

  WHERE ITEM.Number IS NOT NULL