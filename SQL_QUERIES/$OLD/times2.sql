SELECT  DISTINCT ave.EffectiveDateTime
,av.AccountNumber
		FROM AdmVisitEvents ave
		RIGHT JOIN AdmVisits av ON ave.Status=av.Status AND ave.VisitID=av.VisitID
		WHERE ave.VisitID=av.VisitID
		AND ave.Code LIKE 'EN%'

 AND CONVERT(varchar(10),av.ServiceDateTime,23) BETWEEN '2017-08-01' AND '2017-08-31'
		--WHERE ave.VisitID='6011976603'