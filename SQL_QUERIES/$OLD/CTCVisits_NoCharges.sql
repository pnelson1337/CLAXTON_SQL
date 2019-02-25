USE [Livedb]

Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
SET @StartDate= GETDATE() - 30
SET @EndDate= GETDATE() - 1



SELECT

BV.VisitID
,BV.AccountNumber
,BVFD.ChargeTotal
,CONVERT(VARCHAR(10),BV.ServiceDateTime,101)	AS 'Service Date'
,BV.OutpatientLocationID





FROM				[BarVisits]				AS BV
--INNER JOIN		[BarChargeTransactions]	AS BCT		ON BV.VisitID=BCT.VisitI
LEFT OUTER JOIN		[BarVisitFinancialData]	AS BVFD		ON BV.VisitID=BVFD.VisitID


WHERE BV.ServiceDateTime BETWEEN @StartDate AND @EndDate

AND OutpatientLocationID IN ('CTCMEDONC', 'CTCRAD', 'CTCMED')

AND BVFD.ChargeTotal IS NULL

ORDER BY BV.OutpatientLocationID, BV.ServiceDateTime