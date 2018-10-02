SELECT

 AV.Name
,AV.Address1															AS 'Address'
,AV.HomePhone															AS 'Telephone #'
,ISNULL(EMAIL.Email,'')													AS 'Email Address'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),
	   (CONVERT(VARCHAR(10),BV.ServiceDateTime,101)))					AS 'Admit Date'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')				AS 'Discharge Date'
,AV.LocationID															AS 'Location'
,DMPROV.Name															AS 'Attending Provider'
--,BV.FinancialClassID					
--,AV.AccountNumber



FROM		[Livedb].[dbo].[AdmVisits]									AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]									AS BV					ON AV.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[AdmVisitPatientEmail]						AS EMAIL				ON AV.VisitID=EMAIL.VisitID
LEFT JOIN	[Livedb].[dbo].[BarVisitProviders]							AS BVP					ON AV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
LEFT JOIN	[Livedb].[dbo].[DMisProvider]								AS DMPROV				ON BVP.ProviderID=DMPROV.ProviderID



WHERE BV.DischargeDateTime >= DATEADD(mm,DATEDIFF(mm,0,GETDATE())-1,0)
AND	  BV.DischargeDateTime <  DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) 
AND AV.InpatientServiceID !='MHC'
AND BV.FinancialClassID !='MCD'
AND AV.Deleted IS NULL


ORDER BY BV.DischargeDateTime