SET NOCOUNT ON

DECLARE @PMedRecNum VARCHAR(255)--,@PName VARCHAR(255)
--SET @PName='DUMONT,CHARLES J'
SET @PMedRecNum='905981'


SELECT 

 MAX(BV.AccountNumber)													AS 'AccountNumber'
,MAX(BV.Name)															AS 'Patient Name'
,MAX(BV.UnitNumber)														AS 'Medical Record Number'
,MAX(COALESCE(CONVERT(VARCHAR(10),BV.ServiceDateTime,101), '')) 
 + '' + 
 MAX(COALESCE(CONVERT(VARCHAR(10),BV.AdmitDateTime,101), ''))			AS 'Ser/Adm Date'
,MAX(CONVERT(VARCHAR(10),BV.DischargeDateTime,101))						AS 'Discharge Date'
,MAX(NQR.[Response])													AS 'Response'
,MAX(CONVERT(VARCHAR(10),NQR.RowUpdateDateTime,101))					AS 'Response Date'


FROM [Livedb].[dbo].[NurQueryResults]									AS NQR
LEFT JOIN [Livedb].[dbo].[BarVisits]									AS BV		ON NQR.VisitID=BV.VisitID 


WHERE QueryID='NUR2001035'
AND Response NOT IN  ('NONE','UNKNOWN','N')
AND BV.UnitNumber = @PMedRecNum


GROUP BY BV.AccountNumber
ORDER BY AccountNumber