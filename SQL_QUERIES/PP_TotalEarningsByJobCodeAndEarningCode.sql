SELECT

PPTC.JobCode											AS 'Job Code'
,PPTCE.EarningNumber
,MAX(DPPE.PrimaryCheckCaption)							AS 'Description'
,SUM(PPTCE.Amount)										AS 'Dollar Amount'
,SUM(PPTCE.Hours)										AS 'Hours'



FROM		[Livedb].[dbo].[PpTimeCardEarnings]			AS PPTCE
LEFT JOIN	[Livedb].[dbo].[PpTimeCards]				AS PPTC					ON PPTCE.TimeCardID=PPTC.TimeCardID
LEFT JOIN	[Livedb].[dbo].[DPpEarnings]				AS DPPE					ON PPTCE.EarningNumber=DPPE.EarningID	AND DPPE.Active='Y'

WHERE CAST(PPTC.GlPostDateTime AS DATE) BETWEEN @StartDate AND @EndDate
AND PPTC.Contract		IN (@Contract)
AND PPTCE.EarningNumber	IN (@EarningNumber)
AND PPTC.JobCode		IN (@JobCode)



GROUP BY PPTC.JobCode,PPTCE.EarningNumber
ORDER BY PPTC.JobCode,PPTCE.EarningNumber