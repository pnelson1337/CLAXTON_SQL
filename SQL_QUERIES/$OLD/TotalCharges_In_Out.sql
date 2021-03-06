DECLARE @TODAY DATE
SET @TODAY = GETDATE()


SELECT

 SUM(CASE WHEN BV.InpatientOrOutpatient = 'I' THEN BCT.Amount END) AS 'Inpatient Charges'
,SUM(CASE WHEN BV.InpatientOrOutpatient = 'O' THEN BCT.Amount END) AS 'Outpatient Charges'
,SUM(BCT.Amount)												   AS 'Total Charges'	

FROM [Livedb].[dbo].[BarChargeTransactions]													AS BCT
INNER JOIN [Livedb].[dbo].[BarVisits] BV ON BV.VisitID=BCT.VisitID
WHERE BatchDateTime >= DATEADD(DAY,-1, CAST(GETDATE() AS DATE)) AND BatchDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME)