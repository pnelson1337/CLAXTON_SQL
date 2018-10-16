SELECT

BV.Name										AS PATIENT_NAME
,DIAG.SINGLE_VALUE							AS DIAGNOSIS_SINGECELL

FROM		[Livedb].[dbo].[AdmVisits]		AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]		AS BV		ON AV.VisitID=BV.VisitID
LEFT JOIN (SELECT DIAG.VisitID
,STUFF((
SELECT ', ' + Diagnosis FROM [Livedb].[dbo].[AbsDrgDiagnoses]
								WHERE (VisitID = DIAG.VisitID)
								AND (Diagnosis >= 'E08.00') AND (Diagnosis <= 'E13.9') 
								FOR XML PATH (''),type).value('(./text())[1]','varchar(max)')
								, 1, 2,'')	AS SINGLE_VALUE

FROM [Livedb].[dbo].[AbsDrgDiagnoses]			AS DIAG
WHERE (DIAG.Diagnosis >= 'E08.00') AND (DIAG.Diagnosis <= 'E13.9') 
GROUP BY DIAG.VisitID)															AS DIAG			ON AV.VisitID=DIAG.VisitID


WHERE (CONVERT(VARCHAR(10),BV.DischargeDateTime,23) BETWEEN '2018-09-01' AND '2018-09-30') 
AND (AV.InpatientOrOutpatient = 'I')
AND DIAG.SINGLE_VALUE IS NOT NULL


GROUP BY BV.Name


