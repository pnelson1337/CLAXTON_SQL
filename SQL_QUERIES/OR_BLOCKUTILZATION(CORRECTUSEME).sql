SELECT 

SCHOR.PatientCaseID
,CRAZY.DayID
,ISNULL(BLOCKTIMES.DayID,BLOCKTIMES2.DayID)			AS 'DayID'
,'' AS ' '
,CRAZY.FrequencyID
,ISNULL(BLOCKTIMES.FrequencyID,BLOCKTIMES2.FrequencyID)		AS 'FrequencyID'
,'' AS ' '
,CRAZY.ProviderID
,ISNULL(BLOCKTIMES.ProviderID,BLOCKTIMES2.ProviderID)		AS 'ProviderID'
,'' AS ' '
,CRAZY.OperationRoomID
,ISNULL(BLOCKTIMES.ResourceID,BLOCKTIMES2.ResourceID)		AS 'OperationRoomID'
,'' AS ' '
,SCHOR.OperationDateTime
,SCHOR.CompleteDateTime
,ISNULL(CAST(CONVERT(VARCHAR(10),SCHOR.OperationDateTime,126)+' '+LEFT(BLOCKTIMES.[BLOCK BEGIN],2)+':'+RIGHT(BLOCKTIMES.[BLOCK BEGIN],2)+':'+'00.000' AS DATETIME),
		CAST(CONVERT(VARCHAR(10),SCHOR.OperationDateTime,126)+' '+LEFT(BLOCKTIMES2.[BLOCK BEGIN],2)+':'+RIGHT(BLOCKTIMES2.[BLOCK BEGIN],2)+':'+'00.000' AS DATETIME))	AS 'BlockStartDateTime'

,ISNULL(CAST(CONVERT(VARCHAR(10),SCHOR.OperationDateTime,126)+' '+LEFT(BLOCKTIMES.[BLOCK END],2)+':'+RIGHT(BLOCKTIMES.[BLOCK END],2)+':'+'00.000' AS DATETIME),
		CAST(CONVERT(VARCHAR(10),SCHOR.OperationDateTime,126)+' '+LEFT(BLOCKTIMES2.[BLOCK END],2)+':'+RIGHT(BLOCKTIMES2.[BLOCK END],2)+':'+'00.000' AS DATETIME))		AS 'BlockEndDateTime'


FROM		[Livedb].[dbo].[SchOrPatCases]																	AS SCHOR
																						
LEFT JOIN  (SELECT
			 PatientCaseID
			,ProviderID
			,OperationRoomID
			,CASE WHEN DATEPART(DAY,OperationDateTime)/7 = 0 THEN 'MON 1ST'
			 	  WHEN DATEPART(DAY,OperationDateTime)/7 = 1 THEN 'MON 2ND' 
			 	  WHEN DATEPART(DAY,OperationDateTime)/7 = 2 THEN 'MON 3RD' 
			 	  WHEN DATEPART(DAY,OperationDateTime)/7 = 3 THEN 'MON 4TH' 
			 	  WHEN DATEPART(DAY,OperationDateTime)/7 = 4 THEN 'MON 5TH'
				  WHEN DATEPART(DAY,OperationDateTime)/7 = 5 THEN 'MON LAST'   
			 END															AS 'FrequencyID'
			 ,UPPER(LEFT(DATENAME(DW,OperationDateTime),3))					AS 'DayID'
			 FROM [Livedb].[dbo].[SchOrPatCases])							AS CRAZY			ON SCHOR.PatientCaseID=CRAZY.PatientCaseID 	

LEFT JOIN (SELECT
			SRPD.ResourceID,SRPD.ProviderID
			,SRD.FrequencyID
			,SRD.DayID
			,SRD.DayFromTime AS 'BLOCK BEGIN'
			,SRD.DayThruTime AS 'BLOCK END'
			,SRD.DateFrom
			,SRD.DateThru
			--,SRD.DateSeqID
			FROM			[Livedb].[dbo].[DSchResourceDates]					AS SRD
			LEFT JOIN		[Livedb].[dbo].[DSchResourceOrProfileDoctor]		AS SRPD			ON SRD.ResourceID=SRPD.ResourceID AND SRD.DateSeqID=SRPD.DateSeqID
			WHERE SRPD.ResourceID IS NOT NULL)									AS BLOCKTIMES	ON CRAZY.OperationRoomID=BLOCKTIMES.ResourceID AND CRAZY.ProviderID=BLOCKTIMES.ProviderID AND CRAZY.DayID = CASE WHEN BLOCKTIMES.FrequencyID LIKE 'MON%' THEN BLOCKTIMES.DayID END  AND CRAZY.FrequencyID = CASE WHEN BLOCKTIMES.FrequencyID LIKE 'MON%' THEN BLOCKTIMES.FrequencyID  END

LEFT JOIN (SELECT
			SRPD.ResourceID,SRPD.ProviderID
			,SRD.FrequencyID
			,SRD.DayID
			,SRD.DayFromTime AS 'BLOCK BEGIN'
			,SRD.DayThruTime AS 'BLOCK END'
			,SRD.DateFrom
			,SRD.DateThru
			--,SRD.DateSeqID
			FROM			[Livedb].[dbo].[DSchResourceDates]					AS SRD
			LEFT JOIN		[Livedb].[dbo].[DSchResourceOrProfileDoctor]		AS SRPD			ON SRD.ResourceID=SRPD.ResourceID AND SRD.DateSeqID=SRPD.DateSeqID
			WHERE SRPD.ResourceID IS NOT NULL)									AS BLOCKTIMES2	ON CRAZY.OperationRoomID=BLOCKTIMES2.ResourceID AND CRAZY.ProviderID=BLOCKTIMES2.ProviderID AND CRAZY.DayID = CASE WHEN BLOCKTIMES2.FrequencyID NOT LIKE 'MON%' THEN BLOCKTIMES2.DayID END

WHERE SCHOR.OperationDateTime BETWEEN '2018-10-01' AND '2018-11-30'
AND SCHOR.CompleteDateTime IS NOT NULL



ORDER BY SCHOR.OperationDateTime,SCHOR.OperationRoomID


