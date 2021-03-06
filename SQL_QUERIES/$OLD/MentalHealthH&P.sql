--I HAVE THE POWER
SELECT

BV.AccountNumber
,BV.Name
,CASE WHEN PDOC.DocumentTemplateID  IS NULL THEN 'NO'
ELSE 'YES' END											AS 'H&P (Y/N)?'
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)				AS 'Admit Date'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')			AS 'Discharge Date'


FROM		[Livedb].[dbo].[BarVisits]		AS BV
LEFT JOIN	[Livedb].[dbo].[PcmDcmts]		AS PDOC		ON BV.VisitID=PDOC.VisitID AND PDOC.DocumentTemplateID='PCM.MHHP'
WHERE BV.InpatientServiceID='MHC'
AND CAST(BV.AdmitDateTime AS DATE) BETWEEN '2018-06-01' AND '2018-10-26'

ORDER BY BV.AdmitDateTime