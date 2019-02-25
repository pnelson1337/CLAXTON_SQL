SELECT

BVFD.AccountType
,AV.LocationID
,AV.AccountNumber
,AV.Name
,CONVERT(VARCHAR(10),AV.ServiceDateTime,101)																																				AS 'ServiceDate'
,BVFD.ChargeTotal
,BVFD.ReceiptTotal
,BVFD.AdjustmentTotal
,BCTNAME.SINGLE_VALUE																																										AS 'Transaction Names'

FROM		[Livedb].[dbo].[BarVisitFinancialData]																																			AS BVFD
LEFT JOIN	[Livedb].[dbo].[AdmVisits]																																						AS AV				ON BVFD.VisitID=AV.VisitID
LEFT JOIN	(SELECT BV.VisitID
			 ,STUFF((SELECT ' || ' + TRA.Description
			 			FROM (SELECT [VisitID],ROW_NUMBER() OVER (PARTITION BY VisitID ORDER BY TransactionProcedureID DESC ) AS RowNum,[TransactionProcedureID],PRONA.Description
			 					FROM		[Livedb].[dbo].[BarChargeTransactions]																											AS BCT
								LEFT JOIN	[Livedb].[dbo].[DBarProcedures]																													AS PRONA	 ON BCT.TransactionProcedureID=PRONA.ProcedureID AND PRONA.Active='Y'					 
			 					GROUP BY VisitID, TransactionProcedureID, PRONA.Description)																								AS TRA
								WHERE (TRA.VisitID = BV.VisitID)
			 			FOR XML PATH (''),type).value('(./text())[1]','varchar(max)')
			 			, 1, 2,'')																																							AS SINGLE_VALUE
			 		FROM	  [Livedb].[dbo].[BarVisits]		AS BV
									
															)																																AS BCTNAME						ON BVFD.VisitID=BCTNAME.VisitID

WHERE AccountType='INFUSION'
AND AV.LocationID = 'INFUSION'
AND AV.ServiceDateTime BETWEEN @STARTDATE AND @ENDDATE

ORDER BY AV.ServiceDateTime