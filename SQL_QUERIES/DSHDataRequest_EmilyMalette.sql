Declare @StartDate DateTime,@EndDate DateTime
/** Set Globals **/
Set @StartDate='2016-01-01'
Set @EndDate='2016-12-31'



SELECT 
	AV.VisitID
	,AV.AccountNumber													AS 'Account Number' 
    ,AV.UnitNumber														AS 'Medical Records Number'
   
-- START OF NAME SPLIT--
	  		  --Start of Last Name--
	    ,CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END															
																		AS 'Patient Last Name'

		 --Start of First_Name--
  		 ,SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 THEN LEN(BV.Name)
		  ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END)) 
																		AS 'Patient First Name'

		 --Start of Middle Name-- 
		 ,CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1) = 0 THEN ' 'ELSE SUBSTRING(BV.Name,CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)+1,1) END															
																		AS 'Patient Middle Name/Initial'
-- END OF NAME SPLIT--
	,ISNULL(AV.UniquePublicIdentifier,'') AS 'Social Security Number'
	,ISNULL(CONVERT(VARCHAR(10), BV.AdmitDateTime,101),'')				AS 'Admission Date'
	,ISNULL(CONVERT(VARCHAR(10), BV.DischargeDateTime,101),'')			AS 'Discharge Date'
	,DATEDIFF(DAY,BV.AdmitDateTime,BV.DischargeDateTime)				AS 'Length of Stay (LOS)'
	,ISNULL(CONVERT(VARCHAR(10), BV.BirthDateTime,101),'')				AS 'Date Of Birth'
	,ISNULL(BV.Sex,'')													AS 'Gender'
	,ISNULL(BV.InpatientServiceID,'')									AS 'Patient Service Code/Type'
	,ISNULL((SELECT SUM(BCT.TransactionCount)
		FROM [Livedb].[dbo].[BarChargeTransactions] BCT
		WHERE TransactionProcedureID IN ('310005','330005')
		AND BV.VisitID=BCT.VisitID
			),'')														AS 'Observation hours'
   ,ISNULL(BVF.ChargeTotal, 0)											AS 'Total Charges'
   ,ISNULL(BVF.ReceiptTotal, 0)											AS 'Total Payments'
   ,ISNULL((SELECT SUM(BCT.Amount)
   FROM [Livedb].[dbo].[BarCollectionTransactions]	AS BCT
   INNER JOIN [Livedb].[dbo].[BarInsuranceOrder]	AS BI ON BI.VisitID=BV.VisitID AND BI.InsuranceOrderID='1' 
	WHERE BCT.Type='R' AND BV.VisitID=BCT.VisitID AND BI.InsuranceOrderID='1'  AND BI.InsuranceID=BCT.InsuranceID
  ),'')																	AS 'Primary Payor Payment'

  ,ISNULL((SELECT SUM(BCT.Amount)
   FROM [Livedb].[dbo].[BarCollectionTransactions]	AS BCT
   INNER JOIN [Livedb].[dbo].[BarInsuranceOrder]	AS BI ON BI.VisitID=BV.VisitID AND BI.InsuranceOrderID='2' 
	WHERE BCT.Type='R' AND BV.VisitID=BCT.VisitID AND BI.InsuranceOrderID='2'  AND BI.InsuranceID=BCT.InsuranceID
  ),'')																	AS 'Secondary Payor Payment'

  ,ISNULL((SELECT SUM(BCT.Amount)
   FROM [Livedb].[dbo].[BarCollectionTransactions]	AS BCT
   INNER JOIN [Livedb].[dbo].[BarInsuranceOrder]	AS BI ON BI.VisitID=BV.VisitID AND BI.InsuranceOrderID='3' 
	WHERE BCT.Type='R' AND BV.VisitID=BCT.VisitID AND BI.InsuranceOrderID='3'  AND BI.InsuranceID=BCT.InsuranceID
  ),'')																	AS 'Third Payor Payment'

  ,ISNULL((SELECT SUM(BCT.Amount)
   FROM [Livedb].[dbo].[BarCollectionTransactions]	AS BCT
   INNER JOIN [Livedb].[dbo].[BarInsuranceOrder]	AS BI ON BI.VisitID=BV.VisitID AND BI.InsuranceOrderID='4' 
	WHERE BCT.Type='R' AND BV.VisitID=BCT.VisitID AND BI.InsuranceOrderID='4'  AND BI.InsuranceID=BCT.InsuranceID
  ),'')																	AS 'Fourth Payor Payment'


   	 ,ISNULL((Select BI.InsuranceID 
                     from [Livedb].[dbo].[BarInsuranceOrder]BI
                     where BI.InsuranceOrderID='1' 
                     and BV.VisitID=BI.VisitID),'')						AS 'Primary Payor'
    
   	,ISNULL((Select BI.InsuranceID 
                     from [Livedb].[dbo].[BarInsuranceOrder]BI
                     where BI.InsuranceOrderID='2' 
                     and BV.VisitID=BI.VisitID),'')						AS 'Secondary Payor'
   
   	,ISNULL((Select BI.InsuranceID 
                     from [Livedb].[dbo].[BarInsuranceOrder]BI
                     where BI.InsuranceOrderID='3' 
                     and BV.VisitID=BI.VisitID),'')						AS 'Tertiary Payor'

   	,ISNULL((Select BI.InsuranceID 
                     from [Livedb].[dbo].[BarInsuranceOrder]BI
                     where BI.InsuranceOrderID='4' 
                     and BV.VisitID=BI.VisitID),'')						AS 'Fourth Payor'

 ,ISNULL(BV.Address1,'')												AS 'Patient Address Line 1'
 ,ISNULL(BV.Address2,'')												AS 'Patient Address Line 2'
 ,ISNULL(BV.City,'')													AS 'Patient City'
 ,ISNULL(BV.StateProvince,'')											AS 'Patient State'
 ,ISNULL(BV.HomePhone,'')												AS 'Patient Phone #'
 
 ,ISNULL((SELECT TOP 1 BID.PolicyNumber
  FROM [Livedb].[dbo].[BarInsuredData] BID
  JOIN [Livedb].[dbo].[DMisInsurance] DMisIns ON BID.InsuranceID=DMisIns.InsuranceID
  WHERE DMisIns.InsuranceGroupID='MCR' AND BV.VisitID=BID.VisitID
  ),'')																	AS 'Medicare HIC #'
  ,ISNULL((SELECT TOP 1 BID.PolicyNumber
  FROM [Livedb].[dbo].[BarInsuredData] BID
  JOIN [Livedb].[dbo].[DMisInsurance] DMisIns ON BID.InsuranceID=DMisIns.InsuranceID
  WHERE DMisIns.InsuranceGroupID='MCD' AND BV.VisitID=BID.VisitID
  ),'')																	AS 'Medicaid Recipient ID'

 ,ISNULL(AbsDrg.AdmitDrg,'')											AS 'DRG'
 ,ISNULL(BVG.Name,'')													AS 'Guarantor’s Name'
 ,ISNULL(BVG.UniquePublicIdentifier,'')									AS 'Guarantor’s SSN'
 ,''																	AS 'Labor & Delivery Room Days'
,ISNULL(BV1.Name,'')													AS 'Mother’s Name'
,ISNULL(BV1.AccountNumber,'')											AS 'Mother’s Acct/MRN #'





FROM				[Livedb].[dbo].[AdmVisits]							AS AV								
LEFT OUTER JOIN		[Livedb].[dbo].[BarVisits]							AS BV		 ON AV.VisitID = BV.VisitID	
INNER JOIN		    [Livedb].[dbo].[BarVisitFinancialData]				AS BVF		 ON AV.VisitID = BVF.VisitID 
INNER JOIN			[Livedb].[dbo].[AbsDrgData]							AS AbsDrg	 ON AbsDrg.VisitID=BV.VisitID
INNER JOIN          [Livedb].[dbo].[BarVisitGuarantors]					AS BVG		 ON BVG.VisitID=BV.VisitID
LEFT JOIN			[Livedb].[dbo].[BarVisits]							AS BV1		 ON BV.MothersVisitID=BV1.VisitID




--INNER JOIN		    [Livedb].[dbo].[BarInsuredData]						AS BID       ON BID.VisitID=BV.VisitID




WHERE((CONVERT(VarChar(10), BV.DischargeDateTime, 23) BETWEEN @StartDate AND @EndDate)
OR (CONVERT(varchar(10),BV.AdmitDateTime,23) BETWEEN @StartDate AND @EndDate))
AND BV.InpatientOrOutpatient='I'
--AND BV.VisitID='6011615686'


ORDER BY BV.AdmitDateTime, BVF.ChargeTotal