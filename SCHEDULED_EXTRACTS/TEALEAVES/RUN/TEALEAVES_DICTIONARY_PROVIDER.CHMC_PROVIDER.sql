SET NOCOUNT ON
SELECT
 

 ISNULL(CONVERT(VARCHAR(MAX), DMISPROV.NationalProviderIdNumber),'')							AS 'NPI'
,ISNULL(DMISPROV.ProviderID,'')																	AS 'Other_Provider_ID'
,''																								AS 'Other_Provider_ID_2'
,''																								AS 'Provider_Name_Prefix'
--Start of First_Name--
,SUBSTRING(DMISPROV.Name,CHARINDEX(',',DMISPROV.Name)+1,
	(CASE WHEN CHARINDEX(' ',DMISPROV.Name,CHARINDEX(',',DMISPROV.Name)+1)=0 
	THEN LEN(DMISPROV.Name)
	ELSE CHARINDEX(' ',DMISPROV.Name,CHARINDEX(',',DMISPROV.Name)+1)
	-CHARINDEX(',',DMISPROV.Name) END))															AS 'Provider_First_Name'
--Start of Middle Name-- 
,CASE 
	WHEN CHARINDEX(' ',DMISPROV.Name,CHARINDEX(',',DMISPROV.Name)+1) = 0 
	THEN ' ' 
	ELSE SUBSTRING(DMISPROV.Name,CHARINDEX(' ',DMISPROV.Name,
	CHARINDEX(',',DMISPROV.Name)+1)+1,1) END													AS 'Provider_Middle_Name'
--Start of Last Name--
,CASE 
	WHEN DMISPROV.Name NOT LIKE '%,%' 
	THEN DMISPROV.Name 
	ELSE LEFT(DMISPROV.Name, CHARINDEX(',',DMISPROV.Name)- 1) END								AS 'Provider_Last_Name'
,''																								AS 'Provider_Name_Suffix'
,''																								AS 'Professional_Title_Code'
,ISNULL(DMISPROV.[SpecialtyAbsServiceID],'')													AS 'Speciality_Code'
,ISNULL(DMISAS.[Name]		,'')																AS 'Specialty_Description'
,ISNULL(DMISPROV.Company	,'')																AS 'Facility/Site_of_Care_ID'
,ISNULL(DMISPROV.Address	,'')																AS 'Practice_Address_Line_1'
,ISNULL(DMISPROV.Address2	,'')																AS 'Practice_Address_Line_2'
,ISNULL(DMISPROV.City		,'')																AS 'Practice_City'
,ISNULL(DMISPROV.State		,'')																AS 'Practice_State'
,ISNULL(DMISPROV.PostalCode	,'')																AS 'Practice_Zip_Code'
,ISNULL(DMISPROV.Phone		,'')																AS 'Practice_Phone_Number'
,ISNULL(DMISPROV.Sex		,'')																AS 'Provider_Gender'
,ISNULL(CONVERT(VARCHAR(8), PPE.BirthDateTime	,112),'')										AS 'Provider_Birthdate'
,ISNULL(DMISPROV.ProviderGroupID,'')															AS 'Group_ID'
,ISNULL(DMPG.Name ,'')																			AS 'Group_Name'					
,ISNULL(DMISPROV.OnStaff ,'')																	AS 'Staff'
,ISNULL((SELECT DProvQ.Response 
					FROM [Livedb].[dbo].[DMisProviderQuery] DProvQ
 					WHERE (DProvQ.QueryID='EMPPHYS' ) AND  (DProvQ.Response='Y') 
					AND DMISPROV.ProviderID=DProvQ.ProviderID),'')								AS 'Employed'
,CASE
	WHEN DMISPROV.ProviderGroupID='HOSP' THEN 'Y'
	ELSE 'N'
 END																							AS 'Hospitalist'
 ,''																							AS 'Physician_Roster_Record_-_Active/Inactive'
 ,''																							AS 'Roster_Status'
 ,''																							AS 'Provider_Email_Address_1'
 ,''																							AS 'Provider_Email_Address_2'
 ,''																							AS 'Board_Certified_Specialty_1'
 ,''																							AS 'Certified_Date_Specialty_1'
 ,''																							AS 'Board_Certified_Specialty_2'
 ,''																							AS 'Certified_Date_Specialty_2'
 ,''																							AS 'Provider_Division'
 ,''																							AS 'Provider_Department'
 ,''																							AS 'Provider_Program'
 ,''																							AS 'Roster_Data_Source'


FROM			[Livedb].[dbo].[DMisProvider]													AS DMISPROV
LEFT OUTER JOIN [Livedb].[dbo].[DMisAbsService]													AS DMISAS								ON DMISPROV.SpecialtyAbsServiceID=DMISAS.AbsServiceID
LEFT OUTER JOIN [Livedb].[dbo].[DMisUsers]														AS DMisU								ON DMISPROV.ProviderID=DMisU.ProviderID
LEFT OUTER JOIN [Livedb].[dbo].[DMisProviderGroup]												AS DMPG									ON DMISPROV.ProviderGroupID=DMPG.ProviderGroupID	
LEFT OUTER JOIN [Livedb].[dbo].[PpEmployees]													AS PPE									ON PPE.UserID=DMisU.UserID
LEFT OUTER JOIN [Livedb].[dbo].[PpEmployeePayroll]												AS PPEPay								ON PPE.EmployeeID=PPEPay.EmployeeID

--LEFT OUTER JOIN [Livedb].[dbo].[DMisProviderQuery]												AS DMISPROVQ							ON DMISPROV.ProviderID=DMISPROVQ.ProviderID												
