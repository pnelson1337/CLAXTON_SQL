SELECT

--BV.AccountNumber
 --BV.VisitID
 BV.Name
,RE.Account
,RE.LocationID
,RE.PatientStatusID
,DRE.ExamTypeID
,RE.ExamID
,RE.ExamName
,CAST(RE.ExamDateTime AS DATE)											AS 'ExamDate'
,RIGHT(REPT.ProcedureStartDateTime,8)									AS 'ExamStartTime'
,RIGHT(REPT.ProcedureCompleteDateTime,8)								AS 'ExamCompleteDateTime'


,RE.ExamStatus
,RES.Technologist1
,ISNULL(RES.Technologist2,'')											AS 'Technologist2'
,ISNULL(RES.Technologist3,'')											AS 'Technologist3'


FROM		[Livedb].[dbo].[RadExams]						AS RE			--ON BV.VisitID=RE.VisitID
INNER JOIN	[Livedb].[dbo].[RadExamStaff]					AS RES			ON RE.VisitID=RES.VisitID AND RE.ExamSeqID=RES.ExamSeqID AND RE.ExamDateTime=RES.ExamDateTime
LEFT JOIN	[Livedb].[dbo].[BarVisits]						AS BV			ON RE.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[RadExamPatientTracking]			AS REPT			ON RE.VisitID=REPT.VisitID AND RE.ExamSeqID=REPT.ExamSeqID AND RE.ExamDateTime=REPT.ExamDateTime
LEFT JOIN	[Livedb].[dbo].[DRadExamNomenclatureMaps]		AS DRE			ON RE.ExamID=DRE.ExamMnemonicID


WHERE RE.ExamDateTime BETWEEN '2018-10-01' AND '2018-10-31'
--WHERE CONVERT(VARCHAR(10),RE.ExamDateTime,101) BETWEEN '2018-10-01' AND '2018-10-31'
AND RE.ExamStatus != 'C'
AND RE.ProcedureCompletedDateTime IS NOT NULL


ORDER BY RE.ExamDateTime, RES.Technologist1, DRE.ExamTypeID

--GROUP BY RES.Technologist1, RE.ExamName
