SELECT

 AV.Name
,BV.VisitID
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)													AS 'Admit Date'
,AV.LocationID																				AS 'Location'
,DATEDIFF(DAY,BV.AdmitDateTime,GETDATE())													AS 'LOS' 
,BV.PrimaryInsuranceID																		AS 'Primary Insurance'
,BVP.Name																					AS 'Attending Physician (BAR)'
,''																							AS ' '
,ISNULL(ORD.Name,'')																		AS 'Last Ordering Physician'
,ISNULL(ORD.[Order Date],'')																AS 'Order Date'
,ISNULL(ORD.OrderedProcedureName,'')														AS 'Order Name'
,''																							AS '  '
,ISNULL(DPROV.Name,'')																		AS 'Last Dictating Physician'
,ISNULL(CONVERT(VARCHAR(10),PD.SignDateTime,101),'')										AS 'Note Signed Date'
,ISNULL(PD.DocumentTemplateID,'')															AS 'Note Type'
,ISNULL(RPT.Name,'')																		AS 'Note Name'

FROM			[Livedb].[dbo].[AdmVisits]													AS AV		
LEFT JOIN		[Livedb].[dbo].[BarVisits]													AS BV										ON AV.VisitID=BV.VisitID
LEFT JOIN	(SELECT * FROM (SELECT
ROW_NUMBER() OVER (PARTITION BY PD1.VisitID ORDER BY PD1.DcmtID DESC)						AS 'DocSeq'
,PD1.VisitID,PD1.SignDateTime,PD1.DocumentTemplateID,PD1.UserID
FROM [Livedb].[dbo].[PcmDcmts]																AS PD1
WHERE UPPER(PD1.Status)='SIGNED'
) AS X1 WHERE X1.DocSeq='1')																AS PD										ON AV.VisitID=PD.VisitID
LEFT JOIN		[Livedb].[dbo].[DMisUsers]													AS DUSER									ON PD.UserID=DUSER.UserID
LEFT JOIN		[Livedb].[dbo].[DMisProvider]												AS DPROV									ON DUSER.ProviderID=DPROV.ProviderID AND DPROV.Active='Y'
LEFT JOIN		[Livedb].[dbo].[BarVisitProviders]											AS BVP										ON AV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
LEFT JOIN		[Livedb].[dbo].[OeOrders]													AS ALC										ON AV.VisitID=ALC.VisitID AND ALC.OrderedProcedureMnemonic='ALC'		
LEFT JOIN		(SELECT * FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY ORD.VisitID ORDER BY ORD.OrderID DESC)						AS OrderSeq
,ORD.OrderedProcedureName,ORD.Status,PROV.Name,CONVERT(VARCHAR(10),ORD.OrderDateTime,101)	AS 'Order Date'
,ORD.VisitID						
FROM			[Livedb].[dbo].[OeOrders]													AS ORD
INNER JOIN		[Livedb].[dbo].[DMisProvider]												AS PROV										ON ORD.ProviderID=PROV.ProviderID
WHERE ORD.Status != 'CANCEL'
)																							AS X
WHERE X.OrderSeq='1')																		AS ORD										ON AV.VisitID=ORD.VisitID				
LEFT JOIN	[Livedb].[dbo].[DOeReports]														AS RPT										ON 'PDOC'+SUBSTRING(PD.DocumentTemplateID,5,25)=RPT.ReportID AND RPT.DeptLocationID='MEDREC'



WHERE AV.Status='ADM IN'
AND DATEDIFF(DAY,BV.AdmitDateTime,GETDATE()) >= 7		
AND AV.LocationID != '3RD'	
AND ALC.OrderedProcedureMnemonic IS NULL

ORDER BY LOS