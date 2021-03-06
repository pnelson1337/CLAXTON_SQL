Set NOCOUNT ON;
Declare @StartDate DateTime, @EndDate DateTime
Set @StartDate =DATEADD(day, DATEDIFF(day, 0, GETDATE()), -1)
Set @EndDate =DATEADD(day, DATEDIFF(day, 0, GETDATE()), -1)
SELECT 
       e.facilityId'Facility ID'
	  ,f.Name 'Facility Name'
	  ,e.VisitType'Visit Type'
	  ,e.encounterID 'Visit Number'
	  ,convert(varchar(10),e.date,112) 'Visit Date'
	  ,e.patientID'MRN'
	  ,u.ufname 'Patient First Name'
      ,u.ulname 'Patient Last Name'
	  ,u.uminitial 'Patient Middle'
	  ,u.suffix 'Patient Suffix'
	  ,u.upPhone 'Primary Phone'
	  ,'' 'Secondary Phone'
      ,u.uemail 'Email Address'
      ,u.upaddress 'Address 1'
	  ,u.upaddress2 'Address 2'
      ,u.upcity 'City'
      ,u.upstate 'State'
      ,u.zipcode 'Zip 5'
	  ,'' 'Zip 4'
	  ,u.sex 'Gender'
	  ,p.race 'Race'
	  ,p.language 'Language'
	  ,p.maritalstatus 'Marital Status'
      ,convert(varchar(10),u.ptDob, 112)'DOB'
	  ,u2.ufname 'Attending Dr First Name'
	  ,u2.ulname 'Attending Dr Last Name'
	  ,'' 'Attending Dr Middle'
	  ,'' 'Attending Dr Suffix'
	  ,'' 'Attending Dr Degree'
	  ,d.NPI 'Attending Dr ID'
	  ,'NPI' 'Doctor ID Type'
	  ,'' 'Primary Payer ID'
	  ,'' 'Primary Payer Name'
	  ,'' 'Primary Plan Type'
	  ,'' 'Primary Diagnosis'
	  ,'' 'Primary DG Coding System'
	  ,'' 'Primary DG Description' 
	  ,'' 'Secondary Diagnosis'
	  ,'' 'Secondary DG Coding System'
	  ,'' 'Secondary DG Description'
	  ,'' 'Tertiary Diagnosis'
	  ,'' 'Tertiary DG Coding System'
	  ,'' 'Tertiary DG Description'      
      --,u.ssn '
	  --,e.encounterID
      --,e.patientID'MRN'
      --,e.doctorID
	  --,e.doctorID
      --,e.reason
      ,e.STATUS
	  
	  
	  
	  
  FROM [mobiledoc].[dbo].[users]u
  Left Join [mobiledoc].[dbo].[enc]e on u.uid=e.patientID
  Join [mobiledoc].[dbo].[edi_facilities]f on e.facilityId=f.Id
  LEFT OUTER JOIN [mobiledoc].[dbo].[Users]u2 on u2.uid=e.doctorID
  Left Join [mobiledoc].[dbo].[doctors]d on e.doctorID=d.doctorID
  left Join [mobiledoc].[dbo].[patients]p on u.uid=p.pid
  WHERE (CONVERT(VarChar(10),e.Date,23) BETWEEN @StartDate AND @EndDate)
  and e.patientID!='8663'
  and u.ulname NOT LIKE 'Test%'
  and u.ufname!='test'
  and e.VisitType!='LAB'
  and e.VisitType!='TEL'
  and e.VisitType!=''
  and e.VisitType Not like '%Nurse%'
  and e.VisitType!='WEB'
  and e.VisitType!='PACER'
  and f.Name not in('St. Josephs Nursing Home','United Helpers Nursing Home','Claxton Hepburn Wellness Center')
  --and e.STATUS not in('N/S','CANC','CONFPHONE','R/S','ANSPH','VOICEMSG')
  and e.STATUS in('CHK','Billed','ARR')
 
  
  