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
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","ZGFZD," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","ZZFLD," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","ZGFZD_CLASS_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

'' as aa,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(SETBID_PRICE) as SETBID_PRICE,
AVG(SETBID_DOWN_RATE) as SETBID_DOWN_RATE

FROM 
(select * from f_po_setbid where 1=1 
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
 and CATEGORY in (select sap_dept_id from user_org where ORG_TYPE='立项分类')
 )a
where 1=1 
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(CATEGORY_NAME) == 0,"","and CATEGORY_NAME in ('" + CATEGORY_NAME + "')")}
${if(len(ZGFZD) == 0,"","and ZGFZD in ('" + ZGFZD + "')")}
${if(len(ZZFLD) == 0,"","and ZZFLD in ('" + ZZFLD + "')")}
${if(len(ZGFZD_CLASS) == 0,"","and ZGFZD_CLASS_DESC in ('" + ZGFZD_CLASS + "')")}
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","ZGFZD," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","ZZFLD," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","ZGFZD_CLASS_DESC," ) }
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
)
SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
from f_po_setbid
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)








WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct CITY_ORG_NAME,CITY_ORG_CODE
from f_po_setbid
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
SELECT distinct PROJ_NAME
from f_po_setbid
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
from f_po_supplier_object
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST

select distinct SUP_TYPE_NAME,SUP_TYPE
from f_po_supplier_object
order by SUP_TYPE

SELECT distinct PROC_WAY_NAME
FROM f_po_supplier_object

select distinct PROC_MODE_NAME
from f_po_supplier_object


select distinct OBJECT_NAME
from f_po_supplier_object

SELECT distinct ENTITY_ORG_NAME	
FROM f_po_setbid

SELECT 

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }

'' as aa,
sum(LIMIT_MONEY) as LIMIT_MONEY,
sum(SETBID_PRICE) as SETBID_PRICE,
AVG(SETBID_DOWN_RATE) as SETBID_DOWN_RATE

FROM f_po_setbid
where 1=1 
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }

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
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }

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
select distinct CATEGORY_NAME FROM f_po_setbid
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='立项分类' )


select distinct ZGFZD_CLASS_DESC from  f_po_setbid
where 1=1
${if(len(ZGFZD) == 0,"","and ZGFZD in ('" + ZGFZD + "')")}

select 'Y' AS ID,'是' AS NAME
UNION
select 'N' AS ID,'否' AS NAME


