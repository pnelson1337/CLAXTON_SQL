
-- Mnemonic|Name|Address|Address2|City|State|ZIP|Phone|Fax|Company|Group|Delivery
SET NOCOUNT ON

SELECT
'CH-VENDOR-'+VEND.VendorID							AS 'Mnemonic'
,ISNULL(VEND.Name		,'')						AS 'Alias'
FROM [CH_MTLIVE].[dbo].[DMisVendors]					AS VEND	
WHERE VEND.Active='Y'
AND CAST(VEND.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

UNION ALL

SELECT
'CH-VENDOR-'+VEND.VendorID							AS 'Mnemonic'
,ISNULL(VEND.VendorID		,'')					AS 'Alias'
FROM [CH_MTLIVE].[dbo].[DMisVendors]					AS VEND	
WHERE VEND.Active='Y'
AND CAST(VEND.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

UNION ALL

SELECT
'CH-VENDOR-'+VEND.VendorID							AS 'Mnemonic'
,ISNULL(' '+VEND.VendorID		,'')				AS 'Alias'
FROM [CH_MTLIVE].[dbo].[DMisVendors]					AS VEND	
WHERE VEND.Active='Y'
AND CAST(VEND.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

ORDER BY Mnemonic

