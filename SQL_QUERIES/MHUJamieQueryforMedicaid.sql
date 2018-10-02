SELECT * FROM (

SELECT

--AV.VisitID
 AV.AccountNumber
,AV.UnitNumber																										AS 'MRN'
,AV.Name
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)																			AS 'Admit Date'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,101)																		AS 'Discharge Date'
--,ISNULL(SpecialtyAbsServiceID,'')																					AS 'Type'															
--,ISNULL(CONVERT(VARCHAR(10),RXMORD.[Min Appt Date],101),'')															AS 'Appointment Date'
--,ISNULL(ISNULL(ISNULL(ISNULL(RXMORDRP.ReferToProviderID,OL.Name),RXMOD.ToPracticeFree),RXMOD.ToProviderFree),'')	AS 'Appointment Location/Provider'
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

						) THEN 'YES'
		WHEN SpecialtyAbsServiceID = 'PSYCH' THEN 'YES'
		ELSE 'NO' END															AS 'Appointment Made?'
	
FROM		[Livedb].[dbo].[AdmVisits]						AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]						AS BV					ON AV.VisitID=BV.VisitID
LEFT JOIN	(SELECT RXMORD1.VisitID
				,MIN(RXMORD1.OrderDateTime)					AS 'Min Appt Date'
				,MIN(RXMORD1.OrderID)						AS 'OrderID'
				,MIN(RXMORD1.EnteredByUserID)				AS 'EnteredByUserID'
				,MIN(RXMORD1.OrderID)						AS 'ORDID'
				FROM [Livedb].[dbo].[RxmOrds]				AS RXMORD1
				LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]					AS RXMOD1				ON RXMORD1.OrderID=RXMOD1.OrderID
				LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]				AS OL1					ON RXMOD1.ResourceOutsideLocationID=OL1.OutsideLocationID				
				WHERE RXMORD1.OrderTypeID='Referral'
				AND RXMORD1.Status !='CAN'
				AND RXMORD1.OrderDateTime IS NOT NULL
				AND (OL1.Name IN ( 'ACT Team',
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
						'St.Regis Mohawk MH Clinic')
				OR SpecialtyAbsServiceID = 'PSYCH') 					




GROUP BY RXMORD1.VisitID)									AS RXMORD				ON AV.VisitID=RXMORD.VisitID

--INNER JOIN	[Livedb].[dbo].[RxmOrds]						AS RXMORD				ON AV.VisitID=RXMORD.VisitID AND RXMORD.OrderTypeID='Referral'
LEFT JOIN	[Livedb].[dbo].[RxmOrdReferProviders]			AS RXMORDRP				ON RXMORD.OrderID=RXMORDRP.OrderID
LEFT JOIN	[Livedb].[dbo].[RxmOrdReferGroups]				AS RXMORDG				ON RXMORD.OrderID=RXMORDG.OrderID
LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]					AS RXMOD				ON RXMORD.OrderID=RXMOD.OrderID
LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]				AS OL					ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID
LEFT JOIN	[Livedb].[dbo].[DMisUsers]						AS DMU					ON RXMORD.EnteredByUserID=DMU.UserID
LEFT JOIN	[Livedb].[dbo].[DMisDischargeDisposition]		AS DISDISPO				ON BV.DischargeDispositionID=DISDISPO.DispositionID AND DISDISPO.Active='Y'






WHERE CAST(BV.DischargeDateTime AS DATE) BETWEEN  '2018-04-01' AND '2018-06-30'

AND AV.InpatientServiceID ='MHC'
AND BV.DischargeDateTime IS NOT NULL
AND BV.FinancialClassID IN ('HMCD','MCD')


) AS X

--WHERE X.Name LIKE '%FREGOE%'

--WHERE X.COUNT='COUNT' 
--AND X.[Days Appointment Was Made] <= 7
--AND X.[Days Appointment Was Made] >= 8
--OR X.[Days Appointment Was Made] IS NULL
--WHERE X.AccountNumber='26781492'
--ORDER BY X.[Discharge Date],X.[Days Appointment Was Made]

ORDER BY X.[Discharge Date]
