DECLARE @NQR TABLE(QueryID VarChar(MAX),DateTime DATE,Response VarChar(MAX))
INSERT INTO @NQR(QueryID,DateTime,Response)
SELECT NQRT.QueryID,NQRT.DateTime,NQRT.Response
FROM [Livedb].[dbo].[NurQueryResults]NQRT



DECLARE @NQR2 TABLE(QueryID VarChar(MAX),DateTime DATE,Response VarChar(MAX))
INSERT INTO @NQR2(QueryID,DateTime,Response)
SELECT NQRTEMP.QueryID,dt.MaxEffDate,NQRTEMP.Response FROM @NQR NQRTEMP

INNER JOIN (SELECT QueryID,MAX(DateTime) AS MaxEffDate FROM @NQR GROUP BY QueryID)dt
ON NQRTEMP.QueryID=dt.QueryID and NQRTEMP.DateTime=dt.MaxEffDate
GROUP BY NQRTEMP.QueryID,dt.MaxEffDate,NQRTEMP.Response



SELECT

NQR2.QueryID
,NQR2.DateTime
,NQR2.Response




FROM		[Livedb].[dbo].[AdmVisits]					AS AV
INNER JOIN	[Livedb].[dbo].[NurQueryResults]			AS RNQR		ON AV.VisitID=RNQR.VisitID	
LEFT JOIN	@NQR2										AS NQR2		ON RNQR.QueryID=NQR2.QueryID 
  
WHERE NQR2.QueryID='CMIDT037'

 -- AND NQR.DateTime=(SELECT MAX(DateTime) FROM [Livedb].[dbo].[NurQueryResults] WHERE AV.VisitID=VisitID)

