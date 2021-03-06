SELECT * FROM (

SELECT
 PPBT.BenefitTxnDateTime
,PPBT.EmployeeID																AS 'SQL EMPLOYEE ID'
,PPEmp.Number																	AS 'Employee Number'
,PPEmp.Name
,PPEPay.Contract																AS 'Contract'
,PPEPay.JobCode																	AS 'JobCode'
,PPBT.Earned
,(SELECT TEMP.ValueID +' ' + '-' +' ' +  TEMP.Name
  FROM [Livedb].[dbo].[DMisGlComponentValue] TEMP
  WHERE PPEPay.Dept=TEMP.ValueID AND TEMP.ComponentID='DPT' )					AS 'Department'
,PPBT.EarningID
,PPBT.BenTxnPlan
,(SELECT DPPBEN.CheckCaption
	FROM [Livedb].[dbo].[DPpBenefits] DPPBEN
	WHERE PPBT.BenTxnPlan=DPPBEN.ContractCodeID
		AND PPBT.EarningID=DPPBEN.BenefitEarningID								
	)																			AS 'BenefitName'
,PPBT.PointerTimeCardID

,PPTCE.Rate																		AS 'Rate'
,PPBT.Taken																		AS 'Total Hours Taken'
,SUM(PPBT.Taken * PPTCE.Rate)													AS 'Total Benefit Paid'

/*
,'$' + CONVERT(varchar(50),CAST(SUM(PPTCE.Rate) AS MONEY),-1)					AS 'Rate'
,CONVERT(varchar(50),CAST(SUM(PPBT.Taken) AS MONEY),1)							AS 'Total Hours Taken'
,'$' + CONVERT(varchar(50),CAST(SUM(PPBT.Taken * PPTCE.Rate) AS MONEY),-1)		AS 'Total Benefit Paid'

*/
	 
FROM	    [Livedb].[dbo].[PpPerBenefitTransactions]							AS PPBT
	JOIN	[Livedb].[dbo].[PpEmployeePayroll]									AS PPEPay							ON PPEPay.EmployeeID=PPBT.EmployeeID
	JOIN	[Livedb].[dbo].[PpEmployees]										AS PPEmp							ON PPEmp.EmployeeID=PPBT.EmployeeID
	JOIN [Livedb].[dbo].[PpTimeCardEarnings]									AS PPTCE							ON PPTCE.TimeCardID=PPBT.PointerTimeCardID AND EarningCounterID='1'
	--LEFT JOIN [Livedb].[dbo].[PpTimeCardEarnings]								AS PPTCE							ON PPBT.PointerTimeCardID=PPTCE.TimeCardID
	--JOIN [Livedb].[dbo].[PpTimeCardBenefits]									AS TCB								ON PPBT.PointerTimeCardID=TCB.TimeCardID
	--JOIN [Livedb].[dbo].[PpEmployeeBenefitBalances]								AS EBB								ON PPBT.EmployeeID = EBB.EmployeeID
	--LEFT JOIN [Livedb].[dbo].[PpTimeCardComputedEarnings]						AS TCE								ON PPBT.PointerTimeCardID = TCE.TimeCardID AND PPBT.EarningID=TCE.EarningID
	
--WHERE [BenefitTxnDateTime] BETWEEN '2017-11-01' AND '2017-11-30'

WHERE PPBT.[Taken] IS NOT NULL

GROUP BY 	
PPBT.BenefitTxnDateTime
,PPBT.EmployeeID															
,PPEmp.Number																
,PPEmp.Name
,PPEPay.Contract
,PPEPay.JobCode
,PPEPay.Dept
,PPBT.Earned
,PPBT.EarningID
,PPBT.BenTxnPlan
,PPBT.PointerTimeCardID
,PPTCE.Rate
,PPBT.Taken
	
--ORDER BY Department,PPBT.EmployeeID,PPBT.BenefitTxnDateTime,PPBT.EarningID

) AS X

WHERE [BenefitTxnDateTime] BETWEEN @StartDate AND @EndDate
AND X.Department	IN (@Department)
AND X.BenefitName	IN (@Benefit)
AND X.Contract		IN (@Contract)
AND X.JobCode		IN (@JobCode)


--WHERE TEST.Department = '1310 - CHMC MED SURG'
--AND TEST.BenefitName = 'HOL'


/*
   
SELECT
 SUM(PPBT.Taken)																AS 'Total Benefit Taken'
,SUM(PPBT.Taken * PPTCE.Rate)													AS 'Total Benefit Paid($)'

	 
FROM [Livedb].[dbo].[PpPerBenefitTransactions] PPBT
	JOIN [Livedb].[dbo].[PpEmployeePayroll]										AS PPEPay							ON PPEPay.EmployeeID=PPBT.EmployeeID
	JOIN [Livedb].[dbo].[PpEmployees]											AS PPEmp							ON PPEmp.EmployeeID=PPBT.EmployeeID
	JOIN [Livedb].[dbo].[PpTimeCardEarnings]									AS PPTCE							ON PPTCE.TimeCardID=PPBT.PointerTimeCardID AND EarningCounterID='1'

WHERE [BenefitTxnDateTime] BETWEEN '2017-10-01' AND '2017-10-31'
--WHERE [BenefitTxnDateTime] BETWEEN @StartDate AND @EndDate
--AND @Contract
--AND @JobCode
--AND @Department
--AND @Benefit
AND PPBT.Taken IS NOT NULL

*/








   