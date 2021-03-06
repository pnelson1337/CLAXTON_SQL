SELECT 
       --AV.[VisitID]
       AV.[AccountNumber]															
	  ,AV.Name																AS 'Patient Name'
	  ,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)							AS 'Admit Date'
	  ,AV.Status
	  ,AV.InpatientServiceID												AS 'Service Type'

FROM [Livedb].[dbo].[AdmVisits]												AS AV
LEFT JOIN [Livedb].[dbo].[BarVisits]										AS BV ON AV.VisitID=BV.VisitID

WHERE AV.InpatientServiceID IN ('ALC','SWINGBED')
AND BV.DischargeDateTime IS NULL
AND AV.Status NOT IN ('PRE IN','CAN IN')

  

