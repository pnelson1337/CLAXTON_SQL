SELECT * FROM (
SELECT 
 e.encounterID
,u.ufname 'First Name'
,u.ulname 'Last Name'
,u.dob 'DOB'
,u.upcity 'City'
,u.upstate 'State'
,u.zipcode 'Postal Code'
,f.Name 'Facility Name'
,d.PrintName 'Provider'
,convert(varchar(10),e.date,101)'Encounter Date'
,CAST(CONVERT(VARCHAR,hpi.value)AS INT)  'PQH9 Number'

      
FROM [mobiledoc].[dbo].[enc]e
JOIN [mobiledoc].[dbo].[structhpi]hpi on e.encounterID=hpi.encounterId
JOIN [mobiledoc].[dbo].[edi_facilities]f on e.facilityId=f.Id
JOIN [mobiledoc].[dbo].[users]u on e.patientID=u.uid
JOIN [mobiledoc].[dbo].[doctors]d on e.doctorID=d.doctorID
--WHERE (Convert(VarChar(10),e.date,23) Between '2017-01-01' and '2018-07-16')
WHERE (Convert(VarChar(10),e.date,23) Between @StartDate and @EndDate)
AND hpi.detailId='2895'
AND u.ulname not like ('Test')
AND f.Name in ('Lisbon Health Center','Claxton Hepburn Health Center','Hammond Health Center','Canton Health Center','Claxton Medical Internal Medicine',
				'Heuvelton Health Center','Madrid Health Center','Waddington Health Center','Claxton Medical Family Medicine', 'Claxton Medical PC Pediatrics')

 ) AS X
 WHERE X.[PQH9 Number] >= '10'
ORDER BY [Encounter Date]

