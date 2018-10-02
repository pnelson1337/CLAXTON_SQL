SELECT



 AV.Name
,AV.AccountNumber
,AVQ.Response													AS 'Admission Legal Status'
,MHUORDER.MAXRESP												AS 'MHU Legal Status'
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)						AS 'Admit Date'




FROM		[Livedb].[dbo].[AdmVisits]							AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]							AS BV					ON AV.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[AdmVisitQueries]					AS AVQ					ON AV.VisitID=AVQ.VisitID AND AVQ.QueryID='MHULGL'

LEFT JOIN	(SELECT OEORD.VisitID,MAX(OEORD.RowUpdateDateTime)	AS 'MAXORDER'
					,MAX(OEORDQ.Response)						AS 'MAXRESP'
				FROM [Livedb].[dbo].[OeOrders] OEORD
				LEFT JOIN	[Livedb].[dbo].[OeOrderQueries]		AS OEORDQ				ON OEORD.OrderID=OEORDQ.OrderID
				WHERE OEORD.Category='MHU' 
				AND OEORD.OrderedProcedureMnemonic='LEGAL'
				GROUP BY OEORD.VisitID)							AS MHUORDER				ON AV.VisitID=MHUORDER.VisitID

/*LEFT JOIN	[Livedb].[dbo].[OeOrders]					AS OEORD				ON AV.VisitID=OEORD.VisitID AND OEORD.Category='MHU' AND OEORD.OrderedProcedureMnemonic='LEGAL'
LEFT JOIN	[Livedb].[dbo].[OeOrderQueries]				AS OEORDQ				ON OEORD.OrderID=OEORDQ.OrderID
*/

WHERE CAST(BV.AdmitDateTime AS DATE) BETWEEN  '2014-08-11' AND '2018-05-02'
AND AV.InpatientServiceID ='MHC'
AND AVQ.Response IN ('VOLUNTARY')
AND MHUORDER.MAXRESP = 'VOLUNTARY'


ORDER BY BV.AdmitDateTime