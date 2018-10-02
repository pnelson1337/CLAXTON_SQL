/****** Script for SelectTopNRows command from SSMS  ******/
SELECT

BV.Name										AS 'PT NAME'
,BV.UnitNumber								AS 'MR#'
,'DO ME'									AS 'AGE'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)	AS 'DOB'
,BV.Sex										AS 'GEN'
,CONVERT(VARCHAR(10),BV.AdmitDateTime,101)	AS 'ADMIT DATE'
,'DO ME'									AS 'LOS'
,'DO ME'									AS 'OBS LVL'
,BD.DiagnosisCodeID							AS 'DX CODE'
,''											AS 'CLINIC'
,'DO ME'									AS' LAST DC'
,''											AS 'D/C'
,BV.PrimaryInsuranceID						AS 'INS'
,''											AS 'TX. COOR.'

,BV.VisitID

FROM		[Livedb].[dbo].[BarVisits]		AS BV
INNER JOIN	[Livedb].[dbo].[AdmVisits]		AS AV	ON BV.VisitID=AV.VisitID
LEFT JOIN	[Livedb].[dbo].[BarDiagnoses]	AS BD	ON BV.BillingID=BD.BillingID AND BD.DiagnosisSeqID='1'
--LEFT JOIN	(SELECT MAX

WHERE AV.LocationID='3RD'
AND AV.Status='ADM IN'

