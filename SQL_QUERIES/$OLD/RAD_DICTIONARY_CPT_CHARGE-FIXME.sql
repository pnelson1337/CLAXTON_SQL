Set NOCOUNT ON;

-- CPT LATEST EFFECTIVE DATE--
DECLARE @CPT TABLE (ProcID VarChar(30),TypeID VarChar(30),EffectiveDate	DATE,Code VarChar(30))
INSERT INTO @CPT(ProcID,TypeID,EffectiveDate,Code)
SELECT PD.ProcedureID, PD.TypeID, PD.EffectiveDateTime, PD.Code
FROM [Livedb].[dbo].[DBarProcAltCodeEffectDates]PD
WHERE PD.TypeID='CPT-4'
DECLARE @CPT2 TABLE(ProcID varchar(30),EffectiveDate DATE,Code varchar(30))
INSERT INTO @CPT2(ProcID,EffectiveDate,Code)
SELECT CP.ProcID,DT.MaxEffDate,CP.Code FROM @CPT CP
INNER JOIN (SELECT ProcID,MAX(EffectiveDate) AS MaxEffDate FROM @CPT GROUP BY ProcID)DT
ON CP.ProcID=DT.ProcID and CP.EffectiveDate=DT.MaxEffDate
GROUP BY CP.ProcID,DT.MaxEffDate,CP.Code



DECLARE @COST TABLE(ProcID VarChar(30),EffectiveDate DATE,Charge VarChar(30))
INSERT INTO @COST(ProcID,EffectiveDate,Charge)
SELECT PD.ProcedureID,PD.EffectiveDateTime,PD.Charge
FROM [Livedb].[dbo].[DBarProcStandardEffectDates]PD
DECLARE @COST2 TABLE(ProcID	varchar(30),EffectiveDate DATE, Charge varchar(30))
INSERT INTO @COST2(ProcID,EffectiveDate,Charge)
SELECT CHARGE.ProcID,dt.MaxEffDate,CHARGE.Charge FROM @COST CHARGE
INNER JOIN (SELECT ProcID,MAX(EffectiveDate) AS MaxEffDate FROM @COST GROUP BY ProcID)dt
ON CHARGE.ProcID=dt.ProcID and CHARGE.EffectiveDate=dt.MaxEffDate
GROUP BY CHARGE.ProcID,dt.MaxEffDate,CHARGE.Charge




SELECT 


 ISNULL(CP2.Code,'')																		AS 'CPT Code'
,ISNULL(COST2.Charge,'')																	AS 'Total Charge'
,ISNULL(AV.LocationID,'')															AS 'Facility'
,ISNULL(COALESCE(ADMIT.[ProviderID],PROV.AdmitID),'')								AS 'AdmittingPhysicianID'
,ISNULL(ADMIT.[Name],'')															AS 'AdmittingPhysicianName'
,ISNULL(COALESCE
 (ATTEND.[ProviderID],EMERG.[ProviderID],PROV.AttendID,PROV.EmergencyID),'')		AS 'AttendingPhysicianID'
,COALESCE(ATTEND.[Name],EMERG.[Name])												AS 'AttendingPhysicianName'
,ISNULL(BSP.ProviderID,'')															AS 'OperatingPhysicianID'
,ISNULL(BSPName.[Name],'')															AS 'OperatingPhysicianName'				
,ISNULL(COALESCE(REFER.[ProviderID],PROV.ReferID),'')								AS 'ReferringPhysicianID'
,ISNULL(REFER.[Name],'')															AS 'ReferringPhysicianName'
,ISNULL(COALESCE(FAMILY.[ProviderID],PROV.FamilyID),'')								AS 'PrimaryCarePhysicianID'
,ISNULL(FAMILY.[Name],'')															AS 'PrimaryCarePhysicianName'




FROM				[Livedb].[dbo].[AdmVisits]										AS AV								
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisits]										AS BV		 ON AV.VisitID = BV.VisitID	
INNER JOIN		    [Livedb].[dbo].[BarVisitFinancialData]							AS BVF		 ON AV.VisitID = BVF.VisitID 
INNER JOIN			[Livedb].[dbo].[AbsDrgData]										AS AbsDrg	 ON AbsDrg.VisitID=BV.VisitID
LEFT OUTER JOIN		[Livedb].[dbo].[BarSurgicalProcedures]							AS BSP		 ON BV.BillingID=BSP.BillingID						AND BSP.SeqID='1'
LEFT OUTER JOIN		[Livedb].[dbo].[DMisProvider]									AS BSPName	 ON BSP.ProviderID=BSPName.ProviderID
INNER JOIN			[Livedb].[dbo].[BarEmployers]									AS BE		 ON BV.VisitID=BE.VisitID
INNER JOIN			[Livedb].[dbo].[BarDiagnoses]									AS BarDiag	 ON BarDiag.BillingID=BV.BillingID					AND BarDiag.DiagnosisSeqID='1'
INNER JOIN			[Livedb].[dbo].[DMisInsurance]									AS DMI		 ON BV.PrimaryInsuranceID=DMI.InsuranceID
INNER JOIN			[Livedb].[dbo].[DMisFinancialClass]								AS DMFC		 ON	AV.FinancialClassID=DMFC.ClassID

LEFT OUTER JOIN		[Livedb].[dbo].[DMisDischargeDisposition]						AS DMDD		 ON BV.DischargeDispositionID=DMDD.DispositionID
LEFT OUTER JOIN		[Livedb].[dbo].[DMisAdmitSource]								AS DMAS		 ON BV.AdmitSourceID=DMAS.AdmitSourceID

LEFT OUTER JOIN		[Livedb].[dbo].[BarVisitProviders]								AS ADMIT	 ON BV.VisitID=ADMIT.VisitID						AND ADMIT.VisitProviderTypeID='Admitting'
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisitProviders]								AS ATTEND	 ON BV.VisitID=ATTEND.VisitID						AND ATTEND.VisitProviderTypeID='Attending'
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisitProviders]								AS EMERG	 ON BV.VisitID=EMERG.VisitID						AND EMERG.VisitProviderTypeID='Emergency'										
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisitProviders]								AS REFER	 ON BV.VisitID=REFER.VisitID						AND REFER.VisitProviderTypeID='Referring'
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisitProviders]								AS FAMILY	 ON BV.VisitID=FAMILY.VisitID						AND FAMILY.VisitProviderTypeID='Family'
LEFT OUTER JOIN		[Livedb].[dbo].[AdmProviders]									AS PROV		 ON BV.VisitID=PROV.VisitID					
  				


  LEFT JOIN @CPT2																			AS CP2						ON ZDRE.BillingProcedure=CP2.ProcID
  LEFT JOIN @COST2																			AS COST2					ON ZDRE.BillingProcedure=COST2.ProcID

