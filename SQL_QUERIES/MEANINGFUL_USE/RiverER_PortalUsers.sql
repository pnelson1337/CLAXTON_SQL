Declare @StartDate DateTime,@EndDate DateTime
set @StartDate='2017-07-01'
set @EndDate='2017-09-30'



select distinct 

ped.MriPatientID			as 'MriPatientID'
,ped.PhmWebUser				as 'Portal User'
,ped.Action					as 'Action On Portal'
,ped.Description			as 'What Was Done'
,ped.RowUpdateDateTime		as 'Update Date'
,av.InpatientOrOutpatient	as 'PatientStatus'
,av.PatientID				as 'VisitsPatientID'
,av.Name					as 'PatientName'
,av.LocationID				as 'Location'
,BV.DischargeDateTime
,BV.AccountNumber



from [Livemdb].[dbo].[AdmVisits] as av
INNER JOIN [Livemdb].[dbo].[BarVisits] AS BV ON av.VisitID=BV.VisitID
left outer join MisPatientAuditPhmEventsData as ped on ped.MriPatientID=av.PatientID


where BV.DischargeDateTime between @StartDate and @EndDate 
and av.InpatientOrOutpatient='O' 
and ped.RowUpdateDateTime between @StartDate and @EndDate
and ped.DatabaseID='MRI.RH' and ped.Action='V'

AND av.LocationID ='ER'


order by ped.RowUpdateDateTime