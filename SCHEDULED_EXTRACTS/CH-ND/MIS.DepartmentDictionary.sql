
--Mnemonic|Name|Address|Address2|City|State|ZIP|Phone|Fax|Company|Group|Email|Delivery|FileFormat 
SET NOCOUNT ON

SELECT

'CH-DEPT-'+GL.ValueID										AS 'Mnemonic'
,GL.Name													AS 'Name'
,''															AS 'Address'
,''															AS 'Address2'
,''															AS 'City'
,''															AS 'State'
,''															AS 'ZIP'
,''															AS 'Phone'
,''															AS 'Fax'
,'CLAXTON-HEPBURN MEDICAL CENTER'							AS 'Company'
,'CHMC DEPARTMENT'											AS 'Group'
,UPPER(CASE WHEN GL.ValueID = '1497' THEN 'JROWE@CHMED.ORG'
			WHEN dbo.StripNonNumerics(LEFT(GL.Person,4)) = (SELECT  PPEMP.Number		FROM [CH_MTLIVE].[dbo].[PpEmployees] PPEMP WHERE dbo.StripNonNumerics(LEFT(GL.Person,4))=PPEMP.Number) 
			THEN										   (SELECT  PPEMP.EmailAddress	FROM [CH_MTLIVE].[dbo].[PpEmployees] PPEMP WHERE dbo.StripNonNumerics(LEFT(GL.Person,4))=PPEMP.Number)  
			ELSE 'PNELSON@CHMED.ORG' END)					AS 'Email' 	
,'3'														AS 'Delivery'
,'2'														AS 'FileFormat'

										
FROM		[CH_MTLIVE].[dbo].[DMisGlComponentValue]				AS GL
WHERE GL.ComponentID='DPT'
AND GL.Active='Y'
AND CAST(GL.RowUpdateDateTime AS DATE) = CAST(GETDATE() AS DATE)