Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= '2018-07-01'					--DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, DAY(GETDATE())-1)
SET @EndDate=	'2016-11-21'					--DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + -1, DAY(GETDATE())-1)


SELECT
 BV.[Name] 
--,RE.[VisitID]
,CONVERT(VARCHAR(10), RE.ExamDateTime,101)				AS 'Exam Date'
,RE.[Account]
,RE.[ExamNumber]
,RE.[ExamTypeID]
,RE.[ExamName]
,ISNULL(RE.OrderID,'')									AS 'Order Number'
,RES.ProviderID
,ISNULL(RES.Technologist1,'')							AS 'Tech One'
,ISNULL(RES.Technologist2,'')							AS 'Tech Two'
,BCT.TransactionProcedureID
,BCT.Amount



FROM			[Livedb].[dbo].[RadExams]				AS RE
INNER JOIN		[Livedb].[dbo].[RadExamStaff]			AS RES		ON RE.VisitID=RES.VisitID AND RE.ExamDateTime=RES.ExamDateTime AND RE.ExamSeqID=RES.ExamSeqID
INNER JOIN		[Livedb].[dbo].[BarVisits]				AS BV		ON RE.VisitID=BV.VisitID
INNER JOIN		[Livedb].[dbo].[BarChargeTransactions]	AS BCT		ON BV.VisitID=BCT.VisitID

WHERE(CONVERT(varchar(10),RE.ExamDateTime,23) BETWEEN @StartDate AND @EndDate)
AND RE.CancelUserID IS NULL
AND RE.ExamName != 'MAMMO TOMO SCREENING EXAM'

--AND BCT.TransactionProcedureID LIKE ('47%')

ORDER BY BCT.TransactionProcedureID

