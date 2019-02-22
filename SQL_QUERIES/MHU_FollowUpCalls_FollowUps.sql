SELECT *  FROM (

SELECT


 --RXMORD.OrderSeq

 AV.Name
,AV.AccountNumber
,CONVERT(VARCHAR(10),AV.BirthDateTime,101)				AS 'Date of Birth'
,''														AS ' '
,CONVERT(VARCHAR(10),RXMORD.OrderDateTime,101)			AS 'ApptDate'
--,RXMOD.ResourceOutsideLocationID						AS 'Location'
,ISNULL(OL.Name,'')										AS 'ApptLoc'
,ISNULL(OL.Phone,'')									AS 'ApptLocPhone'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,101)			AS 'DisDate'

-- START NOTES IN A SINGLE CELL PER PATIENT ORDER--
				,ISNULL ((SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '1') AND (RXMORD.OrderID = RXMORDTXT.OrderID))  +
				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '2')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '2')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +

				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '3')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '3')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +

				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '4')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '4')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +

				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '5')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '5')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +

				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '6')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '6')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +
		 				
				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '7')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '7')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +

				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '8')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '8')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +
						
				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '9')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '9')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END +								

				CASE 
				WHEN (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '10')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) IS NULL THEN '' 
				ELSE + '' + (SELECT RXMORDTXT.TextLine FROM [Livedb].[dbo].[RxmOrdText]  RXMORDTXT WHERE (RXMORDTXT.TextSeqID = '10')  AND (RXMORD.OrderID = RXMORDTXT.OrderID)) END 
				,'')
				 AS 'Appointment Notes'

--END NOTES IN SINGLE CELL--


,ISNULL(COALESCE(FU11.Response,FU21.Response,FU31.Response,FU41.Response,FU51.Response),'')																					AS 'Attended?'
,ISNULL(COALESCE(FU12.Response,FU22.Response,FU32.Response,FU42.Response,FU52.Response),'')																					AS 'Reason(IF NO)'
,ISNULL(COALESCE(FU13.Response,FU23.Response,FU33.Response,FU43.Response,FU53.Response),'')																					AS 'Rescheduled Date'
,ISNULL(COALESCE(FU14.Response,FU24.Response,FU34.Response,FU44.Response,FU54.Response),'')																			AS 'Attended Resched?'
,ISNULL(COALESCE(FU153.Response,FU253.Response,FU353.Response,FU453.Response,FU553.Response),'')																		AS 'Follow-Up - 1'
,ISNULL(COALESCE(FU163.Response,FU263.Response,FU363.Response,FU463.Response,FU563.Response),'')																		AS 'Follow-Up - 2'
,ISNULL(COALESCE(FU173.Response,FU273.Response,FU373.Response,FU473.Response,FU573.Response),'')																		AS 'Follow-Up - 3'

,CASE WHEN COALESCE(FU11.Response,FU21.Response,FU31.Response,FU41.Response,FU51.Response) IS NULL THEN 'FIRST CLINIC VISIT'
	  WHEN COALESCE(FU12.Response,FU22.Response,FU32.Response,FU42.Response,FU52.Response) = 'RESCHED' 
	   AND COALESCE(FU14.Response,FU24.Response,FU34.Response,FU44.Response,FU54.Response) IS NULL THEN 'RESCHED CLINIC VISIT'
	  ELSE 'HOME FOLLOW UP' END																																							AS 'CallType'

,CASE WHEN COALESCE(FU11.Response,FU21.Response,FU31.Response,FU41.Response,FU51.Response) IS NULL THEN ISNULL(OL.Phone,'')
	  WHEN COALESCE(FU12.Response,FU22.Response,FU32.Response,FU42.Response,FU52.Response) = 'RESCHED' 
	   AND COALESCE(FU14.Response,FU24.Response,FU34.Response,FU44.Response,FU54.Response) IS NULL THEN OL.Phone
	  ELSE BV.HomePhone END																																							AS 'CallTypeNumber'

,CASE WHEN COALESCE(FU153.Response,FU253.Response,FU353.Response,FU453.Response,FU553.Response) IS NULL THEN 'FOLLOW UP #1'
	  WHEN COALESCE(FU163.Response,FU263.Response,FU363.Response,FU463.Response,FU563.Response) IS NULL THEN 'FOLLOW UP #2'
	  WHEN COALESCE(FU173.Response,FU273.Response,FU373.Response,FU473.Response,FU573.Response) IS NULL THEN 'FOLLOW UP #3' END														AS  'FUNumber'
,AV.InpatientServiceID			 
,ISNULL(TS4.Response,'EP')																																										AS 'TX. COOR'
FROM	 	[Livedb].[dbo].[AdmVisits]															AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]															AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN	(SELECT
			 ROW_NUMBER() OVER (PARTITION BY RXMORD.VisitID ORDER BY RXMORD.OrderID)			AS OrderSeq
			 ,RXMORD.*
			 FROM			[Livedb].[dbo].[RxmOrds]											AS RXMORD
			 LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]											AS RXMOD		ON RXMORD.OrderID=RXMOD.OrderID
			 LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]										AS OL			ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID 
			 WHERE RXMORD.OrderTypeID='Referral'
				AND RXMORD.Status !='CAN'
				AND RXMORD.OrderDateTime IS NOT NULL
				AND (RXMOD.ResourceOutsideLocationID IN ('ACT','CBH','CHMCOPMHC','CPHPS','GWC','MWC','MBH','NORTHSTARM','NORTHSTARSL','MENTAL','RWC','SBH','STLAWCMHC ','STREGISMMHC','CHCNCMH','VAMASSMH')
				OR RXMOD.SpecialtyAbsServiceID = 'PSYCH'))										AS RXMORD		ON AV.VisitID=RXMORD.VisitID 				
LEFT JOIN	[Livedb].[dbo].[RxmOrdDetails]														AS RXMOD		ON RXMORD.OrderID=RXMOD.OrderID
LEFT JOIN	[Livedb].[dbo].[DMisOutLocations]													AS OL			ON RXMOD.ResourceOutsideLocationID=OL.OutsideLocationID
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanData]											AS DISPO		ON BV.VisitID=DISPO.VisitID
LEFT JOIN	[Livedb].[dbo].[DMisDischargeDisposition]											AS DISDISPO		ON DISPO.DispositionID=DISDISPO.DispositionID AND DISDISPO.Active='Y'

/* QUERY ANSWERS GROUPED BY SAME QUERY ON EACH REF*/

--ATTENDED APPOINTMENT--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU11			ON AV.VisitID=FU11.VisitID AND FU11.QueryID='MHUFU1.1' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU21			ON AV.VisitID=FU21.VisitID AND FU21.QueryID='MHUFU2.1' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU31			ON AV.VisitID=FU31.VisitID AND FU31.QueryID='MHUFU3.1' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU41			ON AV.VisitID=FU41.VisitID AND FU41.QueryID='MHUFU4.1' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU51			ON AV.VisitID=FU51.VisitID AND FU51.QueryID='MHUFU5.1' AND RXMORD.OrderSeq = '5'

--REASON (IF NO)--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU12			ON AV.VisitID=FU12.VisitID AND FU12.QueryID='MHUFU1.2' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU22			ON AV.VisitID=FU22.VisitID AND FU22.QueryID='MHUFU2.2' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU32			ON AV.VisitID=FU32.VisitID AND FU32.QueryID='MHUFU3.2' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU42			ON AV.VisitID=FU42.VisitID AND FU42.QueryID='MHUFU4.2' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU52			ON AV.VisitID=FU52.VisitID AND FU52.QueryID='MHUFU5.2' AND RXMORD.OrderSeq = '5'

--RESCHED DATE?--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU13			ON AV.VisitID=FU13.VisitID AND FU13.QueryID='MHUFU1.3' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU23			ON AV.VisitID=FU23.VisitID AND FU23.QueryID='MHUFU2.3' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU33			ON AV.VisitID=FU33.VisitID AND FU33.QueryID='MHUFU3.3' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU43			ON AV.VisitID=FU43.VisitID AND FU43.QueryID='MHUFU4.3' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU53			ON AV.VisitID=FU53.VisitID AND FU53.QueryID='MHUFU5.3' AND RXMORD.OrderSeq = '5'

--RESCHED ATTEND?--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU14			ON AV.VisitID=FU14.VisitID AND FU14.QueryID='MHUFU1.4' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU24			ON AV.VisitID=FU24.VisitID AND FU24.QueryID='MHUFU2.4' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU34			ON AV.VisitID=FU34.VisitID AND FU34.QueryID='MHUFU3.4' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU44			ON AV.VisitID=FU44.VisitID AND FU44.QueryID='MHUFU4.4' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU54			ON AV.VisitID=FU54.VisitID AND FU54.QueryID='MHUFU5.4' AND RXMORD.OrderSeq = '5'

--FOLLOW UP #1--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU153		ON AV.VisitID=FU153.VisitID AND FU153.QueryID='MHUFU1.5.3' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU253		ON AV.VisitID=FU253.VisitID AND FU253.QueryID='MHUFU2.5.3' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU353		ON AV.VisitID=FU353.VisitID AND FU353.QueryID='MHUFU3.5.3' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU453		ON AV.VisitID=FU453.VisitID AND FU453.QueryID='MHUFU4.5.3' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU553		ON AV.VisitID=FU553.VisitID AND FU553.QueryID='MHUFU5.5.3' AND RXMORD.OrderSeq = '5'

--FOLLOW UP #1--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU163		ON AV.VisitID=FU163.VisitID AND FU163.QueryID='MHUFU1.6.3' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU263		ON AV.VisitID=FU263.VisitID AND FU263.QueryID='MHUFU2.6.3' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU363		ON AV.VisitID=FU363.VisitID AND FU363.QueryID='MHUFU3.6.3' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU463		ON AV.VisitID=FU463.VisitID AND FU463.QueryID='MHUFU4.6.3' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU563		ON AV.VisitID=FU563.VisitID AND FU563.QueryID='MHUFU5.6.3' AND RXMORD.OrderSeq = '5'

--FOLLOW UP #1--
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU173		ON AV.VisitID=FU173.VisitID AND FU173.QueryID='MHUFU1.7.3' AND RXMORD.OrderSeq = '1'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU273		ON AV.VisitID=FU273.VisitID AND FU273.QueryID='MHUFU2.7.3' AND RXMORD.OrderSeq = '2'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU373		ON AV.VisitID=FU373.VisitID AND FU373.QueryID='MHUFU3.7.3' AND RXMORD.OrderSeq = '3'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU473		ON AV.VisitID=FU473.VisitID AND FU473.QueryID='MHUFU4.7.3' AND RXMORD.OrderSeq = '4'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS FU573		ON AV.VisitID=FU573.VisitID AND FU573.QueryID='MHUFU5.7.3' AND RXMORD.OrderSeq = '5'
LEFT JOIN	[Livedb].[dbo].[AdmPatDischargePlanFormQueries]										AS TS4			ON BV.VisitID=TS4.VisitID AND TS4.QueryID='MHUTS4'	

WHERE BV.DischargeDateTime > '2018-07-01'

)AS X

WHERE (X.[Attended?] ='N' OR X.[Attended?]='')
AND   (X.[Reason(IF NO)] NOT IN ('PTCAN','REHOSP'))
AND   (X.[Attended Resched?] ='N' OR X.[Attended Resched?]='')
AND   (X.[Follow-Up - 1] IN ('NA','LM','OTH') OR X.[Follow-Up - 1]='')
AND   (X.[Follow-Up - 2] IN ('NA','LM','OTH') OR X.[Follow-Up - 2]='')
AND    X.[Follow-Up - 3] =''
AND X.ApptDate IS NOT NULL
AND X.InpatientServiceID='MHC'
AND (X.ApptDate < GETDATE()-1 AND X.[Rescheduled Date] < GETDATE()-1)
AND X.CallType IN ('HOME FOLLOW UP')

ORDER BY FUNumber