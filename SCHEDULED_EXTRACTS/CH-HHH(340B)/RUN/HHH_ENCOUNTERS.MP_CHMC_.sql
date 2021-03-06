Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE

SET @StartDate= DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)

-- 525 Days Back = 5/17/17

SELECT

'CLAXTONHEPBURN'																												AS 'HHHN Client ID'
,BV.UnitNumber																													AS 'Medical Record Code'
,SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0 THEN LEN(BV.Name) 
	ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END))											AS 'First Name'
,CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END								AS 'Last Name'
,CONVERT(VARCHAR(10),AV.BirthDateTime,101)																						AS 'Birth Date'
,AV.Sex																															AS 'Sex'
,AV.City																														AS 'City'
,AV.StateProvince																												AS 'State'
,AV.PostalCode																													AS 'Postal Code'
,AV.LocationID																													AS 'Site'
,CONVERT(VARCHAR(10),AV.ServiceDateTime,101)																					AS 'Visit Date'
,PROV.NationalProviderIdNumber																									AS 'Prescriber NPI'
,PROV.DeaNumber																													AS 'Prescriber DEA'
,''																																AS 'Pharmacy NPI'
,''																																AS 'eRX Number'
,PROV.Name																														AS 'Prescriber Last, First'

FROM		[CH_MTLIVE].[dbo].[AdmVisits]													AS AV
LEFT JOIN	[CH_MTLIVE].[dbo].[BarVisits]													AS BV									ON AV.[AccountNumber]=BV.[AccountNumber]
LEFT JOIN	[CH_MTLIVE].[dbo].[BarVisitProviders]											AS BVP									ON BV.VisitID=BVP.VisitID AND BVP.VisitProviderTypeID='Attending'
LEFT JOIN	[CH_MTLIVE].[dbo].[DMisProvider]												AS PROV									ON BVP.ProviderID=PROV.ProviderID								

		 
WHERE CONVERT(varchar(10),BV.ServiceDateTime,23) BETWEEN @StartDate AND @EndDate
AND AV.LocationID IN ('LIS','WADD','MAD','CAN','HEUV','HAMM','OHC','HHC','CHHC')
ORDER BY AV.LocationID, BV.ServiceDateTime