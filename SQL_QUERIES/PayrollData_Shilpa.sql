DECLARE @PeriodStartDate VARCHAR,@PeriodEndDate VARCHAR

SET @PeriodStartDate ='2018-06-01'
SET @PeriodEndDate = '2018-06-30'

SELECT
 
 --PPEMP.EmployeeID
 PPEMP.Number														AS 'Employee Number'
,PPEMP.Name															AS 'Employee Name'
,TC.TimeCardDateTime												AS 'TimeCard Date'
,CONVERT(VARCHAR(10),PP.HireDateTime,101)							AS 'HireDate'
,CONVERT(VARCHAR(10),PP.AdjustedHireDateTime,101)					AS 'AdjHireDate'
,PP.JobCodeGrade													AS 'Job Code Grade'
,ISNULL(BR.Step,'')													AS 'Step'
,TCE.EarningNumber													AS 'Earn Code'
,EARN.EarnIdentifier												AS 'Earn Description'
,TCE.ExpenseDept													AS 'Work Department Number'	
,GL2.Name															AS 'Work Department'
,TC.BaseRate														AS 'Base Rate'
,TCE.Hours															AS 'Hours'
,TC.BaseRate * TCE.Hours											AS 'Regular Pay(Base Rate * Hours)'
,TCE.Amount															AS 'Actual Amount Paid'
,ISNULL(CASE WHEN TCE.ShiftInput> 1 
		THEN TCE.Amount-(TC.BaseRate * TCE.Hours) END,'0.00')		AS 'Shift Differential Amount'
,ISNULL(CASE WHEN TCE.ShiftInput> 1 
		THEN (TCE.Amount-(TC.BaseRate * TCE.Hours)) 
									   /TCE.Hours END,'0.00')		AS 'Shift Differential'
,TC.JobCode															AS 'Job Code'
,JC.Description														AS 'Job Description'
,PP.Dept															AS 'Home Department Number'
,GL.Name															AS 'Home Department Name'
,PP.EmployeeType													AS 'Employee Type'
,PP.Status															AS 'Employee Status'
,ISNULL(TCE.ShiftInput,'1')											AS 'Shift'
,TC.Contract														AS 'Contract'
,POS.Title															AS 'Position Title'
 --,EARN.PrimaryCheckCaption
 --,CASE WHEN TCE.ShiftInput = '1' THEN TCE.Hours * TC.BaseRate
--	END																AS 'TEST'

 FROM		[Livedb].[dbo].[PpEmployees]PPEMP
JOIN		[Livedb].[dbo].[PpTimeCards]							AS TC				ON PPEMP.EmployeeID=TC.EmployeeID
JOIN		[Livedb].[dbo].[PpTimeCardEarnings]						AS TCE				ON TC.TimeCardID=TCE.TimeCardID
JOIN		[Livedb].[dbo].[PpEmployeePayroll]						AS PP				ON TC.EmployeeID=PP.EmployeeID
LEFT JOIN	[Livedb].[dbo].[DPpPositions]							AS POS				ON PP.PositionNumber=POS.PositionID
LEFT JOIN	[Livedb].[dbo].[DPpEarnings]							AS EARN				ON TCE.EarningNumber=EARN.EarningID
LEFT JOIN	[Livedb].[dbo].[DMisGlComponentValue]					AS GL				ON PP.Dept=GL.ValueID
LEFT JOIN	[Livedb].[dbo].[DMisGlComponentValue]					AS GL2				ON TCE.ExpenseDept=GL2.ValueID
LEFT JOIN	[Livedb].[dbo].[DPpJobCodes]							AS JC				ON TC.JobCode=JC.JobCodeID
JOIN		[Livedb].[dbo].[PpPerEffectiveBaseRates]				AS BR				ON PPEMP.EmployeeID=BR.EmployeeID
--LEFT JOIN	[Livedb].[dbo].[DPpDifferentialShiftGrades]				AS DPPSD			ON TCE.ShiftInput=DPPSD.ShiftID AND TCE.JobInputGrade=DPPSD.GradeID
  Inner Join 
  (select EmployeeID, Max(DateTime) as LatestDate
  from [Livedb].[dbo].[PpPerEffectiveBaseRates]
  Group by EmployeeID)
  as br2 on BR.DateTime=br2.LatestDate
  and BR.EmployeeID=br2.EmployeeID


WHERE (CONVERT(VarChar(10),TC.TimeCardDateTime,23) BETWEEN @TCStartDate AND @TCEndDate)
--WHERE (CONVERT(VARCHAR(10),TC.TimeCardDateTime,23) BETWEEN '2018-06-01' AND '2018-06-30')


AND TCE.ExpenseDept IS NOT NULL
AND TCE.Amount IS NOT NULL
AND GL.Name!='NOT IN USE'

ORDER BY TC.PayDateTime,PPEMP.Number, TCE.EarningNumber, PP.Dept, PPEMP.Name
