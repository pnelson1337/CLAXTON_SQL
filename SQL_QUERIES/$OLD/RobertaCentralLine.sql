DECLARE @STARTDATE DATE, @ENDDATE DATE

SET @STARTDATE = '2018-11-01'
SET @ENDDATE   = '2018-11-30'


SELECT 

AV.Name
,AV.AccountNumber
,ISNULL(ISNULL(CONVERT(VARCHAR(10),BV.AdmitDateTime,101),CONVERT(VARCHAR(10),BV.ServiceDateTime,101)),'')			AS 'Admit Date'
,ISNULL(CLASSEARLY.QueryDate,'')																					AS 'First C/L Assessed' 
,PICCINSERT.Response																								AS 'PICC-INSERTED'
,ISNULL(CONVERT(VARCHAR(10),BV.DischargeDateTime,101),'')															AS 'Discharge Date'
,ISNULL(CLASSLATEST.QueryDate,'')																					AS 'Last C/L Assessed'
,ISNULL(CLDAYCOUNT.Count,'0')																						AS 'CL Days for RunDates'
,ISNULL(CLTOTAL.Count,'0')																							AS 'CL Days for Total Visit'
,ISNULL(CLTYPE.Name, 'NO CENTRAL LINE TYPE')																		AS 'Central Line Type'
,DISDISPO.Name																										AS 'Discharge Disposition'
,LATESTDRESSINGCHANGE.DateTime																						AS 'DressingChangeDateTime'
,LATESTTUBINGCHANGED.DateTime																						AS 'TubingChangedDateTime'


FROM		[Livedb].[dbo].[AdmVisits]																				AS AV
LEFT JOIN	[Livedb].[dbo].[BarVisits]																				AS BV			ON AV.VisitID=BV.VisitID
LEFT JOIN	[Livedb].[dbo].[DMisDischargeDisposition]																AS DISDISPO		ON BV.DischargeDispositionID=DISDISPO.DispositionID AND DISDISPO.Active='Y'
		

-- START LATEST CENTRAL LINE ASSESSED
LEFT JOIN(SELECT * FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY NQR.VisitID ORDER BY NQR.DateTime DESC)												AS OrderSeq
,CONVERT(VARCHAR(10),NQR.DateTime,101)																				AS QueryDate
,NQR.VisitID						
FROM [Livedb].[dbo].[NurQueryResults]																				AS NQR
WHERE NQR.QueryID='CCICVCASSE'
)																													AS X
WHERE X.OrderSeq='1')																								AS CLASSLATEST			ON AV.VisitID=CLASSLATEST.VisitID		

-- START EARLIEST CENTRAL LINE ASSESSED
LEFT JOIN(SELECT * FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY NQR.VisitID ORDER BY NQR.DateTime ASC)												AS OrderSeq
,CONVERT(VARCHAR(10),NQR.DateTime,101)																				AS QueryDate
,NQR.VisitID						
FROM [Livedb].[dbo].[NurQueryResults]																				AS NQR
WHERE NQR.QueryID='CCICVCASSE'
)																													AS X
WHERE X.OrderSeq='1')																								AS CLASSEARLY			ON AV.VisitID=CLASSEARLY.VisitID


-- START DATE OF CENTRAL LINE ASSESSED BETWEEN START AND ENDDATE
LEFT JOIN( SELECT * FROM(SELECT
ROW_NUMBER() OVER (PARTITION BY NQR.VisitID ORDER BY NQR.DateTime ASC)												AS OrderSeq
,CONVERT(VARCHAR(10),NQR.DateTime,101)																				AS QueryDate
,NQR.VisitID						
FROM [Livedb].[dbo].[NurQueryResults]																				AS NQR
WHERE NQR.QueryID='CCICVCASSE'
AND NQR.DateTime BETWEEN @STARTDATE AND @ENDDATE
)																													AS X
WHERE X.OrderSeq='1')																								AS CLDATE ON AV.VisitID=CLDATE.VisitID

-- START COUNT OF CENTRAL LINE ASSESSED DAYS BETWEEN START AND ENDDATE --
LEFT JOIN (SELECT X.VisitID,COUNT(X.VisitID) AS 'Count' FROM(
SELECT DISTINCT
NQR.VisitID
,CONVERT(VARCHAR(10),NQR.DateTime,101)																				AS QueryDate					
FROM [Livedb].[dbo].[NurQueryResults]																				AS NQR
WHERE NQR.QueryID='CCICVCASSE'
AND NQR.Response='Y'
AND NQR.DateTime BETWEEN @STARTDATE AND @ENDDATE
) AS X
GROUP BY X.VisitID)																									AS CLDAYCOUNT	ON AV.VisitID=CLDAYCOUNT.VisitID

-- START COUNT TOTAL CENTRAL LINE DAYS --
LEFT JOIN (SELECT X.VisitID,COUNT(X.VisitID) AS 'Count' FROM(
SELECT DISTINCT
NQR.VisitID
,CONVERT(VARCHAR(10),NQR.DateTime,101)																				AS QueryDate					
FROM [Livedb].[dbo].[NurQueryResults]																				AS NQR
WHERE NQR.QueryID='CCICVCASSE'
AND NQR.Response='Y'
) AS X
GROUP BY X.VisitID)																									AS CLTOTAL	ON AV.VisitID=CLTOTAL.VisitID		

--START CENTRAL LINE TYPE--
LEFT JOIN (SELECT * FROM (
SELECT NQR1.VisitID,NQR1.Response,GR.Name,NQR1.DateTime
,ROW_NUMBER() OVER (PARTITION BY NQR1.VisitID ORDER BY NQR1.DateTime DESC)	AS OrderSeq 
FROM [NurQueryResults] AS NQR1
INNER JOIN [DMisGroupResponseElements]										AS GR		ON GR.CodeID=NQR1.Response AND GR.GroupResponseID='CCICVC007'
WHERE NQR1.QueryID='CCICVC007'
) AS X
WHERE X.OrderSeq='1')														AS CLTYPE	ON AV.VisitID=CLTYPE.VisitID		
-- END CENTRAL LINE TYPE--

--PICC INSERT DATE--
LEFT JOIN (SELECT * FROM (
SELECT NQR1.VisitID,NQR1.Response,NQR1.DateTime
,ROW_NUMBER() OVER (PARTITION BY NQR1.VisitID ORDER BY NQR1.DateTime DESC)	AS OrderSeq 
FROM [NurQueryResults] AS NQR1
WHERE NQR1.QueryID='CCICVC033'
) AS X
WHERE X.OrderSeq='1')														AS PICCINSERT	ON AV.VisitID=PICCINSERT.VisitID		
--PICC INSERT DATE--

--LATEST DRESSING CHANGE--
LEFT JOIN (SELECT * FROM (
SELECT NQR1.VisitID,NQR1.Response,NQR1.DateTime
,ROW_NUMBER() OVER (PARTITION BY NQR1.VisitID ORDER BY NQR1.DateTime DESC)	AS OrderSeq 
FROM [NurQueryResults] AS NQR1
WHERE NQR1.QueryID='CCICVC072'
  AND NQR1.Response='Y'
) AS X
WHERE X.OrderSeq='1')														AS LATESTDRESSINGCHANGE	ON AV.VisitID=LATESTDRESSINGCHANGE.VisitID		
--END LATEST DRESSING CHANGE--

--LATEST DRESSING CHANGE--
LEFT JOIN (SELECT * FROM (
SELECT NQR1.VisitID,NQR1.Response,NQR1.DateTime
,ROW_NUMBER() OVER (PARTITION BY NQR1.VisitID ORDER BY NQR1.DateTime DESC)	AS OrderSeq 
FROM [NurQueryResults] AS NQR1
WHERE NQR1.QueryID='CCICVC073'
  AND NQR1.Response='Y'
) AS X
WHERE X.OrderSeq='1')														AS LATESTTUBINGCHANGED	ON AV.VisitID=LATESTTUBINGCHANGED.VisitID		
--END LATEST DRESSING CHANGE--




WHERE CAST(CLDATE.QueryDate AS DATE) BETWEEN @STARTDATE AND @ENDDATE
ORDER BY [First C/L Assessed]