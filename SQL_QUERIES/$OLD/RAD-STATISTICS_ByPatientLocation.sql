SELECT * FROM
(

SELECT
 CONVERT(VARCHAR(10), RE.ExamDateTime,101)				AS 'Exam Date'
,AV.LocationID
,COUNT(RE.[Account])									AS 'Total Exams'


FROM			[Livedb].[dbo].[RadExams]				AS RE
INNER JOIN		[Livedb].[dbo].[RadExamStaff]			AS RES		ON RE.VisitID=RES.VisitID AND RE.ExamDateTime=RES.ExamDateTime AND RE.ExamSeqID=RES.ExamSeqID
INNER JOIN		[Livedb].[dbo].[BarVisits]				AS BV		ON RE.VisitID=BV.VisitID
INNER JOIN		[Livedb].[dbo].[AdmVisits]				AS AV		ON BV.VisitID=AV.VisitID

LEFT OUTER JOIN	[Livedb].[dbo].[DMisProvider]			AS DMISPROV	ON RES.ProviderID=DMISPROV.ProviderID

WHERE RE.CancelUserID IS NULL

GROUP BY
RE.ExamDateTime
,AV.LocationID

) AS X

WHERE [Exam Date] BETWEEN @StartDate AND @EndDate
AND X.LocationID IN (@Location)


