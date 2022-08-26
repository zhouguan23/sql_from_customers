WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","NODE_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","PROC_PLAN_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","ITEM_NO," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

'' as aa,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(OBJECT_CN) as OBJECT_CN,
count(1) as rowCN

FROM 
(select * from f_po_proc_plan where 1=1
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in 
(select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)
 and CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
 )a
where 1=1 
${if(len(PL_EDATE1) == 0,"","and PL_EDATE >= '" + PL_EDATE1 + "'")}
${if(len(PL_EDATE2) == 0,"","and PL_EDATE <= '" + PL_EDATE2 + "'")}
${if(len(AC_EDATE1) == 0,"","and AC_EDATE >= '" + AC_EDATE1 + "'")}
${if(len(AC_EDATE2) == 0,"","and AC_EDATE <= '" + AC_EDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
 
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
 
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(PROC_CATEGORY_NAME) == 0,"","and PROC_CATEGORY_NAME in ('" + PROC_CATEGORY_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(STAT) == 0,"","and STAT_DESC in ('" + STAT + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(PROC_ITEM_DESC) == 0,"","and PROC_ITEM_DESC like '%" + PROC_ITEM_DESC + "%'")}
${if(len(NODE_STAT_DESC) == 0,"","and NODE_STAT_DESC in ('" + NODE_STAT_DESC + "')")}
${if(len(PROC_PLAN_NO) == 0,"","and PROC_PLAN_NO in ('" + PROC_PLAN_NO + "')")}
${if(len(ITEM_NO) == 0,"","and ITEM_NO in ('" + ITEM_NO + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","NODE_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","PROC_PLAN_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","ITEM_NO," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
2


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
TEMP_AREA AS(
SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
from f_po_proc_plan
)
SELECT AREA_ORG_NAME,AREA_ORG_CODE FROM TEMP_AREA
where 1=1
and  area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a
)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct CITY_ORG_NAME,CITY_ORG_CODE
from f_po_proc_plan
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
and  CITY_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a
)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJ_NAME
from f_po_proc_plan
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in(select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
and PROJ_CODE in 
(select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)

SELECT 
distinct	STAGE_NAME
from f_po_proc_plan
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST

select distinct  ENTITY_ORG_NAME from f_po_proc_plan

select distinct  PROC_CATEGORY_NAME from f_po_proc_plan

select distinct  SUP_TYPE,SUP_TYPE_NAME from f_po_proc_plan
order by SUP_TYPE

select distinct  PROC_MODE_NAME,PROC_MODE from f_po_proc_plan

select distinct  PROC_WAY_NAME from f_po_proc_plan

select distinct  STAT_DESC from f_po_proc_plan

select distinct  PROC_ITEM_NAME from f_po_proc_plan

SELECT 

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

'' as aa,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(OBJECT_CN) as OBJECT_CN,
count(1) as rowCN

FROM f_po_proc_plan
where 1=1 
${if(len(PL_EDATE1) == 0,"","and PL_EDATE >= '" + PL_EDATE1 + "'")}
${if(len(PL_EDATE2) == 0,"","and PL_EDATE <= '" + PL_EDATE2 + "'")}
${if(len(AC_EDATE1) == 0,"","and AC_EDATE >= '" + AC_EDATE1 + "'")}
${if(len(AC_EDATE2) == 0,"","and AC_EDATE <= '" + AC_EDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(PROC_CATEGORY_NAME) == 0,"","and PROC_CATEGORY_NAME in ('" + PROC_CATEGORY_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(STAT) == 0,"","and STAT_DESC in ('" + STAT + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
2

WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct CATEGORY_DESC FROM f_po_proc_plan
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='立项分类'
)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","NODE_STAT_DESC," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

'' as aa,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(OBJECT_CN) as OBJECT_CN,
count(1) as rowCN

FROM 
(select * from f_po_proc_plan where 1=1
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in 
(select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)
 and CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
 )a
where 1=1 
${if(len(PL_EDATE1) == 0,"","and PL_EDATE >= '" + PL_EDATE1 + "'")}
${if(len(PL_EDATE2) == 0,"","and PL_EDATE <= '" + PL_EDATE2 + "'")}
${if(len(AC_EDATE1) == 0,"","and AC_EDATE >= '" + AC_EDATE1 + "'")}
${if(len(AC_EDATE2) == 0,"","and AC_EDATE <= '" + AC_EDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
 
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
 
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(PROC_CATEGORY_NAME) == 0,"","and PROC_CATEGORY_NAME in ('" + PROC_CATEGORY_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(STAT) == 0,"","and STAT_DESC in ('" + STAT + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(PROC_ITEM_DESC) == 0,"","and PROC_ITEM_DESC like '%" + PROC_ITEM_DESC + "%'")}
${if(len(NODE_STAT_DESC) == 0,"","and NODE_STAT_DESC in ('" + NODE_STAT_DESC + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OBJECT_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","NODE_STAT_DESC," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
2

select distinct NODE_STAT_DESC from f_po_proc_plan

select distinct PROC_PLAN_NO,ITEM_NO from f_po_proc_plan order by PROC_PLAN_NO,ITEM_NO asc

