SELECT



 AV.Name
,AV.AccountNumber
,ISNULL(AVQ.Response,'')										AS 'Admission Legal Status'
,ISNULL(MHUORDER.MAXRESP,'')									AS 'MHU Legal Status'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')			AS 'Admit Date'
,AV.LocationID													AS 'Patient Location'
,AV.Status														AS 'Patient Status'




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

WHERE MHUORDER.MAXORDER >= DATEADD(DAY,-2, CAST(GETDATE() AS DATE)) AND MHUORDER.MAXORDER < CAST(CAST(GETDATE() AS DATE) AS DATETIME)

ORDER BY BV.AdmitDateTime