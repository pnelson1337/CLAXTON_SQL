SELECT 


DIAG.VisitID
,STUFF((
SELECT ', ' + Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses]
								WHERE (VisitID = DIAG.VisitID)
								AND (Diagnosis >= 'E08.00') AND (Diagnosis <= 'E13.9') 
								FOR XML PATH (''),type).value('(./text())[1]','varchar(max)')
								, 1, 2,'')	AS SINGLE_VALUE

FROM [Livedb].[dbo].[AbsDrgDiagnoses]			AS DIAG
WHERE (DIAG.Diagnosis >= 'E08.00') AND (DIAG.Diagnosis <= 'E13.9') 
GROUP BY DIAG.VisitID