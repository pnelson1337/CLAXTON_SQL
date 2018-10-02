USE [Livedb]

SELECT

DBPROC.ProcedureID																						AS 'Service/ Charge Code'
,ISNULL(DBPROC.ChargeDeptID,'')																			AS 'Department Number'
,ISNULL(DEPT.Name,'')																					AS 'Department Description'
,''																										AS 'Sub-Department'
,''																										AS 'General Ledger Key'
,DBPROC.Description																						AS 'Service Description'
,''																										AS 'Payer, Financial Class'
,''																										AS 'Patient Type'
,''																										AS 'Technical/Professional Indicator'
,''																										AS 'Split Billing Indicator'
,ISNULL(HCPCS.MAXCODE,'')																				AS 'HCPCS Code'
,ISNULL(CPT.MAXCODE,'')																					AS 'CPT Code'
,''																										AS 'Other Payer Codes'
,''																										AS 'Modifiers'
,ISNULL(HCPCS.MAXDATE,'')																				AS 'Effective Date of the HCPCS Code'
,''																										AS 'End Date of the HCPCS Code'
,''																										AS 'Revenue (UB-04) Code'
,ISNULL(PRICE.MAXCHARGE,'')																				AS 'Charge/Price'
,''																										AS 'ICD-9-CM Procedure Code'
,''																										AS 'Link to Order Entry'
,''																										AS 'Billing Units Conversion'
,''																										AS 'YTD Volume'
,''																										AS 'YTD Charges'
,DBPROC.Active																							AS 'Active/ Inactive Status'
,''																										AS 'Explosions'



																										
																										
FROM		[dbo].[DBarProcedures]																		AS DBPROC	
LEFT JOIN	[dbo].[DMisGlComponentValue]																AS DEPT										ON DBPROC.ChargeDeptID=DEPT.ValueID AND ComponentID='DPT'
LEFT JOIN (SELECT HCPCS1.ProcedureID, MAX(HCPCS1.Code) AS 'MAXCODE', MAX(HCPCS1.EffectiveDateTime)		AS 'MAXDATE'
			FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates] HCPCS1
			WHERE HCPCS1.TypeID='HCPCS'
			GROUP BY HCPCS1.ProcedureID)																AS HCPCS									ON HCPCS.ProcedureID=DBPROC.ProcedureID

LEFT JOIN (SELECT CPT1.ProcedureID, MAX(CPT1.Code) AS 'MAXCODE', MAX(CPT1.EffectiveDateTime)			AS 'MAXDATE'
			FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates] CPT1
			WHERE CPT1.TypeID='CPT-4'
			GROUP BY CPT1.ProcedureID)																	AS CPT										ON CPT.ProcedureID=DBPROC.ProcedureID

LEFT JOIN (SELECT PRICE1.ProcedureID, MAX(PRICE1.Charge) AS 'MAXCHARGE',MAX(PRICE1.EffectiveDateTime)	AS 'MAXDATE'
			FROM [Livedb].[dbo].[DBarProcStandardEffectDates] PRICE1
			GROUP BY PRICE1.ProcedureID)																AS PRICE									ON PRICE.ProcedureID=DBPROC.ProcedureID




WHERE DBPROC.Active='Y'

--AND DBPROC.ProcedureID='317206'