DECLARE @STARTDATE DATE, @ENDDATE DATE


--SET @STARTDATE = '2016-01-03'
SET @STARTDATE   = '10/07/2018'
SET @ENDDATE   = '10/21/2018' 

--SET @STARTDATE = $(STARTDATE) 
--SET @ENDDATE = $(ENDDATE)

--2018-08-26

SELECT

TC.Dept																																														AS 'DEPARTMENT ID'
,MAX(GL.Name)																																												AS 'DEPARTMENT NAME'
,ISNULL(CASE WHEN @STARTDATE=@ENDDATE THEN MAX(OKAY.[Annual FTEs])*1 ELSE (DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1) * MAX(OKAY.[Annual FTEs]) END,'0')									AS 'FTE BUDGETED'


,SUM(CASE WHEN @STARTDATE=@ENDDATE THEN TC.TotalHours / 80  ELSE ((TC.TotalHours/(DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1))/80) * (DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1)  END)		AS 'FTE ACTUAL'	 






,ISNULL(CASE WHEN @STARTDATE=@ENDDATE THEN MAX(OKAY.[Annual FTEs])*1 ELSE (DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1) * MAX(OKAY.[Annual FTEs]) END,'0') -	
 SUM(CASE WHEN @STARTDATE=@ENDDATE THEN TC.TotalHours / 80  ELSE ((TC.TotalHours/(DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1))/80) * (DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1)  END)		AS 'FTE DIFFERENCE'
 ,@STARTDATE																																												AS 'PERIOD START'
 ,@ENDDATE																																													AS 'PERIOD END'
 ,SUM(TC.TotalHours)																																										AS 'PERIOD HOURS'
,CASE WHEN @STARTDATE=@ENDDATE THEN '1' ELSE DATEDIFF(ww,@STARTDATE,@ENDDATE) /  2 + 1 END																									AS 'NUMBER OF PERIODS'


FROM		[Livedb].[dbo].[PpTimeCards]																																					AS TC
LEFT JOIN	[Livedb].[dbo].[DMisGlComponentValue]																																			AS GL	ON TC.Dept=GL.ValueID
LEFT JOIN	(SELECT
				 LEFT(AccountID,4)																																							AS 'Department Number'
				,SUM(AnnualBudget)/2080																																						AS 'Annual FTEs'
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
				GROUP BY BudgetID ,LEFT(AccountID,4))																																		AS OKAY				ON TC.Dept=OKAY.[Department Number]


WHERE CONVERT(VARCHAR(10),TimeCardDateTime,101) BETWEEN @STARTDATE AND @ENDDATE
AND Dept IS NOT NULL


GROUP BY Dept
ORDER BY [DEPARTMENT ID]

