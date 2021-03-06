SELECT

 AV.Name
,PAIN.DateTime 
FROM		[Livedb].[dbo].[AdmVisits]									AS AV
LEFT JOIN (SELECT NQR.DateTime, NQR.VisitID
			FROM [Livedb].[dbo].[NurQueryResults]						AS NQR
			WHERE NQR.DateTime >= DATEADD(HOUR, -12, GETDATE())
			  AND NQR.DateTime <  DATEADD(HOUR, 0, GETDATE())
			  AND NQR.QueryID='CCPAIN065')								AS PAIN				ON AV.VisitID=PAIN.VisitID					


WHERE AV.LocationID='3RD'
AND AV.Status='ADM IN'


ORDER BY Name

