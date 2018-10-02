SELECT 
 BarVisits.AccountNumber,
 BarVisits.Name, 
 BarVisitFinancialData.ChargeTotal,
 BarVisitFinancialData.AccountType,
 BarVisits.InpatientOrOutpatient,
 COALESCE(CONVERT(varchar(10),BarVisits.ServiceDateTime,23), '') + '' + COALESCE(CONVERT(varchar(10),BarVisits.AdmitDateTime,23), '') AS 'Service Date',
 CONVERT(varchar(10),BarVisits.DischargeDateTime,23) AS 'Discharge Date',
 BarVisits.PrimaryInsuranceID,
----------------------------Begin Insurance Selection--------------------------
 	
	(Select ai.InsuranceID 
                     from [Livedb].[dbo].[AdmInsuranceOrder]ai
                     where ai.InsuranceOrderID='1' 
                     and BarVisits.VisitID=ai.VisitID) AS 'Primary Insurance'
    
   ,(Select ai.InsuranceID 
                     from [Livedb].[dbo].[AdmInsuranceOrder]ai 
                     where ai.InsuranceOrderID='2' 
                     and BarVisits.VisitID=ai.VisitID) AS 'Secondary Insurance' 
   
    ,(Select ai.InsuranceID 
                     from [Livedb].[dbo].[AdmInsuranceOrder]ai 
                     where ai.InsuranceOrderID='3' 
                     and BarVisits.VisitID=ai.VisitID) AS 'Tertiary Insurance'

   ,(Select ai.InsuranceID 
                     from [Livedb].[dbo].[AdmInsuranceOrder]ai 
                     where ai.InsuranceOrderID='4' 
                     and BarVisits.VisitID=ai.VisitID) AS 'Quaternary Insurance', 
					 
----------------------------End Insurance Selection----------------------------

 BarVisits.FinancialClassID,
 BarVisits.UnitNumber, 
 BarVisitFinancialData4.CalcDrgNameCmgID, 
 BarVisits.AdmitSourceID, 
 COALESCE(BarVisits.OutpatientLocationID, '') + '' + COALESCE(BarVisits.InpatientServiceID, '') AS 'Location',
 DATEDIFF(day,BarVisits.AdmitDateTime,BarVisits.DischargeDateTime) AS 'Length of Stay'
                 
FROM 
BarVisits
JOIN Livedb.dbo.BarVisitFinancialData ON BarVisits.VisitID=BarVisitFinancialData.VisitID
JOIN Livedb.dbo.BarVisitFinancialData4 ON BarVisits.VisitID=BarVisitFinancialData4.VisitID
--JOIN Livedb.dbo.BarInsuranceOrder ON BarVisits.VisitID=BarInsuranceOrder.VisitID
 
 
WHERE CONVERT(varchar(10),BarVisits.ServiceDateTime,23) BETWEEN '2014-01-01' AND '2014-12-31' OR CONVERT(varchar(10),BarVisits.AdmitDateTime,23) BETWEEN '2014-01-01' AND '2014-12-31'
ORDER BY BarVisits.PrimaryInsuranceID 



