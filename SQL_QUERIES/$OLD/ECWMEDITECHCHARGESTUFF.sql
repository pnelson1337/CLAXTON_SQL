SELECT

--BV.VisitID											
 BV.AccountNumber											AS 'Acct'
,ECWCHG.[TransmittedOn]										AS 'Transmitted On'
,ECWCHG.[chargecodes]										AS 'eCWProcedure'
--,CONVERT(VARCHAR(MAX),BCT.TransactionProcedureID)			AS 'MeditechProcedures'
--,BCT.VisitID												AS 'TTVisitID'
--,BCT.TransactionID											AS 'TTTranID'
-- START DIAGNOSIS CODES IN A SINGLE CELL PER PATIENT ENCOUNTER--
				,ISNULL ((SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT
															INNER JOIN	[Livedb].[dbo].[BarBchs]		AS BCH	ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
															WHERE (BCT.TransactionID = '1') AND (BV.VisitID = BCT.VisitID))  +
				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '2')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '2')  AND (BV.VisitID = BCT.VisitID)) END +

				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '3')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '3')  AND (BV.VisitID = BCT.VisitID)) END +

				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '4')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '4')  AND (BV.VisitID = BCT.VisitID)) END +

				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '5')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '5')  AND (BV.VisitID = BCT.VisitID)) END +

				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '6')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '6')  AND (BV.VisitID = BCT.VisitID)) END +
		 				
				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '7')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '7')  AND (BV.VisitID = BCT.VisitID)) END +

				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '8')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '8')  AND (BV.VisitID = BCT.VisitID)) END +
						
				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '9')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '9')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '10')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '10')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '11')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '11')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '12')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '12')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '13')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '13')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '14')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '14')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '15')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '15')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '16')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '16')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '17')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '17')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '18')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '18')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '19')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '19')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '20')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '20')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '21')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '21')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '22')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '22')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '23')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '23')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '24')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '24')  AND (BV.VisitID = BCT.VisitID)) END +
				
								CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '25')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '25')  AND (BV.VisitID = BCT.VisitID)) END +								

				CASE 
				WHEN (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '26')  AND (BV.VisitID = BCT.VisitID)) IS NULL THEN '' 
				ELSE + ';' + (SELECT BCT.TransactionProcedureID FROM [Livedb].[dbo].[BarChargeTransactions] AS BCT 
				INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
				WHERE (BCT.TransactionID = '26')  AND (BV.VisitID = BCT.VisitID)) END 
				,'')
				 AS 'DIAGNOSIS_CD'
--END DIAGNOSIS IN SINGLE CELL--



FROM		[Livedb].[dbo].[BarVisits]						AS BV
--LEFT JOIN	[Livedb].[dbo].[BarChargeTransactions]			AS BCT			ON BV.VisitID=BCT.VisitID	
--INNER JOIN	[Livedb].[dbo].[BarBchs]						AS BCH			ON BCT.Batch=BCH.Number AND BCT.BatchDateTime=BCH.DateTime AND BCH.Comment='Charge from eCW Interface'
LEFT JOIN	[CH-ECW-DBC-SQL].[mobiledoc].[dbo].[pmcharges]	AS ECWCHG		ON BV.AccountNumber=ECWCHG.[PMVisitNumber]
--LEFT JOIN	[CH-ECW-DBC-SQL].[mobiledoc].[dbo].[enc]		AS ECWENC		ON ECWCHG.[encId]=ECWENC.[encounterID]

WHERE ECWCHG.[TransmittedOn] BETWEEN '2018-08-22' AND '2018-08-23'
--WHERE BCT.BatchDateTime BETWEEN '2018-08-22' AND '2018-08-23'
