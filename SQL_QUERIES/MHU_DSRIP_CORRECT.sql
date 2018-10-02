SELECT * FROM (

SELECT

-- VISIT INFO--

 AV.AccountNumber

,AV.UnitNumber																										AS 'MRN'
,AV.Name																											AS 'Patient Name'
,CONVERT(VARCHAR(10),AV.BirthDateTime,101)																			AS 'Date of Birth'
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)																			AS 'Admit Date'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,101)																		AS 'Discharge Date'
-- APPOINTMENT INFO--
,''																													AS ' '
,ISNULL(RXMORD.OrderSeq,'')																							AS 'ApptSeq'
,ISNULL(DMU.Name,'')																								AS 'Appointment Creator'																
,ISNULL(CONVERT(VARCHAR(10),RXMORD.OrderDateTime,101),'')															AS 'Appointment Date'
,ISNULL(ISNULL(ISNULL(ISNULL(RXMORDRP.ReferToProviderID,OL.Name),RXMOD.ToPracticeFree),RXMOD.ToProviderFree),'')	AS 'Appointment Location/Provider'
,ISNULL(DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime),'')													AS 'Appointment Days After Discharge'
,ISNULL(FU11.Response,'NO DATA')					AS 'Attended?'
,ISNULL(FU12.Response,'NO DATA')					AS 'Reason'
,ISNULL(FU13.Response,'NO DATA')					AS 'Rescheduled Date'
,ISNULL(FU14.Response,'NO DATA')					AS 'Attended Resched?'

FROM	 	[Livedb].[dbo].[AdmVisits]																				AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																				AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN	(SELECT ROW_NUMBER() OVER (PARTITION BY RXMORD.VisitID ORDER BY RXMORD.OrderID)							AS OrderSeq
 ,RXMORD.*
 FROM			[Livedb].[dbo].[RxmOrds]																			AS RXMORD
 LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]																			AS RXMOD		ON RXMORD.OrderID=RXMOD.OrderID
 LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]																		AS OL			ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID 
 WHERE RXMORD.OrderTypeID='Referral'AND RXMORD.Status !='CAN'
	   AND RXMORD.OrderDateTime IS NOT NULL AND (RXMOD.ResourceOutsideLocationID IN ('ACT','CBH','CHMCOPMHC','CPHPS','GWC','MWC','MBH','NORTHSTARM','NORTHSTARSL','MENTAL','RWC','SBH','STLAWCMHC ','STREGISMMHC','CHCNCMH','VAMASSMH'/*CLINICS PRIOR TO 9/19 CHANGE*/,'VAMASS','COMMHCNC')
	   OR RXMOD.SpecialtyAbsServiceID = 'PSYCH'))																	AS RXMORD		ON AV.VisitID=RXMORD.VisitID

LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]																			AS RXMOD		ON RXMORD.OrderID=RXMOD.OrderID
LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]																		AS OL			ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanData]																AS DISPO		ON BV.VisitID=DISPO.VisitID
LEFT JOIN	[Livedb].[dbo].[DMisDischargeDisposition]																AS DISDISPO		ON DISPO.DispositionID=DISDISPO.DispositionID AND DISDISPO.Active='Y'
LEFT JOIN	[Livedb].[dbo].[RxmOrdReferProviders]																	AS RXMORDRP		ON RXMORD.OrderID=RXMORDRP.OrderID
LEFT JOIN	[Livedb].[dbo].[RxmOrdReferGroups]																		AS RXMORDG		ON RXMORD.OrderID=RXMORDG.OrderID
LEFT JOIN	[Livedb].[dbo].[DMisUsers]																				AS DMU			ON RXMORD.EnteredByUserID=DMU.UserID
--ATTENDED APPOINTMENT--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]															AS FU11			ON AV.VisitID=FU11.VisitID AND FU11.QueryID='MHUFU1.1' AND RXMORD.OrderSeq = '1'
--REASON (IF NO)--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]															AS FU12			ON AV.VisitID=FU12.VisitID AND FU12.QueryID='MHUFU1.2' AND RXMORD.OrderSeq = '1'
--RESCHED DATE?--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]															AS FU13			ON AV.VisitID=FU13.VisitID AND FU13.QueryID='MHUFU1.3' AND RXMORD.OrderSeq = '1'
--RESCHED ATTEND?--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]															AS FU14			ON AV.VisitID=FU14.VisitID AND FU14.QueryID='MHUFU1.4' AND RXMORD.OrderSeq = '1'


WHERE CAST(BV.DischargeDateTime AS DATE) BETWEEN  '2018-07-01' AND '2018-09-30'
AND DISPO.DispositionID IN ('H','HHS','HPSY')
AND AV.InpatientServiceID ='MHC'
AND BV.DischargeDateTime IS NOT NULL

)	AS X

WHERE X.ApptSeq = '1' 
OR X.ApptSeq =''

--ORDER BY X.ApptSeq, X.[Appointment Date]

ORDER BY [Appointment Days After Discharge]


