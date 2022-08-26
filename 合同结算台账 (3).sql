WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CLOS_STATUS_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONTRACT_ID," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CLOS_STATUS," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CY_STAT," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CLOS_STATUS_DESC," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CY_STAT_DESC," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","CONT_CLASS1_DESC," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CYDJS_DAT," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","HTJSID," ) }
'' as aa,
sum(CONTRACT_CNT) as CONTRACT_CNT,
sum(CONTRACT_MONEY_NOW) as CONTRACT_MONEY_NOW,
sum(CONTRACT_MONEY_NEW) as CONTRACT_MONEY_NEW,
sum(CONTRACT_SH_CNT) as CONTRACT_SH_CNT,
sum(CONTRACT_JS_CNT) as CONTRACT_JS_CNT,
sum(CONTRACT_JS_MONEY_NOW) as CONTRACT_JS_MONEY_NOW,
sum(CONTRACT_JS_PRICE) as CONTRACT_JS_PRICE,
sum(JS_HJ_MONEY) as JS_HJ_MONEY,
sum(SG_SB_MONEY) as SG_SB_MONEY
from F_COST_CONT_SETTLE_REPT main_tab
left join
(select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code) area_tab
on main_tab.AREA_CODE=area_tab.AREA_ORG_CODE
left join 
(select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code) city_tab
on main_tab.CITY_CODE=city_tab.CITY_ORG_CODE
left join 
(select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code ) proj_tab
on main_tab.PROJECT_NO=proj_tab.PROJ_CODE
left join
(select distinct sap_dept_id from user_org where ORG_TYPE='合同一级分类') cat_tab
on main_tab.CONT_CLASS1=cat_tab.sap_dept_id
where 1=1 
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(proj_tab.PROJ_CODE,'')!=''
and ifnull(cat_tab.sap_dept_id,'')!=''
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJECT_NO in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_NO + "')")}
${if(len(LIFNR_NAME) == 0,"","and LIFNR_NAME in ('" + LIFNR_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_STATUS) == 0,"","and CLOS_STATUS in ('" + CLOS_STATUS + "')")}
${if(len(CY_STAT) == 0,"","and CY_STAT in ('" + CY_STAT + "')")}
${if(len(CYDJS_DAT1) == 0,"","and CYDJS_DAT >='" + CYDJS_DAT1 + "'")}
${if(len(CYDJS_DAT2) == 0,"","and CYDJS_DAT <='" + CYDJS_DAT2 + "'")}
${if(len(CONT_CLASS1) == 0,"","and CONT_CLASS1 in ('" + CONT_CLASS1 + "')")}
${if(len(CONTRACT_ID) == 0,"","and CONTRACT_ID in ('" + CONTRACT_ID + "')")}
${if(len(HTJSID) == 0,"","and HTJSID in ('" + HTJSID + "')")}
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CLOS_STATUS_DESC," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","LIFNR_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONTRACT_ID," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CLOS_STATUS," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CY_STAT," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CLOS_STATUS_DESC," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CY_STAT_DESC," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","CONT_CLASS1_DESC," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CYDJS_DAT," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","HTJSID," ) }
aa

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT distinct
	AREA_NAME,AREA_CODE
FROM F_COST_CONT_SETTLE_REPT
where area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
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
distinct	city_name,city_CODE
FROM F_COST_CONT_SETTLE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
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
distinct	PROJ_NAME,PROJECT_NO
FROM F_COST_CONT_SETTLE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
and PROJECT_NO in(
select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)

SELECT 
distinct	STAGE_NAME
FROM F_COST_CONT_SETTLE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and city_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_CONT_SETTLE_REPT

select distinct
CONT_ARCH_ID
from f_cost_cont_settle_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select distinct
CONT_NAME
from f_cost_cont_settle_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select distinct
LIFNR_NAME
from f_cost_cont_settle_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and city_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}

select distinct
CONTRACT_ID
from f_cost_cont_settle_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}


WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct CONT_CLASS1,CONT_CLASS1_DESC from f_cost_cont_settle_rept main_tab
left join
(select sap_DEPT_ID from user_org where ORG_TYPE='合同一级分类' ) cat_tab
on main_tab.CONT_CLASS1=cat_tab.sap_DEPT_ID
where 1=1 
and ifnull(cat_tab.sap_DEPT_ID,'')!=''


select distinct 
CY_STAT,
case when CY_STAT_DESC = '00 ' then '草稿' else CY_STAT_DESC end CY_STAT_DESC,
CLOS_STATUS,
 CLOS_STATUS_DESC
from f_cost_cont_settle_rept

select distinct  HTJSID from F_COST_CONT_SETTLE_REPT

