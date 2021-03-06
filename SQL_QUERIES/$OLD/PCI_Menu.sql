SELECT 
PCI.UserID
,UPPER(DMU.Name)											AS 'Name'
,PCI.[ApplicationID]
,PCI.[Menu]				


FROM		[Livedb].[dbo].[DMisUserApplicationMenus]		AS PCI
INNER JOIN	[Livedb].[dbo].[DMisUsers]						AS DMU		ON PCI.UserID=DMU.UserID AND Active='Y'

WHERE ApplicationID='PCI.ABH'
AND Menu IN('CLINICMHC')

ORDER BY Name