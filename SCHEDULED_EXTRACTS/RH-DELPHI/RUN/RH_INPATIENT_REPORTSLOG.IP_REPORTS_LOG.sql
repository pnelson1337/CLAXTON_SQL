Set NOCOUNT ON;
DECLARE	@StartDate DATE, @EndDate DATE
/*SET @StartDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
SET @EndDate= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 2, 0)*/

SET @StartDate= DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -4 , 0)
SET @EndDate=   DATEADD(DAY,DATEDIFF(DAY, 0, GETDATE()) -4 , 0)

--SET @StartDate = '2018-08-01'
--SET @EndDate   = '2018-09-01'
SELECT


 ISNULL(DCMTS.DocumentTemplateID,'')																					AS 'Document Name'
,ISNULL(CONVERT(VARCHAR(10),DCMTS.DateTime,112),'')																		AS 'Encounter Date'
,ISNULL(DCMTS.UserID,'')																								AS 'Dictating Provider Mnemonic'
,ISNULL(DCMTSPROV.Name,'')																								AS 'Dictating Provider Name'
,ISNULL(CONVERT(VARCHAR(10),DCMTS.SignDateTime,112),'')																	AS 'Signed Date'
,ISNULL(ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,112),CONVERT(VARCHAR(10),BV.ServiceDateTime,112)),'')				AS 'Date of Service'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,112),'')																AS 'Date of Discharge'
,ISNULL(CONVERT(VARCHAR(5),BV.DischargeDateTime,108),'')																AS 'Time Discharged'
,ISNULL(BV.AccountNumber,'')																							AS 'Patient Account Number'
,ISNULL(BV.UnitNumber,'')																								AS 'Medical Record Number'
,ISNULL(SUBSTRING(BV.Name,CHARINDEX(',',BV.Name)+1,(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)=0	 
	THEN LEN(BV.Name)ELSE CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)-CHARINDEX(',',BV.Name) END)),'') 
																														AS 'Patient First Name'
,ISNULL(CASE WHEN BV.Name NOT LIKE '%,%' THEN BV.Name ELSE LEFT(BV.Name, CHARINDEX(',',BV.Name)- 1) END,'')				AS 'Patient Last Name'
,ISNULL(CASE WHEN CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1) = 0 THEN ' '
		ELSE SUBSTRING(BV.Name,CHARINDEX(' ',BV.Name,CHARINDEX(',',BV.Name)+1)+1,1) END,'')								AS 'Patient Middle Initial'
,ISNULL(PROVNAME.Name,'')																								AS 'Attending Physician'
,ISNULL(CONVERT(VARCHAR(10),BV.BirthDateTime,112),'')																	AS 'Patient Date of Birth'




FROM		[172.16.32.18].[Livemdb].[dbo].[AdmVisits]																		AS AV
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[BarVisits]																		AS BV		 ON AV.VisitID=BV.VisitID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[BarVisitProviders]																AS ATTEND	 ON AV.VisitID=ATTEND.VisitID AND ATTEND.VisitProviderTypeID='Attending'
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[DMisDischargeDisposition]														AS DISPO	 ON BV.DischargeDispositionID=DISPO.DispositionID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[DMisProvider]																	AS PROVNAME	 ON ATTEND.ProviderID=PROVNAME.ProviderID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[PcmDcmts]																		AS DCMTS	 ON AV.VisitID=DCMTS.VisitID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[DMisUsers]																		AS MISUSER	 ON DCMTS.UserID=MISUSER.UserID
LEFT JOIN	[172.16.32.18].[Livemdb].[dbo].[DMisProvider]																	AS DCMTSPROV ON MISUSER.ProviderID=DCMTSPROV.ProviderID
WHERE CONVERT(VARCHAR(10),DCMTS.DateTime,23) BETWEEN  @StartDate AND @EndDate
--WHERE CONVERT(VARCHAR(10),DCMTS.DateTime,23) BETWEEN  '2018-06-01' AND '2019-01-24'
AND DCMTSPROV.Company='DELPHI'

ORDER BY [Encounter Date]