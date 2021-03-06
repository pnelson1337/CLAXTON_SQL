SELECT
DOEPROC.ProcedureMnemonic
,DOEPROC.CategoryID
,ISNULL(DOEPROC.ProcedureID,'')									AS 'ProcedureID'
,DOEPROC.Name													AS 'Description'
,ISNULL(DOEPROCCD.BillProcNumber,'')							AS 'CHMC # (Billing Procedure)'

,CASE WHEN DOEPROC.ProcedureID != DOEPROCCD.BillProcNumber
		THEN 'DO NOT MATCH'
		WHEN DOEPROCCD.BillProcNumber IS NULL
		THEN 'DO NOT MATCH'		ELSE 'MATCH'	END				AS 'Procedure & CHMC # Matching?'

,CASE WHEN DBARPROC.ProcedureID IS NULL 
		THEN 'NO'
		ELSE 'YES' END											AS 'Active in BAR (Y/N)?'


  FROM		[Livedb].[dbo].[DOeProcs]							AS DOEPROC
  LEFT JOIN	[Livedb].[dbo].[DOeProcCampusDestinations]			AS DOEPROCCD			ON DOEPROC.ProcedureID=DOEPROCCD.ProcedureID		AND DOEPROC.CategoryID=DOEPROCCD.CategoryID		
  LEFT JOIN	[Livedb].[dbo].[DBarProcedures]						AS DBARPROC				ON DOEPROCCD.BillProcNumber=DBARPROC.ProcedureID	AND DBARPROC.Active='Y'

  WHERE DOEPROC.CategoryID IN ('OTC','PTC','STC')
  AND DOEPROC.Active='Y'

  ORDER BY DOEPROC.CategoryID,DOEPROC.ProcedureID