
SELECT DISTINCT
av.Name
,av.AccountNumber
,sa.AppointmentID
,av.VisitID
,av.PrimaryInsuranceID
,sa.LocationID AS 'ResourceID'
,ABD.AppBookDate AS 'AppointmentBookedDate'
--,AD.AppDate AS 'AppointmentDate'
,LED.LastEdit
FROM
AdmVisits AS av
--INNER JOIN SchAppointmentEvents AS sae ON av.VisitID=av.VisitID
INNER JOIN SchAppointments AS sa ON av.VisitID=sa.VisitID
INNER JOIN AdmVisitEvents AS ave ON av.VisitID=ave.VisitID

LEFT JOIN (SELECT MAX(ave1.EventDateTime)		AS 'LastEdit',ave1.VisitID	  FROM AdmVisitEvents	AS ave1 GROUP BY VisitID)													AS LED ON av.VisitID=LED.VisitID
LEFT JOIN (SELECT MAX(ave2.EventDateTime)		AS 'AppBookDate',ave2.VisitID   FROM AdmVisitEvents	AS ave2 WHERE ave2.Code LIKE 'ENSCH%'  GROUP BY VisitID)					AS ABD ON av.VisitID=ABD.VisitID
--LEFT JOIN (SELECT MAX(ave3.EffectiveDateTime)	AS 'AppDate',ave3.VisitID	  FROM AdmVisitEvents	AS ave3 WHERE ave3.Code IN ('ENSCHREF','EDSCHREF') GROUP BY VisitID)		AS AD  ON av.VisitID=LED.VisitID


WHERE CONVERT(varchar(10),ave.EffectiveDateTime,23) BETWEEN '2018-01-01' AND '2018-01-07'

