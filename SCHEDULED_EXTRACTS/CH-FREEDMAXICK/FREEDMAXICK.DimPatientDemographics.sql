SET NOCOUNT ON;
Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2016-01-01'
Set @EndDate='2016-12-31'

SELECT

AV.AccountNumber																							AS 'AccountNumber'
,AV.Name																									AS 'PatientName'
,BVFD.AccountType																							AS 'AccountType'
,CASE
	WHEN AV.Status = 'DIS IN' THEN 'I' 
	WHEN AV.Status = 'ADM IN' THEN 'I'
	WHEN AV.Status = 'DEP ER' THEN 'E'
	ELSE 'O'				  END 																			AS 'IOE'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,126),CONVERT(VARCHAR(10),BV.ServiceDateTime,126))				AS 'AdmitDate'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,126)																AS 'DischargeDate'
,BV.FinancialClassID																						AS 'FinancialClass'
,DATEDIFF(DAY,BV.AdmitDateTime,BV.DischargeDateTime)														AS 'LengthOfStay'
,DATEDIFF(DAY,BV.AdmitDateTime,BV.DischargeDateTime)														AS 'FMLOS'
,BV.UnitNumber																								AS 'MedicalRecordNumber'
,ISNULL((Select BI.InsuranceID 
         from [CH_MTLIVE].[dbo].[BarInsuranceOrder]BI
         where BI.InsuranceOrderID='1' 
         and BV.VisitID=BI.VisitID),'NULL')																	AS 'PatientInsurance1'
,ISNULL((Select BI.InsuranceID 
         from [CH_MTLIVE].[dbo].[BarInsuranceOrder]BI
         where BI.InsuranceOrderID='2' 
         and BV.VisitID=BI.VisitID),'NULL')																	AS 'PatientInsurance2'
,ISNULL((Select BI.InsuranceID 
         from [CH_MTLIVE].[dbo].[BarInsuranceOrder]BI
         where BI.InsuranceOrderID='3' 
         and BV.VisitID=BI.VisitID),'NULL')																	AS 'PatientInsurance3'
,ISNULL((Select BI.InsuranceID 
         from [CH_MTLIVE].[dbo].[BarInsuranceOrder]BI
         where BI.InsuranceOrderID='4' 
         and BV.VisitID=BI.VisitID),'NULL')																	AS 'PatientInsurance4'
,BVFD.ChargeTotal																							AS 'TotalCharges'
,DRG.AdmitDrg																								AS 'XXDrg'
,BV.AdmitSourceID																							As 'AdmitSource'
,BV.InpatientServiceID																						AS 'InpatientService'
,AV.LocationID																								AS 'XXLocation'
,ISNULL(YEAR(BV.AdmitDateTime),YEAR(BV.ServiceDateTime))													AS 'Year'														



FROM [CH_MTLIVE].[dbo].[AdmVisits]																				AS AV
LEFT JOIN [CH_MTLIVE].[dbo].[BarVisits]																		As BV		ON AV.VisitID=BV.VisitID
LEFT JOIN [CH_MTLIVE].[dbo].[BarVisitFinancialData]															AS BVFD		ON AV.VisitID=BVFD.VisitID
LEFT JOIN [CH_MTLIVE].[dbo].[AbsDrgData]																		AS DRG		ON AV.VisitID=DRG.VisitID

WHERE((CONVERT(VarChar(10), BV.AdmitDateTime, 23) BETWEEN @StartDate AND @EndDate)
OR (CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate))