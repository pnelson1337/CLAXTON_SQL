DECLARE @STARTDATE DATE = '2018-08-12'
DECLARE @ENDDATE DATE = '2018-08-12'
SET NOCOUNT ON

SELECT


 GL.ValueID																																		AS 'Dept'
,TCHRS.ExpenseDept																																AS 'TCDeptNumber'
,GLHRS.DeptNumber																																AS 'GLDeptNumber'
,TCHRS.TotalHours																																AS 'TCPeriodHours'
,TCHRS.TotalHours / CASE WHEN @STARTDATE=@ENDDATE THEN 80 ELSE (DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1) * 80 END								AS 'TCActualFTE'  -- TC Hours / NumberOfPeriodHours								
,CASE WHEN @STARTDATE=@ENDDATE THEN 80 * GLHRS.PeriodFTE ELSE ((DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1) * 80) * GLHRS.PeriodFTE END		 	AS 'GLPeriodHours'	-- Budgetted FTE * NumberOfPeriodHours
,GLHRS.PeriodFTE																																AS 'GLPeriodFTE'
,CASE WHEN @STARTDATE=@ENDDATE THEN '1' ELSE DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1 END														AS 'NumberOfPeriods'
,CASE WHEN @STARTDATE=@ENDDATE THEN 80 ELSE (DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1) * 80 END												AS 'NumberOfPeriodHours'	

									
FROM		[Livedb].[dbo].[DMisGlComponentValue]				AS GL

------
LEFT JOIN (SELECT 
TCEARN.ExpenseDept
,SUM(TCEARN.Hours)										AS 'TotalHours'
FROM		[Livedb].[dbo].[PpTimeCards]				AS TC
LEFT JOIN	[Livedb].[dbo].[PpTimeCardEarnings]			AS TCEARN	ON TC.TimeCardID=TCEARN.TimeCardID
WHERE TC.Status='POSTED'
AND TC.TimeCardDateTime  BETWEEN @STARTDATE AND @ENDDATE
GROUP BY TCEARN.ExpenseDept)									AS TCHRS			ON GL.ValueID=TCHRS.ExpenseDept

------
LEFT JOIN	(SELECT
				 LEFT(AccountID,4)																																							AS 'DeptNumber'
				,SUM(AnnualBudget)/2080																																						AS 'PeriodFTE'
				FROM [Livedb].[dbo].[GlBudgets]
				WHERE FiscalYearID = '2018'
				AND BudgetID='FILE 18'
				AND(AccountID LIKE '%.2010' -- REGULAR
				OR  AccountID LIKE '%.2012' -- OTHER PROD
				OR  AccountID LIKE '%.2020' -- SICK
				OR  AccountID LIKE '%.2030' -- VACATION
				OR  AccountID LIKE '%.2040' -- PERSONAL
				OR  AccountID LIKE '%.2050' -- HOLIDAY
				)
				GROUP BY BudgetID ,LEFT(AccountID,4))	AS GLHRS		ON GL.ValueID=GLHRS.DeptNumber



WHERE GL.ComponentID='DPT'
AND GL.Active='Y'
AND ExpenseDept IS NOT NULL
