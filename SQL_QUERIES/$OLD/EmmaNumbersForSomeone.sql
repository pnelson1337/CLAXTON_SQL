/*
BC
CHA
NF
STP
 */
DECLARE @EffDate DATETIME,@StartDate DATETIME, @EndDate DATETIME
--SET @EffDate = '2015-08-12'
SET @StartDate='2015-08-01'
SET @EndDate  ='2015-08-01'
DECLARE @cpt TABLE
	(
	ProcID			VarChar(30),
	TypeID			VarChar(30),
	EffectiveDate	DATE,
	Code			VarChar(30)
	)
INSERT INTO @cpt
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


--Select * From @cpt
/** Utilize MAX effective date **/ 
DECLARE @cpt2 TABLE
	(
	ProcID			varchar(30),
	EffectiveDate	DATE,
	Code			varchar(30)
	)
INSERT INTO @cpt2
	(
	ProcID,
	EffectiveDate,
	Code
	)
SELECT cp.ProcID,dt.MaxEffDate,cp.Code FROM @cpt cp
inner join (SELECT ProcID,MAX(EffectiveDate) AS MaxEffDate
            FROM @cpt 
            GROUP BY ProcID)dt
ON cp.ProcID=dt.ProcID and cp.EffectiveDate=dt.MaxEffDate
GROUP BY cp.ProcID,dt.MaxEffDate,cp.Code





SELECT
 MAXCPT.Code																																					AS 'CPTCode'
,''																																								AS 'Description'

,''																																								AS 'Start Gross Charges'
,COUNT(CASE WHEN BV.FinancialClassID IN ('COM','COM-GHI','COM-PPO','COM-RMSCO','COM-SDEM','COM-UAS','HCOM') THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Commercial'
,COUNT(CASE WHEN BV.FinancialClassID IN ('MCD','HMCD')														THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Medicaid'
,COUNT(CASE WHEN BV.FinancialClassID ='MCR'																	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Medicare'
,COUNT(CASE WHEN BV.FinancialClassID =''																	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Managed Medicare'
,COUNT(CASE WHEN BV.FinancialClassID =''																	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Employee Benefits'
,COUNT(CASE WHEN BV.FinancialClassID ='SLF'																	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Self-pay'
,COUNT(CASE WHEN BV.FinancialClassID ='WC'																	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Worker`s Comp'
,COUNT(CASE WHEN BV.FinancialClassID =''																	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Out of State Medicaid'
,COUNT(CASE WHEN BV.FinancialClassID IN ('HOTHR','OTHER','U'/*NOTSUREABOUTTHESE*/,'BC','CHA','NF','STP')	THEN MAXCPT.Code END)	*SUM(BCT.Amount)			AS 'Other'
,COUNT(MAXCPT.Code)																													*SUM(BCT.Amount)			AS 'Grand Total'

,''																																								AS 'Start Volumes'
,COUNT(CASE WHEN BV.FinancialClassID IN ('COM','COM-GHI','COM-PPO','COM-RMSCO','COM-SDEM','COM-UAS','HCOM') THEN MAXCPT.Code END)								AS 'Commercial'
,COUNT(CASE WHEN BV.FinancialClassID IN ('MCD','HMCD')														THEN MAXCPT.Code END)								AS 'Medicaid'
,COUNT(CASE WHEN BV.FinancialClassID ='MCR'																	THEN MAXCPT.Code END)								AS 'Medicare'
,COUNT(CASE WHEN BV.FinancialClassID =''																	THEN MAXCPT.Code END)								AS 'Managed Medicare'
,COUNT(CASE WHEN BV.FinancialClassID =''																	THEN MAXCPT.Code END)								AS 'Employee Benefits'
,COUNT(CASE WHEN BV.FinancialClassID ='SLF'																	THEN MAXCPT.Code END)								AS 'Self-pay'
,COUNT(CASE WHEN BV.FinancialClassID ='WC'																	THEN MAXCPT.Code END)								AS 'Worker`s Comp'
,COUNT(CASE WHEN BV.FinancialClassID =''																	THEN MAXCPT.Code END)								AS 'Out of State Medicaid'
,COUNT(CASE WHEN BV.FinancialClassID IN ('HOTHR','OTHER','U'/*NOTSUREABOUTTHESE*/,'BC','CHA','NF','STP')	THEN MAXCPT.Code END)								AS 'Other'
,COUNT(MAXCPT.Code)																																				AS 'Grand Total'




				 
FROM		[Livedb].[dbo].[BarChargeTransactions]														AS BCT
LEFT JOIN	[Livedb].[dbo].[BarVisits]																	AS BV							ON BCT.VisitID=BV.VisitID
LEFT JOIN (SELECT 
				   CPT2.ProcedureID																		AS 'ProcedureID' 
				  ,CPT2.Code																			AS 'Code'
				  ,MAX(CPT2.EffectiveDateTime)															AS 'MaxDate'									
		FROM DBarProcAltCodeEffectDates																	AS CPT2
		WHERE CPT2.TypeID='CPT-4'
		GROUP BY CPT2.ProcedureID,CPT2.Code)															AS MAXCPT	ON BCT.TransactionProcedureID=MAXCPT.ProcedureID
INNER JOIN	DBarProcAltCodeEffectDates																	AS CPT ON MAXCPT.MaxDate > CPT.EffectiveDateTime AND MAXCPT.ProcedureID=CPT.ProcedureID 

WHERE BV.ServiceDateTime BETWEEN '2017-01-01' AND '2017-12-31'
AND BV.OutpatientLocationID IN ('HAMM','CAN','CHHC','HHC','HEUV','MAD','WADD','LIS')

GROUP BY MAXCPT.Code
ORDER BY MAXCPT.Code	







