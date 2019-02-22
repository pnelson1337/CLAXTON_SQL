--Mnemonic|Name|Address|Address2|City|State|ZIP|Phone|Fax|Company|Group|Email|Delivery|FileFormat 
SET NOCOUNT ON

SELECT

'CH-PROV-'+PROV.ProviderID						AS 'Mnemonic'
,ISNULL(PROV.Name,'')							AS 'Name'
,ISNULL(PROV.Address	,'')					AS 'Address'
,ISNULL(PROV.Address2	,'')					AS 'Address2'
,ISNULL(PROV.City		,'')					AS 'City'
,ISNULL(PROV.State		,'')					AS 'State'
,ISNULL(PROV.PostalCode,'')						AS 'ZIP'
,ISNULL(PROV.Phone		,'')					AS 'Phone'
,ISNULL(dbo.StripNonNumerics(PROV.FaxNumber),'')AS 'Fax'
,''												AS 'Company'
,'CHMC PROVIDERS'								AS 'Group'
,ISNULL(PROV.Email,'')							AS 'Email' 	
,CASE	
		WHEN QUERY.Response IS NULL THEN '9'
		WHEN QUERY.Response='D'		THEN '13'
		WHEN QUERY.Response='F'		THEN '5'
		WHEN QUERY.Response='I'		THEN '9'
		WHEN QUERY.Response='M'		THEN '4'
		WHEN QUERY.Response='O'		THEN '9'
		WHEN QUERY.Response='P'		THEN '4'
		WHEN QUERY.Response='C'		THEN '1'	
		END										AS 'Delivery'
,''												AS 'FileFormat'



FROM		[CH_MTLIVE].[dbo].[DMisProvider]		AS PROV
LEFT JOIN	[CH_MTLIVE].[dbo].[DMisProviderQuery]	AS QUERY		ON PROV.ProviderID=QUERY.ProviderID AND QUERY.QueryID='NDPROVTYPE'

WHERE PROV.Active ='Y'
AND CAST(PROV.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)




ORDER BY PROV.RowUpdateDateTime