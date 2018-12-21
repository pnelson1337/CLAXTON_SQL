SELECT


/* SHE CARES ABOUT THIS FOR DSRIP 
 COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) <= 7 THEN '1' END )							AS 'Appointments Within 7 Days'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) <= 7  AND FU11.Response='Y' THEN '1' END)	AS 'Total Attended Within 7 Days'

,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) >= 8 AND DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) <= 30 AND FU12.Response    THEN '1' END )					AS 'Appointments Between 8 AND 30 DAYS'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) >= 8 AND DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) <= 30 AND FU11.Response='Y'   THEN '1' END )							AS 'Total Attended Between 8 AND 30 DAYS'

,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,FU13.Response) >= 8 AND DATEDIFF(d,BV.DischargeDateTime,FU13.Response) <= 30   THEN '1' END )											AS 'Resched Between 8 AND 30 DAYS'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,FU13.Response) >= 8 AND DATEDIFF(d,BV.DischargeDateTime,FU13.Response) <= 30 AND FU14.Response='Y'   THEN '1' END )											AS 'Resched Attended Between 8 AND 30 DAYS'
*/

 COUNT(BV.VisitID)																									AS 'Total Discharges to Home'
,COUNT(RXMORD.OrderDateTime)																						AS 'Total Appointments Made'
,COUNT(CASE WHEN FU11.Response='Y' THEN '1' END)																	AS 'Total Attended'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) <= 7 THEN '1' END )							AS 'Appointments Made Within 7 Days of Discharge'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,RXMORD.OrderDateTime) <= 7  AND FU11.Response='Y' THEN '1' END)	AS 'Total Attended Within 7 Days of Discharge'
,COUNT(CASE WHEN FU13.Response IS NOT NULL THEN '1' END)															AS 'Total Rescheduled'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,FU13.Response) <= 30  THEN '1' END)								AS 'Total Rescheduled Within 30 Days'
,COUNT(CASE WHEN FU14.Response='Y'  THEN '1' END)																	AS 'Total Attended Rescheduled'
,COUNT(CASE WHEN DATEDIFF(d,BV.DischargeDateTime,FU13.Response) <= 30  AND FU14.Response='Y' THEN '1' END)			AS 'Total Attended Within 30 Days'


FROM	 	[Livedb].[dbo].[AdmVisits]																				AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																				AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanData]																AS DISPO		ON BV.VisitID=DISPO.VisitID
LEFT JOIN	[Livedb].[dbo].[DMisDischargeDisposition]																AS DISDISPO		ON DISPO.DispositionID=DISDISPO.DispositionID AND DISDISPO.Active='Y'

LEFT JOIN	(SELECT * FROM(
SELECT ROW_NUMBER() OVER (PARTITION BY RXMORD.VisitID ORDER BY RXMORD.OrderID)										AS OrderSeq
 ,RXMORD.*
 FROM		[Livedb].[dbo].[RxmOrds]																				AS RXMORD
 LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]																			AS RXMOD		ON RXMORD.OrderID=RXMOD.OrderID
 LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]																		AS OL			ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID 
 WHERE RXMORD.OrderTypeID='Referral'AND RXMORD.Status !='CAN'
	   AND RXMORD.OrderDateTime IS NOT NULL AND (RXMOD.ResourceOutsideLocationID IN ('ACT','CBH','CHMCOPMHC','CPHPS','GWC','MWC','MBH','NORTHSTARM','NORTHSTARSL','MENTAL','RWC','SBH','STLAWCMHC ','STREGISMMHC','CHCNCMH','VAMASSMH'/*CLINICS PRIOR TO 9/19 CHANGE*/,'VAMASS','COMMHCNC')
	   OR RXMOD.SpecialtyAbsServiceID = 'PSYCH')) AS X WHERE X.OrderSeq='1' OR X.OrderSeq IS NULL)					AS RXMORD		ON AV.VisitID=RXMORD.VisitID

LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]																			AS RXMOD		ON RXMORD.OrderID=RXMOD.OrderID
LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]																		AS OL			ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID
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


WHERE CAST(BV.DischargeDateTime AS DATE) BETWEEN  '2018-10-01' AND '2018-12-31'
AND DISPO.DispositionID IN ('H','HHS','HPSY')
AND AV.InpatientServiceID ='MHC'
AND BV.DischargeDateTime IS NOT NULL





