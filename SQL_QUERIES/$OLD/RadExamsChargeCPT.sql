Set NOCOUNT ON;

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
--LEFT JOIN @CPT2	AS CP2						ON TABLEWITHBILLINGPROCNUMBER=CP2.ProcID


SELECT
--BV.VisitID
 BV.AccountNumber																	AS 'Patient Account'		
,BV.UnitNumber																		AS 'Patient MRN'
,BV.Name																			AS 'Patient Name'
,RAD.ExamTypeID																		AS 'Modality'
,RAD.ExamID																			AS 'Exam Code'
,RAD.ExamName																		AS 'Exam Name'
,ISNULL(CP2.Code,'')																AS 'CPT Code'
,ZDRE.BillingProcedure																AS 'Billing Procedure Number'
,CONVERT(varchar(10),RAD.ExamDateTime,23)											AS 'Exam Date'

FROM 
				[Livedb].[dbo].[BarVisits]												AS BV                
INNER JOIN		[Livedb].[dbo].[RadExams]												AS RAD						ON BV.VisitID=RAD.VisitID
LEFT OUTER JOIN	[Livedb].[dbo].[ZcusDRadExams]											AS ZDRE						ON RAD.ExamID=ZDRE.ExamMnemonicID
LEFT JOIN @CPT2																			AS CP2						ON ZDRE.BillingProcedure=CP2.ProcID


WHERE RAD.CancelReason IS NULL
AND RAD.ExamDateTime >= DATEADD(DAY,-1, CAST(GETDATE() AS DATE)) AND RAD.ExamDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME)
AND RAD.ExamTypeID !='CARD'

ORDER BY RAD.ExamTypeID, BV.AccountNumber
