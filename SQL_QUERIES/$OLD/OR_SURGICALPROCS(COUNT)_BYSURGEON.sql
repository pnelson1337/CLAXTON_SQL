SELECT 



COUNT(OPS.OpID)					AS 'Count'
,OPS.OpID
,SCHOR.SurgeonID

--,ORPROF.BasicStartDateTime




FROM		[Livedb].[dbo].[SchOrPatCases]																	AS SCHOR
LEFT JOIN	[Livedb].[dbo].[SchOrPatCaseActualOps]															AS OPS			ON SCHOR.PatientCaseID=OPS.PatientCaseID
--LEFT JOIN	[Livedb].[dbo].[SchCalendarOrProfileProviders]													AS ORPROF		ON SCHOR.OperationRoomID=ORPROF.ResourceID AND CONVERT(VARCHAR(10),SCHOR.OperationDateTime,101)=CONVERT(VARCHAR(10),ORPROF.[DateTime],101) AND SCHOR.ProviderID=ORPROF.ProviderID

WHERE CAST(SCHOR.OperationDateTime AS DATE) BETWEEN '2017-12-01' AND '2018-12-01'
AND SCHOR.CompleteCharge IS NOT NULL

--AND BLOCKTIMES.FrequencyID IS NOT NULL


GROUP BY SCHOR.SurgeonID, OPS.OpID



ORDER BY Count

--ORDER BY OperationDateTime