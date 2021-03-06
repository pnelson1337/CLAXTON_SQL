DECLARE @CPT TABLE
	(
	ProcID			VARCHAR(30),
	TypeID			VARCHAR(30),
	EffectiveDate	DATE,
	Code			VARCHAR(30)
	)
INSERT INTO @CPT
	(
	ProcID,
	TypeID,
	EffectiveDate,
	Code
	)
SELECT
	PD.ProcedureID,
	PD.TypeID,
	PD.EffectiveDateTime,
	PD.Code
FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
WHERE PD.TypeID='CPT-4' --Note: this could be HCPCS, BCALT, MCDCPT
DECLARE @CPT2 TABLE
	(
	ProcID			VARCHAR(30),
	EffectiveDate	DATE,
	Code			VARCHAR(30)
	)
INSERT INTO @CPT2
	(
	ProcID,
	EffectiveDate,
	Code
	)
SELECT CP.ProcID,DT.MaxEffDate,CP.Code FROM @CPT CP
INNER JOIN (SELECT ProcID,MAX(EffectiveDate) AS MaxEffDate
            FROM @CPT 
            GROUP BY ProcID)				AS DT
ON CP.ProcID=DT.ProcID and CP.EffectiveDate=DT.MaxEffDate
GROUP BY CP.ProcID,DT.MaxEffDate,CP.Code



SELECT 

 MAXCPT.Code
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('COM','COM-GHI','COM-PPO','COM-RMSCO','COM-SDEM','COM-UAS','HCOM','BC')	THEN BCT.Amount END)			,'')		AS 'Commercial'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('MCD','HMCD')																THEN BCT.Amount END)			,'')		AS 'Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='MCR'																		THEN BCT.Amount END)			,'')		AS 'Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.Amount END)			,'')		AS 'Managed Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.Amount END)			,'')		AS 'Employee Benefits'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='SLF'																		THEN BCT.Amount END)			,'')		AS 'Self-pay'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='WC'																			THEN BCT.Amount END)			,'')		AS 'Worker`s Comp'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.Amount END)			,'')		AS 'Out of State Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('HOTHR','OTHER','U','NF','STP','CHA')										THEN BCT.Amount END)			,'')		AS 'Other'
,ISNULL(SUM(BCT.Amount)																																	,'')		AS 'Grand Total'
,''																																									AS ' '
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('COM','COM-GHI','COM-PPO','COM-RMSCO','COM-SDEM','COM-UAS','HCOM','BC')	THEN BCT.TransactionCount END)	,'')		AS 'Commercial'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('MCD','HMCD')																THEN BCT.TransactionCount END)	,'')		AS 'Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='MCR'																		THEN BCT.TransactionCount END)	,'')		AS 'Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.TransactionCount END)	,'')		AS 'Managed Medicare'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.TransactionCount END)	,'')		AS 'Employee Benefits'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='SLF'																		THEN BCT.TransactionCount END)	,'')		AS 'Self-pay'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID ='WC'																			THEN BCT.TransactionCount END)	,'')		AS 'Worker`s Comp'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID =''																			THEN BCT.TransactionCount END)	,'')		AS 'Out of State Medicaid'
,ISNULL(SUM(CASE WHEN BV.FinancialClassID IN ('HOTHR','OTHER','U','NF','STP','CHA')										THEN BCT.TransactionCount END)	,'')		AS 'Other'
,ISNULL(SUM(BCT.TransactionCount)																														,'')		AS 'Grand Total'

FROM		[Livedb].[dbo].[BarVisits]					AS BV				
LEFT JOIN	[Livedb].[dbo].[BarChargeTransactions]		AS BCT				ON BV.VisitID=BCT.VisitID
LEFT JOIN	@CPT2										AS MAXCPT			ON BCT.TransactionProcedureID=MAXCPT.ProcID


WHERE CONVERT(VARCHAR(10),BV.ServiceDateTime,101) BETWEEN '01/01/2017' AND '12/31/2017'
AND BCT.TransactionProcedureID LIKE ('652%')


/*
AND(BCT.TransactionProcedureID LIKE ('388%') OR
	BCT.TransactionProcedureID LIKE ('667%') OR
	BCT.TransactionProcedureID LIKE ('387%') OR
	BCT.TransactionProcedureID LIKE ('654%') OR
	BCT.TransactionProcedureID LIKE ('669%') OR
	BCT.TransactionProcedureID LIKE ('653%') OR
	BCT.TransactionProcedureID LIKE ('652%'))
*/

GROUP BY MAXCPT.Code