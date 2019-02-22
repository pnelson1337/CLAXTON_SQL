
--Mnemonic|Name|Address|Address2|City|State|ZIP|Phone|Fax|Company|Group|Email|Delivery|FileFormat 
SET NOCOUNT ON

SELECT
'RH-DEPT-'+GL.ValueID										AS 'Mnemonic'
,GL.Name													AS 'Alias'
FROM		[172.16.32.18].[Livemdb].[dbo].[DMisGlComponentValue]				AS GL
WHERE GL.ComponentID='DPT'
AND GL.Active='Y'
AND CAST(GL.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)

UNION

SELECT
'RH-DEPT-'+GL.ValueID										AS 'Mnemonic'
,GL.ValueID													AS 'Alias'
FROM		[172.16.32.18].[Livemdb].[dbo].[DMisGlComponentValue]				AS GL
WHERE GL.ComponentID='DPT'
AND GL.Active='Y'
AND CAST(GL.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)
