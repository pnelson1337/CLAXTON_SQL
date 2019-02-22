SELECT

AV.Name
,AV.AccountNumber
,BV.VisitID
,CLTYPE.Response																									AS 'CLType'
,ASSESS.Response																									AS 'Assessed'
,DRESSING.Response																									AS 'DressingChanged'
,CAST(DRESSING.DateTime	AS DATE)																					AS 'DressingDate'
,ISNULL(TUBING.Response,'')																							AS 'TubingChanged'
,ISNULL(TUBING.DateTime,'')																							AS 'TubingDate'
--,ASSESS.DateTime																									AS 'DateTime'


FROM		[Livedb].[dbo].[AdmVisits]																				AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																				AS BV			ON AV.VisitID=BV.VisitID
--ASSESS CHANGED--
LEFT JOIN (SELECT [VisitID],[BaseID],[OccurrenceSeqID],[DateTime],
[ActivitySeqID],[QueryID],[Response],[RowUpdateDateTime]
FROM [Livedb].[dbo].[NurQueryResults]
WHERE QueryID='CCICVCASSE')																							AS ASSESS		ON AV.VisitID=ASSESS.VisitID
--START CENTRAL LINE TYPE--
LEFT JOIN (SELECT [VisitID],[BaseID],[OccurrenceSeqID],[DateTime],
[ActivitySeqID],[QueryID],[Response],[RowUpdateDateTime]
FROM [Livedb].[dbo].[NurQueryResults]
WHERE QueryID='CCICVC007')																							AS CLTYPE		ON ASSESS.VisitID=CLTYPE.VisitID AND ASSESS.ActivitySeqID=CLTYPE.ActivitySeqID AND ASSESS.DateTime=CLTYPE.DateTime
--DRESSING CHANGED--
LEFT JOIN (SELECT [VisitID],[BaseID],[OccurrenceSeqID],[DateTime],
[ActivitySeqID],[QueryID],[Response],[RowUpdateDateTime]
FROM [Livedb].[dbo].[NurQueryResults]
WHERE QueryID='CCICVC072' AND Response='Y')																			AS DRESSING		ON ASSESS.VisitID=DRESSING.VisitID AND ASSESS.ActivitySeqID=DRESSING.ActivitySeqID AND ASSESS.DateTime=DRESSING.DateTime
--TUBING CHANGED--
LEFT JOIN (SELECT [VisitID],[BaseID],[OccurrenceSeqID],[DateTime],
[ActivitySeqID],[QueryID],[Response],[RowUpdateDateTime]
FROM [Livedb].[dbo].[NurQueryResults]
WHERE QueryID='CCICVC073' AND Response='Y')																			AS TUBING		ON ASSESS.VisitID=TUBING.VisitID AND ASSESS.ActivitySeqID=TUBING.ActivitySeqID AND ASSESS.DateTime=TUBING.DateTime

WHERE ASSESS.DateTime BETWEEN '2018-12-01' AND '2018-12-31'
AND (DRESSING.Response IS NOT NULL)		


ORDER BY BV.UnitNumber,	DRESSING.DateTime																				