
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
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
sum(subtab.LIMIT_MONEY) as LIMIT_MONEY, -- 招标控制价
sum(subtab.INVEN_CN) as INVEN_CN,
sum(subtab.SENDBID_CN) as SENDBID_CN,
sum(subtab2.OPENBID_CN) as OPENBID_CN,
sum(subtab3.SETBID_CN) as SETBID_CN,
sum(subtab.REPLYBID_CN) as REPLYBID_CN,
sum(subtab.SETOBJ_CN) as SETOBJ_CN, -- 招标立项数量
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
sum(PROVISIONAL_SUM) as PROVISIONAL_SUM,
sum(SETBID_VEN_CN) as SETBID_VEN_CN,
sum(REP_VEN_CN) as REP_VEN_CN,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
sum(SIGNCON_BID_CN) as SIGNCON_BID_CN
from 
(select distinct 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,""," EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","PROJ_CODE as proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
'' as aa,
sum(REPLYBID_CN) as REPLYBID_CN_MAC,
sum(case when PROC_WAY='0103'  then null else QUOTATION_MONEY end) as QUOTATION_MONEY,
sum(case when PROC_WAY='0103'  then null else PROVISIONAL_SUM end) as PROVISIONAL_SUM,
count(case when   PROC_WAY!='0103' and ifnull(SETBID_FLAG,'N')='Y' and SETBID_STAT='03' then 1  else null end ) as SETBID_VEN_CN,
count(case when   PROC_WAY!='0103' then 1  else null end ) as REP_VEN_CN,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
sum(MESG_CN) as MESG_CN
from (select * from f_po_object_setbid a 
where 1=1 and 
AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and  
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and 
CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
and ifnull(SETBID_STAT,'01') in (select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 )a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}
group by 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_CN," ) }
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
aa
)maintab

left join 
(
select 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","PROJ_CODE as proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as bb
,sum(SENDBID_CN) as SENDBID_CN
,sum(SETOBJ_CN) as SETOBJ_CN
,sum(INVEN_CN) as INVEN_CN
,sum(LIMIT_MONEY) as LIMIT_MONEY
,sum(REPLYBID_CN) as REPLYBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
case when SENDBID_FLAG='Y' and m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SENDBID_CN
, count(distinct object_no)  as SETOBJ_CN
, max(case when m.PROC_WAY='0103' then null else INVEN_CN end) as INVEN_CN
, sum(LIMIT_MONEY) as LIMIT_MONEY
, max(case when m.PROC_WAY='0103' then null else REPLYBID_CN end) as REPLYBID_CN  
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SENDBID_FLAG,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
-- ,count(distinct a.object_no) obj_cn  -- 发标数 -- 
count(distinct a.VENDOR_NO) as INVEN_CN -- 入围供应商数量\每立项
,max(a.LIMIT_MONEY) as LIMIT_MONEY -- 招标控制价\每标段
,sum(REPLYBID_CN) REPLYBID_CN    -- 供应商回标数量
from ( select * from f_po_object_setbid a 
where 1=1 and 
AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and CATEGORY in (
select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' 
) and 
ifnull(SETBID_STAT,'01') in(select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 )a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}
group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SENDBID_FLAG
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)m
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SENDBID_FLAG
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
bb
)as subtab
on 1=1
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","and maintab.PROJ_CODE=subtab.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","and maintab.proc1=subtab.proc2 and maintab.STAGE_CODE=subtab.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab.BID_NAME" ) }
-- ${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab.VENDOR_NAME" ) }
left join 
(
select 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","PROJ_CODE as proc3,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as cc
,sum(OPENBID_CN) as OPENBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,max(OPENBID_CN) as OPENBID_CN
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,case when ifnull(OPENBID_FLAG,'')='Y' and PROC_WAY!='0103' and SETBID_STAT='03' then count(distinct OBJECT_NO) else null end as OPENBID_CN
-- #已开标数量
from (select * from f_po_object_setbid a 
where 1=1 
and AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and  
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and 
CATEGORY in (
select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' 
) and 
ifnull(SETBID_STAT,'01') in(select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 )a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}
group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)m	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","proc3,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
cc
)as subtab2
on 1=1
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab2.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab2.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","and maintab.PROJ_CODE=subtab2.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","and maintab.proc1=subtab2.proc3 and maintab.STAGE_CODE=subtab2.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab2.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab2.BID_NAME" ) }
-- ${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab2.VENDOR_NAME" ) }
left join 
(
select 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","PROJ_CODE as proc4,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as dd
,sum(SETBID_CN) as SETBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,max(SETBID_CN) as SETBID_CN 
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,case when ifnull(SETBID_FLAG,'')='Y' and PROC_WAY!='0103'  and SETBID_STAT='03' then count(distinct OBJECT_NO) else null end as SETBID_CN
#立项定标数量
from 
(select * from f_po_object_setbid a 
where 1=1 and 
AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  
left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and 
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and 
CATEGORY in (
select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' 
) and 
ifnull(SETBID_STAT,'01') in(select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 )a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}
group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)m	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","proc4,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
dd
)as subtab3
on 1=1
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab3.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab3.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","and maintab.PROJ_CODE=subtab3.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","and maintab.proc1=subtab3.proc4 and maintab.STAGE_CODE=subtab3.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab3.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab3.BID_NAME" ) }
-- ${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab3.VENDOR_NAME" ) }
group by 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
maintab.aa
order by 
${ if(INARRAY("1", SPLIT(show_up, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show_up, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show_up, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show_up, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
maintab.aa

WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='huafa'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
from DIM_PROJECT -- f_po_object_setbid
where 1=1
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 order by AREA_ORG_CODE


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
distinct CITY_ORG_NAME,CITY_ORG_CODE
from f_po_object_setbid
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
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJ_NAME
from f_po_object_setbid
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,
"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
and PROJ_CODE in 
(select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE
union
 select distinct a.sap_dept_id from user_org a)


SELECT 
distinct	STAGE_NAME
from f_po_object_setbid
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST

select distinct  ENTITY_ORG_NAME from f_po_object_setbid

select distinct  SUP_TYPE,SUP_TYPE_NAME from f_po_object_setbid order by SUP_TYPE

select distinct  PROC_MODE_NAME from f_po_object_setbid

select distinct  PROC_WAY_NAME from f_po_object_setbid

select distinct  VENDOR_NAME from f_po_object_setbid

select distinct  OBJECT_NAME from f_po_object_setbid


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
sum(subtab.LIMIT_MONEY) as LIMIT_MONEY,
sum(subtab.INVEN_CN) as INVEN_CN,
sum(subtab.SENDBID_CN) as SENDBID_CN,
sum(subtab.SETOBJ_CN) as SETOBJ_CN,
sum(subtab.REPLYBID_CN) as REPLYBID_CN,
sum(maintab.REPLYBID_CN_MAC) as REPLYBID_CN_MAC,
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
sum(PROVISIONAL_SUM) as PROVISIONAL_SUM,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(SETBID_DOWN)/sum(SETBID_DOWN_RATE) as SETBID_DOWN_RATE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
sum(GETBID_VEN_CN) as GETBID_VEN_CN,
sum(SENDBID_VEN_CN) as SENDBID_VEN_CN,
sum(SIGNCON_BID_CN) as SIGNCON_BID_CN,
sum(subtab.REPLYBID_CN)/sum(subtab.INVEN_CN) as REPLYBID_RATE,
sum(SETBID_CN)/sum(subtab.REPLYBID_CN) as GETREPLYBID_RATE,
sum(SETBID_CN)/sum(SETBID_RATE) as SETBID_RATE,
sum(SETBID_CN) as SETBID_CN,
sum(MESG_CN)/sum(subtab.REPLYBID_CN) as MESG_RATE,
sum(SIGNCON_CN) as SIGNCON_CN
from 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,""," EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
'' as aa,
sum(REPLYBID_CN) as REPLYBID_CN_MAC,
sum(case when PROC_WAY='0103'  then null else QUOTATION_MONEY end) as QUOTATION_MONEY,
sum(case when PROC_WAY='0103'  then null else PROVISIONAL_SUM end) as PROVISIONAL_SUM,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(case when ifnull(SETBID_FLAG,'N')='Y' and SETBID_STAT='03' then SETBID_DOWN_RATE else null end) as SETBID_DOWN,
count(case when ifnull(SETBID_FLAG,'N')='Y' and SETBID_STAT='03' then 1 else null end) as SETBID_DOWN_RATE,
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SETBID_FLAG,'N')='Y' and SETBID_STAT='03' then 1 else null end) as GETBID_VEN_CN,
count(case when ifnull(SETBID_APPROVAL_DATE,'00000000')!='00000000' then 1 else null end) as SENDBID_VEN_CN,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
count(case when ifnull(SUPPLIER_APPROVAL_DATE,'00000000')!='00000000' then 1 else 0 end)  as REPLYBID_RATE,
count(case when ifnull(OPENBID_FLAG,'N')='Y' and SETBID_STAT='03' then 1 else null end) as SETBID_RATE, 
count(case when ifnull(SETBID_FLAG,'N')='Y' and  SETBID_STAT='03' then 1 else null end) as SETBID_CN,
sum(MESG_CN) as MESG_CN,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_CN
from f_po_object_setbid
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_CN," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
aa
)maintab

left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as bb
,sum(SENDBID_CN) as SENDBID_CN
,sum(SETOBJ_CN) as SETOBJ_CN
,sum(INVEN_CN) as INVEN_CN
,sum(LIMIT_MONEY) as LIMIT_MONEY
,sum(REPLYBID_CN) as REPLYBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
case when SENDBID_FLAG='Y' and m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SENDBID_CN
,case when  m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SETOBJ_CN
, max(case when m.PROC_WAY='0103' then null else INVEN_CN end) as INVEN_CN
, sum(LIMIT_MONEY) as LIMIT_MONEY
, max(case when m.PROC_WAY='0103' then null else REPLYBID_CN end) as REPLYBID_CN  
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SENDBID_FLAG,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
      -- ,count(distinct a.object_no) obj_cn  -- 发标数 -- 
       count(distinct a.VENDOR_NO) as INVEN_CN -- 入围供应商数量\每立项
       ,max(a.LIMIT_MONEY) as LIMIT_MONEY -- 招标控制价\每标段
			 ,sum(REPLYBID_CN) REPLYBID_CN    -- 供应商回标数量
  from f_po_object_setbid a 
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
	,PROC_WAY,a.BID_NUM,SENDBID_FLAG
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SENDBID_FLAG
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
bb
)as subtab
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab.proc2 and maintab.STAGE_CODE=subtab.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab.VENDOR_NAME" ) }
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
maintab.aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
maintab.aa

select  maintab.*
,sum(subtab.LIMIT_MONEY) as LIMIT_MONEY
,sum(subtab2.obj_cn)/maintab.BID_CN as SENDBID_CN
from 
(select distinct 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
VENDOR_NAME,

'' as aa,
sum(REPLYBID_CN)/BID_CN as REPLYBID_CN,
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
avg(QUOTATION_DOWN_RATE) as QUOTATION_DOWN_RATE,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(case when ifnull(SETBID_FLAG,'N')='Y' then SETBID_DOWN_RATE else null end)/count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as SETBID_DOWN_RATE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as GETBID_VEN_CN,
count(case when ifnull(SETBID_APPROVAL_DATE,'00000000')!='00000000' then 1 else null end) as SENDBID_VEN_CN,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
sum(REPLYBID_CN)/count(case when ifnull(SUPPLIER_APPROVAL_DATE,'00000000')!='00000000' then 1 else 0 end)  as REPLYBID_RATE,
count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end)/sum(REPLYBID_CN)  as GETREPLYBID_RATE,
count(case when  ifnull(SETBID_FLAG,'N')='Y' then 1 else null end)/count(case when ifnull(OPENBID_FLAG,'N')='Y' then 1 else null end) as SETBID_RATE, 
count(case when  ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as SETBID_CN,
sum(MESG_CN)/count(OBJECT_NO) as MESG_RATE,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_CN
from f_po_object_setbid
where 1=1

group by 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
VENDOR_NAME,
aa
)maintab

left join 
(
select 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
LIMIT_MONEY,
'' as bb
from f_po_object_setbid 
where 1=1
group by 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
LIMIT_MONEY,bb
)as subtab
on 1=1
and maintab.AREA_ORG_NAME=subtab.AREA_ORG_NAME
and maintab.CITY_ORG_NAME=subtab.CITY_ORG_NAME
and maintab.PROJ_NAME=subtab.PROJ_NAME
and maintab.PROJ_NAME=subtab.PROJ_NAME and maintab.STAGE_NAME=subtab.STAGE_NAME
and maintab.OBJECT_NAME=subtab.OBJECT_NAME
and maintab.SUP_TYPE_NAME=subtab.SUP_TYPE_NAME
and maintab.PROC_MODE_NAME=subtab.PROC_MODE_NAME
and maintab.PROC_WAY_NAME=subtab.PROC_WAY_NAME
and maintab.EVALUATION_BID_METHOD_NAME=subtab.EVALUATION_BID_METHOD_NAME
and maintab.BID_NAME=subtab.BID_NAME
and maintab.OPENBID_FLAG=subtab.OPENBID_FLAG
and maintab.SETBID_FLAG=subtab.SETBID_FLAG

left join 
(
select *,count(1) as obj_cn 
from
(
select distinct
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
PROJ_NAME as projn3,STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
'' as cc
from f_po_object_setbid 
where 1=1

group by 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
projn3,STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
cc
)a
group by 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
projn3,STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
cc
)as subtab2
on 1=1
and maintab.AREA_ORG_NAME=subtab2.AREA_ORG_NAME
and maintab.CITY_ORG_NAME=subtab2.CITY_ORG_NAME
and maintab.PROJ_NAME=subtab2.PROJ_NAME
and maintab.PROJ_NAME=subtab2.PROJ_NAME and maintab.STAGE_NAME=subtab2.STAGE_NAME
and maintab.OBJECT_NAME=subtab2.OBJECT_NAME
and maintab.SUP_TYPE_NAME=subtab2.SUP_TYPE_NAME
and maintab.PROC_MODE_NAME=subtab2.PROC_MODE_NAME
and maintab.PROC_WAY_NAME=subtab2.PROC_WAY_NAME
and maintab.EVALUATION_BID_METHOD_NAME=subtab2.EVALUATION_BID_METHOD_NAME

group by 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
VENDOR_NAME,
maintab.aa

select  maintab.*

from 
(select distinct 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
VENDOR_NAME,

'' as aa,
sum(REPLYBID_CN)/BID_CN as REPLYBID_CN,
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
avg(QUOTATION_DOWN_RATE) as QUOTATION_DOWN_RATE,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(case when ifnull(SETBID_FLAG,'N')='Y' then SETBID_DOWN_RATE else null end)/count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as SETBID_DOWN_RATE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as GETBID_VEN_CN,
count(case when ifnull(SETBID_APPROVAL_DATE,'00000000')!='00000000' then 1 else null end) as SENDBID_VEN_CN,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
sum(REPLYBID_CN)/count(case when ifnull(SUPPLIER_APPROVAL_DATE,'00000000')!='00000000' then 1 else 0 end)  as REPLYBID_RATE,
count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end)/sum(REPLYBID_CN)  as GETREPLYBID_RATE,
count(case when  ifnull(SETBID_FLAG,'N')='Y' then 1 else null end)/count(case when ifnull(OPENBID_FLAG,'N')='Y' then 1 else null end) as SETBID_RATE, 
count(case when  ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as SETBID_CN,
sum(MESG_CN)/count(OBJECT_NO) as MESG_RATE,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_CN
from f_po_object_setbid
where 1=1

group by 
AREA_ORG_NAME,
CITY_ORG_NAME,
PROJ_NAME,
STAGE_NAME,
OBJECT_NAME,
OBJECT_NO,
SUP_TYPE_NAME,
PROC_MODE_NAME,
PROC_WAY_NAME,
EVALUATION_BID_METHOD_NAME,
BID_NAME,
BID_CN,
OBJECT_APPROVAL_DATE,
SUPPLIER_APPROVAL_DATE,
OPENBID_FLAG,
SETBID_FLAG,
SETBID_APPROVAL_DATE,
VENDOR_NAME,
aa
)maintab

select  maintab.*
,sum(subtab.LIMIT_MONEY) as LIMIT_MONEY
,sum(subtab2.obj_cn)/${ if(INARRAY("10", SPLIT(show, ",")) = 0,"1","BID_CN" ) } as SENDBID_CN
from 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_CN," ) }
'' as aa,
sum(REPLYBID_CN)/${ if(INARRAY("10", SPLIT(show, ",")) = 0,"1","BID_CN" ) } as REPLYBID_CN,
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
avg(QUOTATION_DOWN_RATE) as QUOTATION_DOWN_RATE,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(case when ifnull(SETBID_FLAG,'N')='Y' then SETBID_DOWN_RATE else null end)/count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as SETBID_DOWN_RATE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as GETBID_VEN_CN,
count(case when ifnull(SETBID_APPROVAL_DATE,'00000000')!='00000000' then 1 else null end) as SENDBID_VEN_CN,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
sum(REPLYBID_CN)/count(case when ifnull(SUPPLIER_APPROVAL_DATE,'00000000')!='00000000' then 1 else 0 end)  as REPLYBID_RATE,
count(case when ifnull(SETBID_FLAG,'N')='Y' then 1 else null end)/sum(REPLYBID_CN)  as GETREPLYBID_RATE,
count(case when  ifnull(SETBID_FLAG,'N')='Y' then 1 else null end)/count(case when ifnull(OPENBID_FLAG,'N')='Y' then 1 else null end) as SETBID_RATE, 
count(case when  ifnull(SETBID_FLAG,'N')='Y' then 1 else null end) as SETBID_CN,
sum(MESG_CN)/count(OBJECT_NO) as MESG_RATE,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_CN
from f_po_object_setbid
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_CN," ) }
aa
)maintab

left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn2,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
LIMIT_MONEY,
'' as bb
from f_po_object_setbid 
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn2,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
LIMIT_MONEY,bb
)as subtab
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_NAME=subtab.AREA_ORG_NAME" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_NAME=subtab.CITY_ORG_NAME" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_NAME=subtab.PROJ_NAME" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.PROJ_NAME=subtab.PROJ_NAME and maintab.STAGE_NAME=subtab.STAGE_NAME" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NAME=subtab.OBJECT_NAME" ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","and maintab.SUP_TYPE_NAME=subtab.SUP_TYPE_NAME" ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","and maintab.PROC_MODE_NAME=subtab.PROC_MODE_NAME" ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","and maintab.PROC_WAY_NAME=subtab.PROC_WAY_NAME" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","and maintab.EVALUATION_BID_METHOD_NAME=subtab.EVALUATION_BID_METHOD_NAME" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab.BID_NAME" ) }

${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","and maintab.OPENBID_FLAG=subtab.OPENBID_FLAG" ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","and maintab.SETBID_FLAG=subtab.SETBID_FLAG" ) }

left join 
(
select *,count(1) as obj_cn 
from
(
select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn3,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
'' as cc
from f_po_object_setbid 
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn3,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
cc
)a
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn3,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
cc
)as subtab2
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_NAME=subtab2.AREA_ORG_NAME" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_NAME=subtab2.CITY_ORG_NAME" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_NAME=subtab2.PROJ_NAME" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.PROJ_NAME=subtab2.PROJ_NAME and maintab.STAGE_NAME=subtab2.STAGE_NAME" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NAME=subtab2.OBJECT_NAME" ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","and maintab.SUP_TYPE_NAME=subtab2.SUP_TYPE_NAME" ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","and maintab.PROC_MODE_NAME=subtab2.PROC_MODE_NAME" ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","and maintab.PROC_WAY_NAME=subtab2.PROC_WAY_NAME" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","and maintab.EVALUATION_BID_METHOD_NAME=subtab2.EVALUATION_BID_METHOD_NAME" ) }


group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_CN," ) }
maintab.aa


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
sum(subtab.LIMIT_MONEY) as LIMIT_MONEY,
sum(subtab.INVEN_CN) as INVEN_CN,
sum(subtab.SENDBID_CN) as SENDBID_CN,
sum(subtab2.OPENBID_CN) as OPENBID_CN,
sum(subtab3.SETBID_CN) as SETBID_CN,
sum(subtab.REPLYBID_CN) as REPLYBID_CN,
sum(subtab.SETOBJ_CN) as SETOBJ_CN,
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
sum(PROVISIONAL_SUM) as PROVISIONAL_SUM,
sum(SETBID_VEN_CN) as SETBID_VEN_CN,
sum(REP_VEN_CN) as REP_VEN_CN,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
sum(SIGNCON_BID_CN) as SIGNCON_BID_CN
from 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,""," EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
'' as aa,
sum(REPLYBID_CN) as REPLYBID_CN_MAC,
sum(case when PROC_WAY='0103'  then null else QUOTATION_MONEY end) as QUOTATION_MONEY,
sum(case when PROC_WAY='0103'  then null else PROVISIONAL_SUM end) as PROVISIONAL_SUM,
count(case when  ifnull(SETBID_FLAG,'N')='Y' and SETBID_STAT='03' then 1  else null end ) as SETBID_VEN_CN,
count(case when  SETBID_STAT='03' then 1  else null end ) as REP_VEN_CN,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
sum(MESG_CN) as MESG_CN
from f_po_object_setbid
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"and CATEGORY in (select DEPT_ID from fr_user_org where ORG_TYPE='立项分类' and USER_ID='" +fine_username+ "')","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_CN," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
aa
)maintab

left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as bb
,sum(SENDBID_CN) as SENDBID_CN
,sum(SETOBJ_CN) as SETOBJ_CN
,sum(INVEN_CN) as INVEN_CN
,sum(LIMIT_MONEY) as LIMIT_MONEY
,sum(REPLYBID_CN) as REPLYBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
case when SENDBID_FLAG='Y' and m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SENDBID_CN
,case when  m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SETOBJ_CN
, max(case when m.PROC_WAY='0103' then null else INVEN_CN end) as INVEN_CN
, sum(LIMIT_MONEY) as LIMIT_MONEY
, max(case when m.PROC_WAY='0103' then null else REPLYBID_CN end) as REPLYBID_CN  
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SENDBID_FLAG,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
      -- ,count(distinct a.object_no) obj_cn  -- 发标数 -- 
       count(distinct a.VENDOR_NO) as INVEN_CN -- 入围供应商数量\每立项
       ,max(a.LIMIT_MONEY) as LIMIT_MONEY -- 招标控制价\每标段
			 ,sum(REPLYBID_CN) REPLYBID_CN    -- 供应商回标数量
  from f_po_object_setbid a 
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
	,PROC_WAY,a.BID_NUM,SENDBID_FLAG
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SENDBID_FLAG
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
bb
)as subtab
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab.proc2 and maintab.STAGE_CODE=subtab.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab.VENDOR_NAME" ) }
left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc3,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as cc
,sum(OPENBID_CN) as OPENBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,max(OPENBID_CN) as OPENBID_CN
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,case when ifnull(OPENBID_FLAG,'')='Y' and PROC_WAY!='0103' and SETBID_STAT='03' then count(distinct OBJECT_NO) else null end as OPENBID_CN
-- #已开标数量
  from f_po_object_setbid a 
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"and CATEGORY in (select DEPT_ID from fr_user_org where ORG_TYPE='立项分类' and USER_ID='" +fine_username+ "')","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,OPENBID_FLAG,SETBID_STAT
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc3,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
cc
)as subtab2
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab2.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab2.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab2.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab2.proc3 and maintab.STAGE_CODE=subtab2.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab2.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab2.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab2.VENDOR_NAME" ) }
left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc4,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as dd
,sum(SETBID_CN) as SETBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,max(SETBID_CN) as SETBID_CN 
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,case when ifnull(SETBID_FLAG,'')='Y' and PROC_WAY!='0103'  and SETBID_STAT='03' then count(distinct OBJECT_NO) else null end as SETBID_CN
#立项定标数量
  from f_po_object_setbid a 
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"and CATEGORY in (select DEPT_ID from fr_user_org where ORG_TYPE='立项分类' and USER_ID='" +fine_username+ "')","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SETBID_FLAG,SETBID_STAT
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc4,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
dd
)as subtab3
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab3.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab3.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab3.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab3.proc4 and maintab.STAGE_CODE=subtab3.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab3.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab3.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab3.VENDOR_NAME" ) }
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
maintab.aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
maintab.aa


WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct  CATEGORY,CATEGORY_DESC from f_po_object_setbid
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='立项分类')



WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
sum(subtab.LIMIT_MONEY) as LIMIT_MONEY,
sum(subtab.INVEN_CN) as INVEN_CN,
sum(subtab.SENDBID_CN) as SENDBID_CN,
sum(subtab2.OPENBID_CN) as OPENBID_CN,
sum(subtab3.SETBID_CN) as SETBID_CN,
sum(subtab.REPLYBID_CN) as REPLYBID_CN,
sum(subtab.SETOBJ_CN) as SETOBJ_CN,
sum(QUOTATION_MONEY) as QUOTATION_MONEY,
sum(PROVISIONAL_SUM) as PROVISIONAL_SUM,
sum(SETBID_VEN_CN) as SETBID_VEN_CN,
sum(REP_VEN_CN) as REP_VEN_CN,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(MESG_CN) as MESG_CN, 
sum(SIGN_MONEY) as SIGN_MONEY,
sum(SIGNCON_BID_CN) as SIGNCON_BID_CN
from 
(select distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,""," EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
'' as aa,
sum(REPLYBID_CN) as REPLYBID_CN_MAC,
sum(case when PROC_WAY='0103'  then null else QUOTATION_MONEY end) as QUOTATION_MONEY,
sum(case when PROC_WAY='0103'  then null else PROVISIONAL_SUM end) as PROVISIONAL_SUM,
count(case when  ifnull(SETBID_FLAG,'N')='Y' and SETBID_STAT='03' then 1  else null end ) as SETBID_VEN_CN,
count(case when  SETBID_STAT='03' then 1  else null end ) as REP_VEN_CN,
sum(SETBID_PRICE) as SETBID_PRICE,
sum(SIGN_MONEY) as SIGN_MONEY,
count(case when ifnull(SIGN_FLAG,'N')='Y' then 1 else null end) as SIGNCON_BID_CN,
sum(MESG_CN) as MESG_CN
from 	(select * from f_po_object_setbid a 
	where 1=1 
	and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
 )a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","SETBID_STAT_DESC," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_CN," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
aa
)maintab

left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as bb
,sum(SENDBID_CN) as SENDBID_CN
,sum(SETOBJ_CN) as SETOBJ_CN
,sum(INVEN_CN) as INVEN_CN
,sum(LIMIT_MONEY) as LIMIT_MONEY
,sum(REPLYBID_CN) as REPLYBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
case when SENDBID_FLAG='Y' and m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SENDBID_CN
,case when  m.PROC_WAY!='0103'  then count(distinct object_no)  else null end SETOBJ_CN
, max(case when m.PROC_WAY='0103' then null else INVEN_CN end) as INVEN_CN
, sum(LIMIT_MONEY) as LIMIT_MONEY
, max(case when m.PROC_WAY='0103' then null else REPLYBID_CN end) as REPLYBID_CN  
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SENDBID_FLAG,
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
      -- ,count(distinct a.object_no) obj_cn  -- 发标数 -- 
       count(distinct a.VENDOR_NO) as INVEN_CN -- 入围供应商数量\每立项
       ,max(a.LIMIT_MONEY) as LIMIT_MONEY -- 招标控制价\每标段
			 ,sum(REPLYBID_CN) REPLYBID_CN    -- 供应商回标数量
  from 	(select * from f_po_object_setbid a 
	where 1=1 
	and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
 )a
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
	,PROC_WAY,a.BID_NUM,SENDBID_FLAG
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SENDBID_FLAG
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc2,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
bb
)as subtab
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab.proc2 and maintab.STAGE_CODE=subtab.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab.VENDOR_NAME" ) }
left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc3,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as cc
,sum(OPENBID_CN) as OPENBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,max(OPENBID_CN) as OPENBID_CN
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,case when ifnull(OPENBID_FLAG,'')='Y' and PROC_WAY!='0103' and SETBID_STAT='03' then count(distinct OBJECT_NO) else null end as OPENBID_CN
-- #已开标数量
  from 	(select * from f_po_object_setbid a 
	where 1=1 
	and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
 )a
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,OPENBID_FLAG,SETBID_STAT
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,OPENBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc3,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
cc
)as subtab2
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab2.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab2.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab2.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab2.proc3 and maintab.STAGE_CODE=subtab2.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab2.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab2.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab2.VENDOR_NAME" ) }
left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc4,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
'' as dd
,sum(SETBID_CN) as SETBID_CN
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,max(SETBID_CN) as SETBID_CN 
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
,case when ifnull(SETBID_FLAG,'')='Y' and PROC_WAY!='0103'  and SETBID_STAT='03' then count(distinct OBJECT_NO) else null end as SETBID_CN
#立项定标数量
  from 
	(select * from f_po_object_setbid a 
	where 1=1 
	and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and  CITY_org_code in( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in (select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
 select distinct a.sap_dept_id from user_org a)
 and CATEGORY in (select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' )
 )a
	where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,PROC_WAY,a.BID_NUM,SETBID_FLAG,SETBID_STAT
	${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
	)m
	
group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO,m.PROC_WAY,SETBID_FLAG,SETBID_STAT
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"",",BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"",",VENDOR_NAME" ) }
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc4,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","BID_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","VENDOR_NAME," ) }
dd
)as subtab3
on 1=1
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","and maintab.AREA_ORG_CODE=subtab3.AREA_ORG_CODE" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","and maintab.CITY_ORG_CODE=subtab3.CITY_ORG_CODE" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","and maintab.PROJ_CODE=subtab3.PROJ_CODE" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","and maintab.proc1=subtab3.proc4 and maintab.STAGE_CODE=subtab3.STAGE_CODE" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","and maintab.OBJECT_NO=subtab3.OBJECT_NO" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","and maintab.BID_NAME=subtab3.BID_NAME" ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","and maintab.VENDOR_NAME=subtab3.VENDOR_NAME" ) }
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.SUP_TYPE_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.PROC_MODE_NAME," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.PROC_WAY_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.EVALUATION_BID_METHOD_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.BID_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.OBJECT_APPROVAL_DATE," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.SUPPLIER_APPROVAL_DATE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.OPENBID_FLAG," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.SETBID_FLAG," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.SETBID_APPROVAL_DATE," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.VENDOR_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CATEGORY_DESC," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.SETBID_STAT_DESC," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.OBJECT_NO," ) }
maintab.aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
maintab.aa



select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
'' as bb
,sum(SENDBID_CN) as SENDBID_CN
,sum(REPLYBID_CN) as REPLYBID_CN
,sum(LIMIT_MONEY) as LIMIT_MONEY
from(
select m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO
, count(distinct object_no) SENDBID_CN
, max(rep_cn) as REPLYBID_CN
, sum(LIMIT_MONEY) as LIMIT_MONEY
from
(
select a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,a.BID_NUM
      -- ,count(distinct a.object_no) obj_cn  -- 发标数 -- 
       ,count(a.VENDOR_NO) as rep_cn -- 回标数量\每标段
       ,max(a.LIMIT_MONEY) as LIMIT_MONEY -- 招标控制价\每标段
  from f_po_object_setbid a 
  group by a.AREA_ORG_CODE,a.CITY_ORG_CODE,a.PROJ_CODE,a.STAGE_CODE,a.OBJECT_NO
,a.BID_NUM
	)m

group by m.AREA_ORG_CODE,m.CITY_ORG_CODE,m.PROJ_CODE,m.STAGE_CODE,m.OBJECT_NO
)n
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","OBJECT_NO," ) }
bb



WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct SETBID_STAT_DESC from f_po_object_setbid
where 1=1
   and ifnull(SETBID_STAT,'01') in(select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')

select '5,6,7,8,9,11,12,13,15,17,18' as id,'采购立项维度' as name
union
select '10','标段维度'
union
select '5,10,14,16','供应商维度'




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

count(distinct a.VENDOR_NO) as INVEN_CN
from ( 
select * from f_po_object_setbid a 
where 1=1 and 
AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and CATEGORY in (
select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' 
) and 
ifnull(SETBID_STAT,'01') in (select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 ) a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}




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

count(distinct a.OBJECT_NO) as INVEN_CN -- 入围供应商数量\每立项
from ( 
select * from f_po_object_setbid a 
where 1=1 and 
AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and CATEGORY in (
select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' 
) and 
ifnull(SETBID_STAT,'01') in (select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 ) a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}




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

REPLYBID_CN as INVEN_CN -- 入围供应商数量\每立项
from ( 
select * from f_po_object_setbid a 
where 1=1 and 
AREA_ORG_CODE in ( 
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
CITY_org_code in( 
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   union
select distinct a.sap_dept_id from user_org a
) and 
PROJ_CODE in (
select distinct b.PROJ_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.CITY_ORG_CODE   
union
select distinct a.sap_dept_id from user_org a
) and CATEGORY in (
select SAP_DEPT_ID from user_org where ORG_TYPE='立项分类' 
) and 
ifnull(SETBID_STAT,'01') in (select  SAP_DEPT_ID from user_org where ORG_TYPE='招标分类')
 ) a
where 1=1
${if(len(SUPPLIER_APPROVAL_DATE1) == 0,"","and SUPPLIER_APPROVAL_DATE >= '" + SUPPLIER_APPROVAL_DATE1 + "'")}
${if(len(SUPPLIER_APPROVAL_DATE2) == 0,"","and SUPPLIER_APPROVAL_DATE <= '" + SUPPLIER_APPROVAL_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ENTITY_ORG_NAME) == 0,"","and ENTITY_ORG_NAME in ('" + ENTITY_ORG_NAME + "')")}
${if(len(OBJECT_NAME) == 0,"","and OBJECT_NAME in ('" + OBJECT_NAME + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(VENDOR_NAME) == 0,"","and VENDOR_NAME in ('" + VENDOR_NAME + "')")}
${if(len(CATEGORY_DESC) == 0,"","and CATEGORY_DESC in ('" + CATEGORY_DESC + "')")}
${if(len(SETBID_STAT_DESC) == 0,"","and SETBID_STAT_DESC in ('" + SETBID_STAT_DESC + "')")}
${if(len(SETBID_FLAG) == 0,"","and SETBID_FLAG in ('" + SETBID_FLAG + "')")}



