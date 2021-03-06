SELECT * FROM
(

SELECT
 BV.[Name] 
--,RE.[VisitID]
,CONVERT(VARCHAR(10), RE.ExamDateTime,101)				AS 'Exam Date'
,RE.[Account]
,RE.[ExamNumber]
,RE.[ExamTypeID]
,RE.[ExamName]
,ISNULL(RE.OrderID,'')									AS 'OrderNumber'
,RES.ProviderID
,DMISPROV.Name
,ISNULL(RES.Technologist1,'')							AS 'TechOne'
,ISNULL(RES.Technologist2,'')							AS 'TechTwo'

,COUNT(RE.[Account])									AS 'Total Exams'


FROM			[Livedb].[dbo].[RadExams]				AS RE
INNER JOIN		[Livedb].[dbo].[RadExamStaff]			AS RES		ON RE.VisitID=RES.VisitID AND RE.ExamDateTime=RES.ExamDateTime AND RE.ExamSeqID=RES.ExamSeqID
INNER JOIN		[Livedb].[dbo].[BarVisits]				AS BV		ON RE.VisitID=BV.VisitID
LEFT OUTER JOIN	[Livedb].[dbo].[DMisProvider]			AS DMISPROV	ON RES.ProviderID=DMISPROV.ProviderID


WHERE(CONVERT(varchar(10),RE.ExamDateTime,23) BETWEEN @StartDate AND @EndDate)

AND RE.CancelUserID IS NULL
) AS X

WHERE [Exam Date] BETWEEN @StartDate AND @EndDate
AND X.ProviderID IN (@Provider)


