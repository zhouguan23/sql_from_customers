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
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","OBJECT_PROC_WAY_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }

aa,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(PROVISIONAL_SUM) as PROVISIONAL_SUM,
sum(SIGN_CN) as SIGN_CN,
sum(SIGN_MONEY) as SIGN_MONEY
FROM 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","case when PROC_WAY='0104' and ifnull(SIGN_FLAG,'')='Y' then VENDOR_NAME
     when PROC_WAY!='0104' and ifnull(SETBID_FLAG,'')='Y' then VENDOR_NAME else null end as VENDOR_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","OBJECT_PROC_WAY_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }

LIMIT_MONEY,
PL_DAYS,
AC_DAYS,
SETBID_PRICE,
PROVISIONAL_SUM,
SETBID_DOWN_RATE,
case when SIGN_FLAG='Y' then 1 else null end as SIGN_CN,
SIGN_MONEY,
'' as aa
from 
(select main_tab.* from f_po_bidfile main_tab
left join 
( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
 left join 
( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a) city_tab
 on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
  left join 
( select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a) proj_tab 
  on main_tab.PROJ_CODE=proj_tab.PROJ_CODE
  left join 
	(select distinct sap_dept_id from user_org where ORG_TYPE='立项分类' ) cat_tab
	on main_tab.CATEGORY=cat_tab.sap_dept_id
where 1=1 
  and ifnull(area_tab.AREA_ORG_CODE,'')!=''
  and ifnull(city_tab.CITY_ORG_CODE,'')!=''
	and ifnull(proj_tab.PROJ_CODE,'')!=''
  and ifnull(cat_tab.sap_dept_id,'')!=''
	and ifnull(SETBID_STAT,'01') in(select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
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
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(OBJECT_PROC_WAY_NAME) == 0,"","and OBJECT_PROC_WAY_NAME in ('" + OBJECT_PROC_WAY_NAME + "')")}
${if(len(STAT) == 0,"","and STAT_DESC in ('" + STAT + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(EVALUATION_BID_METHOD_NAME) == 0,"","and EVALUATION_BID_METHOD_NAME in ('" + EVALUATION_BID_METHOD_NAME + "')")}
${if(len(CATEGORY_NAME) == 0,"","and CATEGORY_NAME in ('" + CATEGORY_NAME +"')")}
)a
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","OBJECT_PROC_WAY_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }
aa
order by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
aa

WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
TEMP_AREA AS(
SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
from DIM_PROJECT -- f_po_bidfile
)
SELECT
AREA_ORG_NAME,AREA_ORG_CODE
FROM TEMP_AREA
where   AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
order by AREA_ORG_CODE




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
from f_po_bidfile
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
and  CITY_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)




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
from f_po_bidfile
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
and PROJ_CODE in 
(select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)


SELECT 
distinct	STAGE_NAME
from f_po_bidfile
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST

select distinct  ENTITY_ORG_NAME from f_po_object_setbid

select distinct SUP_TYPE, SUP_TYPE_NAME from f_po_bidfile 
order by SUP_TYPE

select distinct  PROC_MODE_NAME from f_po_bidfile

select distinct  PROC_WAY_NAME,OBJECT_PROC_WAY_NAME from f_po_bidfile


select distinct  VENDOR_NAME from f_po_bidfile

select distinct  OBJECT_NAME from f_po_bidfile
where 1=1
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
projn1,STAGE_NAME,
PROC_CATEGORY_NAME,
PROC_ITEM_NAME,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
PL_EDATE,
AC_EDATE,
STAT,
BID_NAME,
OBJECT_NO,
OBJECT_NAME,
EVALUATION_BID_METHOD_NAME,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
VENDOR_NAME,
aa,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(SETBID_PRICE) as SETBID_PRICE,
avg(SETBID_DOWN_RATE) as SETBID_DOWN_RATE,
sum(SIGN_CN) as SIGN_CN,
sum(SIGN_MONEY) as SIGN_MONEY
FROM 
(select distinct 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
PROJ_NAME as projn1,STAGE_NAME,
PROC_CATEGORY_NAME,
PROC_ITEM_NAME,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
PL_EDATE,
AC_EDATE,
STAT,
BID_NAME,
OBJECT_NO,
OBJECT_NAME,
EVALUATION_BID_METHOD_NAME,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
VENDOR_NAME,
LIMIT_MONEY,
PL_DAYS,
AC_DAYS,
SETBID_PRICE,
SETBID_DOWN_RATE,
case when SIGN_FLAG='Y' then 1 else null end as SIGN_CN,
SIGN_MONEY,
'' as aa
from f_po_bidfile
)a
where 1=1 and CITY_ORG_NAME='北京公司'
group by
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
projn1,STAGE_NAME,
PROC_CATEGORY_NAME,
PROC_ITEM_NAME,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
PL_EDATE,
AC_EDATE,
STAT,
BID_NAME,
OBJECT_NO,
OBJECT_NAME,
EVALUATION_BID_METHOD_NAME,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
VENDOR_NAME,
aa

-- 18120562.29



select distinct EVALUATION_BID_METHOD_NAME from f_po_bidfile

select distinct PROC_ITEM_NAME from f_po_bidfile

select distinct PROC_CATEGORY_NAME from f_po_bidfile

select distinct STAT_DESC from f_po_bidfile

select distinct 

OBJECT_NO,
OBJECT_NAME,
LIMIT_MONEY,
SETBID_PRICE,
SETBID_DOWN_RATE,
case when SIGN_FLAG='Y' then 1 else null end as SIGN_CN,
SIGN_MONEY,
'' as aa
from f_po_bidfile
where 1=1 and PROC_WAY_NAME !='其他'

SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
aa,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(SETBID_PRICE) as SETBID_PRICE,
avg(SETBID_DOWN_RATE) as SETBID_DOWN_RATE,
sum(SIGN_CN) as SIGN_CN,
sum(SIGN_MONEY) as SIGN_MONEY
FROM 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","case when ifnull(SETBID_FLAG,'')='Y' then VENDOR_NAME else null end as VENDOR_NAME," ) }
LIMIT_MONEY,
PL_DAYS,
AC_DAYS,
SETBID_PRICE,
SETBID_DOWN_RATE,
case when SIGN_FLAG='Y' then 1 else null end as SIGN_CN,
SIGN_MONEY,
'' as aa
from f_po_bidfile
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
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(EVALUATION_BID_METHOD_NAME) == 0,"","and EVALUATION_BID_METHOD_NAME in ('" + EVALUATION_BID_METHOD_NAME + "')")}
)a
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
aa



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
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","OBJECT_PROC_WAY_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }

aa,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(PL_DAYS) as PL_DAYS,
sum(AC_DAYS) as AC_DAYS,
sum(SETBID_PRICE) as SETBID_PRICE,
avg(SETBID_DOWN_RATE) as SETBID_DOWN_RATE,
sum(SIGN_CN) as SIGN_CN,
sum(SIGN_MONEY) as SIGN_MONEY
FROM 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","case when PROC_WAY='0104' and ifnull(SIGN_FLAG,'')='Y' then VENDOR_NAME
     when PROC_WAY!='0104' and ifnull(SETBID_FLAG,'')='Y' then VENDOR_NAME else null end as VENDOR_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","OBJECT_PROC_WAY_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }

LIMIT_MONEY,
PL_DAYS,
AC_DAYS,
SETBID_PRICE,
SETBID_DOWN_RATE,
case when SIGN_FLAG='Y' then 1 else null end as SIGN_CN,
SIGN_MONEY,
'' as aa
from f_po_bidfile
where 1=1
${if(len(PL_EDATE1) == 0,"","and PL_EDATE >= '" + PL_EDATE1 + "'")}
${if(len(PL_EDATE2) == 0,"","and PL_EDATE <= '" + PL_EDATE2 + "'")}
${if(len(AC_EDATE1) == 0,"","and AC_EDATE >= '" + AC_EDATE1 + "'")}
${if(len(AC_EDATE2) == 0,"","and AC_EDATE <= '" + AC_EDATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(PROC_CATEGORY_NAME) == 0,"","and PROC_CATEGORY_NAME in ('" + PROC_CATEGORY_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(OBJECT_PROC_WAY_NAME) == 0,"","and OBJECT_PROC_WAY_NAME in ('" + OBJECT_PROC_WAY_NAME + "')")}
${if(len(STAT) == 0,"","and STAT_DESC in ('" + STAT + "')")}
${if(len(PROC_ITEM_NAME) == 0,"","and PROC_ITEM_NAME in ('" + PROC_ITEM_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(EVALUATION_BID_METHOD_NAME) == 0,"","and EVALUATION_BID_METHOD_NAME in ('" + EVALUATION_BID_METHOD_NAME + "')")}
${if(len(CATEGORY_NAME) == 0,"and CATEGORY in (select DEPT_ID from fr_user_org where ORG_TYPE='立项分类' and USER_ID='" +fine_username+ "')","and CATEGORY_NAME in ('" + CATEGORY_NAME +"')")}
)a
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROC_CATEGORY_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PROC_ITEM_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PL_EDATE," ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","AC_EDATE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","STAT_DESC," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","OBJECT_PROC_WAY_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","PROC_ITEM_DESC," ) }
aa
order by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
aa

WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct CATEGORY_NAME FROM f_po_bidfile
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='立项分类' )

