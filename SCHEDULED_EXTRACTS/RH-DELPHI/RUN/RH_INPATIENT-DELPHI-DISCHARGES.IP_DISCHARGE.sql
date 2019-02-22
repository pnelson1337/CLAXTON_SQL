Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)*/

SET @StartDate= DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -1 , 0)

--SET @StartDate = '2018-01-01'
--SET @EndDate   = '2018-01-15'
SELECT


 ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,112),CONVERT(VARCHAR(10),BV.ServiceDateTime,112))				AS 'Date of Service'
,CONVERT(VARCHAR(10),BV.DischargeDateTime,112)																AS 'Date of Discharge'
,CONVERT(VARCHAR(5),BV.DischargeDateTime,108)																AS 'Time Discharged'
,ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,112),CONVERT(VARCHAR(10),BV.ServiceDateTime,112))				AS 'Date of Arrival'
,ISNULL(CONVERT(VARCHAR(5),BV.AdmitDateTime,108),CONVERT(VARCHAR(5),BV.ServiceDateTime,108))				AS 'TIme of Arrival'
,''																											AS 'Time to Triage'
,''																											AS 'Time to Bed'
,''																											As 'Time to Doc'
,BV.AccountNumber																							AS 'Patient Account Number'
,BV.UnitNumber																								AS 'Medical Record Number'
,SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0	 
	THEN LEN(BV.Name)ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END)) 
																											AS 'Patient First Name'
,CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END			AS 'Patient Last Name'
,CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1) = 0 THEN ' '
		ELSE SUBSTRING(BV.Name,CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)+1,1) END						AS 'Patient Middle Initial'
,PROVNAME.Name																								AS 'Attending Physician'
,CONVERT(VARCHAR(10),BV.BirthDateTime,112)																	AS 'Patient Date of Birth'
,''																											AS 'Presenting Complaint'
,DISPO.Name																									AS 'Disposition'
,''																											AS 'Patient Type'
,''																											AS 'Mid-Level Name'
,''																											AS 'Scribe Name'
,''																											AS 'Total Face-to-Face time'



FROM		[172.16.32.18].[Livemdb].[dbo].[AdmVisits]														AS AV
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[BarVisits]														AS BV		ON AV.VisitID=BV.VisitID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[BarVisitProviders]												AS ATTEND	ON AV.VisitID=ATTEND.VisitID AND ATTEND.VisitProviderTypeID='Attending'
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[DMisDischargeDisposition]										AS DISPO	ON BV.DischargeDispositionID=DISPO.DispositionID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[DMisProvider]													AS PROVNAME	ON ATTEND.ProviderID=PROVNAME.ProviderID

WHERE CONVERT(varchar(10),BV.DischargeDateTime,23) BETWEEN  @StartDate AND @EndDate
AND AV.Status='DIS IN'
AND PROVNAME.NationalProviderIdNumber IN ('1811306590','1891898003','1407898356','1609131515','1366966277','1134126881','1124007489','1629414651','1922017128','1073820171','1467450833'
,'1982644019','1699771295','1710982731','1922042225','1194755520','1467424226','1912961061','1801229604','1306251400','1851387971','1558516591','1194243238','1235188178','1528588639'
,'1750387023','1174788541','1396992863','1437460003','1174810279','1003159054','1205190535','1386091445','1124385273','1992751366','1083602221','1851816961','1053359109','1386875649'
,'1538268289','1285041285','1659513125','1821191933','1336669126','1710993373','1598045205','1033103783','1033233879','1073996930','1578736336','1255516852','1063446508','1558308122'
,'1699181974','1619168689','1750644191','1801120746','1023057692','1730536004','1992174007','1750369385','1750572574')

ORDER BY BV.DischargeDateTime