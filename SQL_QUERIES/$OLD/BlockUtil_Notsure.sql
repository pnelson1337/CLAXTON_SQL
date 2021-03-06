SELECT

SCHOR.PatientCaseID
,SCHOR.OperationRoomID																												AS 'OPERATING ROOM'
,BV.Name
,SCHOR.ProviderID	
,SCHOR.OperationDateTime																											AS 'OPERATION DATE/TIME'


,UPPER(LEFT(DATENAME(WEEKDAY,SCHOR.OperationDateTime),3))																			AS 'DAY OF WEEK'
,BLOCKTIMES.DayID																													AS 'BLOCK DAY'
,BLOCKTIMES.[BLOCK BEGIN]																											AS 'BLOCK START'
,ORTIMES.[OR IN(HHMM)]
,BLOCKTIMES.[BLOCK END]																												AS 'BLOCK END'
,ORTIMES.[OR OUT(HHMM)]
,DATEDIFF(MI,ORTIMES.[OR IN(HHMM)],ORTIMES.[OR OUT(HHMM)])

,CASE WHEN ORTIMES.[OR IN(HHMM)] > BLOCKTIMES.[BLOCK BEGIN] AND ORTIMES.[OR OUT(HHMM)] > BLOCKTIMES.[BLOCK END]		THEN (ORTIMES.[OR OUT(HHMM)]-BLOCKTIMES.[BLOCK END])
	  WHEN ORTIMES.[OR IN(HHMM)] < BLOCKTIMES.[BLOCK BEGIN]	AND ORTIMES.[OR OUT(HHMM)] < BLOCKTIMES.[BLOCK END]		THEN (BLOCKTIMES.[BLOCK BEGIN]-ORTIMES.[OR IN(HHMM)])
	  WHEN ORTIMES.[OR IN(HHMM)] > BLOCKTIMES.[BLOCK BEGIN] AND ORTIMES.[OR OUT(HHMM)] < BLOCKTIMES.[BLOCK BEGIN]	THEN '0'
	  WHEN ORTIMES.[OR IN(HHMM)] < BLOCKTIMES.[BLOCK BEGIN] AND ORTIMES.[OR OUT(HHMM)] > BLOCKTIMES.[BLOCK BEGIN]	THEN (BLOCKTIMES.[BLOCK BEGIN]-ORTIMES.[OR IN(HHMM)])+(ORTIMES.[OR OUT(HHMM)]-BLOCKTIMES.[BLOCK END])
	  WHEN BLOCKTIMES.[BLOCK BEGIN] IS NULL THEN ORTIMES.[OR OUT(HHMM)]-ORTIMES.[OR IN(HHMM)] 

END AS	'OUT TIME'


FROM		[Livedb].[dbo].[SchOrPatCases]																							AS SCHOR
LEFT JOIN	[Livedb].[dbo].[BarVisits]																								AS BV			ON SCHOR.VisitID=BV.VisitID
LEFT JOIN (SELECT
			ONE.CaseID
			--,Op2DateTime																														AS 'OR IN DATETIME'
			--,Op6DateTime																														AS 'OR OUT DATETIME'
			,CAST(RIGHT('0' + CAST(DATEPART(HH,Op2DateTime) AS VARCHAR),2)+RIGHT('0' + CAST(DATEPART(MI,Op2DateTime) AS VARCHAR),2) AS INT)		AS 'OR IN(HHMM)'
			,CAST(RIGHT('0' + CAST(DATEPART(HH,Op6DateTime) AS VARCHAR),2)+RIGHT('0' + CAST(DATEPART(MI,Op6DateTime) AS VARCHAR),2)	AS INT)		AS 'OR OUT(HHMM)'
			 FROM		[Livedb].[dbo].[SchPatOrCaseTimesOp1]	AS ONE
			 LEFT JOIN	[Livedb].[dbo].[SchPatOrCaseTimesOp2]	AS TWO	ON ONE.CaseID=TWO.CaseID)									AS ORTIMES	ON SCHOR.PatientCaseID=ORTIMES.CaseID
			 
LEFT JOIN (SELECT
			SRPD.ResourceID,SRPD.ProviderID,SRD.DayID,SRD.DayFromTime AS 'BLOCK BEGIN',SRD.DayThruTime AS 'BLOCK END'
			FROM			[Livedb].[dbo].[DSchResourceDates]																		AS SRD
			LEFT JOIN		[Livedb].[dbo].[DSchResourceOrProfileDoctor]															AS SRPD						ON SRD.ResourceID=SRPD.ResourceID AND SRD.DateSeqID=SRPD.DateSeqID
			INNER JOIN (SELECT SRPD.ResourceID,SRPD.ProviderID,MAX(SRD.DateSeqID)													AS 'DateSeqID',SRD.DayID
						FROM [Livedb].[dbo].[DSchResourceDates]																		AS SRD
						LEFT JOIN [Livedb].[dbo].[DSchResourceOrProfileDoctor]														AS SRPD						ON SRD.ResourceID=SRPD.ResourceID AND SRD.DateSeqID=SRPD.DateSeqID
						WHERE SRPD.ResourceID IS NOT NULL GROUP BY SRPD.ResourceID,SRPD.ProviderID,SRD.DayID)						AS TEST						ON TEST.DateSeqID=SRPD.DateSeqID AND TEST.ProviderID=SRPD.ProviderID AND TEST.ResourceID=SRD.ResourceID
			WHERE SRPD.ResourceID IS NOT NULL)																						AS BLOCKTIMES				ON SCHOR.ProviderID=BLOCKTIMES.ProviderID AND UPPER(LEFT(DATENAME(WEEKDAY,SCHOR.OperationDateTime),3))=BLOCKTIMES.DayID AND SCHOR.OperationRoomID=BLOCKTIMES.ResourceID


WHERE SCHOR.OperationDateTime BETWEEN '2018-10-04' AND '2018-10-10'
AND SCHOR.CompleteDateTime IS NOT NULL
--AND SCHOR.VisitID='6012183219'
--AND SCHOR.PatientCaseID='81153'