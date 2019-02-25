SELECT
BV.Name																		AS 'Patient Name'
,BV.AccountNumber															AS 'Patient account number'
,BV.UnitNumber																As 'Patient Medical Record Number'
,CONVERT(VARCHAR(10),BV.BirthDateTime,101)									AS 'DOB'
,CONVERT(VARCHAR(10),BV.ServiceDateTime,101)								AS 'Service Date'
,BV.PrimaryInsuranceID														AS 'Insurance'
,BVPROV.Name																AS 'Physician providing services'
,CASE 
	WHEN BV.OutpatientLocationID='HEUV' THEN 'Heuvelton Health Center'
	WHEN BV.OutpatientLocationID='LIS'	THEN 'Lisbon Health Center'
	WHEN BV.OutpatientLocationID='CAN'	THEN 'Canton Health Center'
	WHEN BV.OutpatientLocationID='MAD'	THEN 'Madrid Health Center'
	WHEN BV.OutpatientLocationID='WADD' THEN 'Waddington Health Center'
	WHEN BV.OutpatientLocationID='HAMM' THEN 'Hammond Health Center' 
	WHEN BV.OutpatientLocationID='CHHC' THEN 'Ogdensburg Health Center'
ELSE 'UNKNOWN' 
END																			AS 'Location of clinic'																			



FROM		[Livedb].[dbo].[BarVisits]					AS BV
LEFT JOIN	[Livedb].[dbo].[BarVisitProviders]			AS BVPROV		ON BV.VisitID=BVPROV.VisitID AND BVPROV.VisitProviderTypeID='Attending'

WHERE BV.ServiceDateTime BETWEEN '2017-01-01' AND '2017-12-31'
AND BV.OutpatientLocationID IN ('HEUV','LIS','CAN','MAD','WADD','HAMM','CHHC')

ORDER BY BV.ServiceDateTime