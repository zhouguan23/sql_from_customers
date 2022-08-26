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
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT,
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT,
sum(DC_DIFF_AMT) as DC_DIFF_AMT,
sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)*100  as DIFF_RATE,
aa
from
(
select AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT,
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT,
sum(DC_DIFF_AMT) as DC_DIFF_AMT,
sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)*100  as DIFF_RATE,
'' as aa
FROM f_cost_dyncost
where 1=1 
and PRODTYPE_COMP_DES is not null 
and ftsx='N'  and ACC_CODE='5001'
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(PeriodOfValidity == '1',"","and DC_OBJ_COST_ZERO_FLAG='Y'")}
#分期的汇总目标成本为0时，标识N，否则Y
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
group by AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,aa

)maintab
where 1=1 
 and ifnull(DC_DIFF_AMT,0)<0  
    ${if(len(DC_DIFF_RATE_AMT1) == 0,"","and DIFF_RATE>'" + DC_DIFF_RATE_AMT1 + "'")}
    ${if(len(DC_DIFF_RATE_AMT2) == 0,"","and DIFF_RATE<'" + DC_DIFF_RATE_AMT2 + "'")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
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
	AREA_ORG_NAME,AREA_ORG_CODE
FROM DIM_PROJECT
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
distinct CITY_ORG_NAME,CITY_ORG_CODE
FROM F_COST_DYNCOST
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
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
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
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
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST

SELECT 
distinct	CONCAT(ACC_CODE,CONCAT(' ',ACC_NAME)) as ACC_NAME,ACC_CODE
FROM F_COST_DYNCOST
where 1=1
${if(len(ZLEVEL) == 0,"","and ZLEVEL <=" + ZLEVEL)}

SELECT 
distinct	PRODTYPE_COMP_DES
FROM F_COST_DYNCOST
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

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
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT,
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT,
sum(DC_DIFF_AMT) as DC_DIFF_AMT,
sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)  as DIFF_RATE,
aa
from
(
select AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT,
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT,
sum(DC_DIFF_AMT) as DC_DIFF_AMT,
sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)  as DIFF_RATE,
'' as aa
FROM f_cost_dyncost
where 1=1 
and PRODTYPE_COMP_DES is not null 
and ftsx='N'  and ACC_CODE='5001'
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
group by AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,aa
)maintab
where 1=1 
 and ifnull(DC_DIFF_AMT,0)<0  
 ${if(PeriodOfValidity == '1',"","and DC_OBJ_COST_AMT>0")}
    ${if(len(DC_DIFF_RATE_AMT1) == 0,"","and DIFF_RATE>'" + DC_DIFF_RATE_AMT1 + "'")}
    ${if(len(DC_DIFF_RATE_AMT2) == 0,"","and DIFF_RATE<'" + DC_DIFF_RATE_AMT2 + "'")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
aa

