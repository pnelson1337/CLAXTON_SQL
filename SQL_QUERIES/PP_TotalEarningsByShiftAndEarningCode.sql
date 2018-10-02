SELECT

 PPTCE.EarningNumber
,DEARN.PrimaryCheckCaption
,PPTC.Shift
,SUM(PPTCE.Amount)									AS 'Dollar Amount'
,SUM(PPTCE.Hours)									AS 'Hours'

FROM		[Livedb].[dbo].[PpTimeCardEarnings]		AS PPTCE
LEFT JOIN	[Livedb].[dbo].[PpTimeCards]			AS PPTC					ON PPTCE.TimeCardID=PPTC.TimeCardID
LEFT JOIN	[Livedb].[dbo].[DPpEarnings]			AS DEARN				ON PPTCE.EarningNumber=DEARN.EarningID AND DEARN.Active='Y'

WHERE CAST(PPTC.GlPostDateTime AS DATE) BETWEEN '2017-01-01' AND '2017-12-31'
AND PPTC.Contract IN ('L200','L721')

GROUP BY PPTC.Shift,PPTCE.EarningNumber,DEARN.PrimaryCheckCaption
ORDER BY PPTC.Shift,PPTCE.EarningNumber