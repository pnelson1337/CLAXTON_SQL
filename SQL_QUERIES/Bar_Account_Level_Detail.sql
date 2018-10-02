SELECT 
absd.UnitNumber as MRN,
LEFT(absd.Name, CHARINDEX(',',absd.Name)- 1) as LAST_NAME,
CASE 
WHEN CHARINDEX(' ',absd.Name,CHARINDEX(',',absd.Name)+1) = 0 THEN ' '
ELSE SUBSTRING(absd.Name,CHARINDEX(' ',absd.Name,CHARINDEX(',',absd.Name)+1)+1,1) 
END as MIDDLE,
SUBSTRING(
absd.Name,
CHARINDEX(',',absd.Name)+1,
(CASE 
WHEN CHARINDEX(' ',absd.Name,CHARINDEX(',',absd.Name)+1)=0 THEN LEN(absd.Name)
ELSE CHARINDEX(' ',absd.Name,CHARINDEX(',',absd.Name)+1)-CHARINDEX(',',absd.Name) 
END)
) as FIRST_NAME,
REPLACE(CONVERT(varchar,absd.BirthDateTime,110),'-','/') as DOB,
absd.Sex as GENDER,
avis.Address1 as ADDR1,
COALESCE(avis.Address2,'') as ADDR2,
avis.City as CITY,
avis.StateProvince as [STATE],
LEFT(avis.PostalCode,5) as ZIP,
REPLACE(CONVERT(varchar,absd.AdmitDateTime,110),'-','') as ADMSVCDATE,
REPLACE(CONVERT(varchar,absd.DischargeDateTime,110),'-','') as DISDATE,
absd.FinancialClassID as FINANCIAL_CLASS,
absd.LocationID as TYPE_OF_SERVICE,
avis.InpatientOrOutpatient as ENCOUNTER_TYPE,
'' as PATIENT_TYPE,
COALESCE(Charge.ChargeTotal,0) as CHARGES,
COALESCE(Charge.ReceiptTotal,0) as PAYMENTS,
'!!!!!!END FILE FIELDS- START AUDIT FIELDS!!!!' as AuditDivider,
absd.AccountNumber,
COALESCE(Charge.UrChargeTotal,0) as UrChargeTotal,
COALESCE(Charge.ArChargeTotal,0) as ArChargeTotal,
COALESCE(Charge.AdjustmentTotal,0) as Adjustments,
COALESCE(Charge.Balance,0) as Balance,
COALESCE(Charge.RefundTotal,0) as Refunds,
COALESCE(Charge.BarStatus,'UNKNOWN') as BAR_Status,
COALESCE(Charge.AbsStatus,'UNKNOWN') as ABS_Status
FROM
AbstractData absd
INNER JOIN AdmVisits avis
ON absd.SourceID = avis.SourceID
AND absd.VisitID = avis.VisitID
LEFT OUTER JOIN BarVisitFinancialData Charge 
ON Charge.VisitID = absd.VisitID
WHERE
absd.DischargeDateTime BETWEEN '2014-09-01' AND '2014-09-30'
-- and absd.AccountNumber = 'V6714208'
ORDER BY
absd.DischargeDateTime