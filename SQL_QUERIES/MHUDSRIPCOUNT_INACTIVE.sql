SELECT * FROM (

SELECT DISTINCT

AV.VisitID
,BV.AdmitDateTime
,BV.DischargeDateTime
--,ISNULL(RXMORDRP.ReferToProviderID,OL.Name)									AS'OKAY'
,CASE WHEN OL.Name IN ( 'ACT Team',
						'Carthage Behavioral Health',
						'CHMC Wellness Center',
						'CPH Psychiatry Services',
						'Gouverneur Wellness Center',
						'Massena Wellness Center',
						'Mosaic Behavioral Health',
						'Northstar Mental Health-Malone',
						'Northstar MH-Saranac Lake',
						'Ogdensburg Wellness Center',
						'River Wellness Center',
						'Samaritan Behavioral Health',
						'St.Lawrence County MH Clinic',
						'VA Clinic in Massena',
						/*LIST BASED  ON COLUMN NAMES*/
						'Ogdensburg Wellness Clinic',
						'Mosaic Behavorial Health',
						'Gouverneur Wellness Clinic',
						'Massena Wellness Clinic',
						'St.Regis Mohawk MH Clinic'

						) THEN 'COUNT'
	--WHEN RXMOD.ToPracticeFree IS NOT NULL THEN 'COUNT'
	--WHEN RXMOD.ToProviderFree IS NOT NULL THEN 'COUNT'
		ELSE '' END																AS 'COUNT'




--,RXMORDTXT1.TextSeqID
--,RXMORDTXT1.TextLine+''+RXMORDTXT2.TextLine+''+RXMORDTXT3.TextLine+''+RXMORDTXT4.TextLine+''+RXMORDTXT5.TextLine+''+RXMORDTXT6.TextLine+''+RXMORDTXT7.TextLine+''+RXMORDTXT8.TextLine+''+RXMORDTXT9.TextLine+''+RXMORDTXT10.TextLine


FROM		[Livedb].[dbo].[AdmVisits]					AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]					AS BV					ON AV.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[RxmOrds]					AS RXMORD				ON AV.VisitID=RXMORD.VisitID AND RXMORD.OrderTypeID='Referral'
LEFT JOIN	[Livedb].[dbo].[RxmOrdReferProviders]		AS RXMORDRP				ON RXMORD.OrderID=RXMORDRP.OrderID
LEFT JOIN	[Livedb].[dbo].[RxmOrdReferGroups]			AS RXMORDG				ON RXMORD.OrderID=RXMORDG.OrderID
LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]				AS RXMOD				ON RXMORD.OrderID=RXMOD.OrderID
LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]			AS OL					ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID
/*
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT1			ON RXMORD.OrderID=RXMORDTXT1.OrderID AND RXMORDTXT1.TextSeqID='1'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT2			ON RXMORD.OrderID=RXMORDTXT2.OrderID AND RXMORDTXT2.TextSeqID='2'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT3			ON RXMORD.OrderID=RXMORDTXT3.OrderID AND RXMORDTXT3.TextSeqID='3'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT4			ON RXMORD.OrderID=RXMORDTXT4.OrderID AND RXMORDTXT4.TextSeqID='4'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT5			ON RXMORD.OrderID=RXMORDTXT5.OrderID AND RXMORDTXT5.TextSeqID='5'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT6			ON RXMORD.OrderID=RXMORDTXT6.OrderID AND RXMORDTXT6.TextSeqID='6'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT7			ON RXMORD.OrderID=RXMORDTXT7.OrderID AND RXMORDTXT7.TextSeqID='7'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT8			ON RXMORD.OrderID=RXMORDTXT8.OrderID AND RXMORDTXT8.TextSeqID='8'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT9			ON RXMORD.OrderID=RXMORDTXT9.OrderID AND RXMORDTXT9.TextSeqID='9'
LEFT JOIN	[Livedb].[dbo].[RxmOrdText]					AS RXMORDTXT10			ON RXMORD.OrderID=RXMORDTXT10.OrderID AND RXMORDTXT10.TextSeqID='10'
*/



WHERE CAST(BV.DischargeDateTime AS DATE) BETWEEN  '2018-01-01' AND '2018-03-31'

AND AV.InpatientServiceID ='MHC'
AND RXMORD.OrderTypeID='Referral'
AND RXMORD.CancelledDateTime IS NULL
AND BV.DischargeDateTime IS NOT NULL

--ORDER BY BV.AdmitDateTime
) AS X

WHERE X.COUNT='COUNT' 