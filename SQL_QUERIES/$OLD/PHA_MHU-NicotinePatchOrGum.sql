SELECT

--MED.VisitID
BV.AccountNumber												AS 'Patient Account'									
,BV.Name														AS 'Patient Name'
,MED.DrugID														AS 'DrugID'
,DRUG.Name														AS 'Drug Name'
,CONVERT(VARCHAR(10),MED.RowUpdateDateTime,101)					AS 'Date Drug Given'
,AV.LocationID													AS 'Patient Location'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),'')			AS 'Admit Date'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')		AS 'Discharge Date'

FROM			[Livedb].[dbo].[PhaRxMedications]				AS MED
LEFT JOIN		[Livedb].[dbo].[AdmVisits]						AS AV			ON MED.VisitID=AV.VisitID
LEFT JOIN		[Livedb].[dbo].[BarVisits]						AS BV			ON MED.VisitID=BV.VisitID
LEFT JOIN		[Livedb].[dbo].[DPhaDrugData]					AS DRUG			ON MED.DrugID=DRUG.DrugID


WHERE CAST(MED.RowUpdateDateTime AS DATE)  = DATEADD(DAY,-1,CONVERT(DATE, GETDATE()))
AND MED.DrugID IN ('NIC2GUM','NIC21PAT')
AND AV.LocationID='3RD'

ORDER BY DrugID