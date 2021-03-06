SELECT 
                bv.AccountNumber
                ,fd.AccountType
                ,av.InpatientOrOutpatient
				,CONVERT(varchar(10),tx.BatchDateTime,23) AS 'Batch Date'
				,COALESCE(CONVERT(varchar(10),bv.ServiceDateTime,23), '') + '' + COALESCE(CONVERT(varchar(10),bv.AdmitDateTime,23), '') AS 'Service Date'
                ,tx.TransactionID
                ,tx.TransactionProcedureID
				,db.Description
				,db.ChargeCategoryID
				,tx.TransactionCount
                ,tx.Amount AS 'Amount'
                ,tx.InsuranceID
                ,tx.Type AS 'Tx Type'
                ,(SELECT bd.DiagnosisCodeID FROM Livedb.dbo.BarDiagnoses bd WHERE (bd.DiagnosisSeqID = '1') AND
                                (bd.BillingID = tx.BillingID)) AS 'Diagnosis Code'
				,COALESCE(CONVERT(varchar(10),fd2.AttendProviderID,23), '') + '' + COALESCE(CONVERT(varchar(10),fd2.ErProviderID,23), '') AS 'Attending Provider'
                ,tx.UniqueClaimReferenceNumber
FROM Livedb.dbo.BarCollectionTransactions tx
                JOIN Livedb.dbo.BarVisits bv ON tx.VisitID=bv.VisitID
                JOIN Livedb.dbo.BarVisitFinancialData fd ON tx.VisitID=fd.VisitID
				JOIN Livedb.dbo.BarVisitFinancialData2 fd2 ON fd.VisitID=fd2.VisitID
                LEFT JOIN Livedb.dbo.AdmVisits av ON tx.VisitID=av.VisitID
				LEFT JOIN Livedb.dbo.DBarProcedures db ON tx.TransactionProcedureID=db.ProcedureID
WHERE CONVERT(varchar(10),bv.ServiceDateTime,23) BETWEEN '2014-01-01' AND '2014-12-31' OR CONVERT(varchar(10),bv.AdmitDateTime,23) BETWEEN '2014-01-01' AND '2014-12-31'
ORDER BY BatchDateTime,tx.VisitID, tx.TransactionID
