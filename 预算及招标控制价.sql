WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) } 

${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","BILL_TYPE_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CORE_CTR_FLAG," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","STRATEGIC_FLAG," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","ENGINE_NAME," ) }

sum(LIMIT_CN) as LIMIT_CN,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(APPROVAL_LIMIT_CN) as APPROVAL_LIMIT_CN,
sum(APPROVAL_LIMIT_MONEY) as APPROVAL_LIMIT_MONEY,

'' as aa
FROM f_cost_price 
where 1=1 
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}


${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(BILL_TYPE_NAME) == 0,"","and BILL_TYPE_NAME in ('" + BILL_TYPE_NAME + "')")}
${if(len(CORE_CTR_FLAG) == 0,"","and CORE_CTR_FLAG in ('" + CORE_CTR_FLAG + "')")}
${if(len(STRATEGIC_FLAG) == 0,"","and STRATEGIC_FLAG in ('" + STRATEGIC_FLAG + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","BILL_TYPE_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CORE_CTR_FLAG," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","STRATEGIC_FLAG," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","ENGINE_NAME," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
2

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
FROM DIM_PROJECT -- F_COST_DYNCOST
where area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
order by AREA_ORG_CODE

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT 
distinct CITY_ORG_NAME
FROM F_COST_DYNCOST
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT 
distinct	PROJ_NAME
FROM F_COST_DYNCOST
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)

SELECT 
distinct	STAGE_NAME
FROM F_COST_DYNCOST
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST

select distinct BILL_TYPE_NAME from f_cost_price

