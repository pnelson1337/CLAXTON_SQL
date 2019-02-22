--Mnemonic|Name|Address|Address2|City|State|ZIP|Phone|Fax|Company|Group|Email|Delivery|FileFormat 
SET NOCOUNT ON

SELECT
'CH-PROV-'+PROV.ProviderID															AS 'Mnemonic'
,ISNULL(PROV.Name,'**THISWILLNEVERBEUSED**')										AS 'Alias'
FROM [CH_MTLIVE].[dbo].[DMisProvider]													AS PROV
WHERE PROV.Active ='Y'
AND CAST(PROV.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

UNION ALL

SELECT
'CH-PROV-'+PROV.ProviderID															AS 'Mnemonic'
,ISNULL(PROV.ProviderID,'**THISWILLNEVERBEUSED**')									AS 'Alias'
FROM [CH_MTLIVE].[dbo].[DMisProvider]													AS PROV
WHERE PROV.Active ='Y'
AND CAST(PROV.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

UNION ALL

SELECT
'CH-PROV-'+PROV.ProviderID															AS 'Mnemonic'
,ISNULL( CAST(PROV.NationalProviderIdNumber AS VARCHAR),'**THISWILLNEVERBEUSED**')	AS 'Alias'
FROM [CH_MTLIVE].[dbo].[DMisProvider]													AS PROV
WHERE PROV.Active ='Y'
AND CAST(PROV.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

ORDER BY Mnemonic