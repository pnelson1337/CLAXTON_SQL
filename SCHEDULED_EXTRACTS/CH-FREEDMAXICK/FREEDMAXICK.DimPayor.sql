SET NOCOUNT ON;
SELECT

InsuranceID									AS 'InsuranceMnemonic'
,Name										AS 'InsuranceName'
,InsuranceGroupID							AS 'InsuranceGroup'
,ClaimGroup									AS 'ClaimGroup'
,GlComponent								AS 'GlComponent'
,''											AS 'DSHCapCategory'
,''											AS 'Year'

FROM [CH_MTLIVE].[dbo].[DMisInsurance]

WHERE Active='Y'

