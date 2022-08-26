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
FROM f_cost_ov_pay
where area_org_code in(
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
distinct CITY_ORG_NAME,CITY_ORG_CODE
FROM f_cost_ov_pay
where 1=1 
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
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
FROM f_cost_ov_pay
where 1=1 
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)


SELECT 
distinct	STAGE_NAME
FROM f_cost_ov_pay
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM f_cost_adjcont

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
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE as proc1,cont_ov_tab.STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_NAME as pron1,cont_ov_tab.STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","cont_ov_tab.HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","cont_ov_tab.BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B," ) }
'' as aa,
 sum(cont_ov_tab.CONT_AMT) CONT_AMT,
 sum(cont_ov_tab.REP_CONT_AMT) REP_CONT_AMT,
 sum(cont_ov_tab.CURR_SIGN_AMT) CURR_SIGN_AMT,
 sum(cont_ov_tab.CONT_NEW_AMT) CONT_NEW_AMT
,sum(cont_ov_tab.OV_AMT) OV_AMT
,sum(cont_ov_tab.OV_PAY_AMT) OV_PAY_AMT
,sum(cont_ov_tab.PREPAY_AMT) PREPAY_AMT
,sum(cont_ov_tab.PROCESS_PRE_AMT) PROCESS_PRE_AMT
,sum(cont_ov_tab.UNPAY_PREAMT) UNPAY_PREAMT
,sum(cont_ov_tab.PAY_AMT) PAY_AMT
,sum(cont_ov_tab.APPPAY_CN) APPPAY_CN
,sum(cont_ov_tab.APPPAY_AMT) APPPAY_AMT
,sum(cont_ov_tab.APPROVAL_APPPAY_CN) APPROVAL_APPPAY_CN
,sum(cont_ov_tab.PAID_AMT) PAID_AMT
,sum(cont_ov_tab.UNPAID_AMT) UNPAID_AMT
from
(
select cont_tab.*,
 OV_AMT,
 OV_PAY_AMT,
 PREPAY_AMT,
 PROCESS_PRE_AMT,
 UNPAY_PREAMT,
 PAY_AMT,
 APPPAY_CN,
 APPPAY_AMT,
 APPROVAL_APPPAY_CN,
 PAID_AMT,
 UNPAID_AMT
from
(
select distinct AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_CODE as projc1,PROJ_NAME as projn1,PROJ_NAME,PROJ_CODE,STAGE_CODE,STAGE_NAME,CONTRACT_NO ,CONT_CLASSNAME1,CONT_CLASSNAME2,CONT_CLASSNAME3
,CONT_KIND_NAME,CONT_TYPE_NAME,HG_CONT_FLAG,CONT_ARCH_ID,CONT_NAME,PARTY_A_NAME,PARTY_B_NAME,CLOS_FLAG,CLOS_STAT_DESC
,CONT_CLASS1,CONT_CLASS2,CONT_CLASS3,CONT_KIND,CONT_TYPE,PARTY_A,PARTY_B,BUS_CONT_NAME,BUS_CONT_TYPE,
 CONT_AMT,
 REP_CONT_AMT,
 CURR_SIGN_AMT,
 CONT_NEW_AMT,
'' as aa
FROM 
(
select main_tab.* from f_cost_ov_pay main_tab
#左接权限配置表的区域城市项目查询，合同分类和事项分类合并查询
left join ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
 left join ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) city_tab
  on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
 left join ( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) PROJ_tab
  on main_tab.CITY_ORG_CODE=PROJ_tab.PROJ_CODE
 left join (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' 
             union select sap_dept_id from user_org where ORG_TYPE='事项审批分类'
             union select PRIV_VALUE from fr_user_priv where EMP_ID='${fr_username}') con_tab
  on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or main_tab.BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(PROJ_tab.PROJ_CODE,'')!=''
and ifnull(con_tab.sap_dept_id,'')!=''
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_PAY_AMT),0)+ifnull(PAID_AMT,0))>0")}
#产值应付的绝对值+已付金额大于0
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and main_tab.AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and main_tab.CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and main_tab.PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and main_tab.STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and main_tab.CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and main_tab.CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and main_tab.CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and main_tab.CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and main_tab.CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and main_tab.CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and main_tab.CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and main_tab.CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and main_tab.CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and main_tab.PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and main_tab.PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and main_tab.HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and main_tab.CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and main_tab.BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
)a
)cont_tab
left join
(
select CONTRACT_NO
,sum(OV_AMT) as OV_AMT,
sum(OV_PAY_AMT) as OV_PAY_AMT,
sum(PREPAY_AMT) as PREPAY_AMT,
sum(PROCESS_PRE_AMT) as PROCESS_PRE_AMT,
sum(UNPAY_PREAMT) as UNPAY_PREAMT,
sum(PAY_AMT) as PAY_AMT,
sum(APPPAY_CN) as APPPAY_CN,
sum(APPPAY_AMT) as APPPAY_AMT,
sum(APPROVAL_APPPAY_CN) as APPROVAL_APPPAY_CN,
sum(PAID_AMT) as PAID_AMT,
sum(UNPAID_AMT) as UNPAID_AMT
from
(
select main_tab.* from f_cost_ov_pay main_tab
#左接权限配置表的区域城市项目查询，合同分类和事项分类合并查询
left join ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
 left join ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) city_tab
  on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
 left join ( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) PROJ_tab
  on main_tab.CITY_ORG_CODE=PROJ_tab.PROJ_CODE
 left join (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' 
             union select sap_dept_id from user_org where ORG_TYPE='事项审批分类'
              union select PRIV_VALUE from fr_user_priv where EMP_ID='${fr_username}') con_tab
  on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or main_tab.BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(PROJ_tab.PROJ_CODE,'')!=''
and ifnull(con_tab.sap_dept_id,'')!=''
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_PAY_AMT),0)+ifnull(PAID_AMT,0))>0")}
#产值应付的绝对值+已付金额大于0
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and main_tab.AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and main_tab.CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and main_tab.PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and main_tab.STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and main_tab.CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and main_tab.CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and main_tab.CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and main_tab.CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and main_tab.CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and main_tab.CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and main_tab.CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and main_tab.CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and main_tab.CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and main_tab.PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and main_tab.PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and main_tab.HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and main_tab.CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and main_tab.BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
)a
group by 
CONTRACT_NO
)ov_tab
on cont_tab.CONTRACT_NO=ov_tab.CONTRACT_NO
)cont_ov_tab
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,cont_ov_tab.STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,cont_ov_tab.STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","cont_ov_tab.HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","cont_ov_tab.BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","cont_ov_tab.STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS3," ) }
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
select distinct CONT_CLASSNAME1 FROM f_cost_ov_pay
where 1=1 and CONT_CLASS1 in (select sap_DEPT_ID from user_org where ORG_TYPE='合同一级分类' 
)


select distinct CONT_CLASSNAME2 FROM f_cost_ov_pay
where 1=1
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}

select distinct CONT_CLASSNAME3 FROM f_cost_ov_pay
where 1=1
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}

select distinct CONT_KIND_NAME FROM f_cost_ov_pay

select distinct CONT_TYPE_NAME FROM f_cost_ov_pay 
where 1=1 

select distinct CLOS_FLAG FROM f_cost_ov_pay

select distinct CLOS_STAT_DESC FROM f_cost_ov_pay

select CONT_ARCH_ID FROM f_cost_ov_pay
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select CONT_NAME FROM f_cost_ov_pay
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select PARTY_A_NAME FROM f_cost_ov_pay
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select PARTY_B_NAME FROM f_cost_ov_pay
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CONT_ARCH_ID ) == 0,"","and CONT_ARCH_ID  in ('" + CONT_ARCH_ID  + "')")}


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select maintab.*
,subtab.OV_AMT
,subtab.OV_PAY_AMT
,subtab.PREPAY_AMT
,subtab.PROCESS_PRE_AMT
,subtab.UNPAY_PREAMT
,subtab.PAY_AMT
,subtab.APPPAY_CN
,subtab.APPPAY_AMT
,subtab.APPROVAL_APPPAY_CN
,subtab.PAID_AMT
,subtab.UNPAID_AMT

from
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
aa,
sum(CONT_AMT) CONT_AMT,
sum(REP_CONT_AMT) REP_CONT_AMT,
sum(CURR_SIGN_AMT) CURR_SIGN_AMT,
sum(CONT_NEW_AMT) CONT_NEW_AMT
from
(
select distinct AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_CODE as projc1,PROJ_NAME as projn1,PROJ_NAME,PROJ_CODE,STAGE_CODE,STAGE_NAME,CONTRACT_NO ,CONT_CLASSNAME1,CONT_CLASSNAME2,CONT_CLASSNAME3
,CONT_KIND_NAME,CONT_TYPE_NAME,HG_CONT_FLAG,CONT_ARCH_ID,CONT_NAME,PARTY_A_NAME,PARTY_B_NAME,CLOS_FLAG,CLOS_STAT_DESC
,CONT_CLASS1,CONT_CLASS2,CONT_CLASS3,CONT_KIND,CONT_TYPE,PARTY_A,PARTY_B,BUS_CONT_NAME,BUS_CONT_TYPE,
 CONT_AMT,
 REP_CONT_AMT,
 CURR_SIGN_AMT,
 CONT_NEW_AMT,
'' as aa
FROM f_cost_ov_pay
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a)
 and CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a)
	 and ( CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
       or BUS_CONT_TYPE in (select sap_dept_id from user_org where ORG_TYPE='事项审批分类' ) 
        )
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_AMT),0)+ifnull(PAID_AMT,0))>0")}
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
)a
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn1,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
aa
)
maintab
left join 
(
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as projc2,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn2,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
'' as bb,
sum(OV_AMT) as OV_AMT,
sum(OV_PAY_AMT) as OV_PAY_AMT,
sum(PREPAY_AMT) as PREPAY_AMT,
sum(PROCESS_PRE_AMT) as PROCESS_PRE_AMT,
sum(UNPAY_PREAMT) as UNPAY_PREAMT,
sum(PAY_AMT) as PAY_AMT,
sum(APPPAY_CN) as APPPAY_CN,
sum(APPPAY_AMT) as APPPAY_AMT,
sum(APPROVAL_APPPAY_CN) as APPROVAL_APPPAY_CN,
sum(PAID_AMT) as PAID_AMT,
sum(UNPAID_AMT) as UNPAID_AMT
from f_cost_ov_pay
where 1=1
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a)
 and CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a)
 and PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a)
	 and ( CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
       or BUS_CONT_TYPE in (select sap_dept_id from user_org where ORG_TYPE='事项审批分类' ) 
        )
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_PAY_AMT),0)+ifnull(PAID_AMT,0))>0")}
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projc2,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","projn2,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
bb
)subtab
on
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE=subtab.AREA_ORG_CODE and" ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME=subtab.AREA_ORG_NAME and" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE=subtab.CITY_ORG_CODE and" ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME=subtab.CITY_ORG_NAME and" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE=subtab.PROJ_CODE and" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE=subtab.PROJ_CODE and maintab.STAGE_CODE=subtab.STAGE_CODE and" ) } 

${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.HG_CONT_FLAG=subtab.HG_CONT_FLAG and" ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.CONT_ARCH_ID=subtab.CONT_ARCH_ID and" ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.CONT_NAME=subtab.CONT_NAME and" ) } 

${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.CLOS_FLAG=subtab.CLOS_FLAG and" ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.CLOS_STAT_DESC=subtab.CLOS_STAT_DESC and" ) } 
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","maintab.CONTRACT_NO=subtab.CONTRACT_NO and" ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","maintab.BUS_CONT_NAME=maintab.BUS_CONT_NAME and " ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.CONT_CLASS1=subtab.CONT_CLASS1 and" ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.CONT_CLASS2=subtab.CONT_CLASS2 and" ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.CONT_CLASS3=subtab.CONT_CLASS3 and" ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.CONT_KIND=subtab.CONT_KIND and" ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.CONT_TYPE=subtab.CONT_TYPE and" ) } 
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.PARTY_A=subtab.PARTY_A and" ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.PARTY_B=subtab.PARTY_B and" ) } 
maintab.aa=subtab.bb
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
aa

select CONTRACT_NO FROM f_cost_ov_pay
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
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
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
'' as aa,
sum(CONT_AMT) CONT_AMT,
sum(REP_CONT_AMT) REP_CONT_AMT,
sum(CURR_SIGN_AMT) CURR_SIGN_AMT,
sum(CONT_NEW_AMT) CONT_NEW_AMT,
sum(OV_AMT) as OV_AMT,
sum(OV_PAY_AMT) as OV_PAY_AMT,
sum(PREPAY_AMT) as PREPAY_AMT,
sum(PROCESS_PRE_AMT) as PROCESS_PRE_AMT,
sum(UNPAY_PREAMT) as UNPAY_PREAMT,
sum(PAY_AMT) as PAY_AMT,
sum(APPPAY_CN) as APPPAY_CN,
sum(APPPAY_AMT) as APPPAY_AMT,
sum(APPROVAL_APPPAY_CN) as APPROVAL_APPPAY_CN,
sum(PAID_AMT) as PAID_AMT,
sum(UNPAID_AMT) as UNPAID_AMT
from
(

select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as proc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as pron1,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
'' as a,
max(CONT_AMT) CONT_AMT,
max(REP_CONT_AMT) REP_CONT_AMT,
max(CURR_SIGN_AMT) CURR_SIGN_AMT,
max(CONT_NEW_AMT) CONT_NEW_AMT,
sum(OV_AMT) as OV_AMT,
sum(OV_PAY_AMT) as OV_PAY_AMT,
sum(PREPAY_AMT) as PREPAY_AMT,
sum(PROCESS_PRE_AMT) as PROCESS_PRE_AMT,
sum(UNPAY_PREAMT) as UNPAY_PREAMT,
sum(PAY_AMT) as PAY_AMT,
sum(APPPAY_CN) as APPPAY_CN,
sum(APPPAY_AMT) as APPPAY_AMT,
sum(APPROVAL_APPPAY_CN) as APPROVAL_APPPAY_CN,
sum(PAID_AMT) as PAID_AMT,
sum(UNPAID_AMT) as UNPAID_AMT
from 
(select main_tab.* from f_cost_ov_pay main_tab
#左接权限配置表的区域城市项目查询，合同分类和事项分类合并查询
left join ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
 left join ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) city_tab
  on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
 left join ( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) PROJ_tab
  on main_tab.CITY_ORG_CODE=PROJ_tab.PROJ_CODE
 left join (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' 
             union select sap_dept_id from user_org where ORG_TYPE='事项审批分类') con_tab
  on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or main_tab.BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_PAY_AMT),0)+ifnull(PAID_AMT,0))>0")}
#产值应付的绝对值+已付金额大于0
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and main_tab.AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and main_tab.CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and main_tab.PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and main_tab.STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and main_tab.CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and main_tab.CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and main_tab.CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and main_tab.CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and main_tab.CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and main_tab.CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and main_tab.CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and main_tab.CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and main_tab.CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and main_tab.PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and main_tab.PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and main_tab.HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and main_tab.CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and main_tab.BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(PROJ_tab.PROJ_CODE,'')!=''
and ifnull(con_tab.sap_dept_id,'')!=''
)m
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
a
)a
where 1=1
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
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
select distinct BUS_CONT_TYPE,BUS_CONT_NAME from f_cost_ov_pay main
left join 
(
select sap_DEPT_ID from user_org where ORG_TYPE='事项审批分类' 
union 
select PRIV_VALUE from fr_user_priv where EMP_ID='${fine_username}'
)priv
on main.BUS_CONT_TYPE=priv.sap_DEPT_ID
where 1=1 and ifnull(priv.sap_DEPT_ID,'')!=''


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='report01')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE as proc1,cont_ov_tab.STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_NAME as pron1,cont_ov_tab.STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","cont_ov_tab.HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","cont_ov_tab.BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B," ) }
'' as aa,
 sum(cont_ov_tab.CONT_AMT) CONT_AMT,
 sum(cont_ov_tab.REP_CONT_AMT) REP_CONT_AMT,
 sum(cont_ov_tab.CURR_SIGN_AMT) CURR_SIGN_AMT,
 sum(cont_ov_tab.CONT_NEW_AMT) CONT_NEW_AMT
,sum(cont_ov_tab.OV_AMT) OV_AMT
,sum(cont_ov_tab.OV_PAY_AMT) OV_PAY_AMT
,sum(cont_ov_tab.PREPAY_AMT) PREPAY_AMT
,sum(cont_ov_tab.PROCESS_PRE_AMT) PROCESS_PRE_AMT
,sum(cont_ov_tab.UNPAY_PREAMT) UNPAY_PREAMT
,sum(cont_ov_tab.PAY_AMT) PAY_AMT
,sum(cont_ov_tab.APPPAY_CN) APPPAY_CN
,sum(cont_ov_tab.APPPAY_AMT) APPPAY_AMT
,sum(cont_ov_tab.APPROVAL_APPPAY_CN) APPROVAL_APPPAY_CN
,sum(cont_ov_tab.PAID_AMT) PAID_AMT
,sum(cont_ov_tab.UNPAID_AMT) UNPAID_AMT
from
(
select cont_tab.*,
 OV_AMT,
 OV_PAY_AMT,
 PREPAY_AMT,
 PROCESS_PRE_AMT,
 UNPAY_PREAMT,
 PAY_AMT,
 APPPAY_CN,
 APPPAY_AMT,
 APPROVAL_APPPAY_CN,
 PAID_AMT,
 UNPAID_AMT
from
(
select distinct AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_CODE as projc1,PROJ_NAME as projn1,PROJ_NAME,PROJ_CODE,STAGE_CODE,STAGE_NAME,CONTRACT_NO ,CONT_CLASSNAME1,CONT_CLASSNAME2,CONT_CLASSNAME3
,CONT_KIND_NAME,CONT_TYPE_NAME,HG_CONT_FLAG,CONT_ARCH_ID,CONT_NAME,PARTY_A_NAME,PARTY_B_NAME,CLOS_FLAG,CLOS_STAT_DESC
,CONT_CLASS1,CONT_CLASS2,CONT_CLASS3,CONT_KIND,CONT_TYPE,PARTY_A,PARTY_B,BUS_CONT_NAME,BUS_CONT_TYPE,
 CONT_AMT,
 REP_CONT_AMT,
 CURR_SIGN_AMT,
 CONT_NEW_AMT,
'' as aa
FROM 
(
select main_tab.* from f_cost_ov_pay main_tab
#左接权限配置表的区域城市项目查询，合同分类和事项分类合并查询
left join ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
 left join ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) city_tab
  on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
 left join ( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) PROJ_tab
  on main_tab.CITY_ORG_CODE=PROJ_tab.PROJ_CODE
 left join (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' 
             union select sap_dept_id from user_org where ORG_TYPE='事项审批分类') con_tab
  on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or main_tab.BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(PROJ_tab.PROJ_CODE,'')!=''
and ifnull(con_tab.sap_dept_id,'')!=''
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_PAY_AMT),0)+ifnull(PAID_AMT,0))>0")}
#产值应付的绝对值+已付金额大于0
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and main_tab.AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and main_tab.CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and main_tab.PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and main_tab.STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and main_tab.CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and main_tab.CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and main_tab.CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and main_tab.CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and main_tab.CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and main_tab.CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and main_tab.CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and main_tab.CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and main_tab.CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and main_tab.PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and main_tab.PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and main_tab.HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and main_tab.CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and main_tab.BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
)a
)cont_tab
left join
(
select CONTRACT_NO
,sum(OV_AMT) as OV_AMT,
sum(OV_PAY_AMT) as OV_PAY_AMT,
sum(PREPAY_AMT) as PREPAY_AMT,
sum(PROCESS_PRE_AMT) as PROCESS_PRE_AMT,
sum(UNPAY_PREAMT) as UNPAY_PREAMT,
sum(PAY_AMT) as PAY_AMT,
sum(APPPAY_CN) as APPPAY_CN,
sum(APPPAY_AMT) as APPPAY_AMT,
sum(APPROVAL_APPPAY_CN) as APPROVAL_APPPAY_CN,
sum(PAID_AMT) as PAID_AMT,
sum(UNPAID_AMT) as UNPAID_AMT
from
(
select main_tab.* from f_cost_ov_pay main_tab
#左接权限配置表的区域城市项目查询，合同分类和事项分类合并查询
left join ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
 left join ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) city_tab
  on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
 left join ( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) PROJ_tab
  on main_tab.CITY_ORG_CODE=PROJ_tab.PROJ_CODE
 left join (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' 
             union select sap_dept_id from user_org where ORG_TYPE='事项审批分类') con_tab
  on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or main_tab.BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(PROJ_tab.PROJ_CODE,'')!=''
and ifnull(con_tab.sap_dept_id,'')!=''
${if(len(OV_AMTplusPAID_AMT)==0,"","and (ifnull(abs(OV_PAY_AMT),0)+ifnull(PAID_AMT,0))>0")}
#产值应付的绝对值+已付金额大于0
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and main_tab.AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and main_tab.CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and main_tab.PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and main_tab.STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_CLASSNAME1) == 0,"","and main_tab.CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and main_tab.CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}
${if(len(CONT_CLASSNAME3) == 0,"","and main_tab.CONT_CLASSNAME3 in ('" + CONT_CLASSNAME3 + "')")}
${if(len(CONT_KIND_NAME) == 0,"","and main_tab.CONT_KIND_NAME in ('" + CONT_KIND_NAME + "')")}
${if(len(CONT_TYPE_NAME) == 0,"","and main_tab.CONT_TYPE_NAME in ('" + CONT_TYPE_NAME + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and main_tab.CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and main_tab.CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CLOS_FLAG) == 0,"","and main_tab.CLOS_FLAG in ('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT) == 0,"","and main_tab.CLOS_STAT_DESC in ('" + CLOS_STAT + "')")}
${if(len(PARTY_A_NAME) == 0,"","and main_tab.PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and main_tab.PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and main_tab.HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(CONTRACT_NO) == 0,"","and main_tab.CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BUS_CONT_TYPE) == 0,"","and main_tab.BUS_CONT_TYPE in ('" + BUS_CONT_TYPE + "')")}
)a
group by 
CONTRACT_NO
)ov_tab
on cont_tab.CONTRACT_NO=ov_tab.CONTRACT_NO
)cont_ov_tab
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","proc1,cont_ov_tab.STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,cont_ov_tab.STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASSNAME3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","cont_ov_tab.HG_CONT_FLAG," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_ARCH_ID," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_NAME," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_FLAG," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","cont_ov_tab.CLOS_STAT_DESC," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONTRACT_NO," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","cont_ov_tab.BUS_CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","cont_ov_tab.PARTY_B," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","cont_ov_tab.AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","cont_ov_tab.CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","cont_ov_tab.PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","cont_ov_tab.STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","cont_ov_tab.CONT_CLASS3," ) }
aa

