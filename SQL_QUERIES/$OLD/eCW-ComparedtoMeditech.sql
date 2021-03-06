DECLARE @max_com_id INT, @i INT

SET @max_com_id = (SELECT MAX(TransactionID) FROM [BarChargeTransactions])
SET @i = 2

SELECT

--BV.VisitID											
 BV.AccountNumber											AS 'Acct'
,ECWCHG.[TransmittedOn]										AS 'Transmitted On'
,ECWCHG.[chargecodes]										AS 'eCWProcedure'

,CONVERT(VARCHAR(MAX),BCT.TransactionProcedureID)			AS 'MeditechProcedures'
,BCT.VisitID												AS 'TTVisitID'
,BCT.TransactionID											AS 'TTTranID'

INTO #charges


FROM		[Livedb].[dbo].[BarVisits]						AS BV
LEFT JOIN	[Livedb].[dbo].[BarChargeTransactions]			AS BCT			ON BV.VisitID=BCT.VisitID	
INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
LEFT JOIN	[CH-ECW-DBC-SQL].[mobiledoc].[dbo].[pmcharges]	AS ECWCHG		ON BV.AccountNumber=ECWCHG.[PMVisitNumber]
LEFT JOIN	[CH-ECW-DBC-SQL].[mobiledoc].[dbo].[enc]		AS ECWENC		ON ECWCHG.[encId]=ECWENC.[encounterID]

--WHERE ECWCHG.[TransmittedOn] BETWEEN '2018-08-22' AND '2018-08-23'
WHERE BCT.BatchDateTime BETWEEN '2018-08-22' AND '2018-08-23'

WHILE (@i <= @max_com_id)
	BEGIN
		UPDATE #charges
		SET MeditechProcedures= MeditechProcedures + ',' + BCT.TransactionProcedureID
		FROM #charges
		INNER JOIN [Livedb].[dbo].[BarChargeTransactions]	AS BCT			ON TTVisitID = BCT.VisitID
		INNER JOIN	[Livedb].[dbo].[BarBchs]				AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
		AND TTTranID = BCT.TransactionID 
		WHERE BCT.TransactionID = @i

	    SET @i = @i + 1
END

SELECT * FROM #charges
DROP TABLE #charges
