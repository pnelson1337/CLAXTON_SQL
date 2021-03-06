DECLARE @STARTDATE VARCHAR(10) = '2018-01-01'
DECLARE @ENDDATE VARCHAR(10) = '2018-12-31'
SELECT

 DRUG.DrugID
,DRUGCTIN.Number											AS 'ChargeProc'
,ISNULL(DRUG.DispenseUnitID,'')								AS 'DispenseUnit'
,DRUG.UnitCost												AS 'UnitCost'
,DRUG.UnitCost * ((DRUGFORM.Markup / 100) + 1)				AS 'UnitPrice'
,ISNULL(HCPCS.MAXCODE,'')									AS 'HCPCS'
,ISNULL(DBPROC.Description,'')								AS 'CDM Description'
,ISNULL(Volumes.Count,'0')									AS 'Total Volume'
--,DRUGCTIN.ChargeTypeID										AS 'ChargeType'
--,DRUGFORM.FormulaID																


FROM		[Livedb].[dbo].[DPhaDrugData]					AS DRUG
LEFT JOIN	[Livedb].[dbo].[DPhaDrugDefaultChargeTypesEp]	AS DRUGDCTEP			ON DRUG.DrugID=DRUGDCTEP.DrugID AND DRUGDCTEP.DxControlID='.DFT'
LEFT JOIN	[Livedb].[dbo].[DPhaChargeType]					AS DRUGCTIN				ON DRUGDCTEP.InpatientID=DRUGCTIN.ChargeTypeID
LEFT JOIN	[Livedb].[dbo].[DPhaChargeType]					AS DRUGCTOUT			ON DRUGDCTEP.InpatientID=DRUGCTOUT.ChargeTypeID
LEFT JOIN	[Livedb].[dbo].[DPhaChargeFormula]				AS DRUGFORM				ON DRUGCTIN.ChargeFormulaID=DRUGFORM.FormulaID
LEFT JOIN	[Livedb].[dbo].[DBarProcedures]					AS DBPROC				ON DRUGCTIN.Number=DBPROC.ProcedureID AND DBPROC.Active='Y'
LEFT JOIN (SELECT HCPCS1.ProcedureID, MAX(HCPCS1.Code) AS 'MAXCODE', MAX(HCPCS1.EffectiveDateTime)			AS 'MAXDATE'
			FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates] HCPCS1
			WHERE HCPCS1.TypeID='HCPCS'
			GROUP BY HCPCS1.ProcedureID)																	AS HCPCS									ON HCPCS.ProcedureID=DRUGCTIN.Number
LEFT JOIN (SELECT TransactionProcedureID,COUNT(TransactionCount)											AS 'Count'
			FROM [Livedb].[dbo].[BarChargeTransactions]WHERE BatchDateTime BETWEEN @STARTDATE AND @ENDDATE
			GROUP BY TransactionProcedureID)																AS Volumes									ON DBPROC.ProcedureID=Volumes.TransactionProcedureID
WHERE DRUG.Active='Y'
AND DRUG.UsageType='Formulary'
AND DRUGCTIN.Number IS NOT NULL

ORDER BY [Total Volume]