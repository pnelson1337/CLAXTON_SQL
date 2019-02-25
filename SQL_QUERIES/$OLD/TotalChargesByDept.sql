DECLARE @TODAY DATE
SET @TODAY = GETDATE()


SELECT

 SUM(CASE WHEN BV.InpatientOrOutpatient = 'I' THEN BCT.Amount END) AS 'Inpatient Charges'
,SUM(CASE WHEN BV.InpatientOrOutpatient = 'O' THEN BCT.Amount END) AS 'Outpatient Charges'
,SUM(CASE WHEN  = '3RD' THEN BCT.Amount END)			AS 'MHU CHARGES'
,SUM(BCT.Amount)												   AS 'Total Charges'	

FROM [Livedb].[dbo].[BarChargeTransactions]													AS BCT
INNER JOIN [Livedb].[dbo].[BarVisits] BV ON BV.VisitID=BCT.VisitID
INNER JOIN  [Livedb].[dbo].[AdmVisits] AV ON AV.VisitID=BCT.VisitID		
WHERE BatchDateTime >= DATEADD(DAY,-30, CAST(GETDATE() AS DATE)) AND BatchDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME)