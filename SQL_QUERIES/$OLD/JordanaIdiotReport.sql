SELECT * FROM (
SELECT 

BV.Name
,ROW_NUMBER() OVER (PARTITION BY BV.UnitNumber ORDER BY BV.AccountNumber DESC )		AS RowNum
,LASTADMIT.AdmitDateTime
,BV.UnitNumber

FROM	  [Livedb].[dbo].[BarVisits]													AS BV
LEFT JOIN [Livedb].[dbo].[AdmVisits]													AS AV									ON BV.VisitID=AV.VisitID
LEFT JOIN [Livedb].[dbo].[SchAppointments]												AS SA									ON BV.VisitID=SA.VisitID		
LEFT JOIN	(SELECT*FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY BV.UnitNumber ORDER BY BV.AdmitDateTime DESC )			AS RowNum
,BV.UnitNumber,BV.Name,BV.VisitID,BV.AdmitDateTime,BVP.ProviderID
FROM [Livedb].[dbo].[BarVisits]															AS BV
LEFT JOIN [Livedb].[dbo].[BarVisitProviders]											AS BVP									ON BV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
WHERE BV.AdmitDateTime IS NOT NULL AND BV.VisitID IS NOT NULL AND BV.UnitNumber IS NOT NULL AND BV.InpatientServiceID='MHC'
) AS X
WHERE X.RowNum='1')																		AS LASTADMIT							ON LASTADMIT.UnitNumber=BV.UnitNumber
INNER JOIN [CH-ECW-DBC-SQL].[mobiledoc].[dbo].[enc]										AS ECWENC								ON AV.AccountNumber=ECWENC.HL7Id
INNER JOIN (SELECT 
 CONVERT(INT,CASE WHEN IsNumeric(CONVERT(VARCHAR(12), ECWACOPROG.[patientId]))		= 1	THEN CONVERT(VARCHAR(12),ECWACOPROG.[patientId])		ELSE 0 END)	AS 'patientId'
,CONVERT(INT,CASE WHEN IsNumeric(CONVERT(VARCHAR(12), ECWACOPROG.enrollmentstatus)) = 1 THEN CONVERT(VARCHAR(12),ECWACOPROG.enrollmentstatus)	ELSE 0 END)	AS 'enrollmentstatus'
,CONVERT(INT,CASE WHEN IsNumeric(CONVERT(VARCHAR(12), ECWACOPROG.delFlag))			= 1	THEN CONVERT(VARCHAR(12),ECWACOPROG.delFlag)			ELSE 0 END)	AS 'delFlag'
,CONVERT(INT,CASE WHEN IsNumeric(CONVERT(VARCHAR(12), ECWACOPROG.programId))		= 1	THEN CONVERT(VARCHAR(12),ECWACOPROG.programId)			ELSE 0 END)	AS 'programId'
,CONVERT(INT,CASE WHEN IsNumeric(CONVERT(VARCHAR(12), ECWACOPROG.STATUS))			= 1	THEN CONVERT(VARCHAR(12),ECWACOPROG.STATUS)				ELSE 0 END)	AS 'STATUS'
FROM [CH-ECW-DBC-SQL].[mobiledoc].[dbo].[ptacoprograms] AS ECWACOPROG
WHERE ECWACOPROG.source = 'Claxton Hepburn Wellness Center' AND ECWACOPROG.delFlag = 0 AND ECWACOPROG.programId = 7 AND ECWACOPROG.enrollmentstatus = 1 AND ECWACOPROG.STATUS = 0) AS ECWACOPROG ON ECWENC.[patientID]=ECWACOPROG.[patientId]



WHERE SA.LocationID='WELL'
AND SA.CancelReasonID IS NULL

) AS FU
WHERE FU.RowNum='1'
AND FU.AdmitDateTime IS NOT NULL
ORDER BY FU.AdmitDateTime





