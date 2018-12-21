SELECT

BV.AccountNumber
,PDOC.DocumentTemplateID
,PDOC.DcmtID
--,PDOC.DcmtID
,DPROV.ProviderID											AS 'Physician Mnemonic'
,DPROV.Name													AS 'Physician Name'
,PDOC.ReportStatus
,PDOCSV.SINGLE_VALUE

FROM		[Livedb].[dbo].[BarVisits]						AS BV
LEFT JOIN	[Livedb].[dbo].[PcmDcmts]						AS PDOC		ON BV.VisitID=PDOC.VisitID
INNER JOIN	[Livedb].[dbo].[DMisUsers]						AS DUSER	ON PDOC.UserID=DUSER.UserID
LEFT JOIN	[Livedb].[dbo].[DMisProvider]					AS DPROV	ON DUSER.ProviderID=DPROV.ProviderID AND DPROV.Active='Y'
INNER JOIN	[Livedb].[dbo].[DelphiHospitalistProviderList]	AS DELPHI	ON DPROV.NationalProviderIdNumber=DELPHI.NPI
LEFT JOIN (SELECT DOC.DcmtID,STUFF((SELECT '' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TextLine,'Verdana 4Bd','')
									,'Verdana 4d',''),'Verdana 5BUg',''),'Verdana 5Bd',''),'Verdana 4Bg',''),'Arial 4d','')
									,'Arial 5Bd',''),'Arial 4Bd',''),'Courier New 4r',''),'Courier New 4d','') FROM [Livedb].[dbo].[PcmDcmtBodyText] WHERE ([DcmtID] = DOC.[DcmtID])
									FOR XML PATH (''),type).value('(./text())[1]','varchar(max)'), 1, 2,'')	AS SINGLE_VALUE FROM [Livedb].[dbo].[PcmDcmts]AS DOC GROUP BY DOC.DcmtID)							
															AS PDOCSV		ON PDOC.DcmtID=PDOCSV.DcmtID

WHERE CAST(PDOC.SignDateTime AS DATE) BETWEEN '2018-12-06' AND '2018-12-06'
AND ReportStatus = 'Signed'
AND PDOC.DcmtID='64275'


ORDER BY PDOC.DcmtID