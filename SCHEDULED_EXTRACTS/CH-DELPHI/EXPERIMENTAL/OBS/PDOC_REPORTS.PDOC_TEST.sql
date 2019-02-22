SELECT

BV.AccountNumber
,PDOC.DocumentTemplateID
,PDOC.DcmtID
,PDOCTEXT.TextSeqID
,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PDOCTEXT.TextLine,'Verdana 4Bd',''),'Verdana 4d',''),'Verdana 5BUg',''),'Verdana 5Bd',''),'Verdana 4Bg',''),'Arial 4d','')
,'Arial 5Bd',''),'Arial 4Bd',''),'Courier New 4r',''),'Courier New 4d','')
,DPROV.ProviderID											AS 'Physician Mnemonic'
,DPROV.Name													AS 'Physician Name'
,PDOC.ReportStatus

FROM		[Livedb].[dbo].[BarVisits]						AS BV
LEFT JOIN	[Livedb].[dbo].[PcmDcmts]						AS PDOC		ON BV.VisitID=PDOC.VisitID
INNER JOIN	[Livedb].[dbo].[PcmDcmtBodyText]				AS PDOCTEXT	ON PDOC.DcmtID=PDOCTEXT.DcmtID
INNER JOIN	[Livedb].[dbo].[DMisUsers]						AS DUSER	ON PDOC.UserID=DUSER.UserID
LEFT JOIN	[Livedb].[dbo].[DMisProvider]					AS DPROV	ON DUSER.ProviderID=DPROV.ProviderID AND DPROV.Active='Y'
INNER JOIN	[Livedb].[dbo].[DelphiHospitalistProviderList]	AS DELPHI	ON DPROV.NationalProviderIdNumber=DELPHI.NPI

WHERE PDOC.SignDateTime > '2018-10-01'
AND ReportStatus = 'Signed'
--AND PDOC.DcmtID = '56608'

ORDER BY PDOC.DcmtID, PDOCTEXT.TextSeqID


--PCM.MHHP