SET NOCOUNT ON;
SELECT 
bv.AccountNumber																											AS 'AccountNumber'
,fd.AccountType																												AS 'AccountType'
,av.InpatientOrOutpatient																									AS 'AcctTypeInOut'
,CONVERT(varchar(10),ct.BatchDateTime,23)																					AS 'TransactionDate'
,ct.TransactionID																											AS 'TransactionURN'																									
,ct.TransactionProcedureID																									AS 'TransactionProcedureCode'
,bp.Description																												AS 'TransactionProcedureDescription'
,ct.TransactionCount																										AS 'TransactionCount'
,ct.Amount																													AS 'TransactionAmount'
,''																															AS 'TransactionMnemonic'
,ct.Type																													AS 'TransactionType'
,bp.ChargeCategoryID																										AS 'TransactionProcedureChargeCat'
,bp.ChargeDeptID																											AS 'TransactionProcedureChgDept'
,bv.PrimaryInsuranceID																										AS 'XXXInsComp'
,bp.GlStatComponent																											AS 'AcctTypesGLRevComp'
,(Select bd.DiagnosisCodeID
				 from [Livedb].[dbo].[BarDiagnoses]bd
                    where bd.DiagnosisSeqID='1' 
                    and fd.BillingID=bd.BillingID)																			AS 'XXDiagCode'
,COALESCE(CONVERT(varchar(10),fd2.AttendProviderID,23), '') + '' + COALESCE(CONVERT(varchar(10),fd2.ErProviderID,23), '')	AS 'XXDoc'
,ct.UniqueClaimReferenceNumber																								AS 'TransactionUCRN'

FROM Livedb.dbo.BarChargeTransactions ct

JOIN Livedb.dbo.BarVisits bv ON ct.VisitID=bv.VisitID
JOIN Livedb.dbo.BarVisitFinancialData fd ON ct.VisitID=fd.VisitID
JOIN Livedb.dbo.BarVisitFinancialData2 fd2 ON fd.VisitID=fd2.VisitID
JOIN Livedb.dbo.DBarProcedures bp ON ct.TransactionProcedureID=bp.ProcedureID AND bp.Active='Y'
LEFT JOIN Livedb.dbo.AdmVisits av ON ct.VisitID=av.VisitID
--LEFT JOIN [Livedb].[dbo].[BarUniqueClaimReferenceData]		AS UCRN	ON ct.VisitID=UCRN.VisitID
	
WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN '2016-01-01' AND '2016-12-31' OR CONVERT(varchar(10),bv.AdmitDateTime,23) BETWEEN '2016-01-01' AND '2016-12-31'


UNION ALL

SELECT 
	bv.AccountNumber																											AS 'AccountNumber'
	,fd.AccountType																												AS 'AccountType'
	,av.InpatientOrOutpatient																									AS 'AcctTypeInOut'
	,CONVERT(varchar(10),ct.BatchDateTime,23)																					AS 'TransactionDate'
	,ct.TransactionID																											AS 'TransactionURN'																									
	,ct.TransactionProcedureID																									AS 'TransactionProcedureCode'
	,bp.Description																												AS 'TransactionProcedureDescription'
	,ct.TransactionCount																										AS 'TransactionCount'
	,ct.Amount																													AS 'TransactionAmount'
	,ct.InsuranceID																												AS 'TransactionMnemonic'
	,ct.Type																													AS 'TransactionType'
	,bp.ChargeCategoryID																										AS 'TransactionProcedureChargeCat'
	,bp.ChargeDeptID																											AS 'TransactionProcedureChgDept'
	,bv.PrimaryInsuranceID																										AS 'XXXInsComp'
	,bp.GlStatComponent																											AS 'AcctTypesGLRevComp'
	,(Select bd.DiagnosisCodeID
					 from [Livedb].[dbo].[BarDiagnoses]bd
                     where bd.DiagnosisSeqID='1' 
                     and fd.BillingID=bd.BillingID)																				AS 'XXDiagCode'
	,COALESCE(CONVERT(varchar(10),fd2.AttendProviderID,23), '') + '' + COALESCE(CONVERT(varchar(10),fd2.ErProviderID,23), '')	AS 'XXDoc'
	,ct.UniqueClaimReferenceNumber																								AS 'TransactionUCRN'

FROM [Livedb].[dbo].[BarCollectionTransactions]		AS  ct

JOIN Livedb.dbo.BarVisits							AS	bv  ON ct.VisitID=bv.VisitID
JOIN Livedb.dbo.BarVisitFinancialData				AS	fd  ON ct.VisitID=fd.VisitID
JOIN Livedb.dbo.BarVisitFinancialData2				AS	fd2 ON fd.VisitID=fd2.VisitID
JOIN Livedb.dbo.DBarProcedures						AS	bp  ON ct.TransactionProcedureID=bp.ProcedureID AND bp.Active='Y'
LEFT JOIN Livedb.dbo.AdmVisits						AS	av  ON ct.VisitID=av.VisitID
--LEFT JOIN [Livedb].[dbo].[BarUniqueClaimReferenceData]		AS UCRN	ON ct.VisitID=UCRN.VisitID
	
WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN '2016-01-01' AND '2016-12-31' OR CONVERT(varchar(10),bv.AdmitDateTime,23) BETWEEN '2016-01-01' AND '2016-12-31'
AND ct.Type IN ('R','A')








