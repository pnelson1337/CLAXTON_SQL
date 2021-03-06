

SELECT
 RE.Account
,RE.VisitID
,RE.ExamName
,REPT.ExamSeqID
,CONVERT(VARCHAR,RE.ExamDateTime,101)									AS 'Exam Date'
,DATEDIFF(n,REPT.ArrivalDateTime,REPT.DepartureDateTime)				AS 'Arrival to Depart (Minutes)'
,DATEDIFF(n,REPT.ArrivalDateTime,RE.ProcedureCompletedDateTime)			AS 'Arrival to Procedure Completion (Minutes)'
,DATEDIFF(n,REPT.ProcedureStartDateTime,RE.ProcedureCompletedDateTime)	AS 'Procedure Start to Procedure Finish'
,DATEDIFF(n,RE.ProcedureCompletedDateTime,RE.DraftDateTime)				AS 'Procedure Completion to Draft (Minutes)'
,DATEDIFF(n,RE.DraftDateTime,RE.SignedDateTime)							AS 'Draft to Signed (Minutes)'


FROM
				[Livedb].[dbo].[RadExams]								AS RE
--INNER JOIN		[Livedb].[dbo].[BarVisits]								AS BV		ON RE.VisitID=BV.VisitID
LEFT OUTER JOIN	[Livedb].[dbo].[RadExamPatientTracking]					AS REPT		ON RE.VisitID=REPT.VisitID AND RE.ExamSeqID=REPT.ExamSeqID AND RE.ExamDateTime=REPT.ExamDateTime


  WHERE RE.ExamDateTime BETWEEN '2017-12-01' AND '2017-12-01'
  AND RE.CancelDateTime IS NULL
  AND RE.ExamTypeID NOT IN ('CARD')

 -- AND RE.VisitID='6012010198'


  ORDER BY RE.ExamDateTime, RE.Account, RE.ExamSeqID




