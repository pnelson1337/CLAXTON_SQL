SELECT

SUM(CASE WHEN DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) <= 30 THEN PivotTable.BC END)		AS '<= 30'
,SUM(CASE WHEN DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) >= 31 AND DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) <=60 THEN PivotTable.BC END)		AS '>=31 OR <=60'
,SUM(CASE WHEN DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) >= 61 AND DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) <=90 THEN PivotTable.BC END)		AS '>=61 OR <=90'
,SUM(CASE WHEN DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) >= 91 AND DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) <=120 THEN PivotTable.BC END)		AS '>=91 OR <=120'
,SUM(CASE WHEN DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) >= 121 AND DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) <=150 THEN PivotTable.BC END)		AS '>=121 OR <=150'
,SUM(CASE WHEN DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE()) > 151														 THEN PivotTable.BC END)		AS '151+'
--,PivotTable.AccountNumber
--,PivotTable.BC
--,DATEDIFF(DAY,PivotTable.SerAdmitDate,GETDATE())
FROM
(
    SELECT BINS.[VisitID]
		   ,BV.AccountNumber
           ,BINS.InsuranceID
		   ,BINS.Balance
		   ,ISNULL(BV.ServiceDateTime,BV.AdmitDateTime)														AS 'SerAdmitDate'
    FROM 		[Livedb].[dbo].[BarInsuranceLedger]															AS BINS
	LEFT JOIN	[Livedb].[dbo].[BarVisitFinancialData]														AS BVFD		ON BINS.VisitID=BVFD.VisitID
	LEFT JOIN	[Livedb].[dbo].[BarVisits]																	AS BV		ON BINS.VisitID=BV.VisitID
	WHERE (BV.ServiceDateTime BETWEEN '2017-01-01' AND '2018-11-30' OR BV.DischargeDateTime BETWEEN '2017-01-01' AND '2018-11-30')
	AND BVFD.BarStatus NOT IN ('CR','BD')
) AS SourceTable PIVOT(AVG([Balance]) FOR [InsuranceID] IN(BC)) AS PivotTable
WHERE PivotTable.BC > 0

--ORDER BY SerAdmitDate