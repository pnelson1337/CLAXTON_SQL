SELECT DISTINCT
Menu

FROM [Livedb].[dbo].[DMisUserApplicationMenus]				AS PCI
INNER JOIN	[Livedb].[dbo].[DMisUsers]						AS DMU		ON PCI.UserID=DMU.UserID AND Active='Y'

WHERE ApplicationID='PCI.ABH'

ORDER BY Menu