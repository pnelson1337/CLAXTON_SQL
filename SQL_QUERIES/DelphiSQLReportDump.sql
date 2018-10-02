
SELECT 

--AV.AccountNumber												AS 'Account Number'
 OERES.ReportID													AS 'ReportID'
--,DOERPT.HeaderDescription										AS 'ReportID Description'
,OERESCT.ResultID												AS 'ResultID'
,OERESCT.[TextSeqID]											AS 'ResultSeqID'
,CONVERT(VARCHAR(MAX),OERESCT.TextLine)							AS 'ReportText'
,CONVERT(VARCHAR(10),OERES.SignDateTime,112)					AS 'Signed Date'
,OERES.DictatedBy												AS 'DictatedByMnemonic'
--,DPROV.Name														AS 'DictatedByName'	
--,DPROV.NationalProviderIdNumber									AS 'DictatedByNPI'





FROM		[Livedb].[dbo].[OeResultCompiledText]				AS OERESCT
LEFT JOIN	[Livedb].[dbo].[OeResults]							AS OERES		ON OERESCT.ResultID=OERES.ResultID

--INNER JOIN	[Livedb].[dbo].[DMisProvider]						AS DPROV		ON OERES.DictatedBy=DPROV.ProviderID AND DPROV.Active='Y' and DPROV.Company='DELPHI'
--LEFT JOIN	[Livedb].[dbo].[DOeReports]							AS DOERPT		ON OERES.ReportID=DOERPT.ReportID AND OERES.DeptLocationID=DOERPT.DeptLocationID AND DOERPT.Active='Y' 
--LEFT JOIN	[Livedb].[dbo].[AdmVisits]							AS AV			ON OERES.PatientVisitID=AV.VisitID		
--LEFT JOIN	[Livedb].[dbo].[BarVisits]							AS BV			ON AV.VisitID=BV.VisitID
--LEFT JOIN	[Livedb].[dbo].[DMisProvider]						AS DPROV		ON OERES.DictatedBy=DPROV.ProviderID AND DPROV.Active='Y'	




--WHERE (CONVERT(varchar(10),BV.DischargeDateTime,23) BETWEEN '2018-06-01' AND '2018-07-31')
--WHERE OERESCT.ResultID='1001576' 

--WHERE OERES.Status='Signed'
/*
WHERE DPROV.NationalProviderIdNumber IN ('1811306590','1891898003','1407898356','1609131515','1366966277','1134126881','1124007489','1629414651','1922017128','1073820171','1467450833','1982644019','1699771295','1710982731','1922042225'
,'1194755520','1467424226','1912961061','1801229604','1306251400','1851387971','1558516591','1194243238','1235188178','1528588639','1750387023','1174788541','1396992863','1437460003','1174810279','1003159054','1205190535','1386091445'
,'1124385273','1992751366','1083602221','1851816961','1053359109','1386875649','1538268289','1285041285','1659513125','1821191933','1336669126','1710993373','1598045205','1033103783','1033233879','1073996930','1578736336','1255516852'
,'1063446508','1558308122','1699181974','1619168689','1750644191','1801120746','1023057692','1730536004','1992174007','1750369385','1750572574')
*/

--WHERE OERES.SignDateTime > '2018-07-31'

WHERE OERES.DictatedBy='UNGR'

ORDER BY ResultID, ResultSeqID

