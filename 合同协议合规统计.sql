WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),T0 AS (
select DISTINCT
area_org_code,
area_org_name,
city_org_code,
city_org_name,
proj_name,
proj_code,
stage_name,
stage_code,
CONT_CLASS1,
SETBID_NO,
t1.contract_no,
t2.contract_no exp
from 
f_po_cont_det t1 left join f_po_cont_det_exp t2 on t1.contract_no = t2.contract_no
WHERE STAT IN (01,05,06,07,08,13)
AND CONT_TYPE IN (01,05)
AND CONT_KIND='03'
and PROC_MODE = '04'
and CONT_CLASS1 in (0302,0303)
and proj_code in (select sap_dept_id from user_org where dept_level = 3)
${if(len(sdate)=0,"","and left(create_time,8)>='"+sdate+"'")}
${if(len(edate)=0,"","and left(create_time,8)<='"+edate+"'")}
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}
and period_wid =  DATE_FORMAT(date_add(curdate(), interval -1 day),"%Y-%m")

union 
select DISTINCT
area_org_code,
area_org_name,
city_org_code,
city_org_name,
proj_name,
proj_code,
stage_name,
stage_code,
CONT_CLASS1,
SETBID_NO,
t1.contract_no,
t2.contract_no exp
from 
f_po_cont_det t1 left join f_po_cont_det_exp t2 on t1.contract_no = t2.contract_no
WHERE 
STAT IN (01,05,06,07,08,13)
AND CONT_KIND IN (01,02)
and CONT_CLASS1 in (0302,0303)
and proj_code in (select sap_dept_id from user_org where dept_level = 3)
${if(len(sdate)=0,"","and left(create_time,8)>='"+sdate+"'")}
${if(len(edate)=0,"","and left(create_time,8)<='"+edate+"'")}
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}
and period_wid =  DATE_FORMAT(date_add(curdate(), interval -1 day),"%Y-%m")
),
T1 as (
select DISTINCT
area_org_code,
area_org_name,
city_org_code,
city_org_name,
proj_name,
proj_code,
stage_name,
stage_code
from 
f_po_cont_det
WHERE STAT IN (01,05,06,07,08,13)
AND CONT_TYPE IN (01,05)
AND CONT_KIND='03'
and PROC_MODE = '04'
and CONT_CLASS1 in (0302,0303)
and proj_code in (select sap_dept_id from user_org where dept_level = 3)
${if(len(sdate)=0,"","and left(create_time,8)>='"+sdate+"'")}
${if(len(edate)=0,"","and left(create_time,8)<='"+edate+"'")}
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}
and period_wid =  DATE_FORMAT(date_add(curdate(), interval -1 day),"%Y-%m")

union 
select DISTINCT
area_org_code,
area_org_name,
city_org_code,
city_org_name,
proj_name,
proj_code,
stage_name,
stage_code
from 
f_po_cont_det
WHERE 
STAT IN (01,05,06,07,08,13)
AND CONT_KIND IN (01,02)
and CONT_CLASS1 in (0302,0303)
and proj_code in (select sap_dept_id from user_org where dept_level = 3)
${if(len(sdate)=0,"","and left(create_time,8)>='"+sdate+"'")}
${if(len(edate)=0,"","and left(create_time,8)<='"+edate+"'")}
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_NAME + "')")}
and period_wid =  DATE_FORMAT(date_add(curdate(), interval -1 day),"%Y-%m")
)


select
T1.area_org_code,
T1.area_org_name,
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","T1.city_org_name,T1.city_org_code,")} 
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","T1.proj_name,T1.proj_code,")} 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","T1.stage_name,T1.stage_code,")} 
'a' as a,
count(case when (SETBID_NO is not null AND SETBID_NO <>'' or exp is not null) and CONT_CLASS1 = '0302' then contract_no else null end) HGSG,
count(case when (SETBID_NO is not null AND SETBID_NO <>'' or exp is not null) and CONT_CLASS1 = '0303' then  contract_no else null end) HGXM,
count(case when CONT_CLASS1 = '0302' then  contract_no else null end) SG,
count(case when CONT_CLASS1 = '0303' then  contract_no else null end) XM
from t1 left join t0 on t1.stage_code =t0.stage_code and t1.proj_code =t0.proj_code

group by 
area_org_code,
area_org_name,
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","city_org_name,city_org_code," ) } 
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","T1.proj_name,T1.proj_code,")} 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","T1.stage_name,T1.stage_code,")}
a


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct AREA_ORG_NAME,AREA_ORG_CODE
FROM f_po_cont_det
where 1=1
and city_org_code in (select distinct sap_dept_id from user_org)

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
FROM f_po_cont_det
where 1=1
${if(len(AREA_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_NAME + "')")}
and city_org_code in (select distinct sap_dept_id from user_org)


select max(W_INSERT_DT) from f_po_cont_det

