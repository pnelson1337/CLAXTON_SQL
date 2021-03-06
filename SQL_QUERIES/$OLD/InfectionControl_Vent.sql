-- VENT DAYS--
SELECT

BV.Name
,BV.AccountNumber									
,BV.UnitNumber																						AS 'Med Rec #'
,CONVERT(VARCHAR(10),BCT.ServiceDateTime,101)														AS 'Service Date'
,''																									AS ' '
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)															AS 'Birth Date'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),CONVERT(VARCHAR(10),BV.ServiceDateTime,101))		AS 'Admit Date'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,101)														AS 'Discharge Date'
,AV.LocationID																						AS 'Location'
,BCTI.ProcedureID																					AS 'Proc Code'
,DBPROC.Description																					AS 'Proc Description'
,CASE WHEN BD.DiagnosisCodeID IS NULL  THEN 'N' 
	  WHEN BD1.DiagnosisCodeID IS NULL THEN 'N' ELSE 'Y' END										AS 'Pneumonia(Y/N)'
--,BV.VisitID




FROM		[Livedb].[dbo].[BarVisits]				AS BV			
LEFT JOIN	[Livedb].[dbo].[AdmVisits]				AS AV			ON BV.VisitID=AV.VisitID
INNER JOIN	[Livedb].[dbo].[BarBchTxns]				AS BCT			ON BV.BillingID=BCT.BillingID
INNER JOIN	[Livedb].[dbo].[BarBchs]				AS BCH			ON BCH.BatchID=BCT.BatchID AND BCH.Status!='DELETED'
LEFT JOIN	[Livedb].[dbo].[BarBchTxnItems]			AS BCTI			ON BCT.BatchID=BCTI.BatchID AND BCT.TxnNumberID=BCTI.TxnNumberID
LEFT JOIN	[Livedb].[dbo].[DBarProcedures]			AS DBPROC		ON BCTI.ProcedureID=DBPROC.ProcedureID AND DBPROC.Active='Y'
LEFT JOIN	[Livedb].[dbo].[BarDiagnoses]			AS BD			ON BV.BillingID=BD.BillingID AND BD.DiagnosisCodeID IN ('J95.851')
LEFT JOIN	[Livedb].[dbo].[BarDiagnoses]			AS BD1			ON BV.BillingID=BD.BillingID AND BD.DiagnosisCodeID IN ('J15.9')
--LEFT JOIN	[Livedb].[dbo].[OeOrders]				AS OEORD		ON BCTI.ProcedureID=OEORD.OrderedProcedure AND BCT.ServiceDateTime=OEORD.ServiceDateTime AND BV.VisitID=OEORD.VisitID

WHERE BCTI.ProcedureID IN ('480095','480096')
AND BV.DischargeDateTime BETWEEN @StartDate AND @EndDate
AND BCT.ServiceDateTime BETWEEN  @StartDate AND @EndDate


ORDER BY Name, BCT.ServiceDateTime