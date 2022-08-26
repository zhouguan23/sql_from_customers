WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT distinct
	AREA_ORG_NAME
FROM f_cost_contw
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
distinct CITY_ORG_NAME
FROM f_cost_contw
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
FROM f_cost_contw
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
FROM f_cost_contw
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
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
select maintab.*
,subtab.CONTW_AMT
,subtab.CONTW_CN
,subtab.APPROVAL_CONTW_CN
,subtab.APPROVAL_CONTW_AMT

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
SELECT distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as projc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) } 
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
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
 CONT_AMT,
 REP_CONT_AMT,
 CURR_SIGN_AMT,
 CONT_NEW_AMT,
'' as aa
FROM f_cost_contw
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
  and CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
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
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_B," ) }
'' as bb,
sum(CONTW_AMT) as CONTW_AMT,
sum(CONTW_CN) as CONTW_CN,
sum(APPROVAL_CONTW_CN) as APPROVAL_CONTW_CN,
sum(APPROVAL_CONTW_AMT) as APPROVAL_CONTW_AMT
from f_cost_contw
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
  and CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
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
select distinct CONT_CLASSNAME1 from f_cost_contw
where 1=1 and CONT_CLASS1 in (select sap_DEPT_ID from user_org where ORG_TYPE='合同一级分类' 
)


select distinct CONT_CLASSNAME2  from f_cost_contw
where 1=1
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}

select distinct CONT_CLASSNAME3  from f_cost_contw
where 1=1
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}

select distinct CONT_KIND_NAME FROM f_cost_contw

select distinct CONT_TYPE_NAME FROM f_cost_contw

select distinct CLOS_FLAG FROM f_cost_contw

select distinct CLOS_STAT_DESC FROM f_cost_contw

select CONT_ARCH_ID from f_cost_contw
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select CONT_NAME from f_cost_contw
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select PARTY_A_NAME from f_cost_contw
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CONT_ARCH_ID ) == 0,"","and CONT_ARCH_ID  in ('" + CONT_ARCH_ID  + "')")}


select PARTY_B_NAME from  f_cost_contw
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CONT_ARCH_ID ) == 0,"","and CONT_ARCH_ID  in ('" + CONT_ARCH_ID  + "')")}



select maintab.*,
 subtab.CONTW_AMT,
 subtab.CONTW_CN,
 subtab.APPROVAL_CONTW_CN,
 subtab.APPROVAL_CONTW_AMT
from
(SELECT distinct 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME ," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE ," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE as projc1,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as projn1,STAGE_NAME," ) } 
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
 CONT_AMT,
 REP_CONT_AMT,
 CURR_SIGN_AMT,
 CONT_NEW_AMT,
'' as aa
FROM f_cost_contw
where 1=1 
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
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
) as maintab
left join 
(SELECT 
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
sum(CONTW_AMT) as CONTW_AMT,
sum(CONTW_CN) as CONTW_CN,
sum(APPROVAL_CONTW_CN) as APPROVAL_CONTW_CN,
sum(APPROVAL_CONTW_AMT) as APPROVAL_CONTW_AMT,
'' as aa
FROM f_cost_contw
where 1=1 
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(TDATE1) == 0,"","and TDATE >= '" + TDATE1 + "'")}
${if(len(TDATE2) == 0,"","and TDATE <= '" + TDATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
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
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) } 
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
aa
)subtab
on
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_CODE=subtab.AREA_ORG_CODE and" ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","maintab.AREA_ORG_NAME=subtab.AREA_ORG_NAME and" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_CODE=subtab.CITY_ORG_CODE and" ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","maintab.CITY_ORG_NAME=subtab.CITY_ORG_NAME and" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE=subtab.PROJ_CODE and" ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","maintab.PROJ_CODE=subtab.PROJ_CODE and maintab.STAGE_CODE=subtab.STAGE_CODE and" ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","maintab.CONT_CLASSNAME1=subtab.CONT_CLASSNAME1 and" ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","maintab.CONT_CLASSNAME2=subtab.CONT_CLASSNAME2 and" ) } 
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","maintab.CONT_CLASSNAME3=subtab.CONT_CLASSNAME3 and" ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","maintab.CONT_KIND_NAME=subtab.CONT_KIND_NAME and" ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","maintab.CONT_TYPE_NAME=subtab.CONT_TYPE_NAME and" ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","maintab.HG_CONT_FLAG=subtab.HG_CONT_FLAG and" ) } 
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","maintab.CONT_ARCH_ID=subtab.CONT_ARCH_ID and" ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","maintab.CONT_NAME=subtab.CONT_NAME and" ) } 
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","maintab.PARTY_A_NAME=subtab.PARTY_A_NAME and" ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","maintab.PARTY_B_NAME=subtab.PARTY_B_NAME and" ) } 
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","maintab.CLOS_FLAG=subtab.CLOS_FLAG and" ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","maintab.CLOS_STAT_DESC=subtab.CLOS_STAT_DESC and" ) } 
maintab.aa=subtab.aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_CODE,STAGE_CODE," ) } 
2

select CONTRACT_NO from f_cost_contw
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

