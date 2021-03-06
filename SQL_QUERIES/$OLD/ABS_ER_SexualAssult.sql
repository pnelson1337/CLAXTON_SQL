Set NOCOUNT ON;
DECLARE	@StartDate VARCHAR, @EndDate VARCHAR
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)
*/

SET @StartDate= '2017-11-21'					--DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, DAY(GETDATE())-1)
SET @EndDate=	'2017-11-21'					--DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + -1, DAY(GETDATE())-1)



SELECT

 BV.VisitID
,BV.AccountNumber
,BV.UnitNumber
,BV.Name
,DIAG.Diagnosis
,CONVERT(VARCHAR,BV.ServiceDateTime,101)	AS 'ServiceDate'
,BV.OutpatientLocationID					AS 'Location'
,BV.BirthDateTime

FROM [Livedb].[dbo].[AbsDrgDiagnoses]		AS DIAG
INNER JOIN[Livedb].[dbo].[BarVisits]		AS BV		ON DIAG.VisitID=BV.VisitID 
INNER JOIN[Livedb].[dbo].[AdmVisits]		AS AV		ON DIAG.VisitID=AV.VisitID


/*
WHERE	BV.ServiceDateTime >= DATEADD(qq,-1,GETDATE())
AND		BV.ServiceDateTime <= DATEADD(qq, -1,GETDATE())
*/

WHERE CAST(BV.ServiceDateTime AS DATE) BETWEEN '2018-01-01' AND '2018-03-31'

AND Diagnosis IN ('Z04.41','Z04.41','Z04.42','Z04.71','Z04.72','T74.21','T74.21XA','T76.21XA','T74.22XA','T76.22XA')
AND BV.ServiceDateTime > '10-01-2016'
AND AV.[Status] LIKE '%ER%'