
-- Mnemonic|Name|Address|Address2|City|State|ZIP|Phone|Fax|Company|Group|Delivery
SET NOCOUNT ON

SELECT

'CH-VENDOR-'+VEND.VendorID							AS 'Mnemonic'
,ISNULL(VEND.Name		,'')						AS 'Name'
,ISNULL(VEND.Address1	,'')						AS 'Address'
,ISNULL(VEND.Address2	,'')						AS 'Address2'
,ISNULL(VEND.City		,'')						AS 'City'
,ISNULL(VEND.State		,'')						AS 'State'
,ISNULL(VEND.PostalCode	,'')						AS 'ZIP'
,ISNULL(VEND.MainPhoneNumber,'')					AS 'Phone'
,ISNULL(dbo.StripNonNumerics(VEND.FaxNumber),'')	AS 'Fax'
,ISNULL(VEND.Name,'')								AS 'Company'
,ISNULL(VEND.FilingDatabaseID,'')					AS 'Group'
,'5'												AS 'Delivery'

FROM [CH_MTLIVE].[dbo].[DMisVendors]					AS VEND	

WHERE VEND.Active='Y'
AND CAST(VEND.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)