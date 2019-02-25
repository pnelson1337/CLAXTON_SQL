DECLARE @STARTDATE DATE = '2018-08-12'
DECLARE @ENDDATE DATE = '2018-08-26'


SELECT DISTINCT



 --TCEARN.ExpenseDept
 TCEARN.EarningNumber
,EARN.EarnIdentifier


FROM		[Livedb].[dbo].[PpTimeCards]				AS TC


LEFT JOIN  (SELECT 
TCEARN.ExpenseDept
,SUM(TCEARN.Hours)										AS 'TotalHours'
FROM		[Livedb].[dbo].[PpTimeCards]				AS TC
LEFT JOIN	[Livedb].[dbo].[PpTimeCardEarnings]			AS TCEARN	ON TC.TimeCardID=TCEARN.TimeCardID
WHERE TC.Status='POSTED'
AND TC.TimeCardDateTime  BETWEEN @STARTDATE AND @ENDDATE
GROUP BY TCEARN.ExpenseDept)							AS TCHRS	ON TCHRS.ExpenseDept=TC.Dept

LEFT JOIN	[Livedb].[dbo].[PpTimeCardEarnings]			AS TCEARN	ON TC.TimeCardID=TCEARN.TimeCardID
LEFT JOIN	[Livedb].[dbo].[PpEmployees]				AS PPEMP	ON TC.EmployeeID=PPEMP.EmployeeID
LEFT JOIN	[Livedb].[dbo].[DPpEarnings]				AS EARN		ON TCEARN.EarningNumber=EARN.EarningID AND EARN.Active='Y'


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
				GROUP BY BudgetID ,LEFT(AccountID,4))	AS FTE		ON TCEARN.ExpenseDept=FTE.DeptNumber

 
WHERE TC.Status='POSTED'
--AND TC.EmployeeID='2659'
--AND TC.TotalHours IS NOT NULL
AND TC.TimeCardDateTime  BETWEEN @STARTDATE AND @ENDDATE


GROUP BY TCEARN.ExpenseDept,TCEARN.EarningNumber, EARN.EarnIdentifier

--ORDER BY TCEARN.ExpenseDept

ORDER BY TCEARN.EarningNumber