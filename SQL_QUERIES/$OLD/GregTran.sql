
SELECT --DISTINCT

                bvfd.AccountType                                                                                                                  AS 'AcctType'
                ,ig.Name                                                                                                                      AS 'InsGroup' 
				,bv.AccountNumber          
				
				
				--,SUM(ISNULL(CHARGES.CHARGES,'0.00'))                                                                                                   AS 'Charges'
                
				
				--,SUM(ISNULL(PRIINSRCP.PRIINSRCP,'0.00'))                                                                              AS 'PrimaryInsReceipts'
                
				/*
				,SUM(ISNULL(OTHERRCP.OTHERRCP,'0.00'))                                                                                              AS 'OtherReceipts'
                ,SUM(ISNULL(PRIINSRCP.PRIINSRCP,'0.00') + ISNULL(OTHERRCP.OTHERRCP,'0.00'))         AS 'TotalReceipts'
                ,SUM(ISNULL(PRIINSREF.PRIINSREF,'0.00'))                                                                                AS 'PrimaryInsRefunds'
                ,SUM(ISNULL(OTHERREF.OTHERREF,'0.00'))                                                                                                AS 'OtherInsRefunds'
                ,SUM(ISNULL(PRIINSREF.PRIINSREF,'0.00') + ISNULL(OTHERREF.OTHERREF,'0.00'))           AS 'TotalRefunds'
                ,SUM(ISNULL(PRIINSADJ.PRIINSADJ,'0.00'))                                                                               AS 'PrimaryInsAdjustments'
                ,SUM(ISNULL(OTHERADJ.OTHERADJ,'0.00'))                                                                                               AS 'OtherAdjustments'
                ,SUM(ISNULL(PRIINSADJ.PRIINSADJ,'0.00') + ISNULL(OTHERADJ.OTHERADJ,'0.00'))          AS 'TotalAdjustments'
                ,CASE WHEN SUM(CHARGES.CHARGES) = 0 OR SUM(CHARGES.CHARGES) IS NULL THEN '0.00' ELSE CAST((ISNULL(SUM(PRIINSRCP.PRIINSRCP),'0.00')/ISNULL(SUM(CHARGES.CHARGES),'0.00'))*100 AS decimal(10,2)) END                                                                                                                                                       AS 'PriInsRcp/Chg'
                ,CASE WHEN SUM(CHARGES.CHARGES) = 0 OR SUM(CHARGES.CHARGES) IS NULL THEN '0.00' ELSE CAST((ISNULL(SUM(PRIINSADJ.PRIINSADJ),'0.00')/ISNULL(SUM(CHARGES.CHARGES),'0.00'))*100 AS decimal(10,2)) END                                                                                                                                                       AS 'PriInsAdj/Chg'
                ,CASE WHEN SUM(CHARGES.CHARGES) = 0 OR SUM(CHARGES.CHARGES) IS NULL THEN '0.00' ELSE CAST(((ISNULL(SUM(PRIINSADJ.PRIINSADJ),'0.00') + ISNULL(SUM(OTHERADJ.OTHERADJ),'0.00'))/ISNULL(SUM(CHARGES.CHARGES),'0.00'))*100 AS decimal(10,2)) END                AS 'TotalAdj/Chg'
                --,DATES.DateTime
				*/
				,CHARGES.CHARGES
				,PRIINSRCP.PRIINSRCP
				                                                                                                                                                                                                                                         --AS 'BatchDate'
FROM
                BarVisits AS bv
                INNER JOIN DMisInsuranceGroup AS ig ON bv.FinancialClassID=ig.InsuranceGroupID
                INNER JOIN BarVisitFinancialData AS bvfd ON bv.BillingID=bvfd.BillingID
                LEFT JOIN ( SELECT BillingID,SUM(ChargeTotal) AS 'CHARGES' FROM BarVisitFinancialData
                                                                GROUP BY BillingID) AS CHARGES ON bv.BillingID=CHARGES.BillingID

                LEFT JOIN ( SELECT BCT.BillingID,BTI.Amount AS 'PRIINSRCP' FROM BarVisits AS BV 
                                                                INNER JOIN BarBchTxns                                AS BCT ON BV.BillingID=BCT.BillingID
                                                                LEFT JOIN BarBchTxnItems          AS BTI ON BCT.BatchID=BTI.BatchID AND BCT.TxnNumberID=BTI.TxnNumberID
                                                                LEFT JOIN DBarProcedures          AS DBP ON BTI.ProcedureID=DBP.ProcedureID AND DBP.Active = 'Y'
                                                                WHERE
                                                                                BV.PrimaryInsuranceID = DBP.InsuranceID
                                                                                AND BTI.Type = 'RCP'
                                                                ) AS PRIINSRCP ON bv.BillingID=PRIINSRCP.BillingID
/*
                LEFT JOIN ( SELECT BCT.BillingID,SUM(BTI.Amount) AS 'OTHERRCP' FROM BarVisits AS BV 
                                                                INNER JOIN BarBchTxns                                AS BCT ON BV.BillingID=BCT.BillingID
                                                                LEFT JOIN BarBchTxnItems          AS BTI ON BCT.BatchID=BTI.BatchID AND BCT.TxnNumberID=BTI.TxnNumberID
                                                                LEFT JOIN DBarProcedures          AS DBP ON BTI.ProcedureID=DBP.ProcedureID AND DBP.Active = 'Y'
                                                                WHERE
                                                                                BV.PrimaryInsuranceID != DBP.InsuranceID
                                                                                AND BTI.Type = 'RCP'
                                                                GROUP BY BCT.BillingID) AS OTHERRCP ON bv.BillingID=OTHERRCP.BillingID
               
			    LEFT JOIN ( SELECT BCT.BillingID,SUM(BTI.Amount) AS 'PRIINSREF' FROM BarVisits AS BV 
                                                                INNER JOIN BarBchTxns                                AS BCT ON BV.BillingID=BCT.BillingID
                                                                LEFT JOIN BarBchTxnItems          AS BTI ON BCT.BatchID=BTI.BatchID AND BCT.TxnNumberID=BTI.TxnNumberID
                                                                LEFT JOIN DBarProcedures          AS DBP ON BTI.ProcedureID=DBP.ProcedureID AND DBP.Active = 'Y'
                                                                WHERE
                                                                                BV.PrimaryInsuranceID = DBP.InsuranceID
                                                                                AND BTI.Type = 'P'
                                                                GROUP BY BCT.BillingID) AS PRIINSREF ON bv.BillingID=PRIINSREF.BillingID
                LEFT JOIN ( SELECT BCT.BillingID,SUM(BTI.Amount) AS 'OTHERREF' FROM BarVisits AS BV 
                                                                INNER JOIN BarBchTxns                                AS BCT ON BV.BillingID=BCT.BillingID
                                                                LEFT JOIN BarBchTxnItems          AS BTI ON BCT.BatchID=BTI.BatchID AND BCT.TxnNumberID=BTI.TxnNumberID
                                                                LEFT JOIN DBarProcedures          AS DBP ON BTI.ProcedureID=DBP.ProcedureID AND DBP.Active = 'Y'
                                                                WHERE
                                                                                BV.PrimaryInsuranceID != DBP.InsuranceID
                                                                                AND BTI.Type = 'P'
                                                                GROUP BY BCT.BillingID) AS OTHERREF ON bv.BillingID=OTHERREF.BillingID

                LEFT JOIN ( SELECT BCT.BillingID,SUM(BTI.Amount) AS 'PRIINSADJ' FROM BarVisits AS BV 
                                                                INNER JOIN BarBchTxns                                AS BCT ON BV.BillingID=BCT.BillingID
                                                                LEFT JOIN BarBchTxnItems          AS BTI ON BCT.BatchID=BTI.BatchID AND BCT.TxnNumberID=BTI.TxnNumberID
                                                                LEFT JOIN DBarProcedures          AS DBP ON BTI.ProcedureID=DBP.ProcedureID AND DBP.Active = 'Y'
                                                                WHERE
                                                                                BV.PrimaryInsuranceID = DBP.InsuranceID
                                                                                AND BTI.Type = 'ADJ'
                                                                GROUP BY BCT.BillingID) AS PRIINSADJ ON bv.BillingID=PRIINSADJ.BillingID

                LEFT JOIN ( SELECT BCT.BillingID,SUM(BTI.Amount) AS 'OTHERADJ' FROM BarVisits AS BV 
                                                                INNER JOIN BarBchTxns                                AS BCT ON BV.BillingID=BCT.BillingID
                                                                LEFT JOIN BarBchTxnItems          AS BTI ON BCT.BatchID=BTI.BatchID AND BCT.TxnNumberID=BTI.TxnNumberID
                                                                LEFT JOIN DBarProcedures          AS DBP ON BTI.ProcedureID=DBP.ProcedureID AND DBP.Active = 'Y'
                                                                WHERE
                                                                                BV.PrimaryInsuranceID != DBP.InsuranceID
                                                                                AND BTI.Type = 'ADJ'
                                                                GROUP BY BCT.BillingID) AS OTHERADJ ON bv.BillingID=OTHERADJ.BillingID
																*/
                LEFT JOIN ( SELECT BillingID,DateTime FROM BarBch AS BCH WHERE BCH.Status != 'DELETED') AS DATES ON bv.BillingID=DATES.BillingID 

WHERE
                CONVERT(varchar(10),DATES.DateTime,23) BETWEEN '2018-10-01' AND '2018-10-31'
                --CONVERT(varchar(10),DATES.DateTime,23) BETWEEN @StartDate AND @EndDate
                --AND bvfd.Balance <= @Balance
                --AND bvfd.Balance <= 0
                --AND bvfd.AccountType IN (@AcctType)
--GROUP BY bvfd.AccountType,ig.Name

ORDER BY AccountNumber

