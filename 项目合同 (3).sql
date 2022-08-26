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
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PARTY_C_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PARTY_E_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_D_NAME," ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CONT_TYPE3," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PAY_METH," ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CLASS1_NAME," ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CLASS2_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","CLASS3_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("24", SPLIT(show, ",")) = 0,"","REL_AGREE_NAME," ) }
${ if(INARRAY("25", SPLIT(show, ",")) = 0,"","REL_AGREE_ARCH_ID," ) }
${ if(INARRAY("27", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("27", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("28", SPLIT(show, ",")) = 0,"","ARCHIVE_DATE," ) }
'' as aa,
sum(NUM) as NUM,
sum(CONT_CNY) as CONT_CNY,
sum(NEWQD_CONT) as NEWQD_CONT,
sum(CONT_AMT_NEW) as CONT_AMT_NEW,
sum(PROJ_BD_CONT) as PROJ_BD_CONT,
sum(PAY_NUM) as PAY_NUM,
sum(paid_amt) as paid_amt,
sum(PRO_SUM) as PRO_SUM,
sum(DYN_CONT) as DYN_CONT,
sum(SUPP_AMT) as SUPP_AMT
FROM 
(
SELECT * FROM `f_po_project_contract` main_tab
/*
left join 
(select distinct b.AREA_ORG_CODE from user_org a  join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   
union select a.sap_dept_id from user_org a where org_type='组织' and DEPT_LEVEL='1'
) area_tab
on main_tab.AREA_CODE=area_tab.AREA_ORG_CODE
 left join 
 (select distinct b.CITY_ORG_CODE from user_org a  join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   
union select a.sap_dept_id from user_org a where org_type='组织' and DEPT_LEVEL='2'
 ) city_tab
 on main_tab.CITY_CODE=city_tab.CITY_ORG_CODE */
 left join
  (  select distinct  b.PROJ_CODE from user_org a join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
	union select a.sap_dept_id from user_org a where org_type='组织' and DEPT_LEVEL='3'    
 )  proj_tab
 on main_tab.PROJECT_NO=proj_tab.PROJ_CODE
 left join 
(select distinct sap_dept_id from user_org where ORG_TYPE='合同一级分类'
 union select distinct sap_dept_id from user_org where ORG_TYPE='事项审批分类'
 union select PRIV_VALUE from fr_user_priv where EMP_ID='${fr_username}'
) con_tab
on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
  -- and ifnull(area_tab.AREA_ORG_CODE,'')!=''
 -- and ifnull(city_tab.CITY_ORG_CODE,'')!=''
  and ifnull(proj_tab.PROJ_CODE,'')!=''
 and ifnull(con_tab.sap_dept_id,'')!=''
)maintab
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJECT_NO in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(PARTY_C_NAME) == 0,"","and PARTY_C_NAME in ('" + PARTY_C_NAME + "')")}
${if(len(CG_PATTERN) == 0,"","and CG_PATTERN in ('" + CG_PATTERN + "')")}
${if(len(CG_WAY) == 0,"","and CG_WAY in ('" + CG_WAY + "')")}
${if(len(CG_CLASS) == 0,"","and CG_CLASS_CODE in ('" + CG_CLASS + "')")}
${if(len(CONT_TYPE) == 0,"","and CONT_TYPE in ('" + CONT_TYPE + "')")}
${if(len(CLASS3_NAME) == 0,"","and CLASS3_NAME in ('" + CLASS3_NAME + "')")}
${if(len(CLASS2_NAME) == 0,"","and CLASS2_NAME in ('" + CLASS2_NAME + "')")}
${if(len(CLASS1_NAME) == 0,"","and CLASS1_NAME in ('" + CLASS1_NAME + "')")}
${if(len(CONT_TYPE3) == 0,"","and CONT_TYPE3 in ('" + CONT_TYPE3 + "')")}
${if(len(PAY_METH) == 0,"","and PAY_METH in ('" + PAY_METH + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(BUS_CONT_NAME) == 0,"","and BUS_CONT_NAME in ('" + BUS_CONT_NAME + "')")}
${if(len(PARTY_D_NAME) == 0,"","and PARTY_D_NAME in ('" + PARTY_D_NAME + "')")}
${if(len(REL_AGREE_NAME) == 0,"","and REL_AGREE_NAME in ('" + REL_AGREE_NAME + "')")}
${if(len(REL_AGREE_ARCH_ID) == 0,"","and REL_AGREE_ARCH_ID in ('" + REL_AGREE_ARCH_ID + "')")}

${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >='" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(CLOS_FLAG) == 0,"","and CLOS_FLAG in('" + CLOS_FLAG + "')")}
${if(len(CLOS_STAT_DESC) == 0,"","and CLOS_STAT_DESC in('" + CLOS_STAT_DESC + "')")}
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PARTY_C_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PARTY_E_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","PARTY_D_NAME," ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CONT_TYPE3," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PAY_METH," ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CLASS1_NAME," ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CLASS2_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","CLASS3_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("24", SPLIT(show, ",")) = 0,"","REL_AGREE_NAME," ) }
${ if(INARRAY("25", SPLIT(show, ",")) = 0,"","REL_AGREE_ARCH_ID," ) }
${ if(INARRAY("27", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("27", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("28", SPLIT(show, ",")) = 0,"","ARCHIVE_DATE," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
aa

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='huafa')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
TEMP_AREA as(
SELECT distinct
	AREA_NAME,area_code
FROM F_PO_PROJECT_CONTRACT
)
SELECT 
AREA_NAME,area_code
FROM TEMP_AREA
where 1=1
and  area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
 union
 select distinct a.sap_dept_id from user_org a
)
union select '铧国' AREA_NAME , 'E0199' area_code

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct CITY_NAME,CITY_CODE
FROM F_PO_PROJECT_CONTRACT
where 1=1 
and AREA_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
and  CITY_CODE in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
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
SELECT distinct PROJECT_NO,PROJ_NAME FROM F_PO_PROJECT_CONTRACT 
where 1=1 
and AREA_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union
 select distinct a.sap_dept_id from user_org a)
 and CITY_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union
 select distinct a.sap_dept_id from user_org a) 
 ${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")} 
 ${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
and  PROJECT_NO in(
	 select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
	  union
 select distinct a.sap_dept_id from user_org a
)

SELECT distinct
STAGE_NAME
FROM F_PO_PROJECT_CONTRACT
where 
1=1
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJECT_NO in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_PO_PROJECT_CONTRACT

SELECT distinct
PARTY_A_NAME
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
PARTY_B_NAME
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
CG_PATTERN
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
CG_WAY
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
CG_CLASS,CG_CLASS_CODE
FROM F_PO_PROJECT_CONTRACT
order by CG_CLASS

SELECT distinct
CONT_TYPE
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
CLASS3_NAME
FROM F_PO_PROJECT_CONTRACT
where 1=1
${if(len(CLASS2_NAME) == 0,"","and CLASS2_NAME in ('" + CLASS2_NAME + "')")}
${if(len(CLASS1_NAME) == 0,"","and CLASS1_NAME in ('" + CLASS1_NAME + "')")}

SELECT distinct
CONT_TYPE3
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
PAY_METH
FROM F_PO_PROJECT_CONTRACT

SELECT distinct
CONT_NAME
FROM F_PO_PROJECT_CONTRACT

select distinct CONT_ARCH_ID from F_PO_PROJECT_CONTRACT

SELECT distinct
CLASS2_NAME
FROM F_PO_PROJECT_CONTRACT
where 1=1
${if(len(CLASS1_NAME) == 0,"","and CLASS1_NAME in ('" + CLASS1_NAME + "')")}

WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
CLASS1_NAME
FROM F_PO_PROJECT_CONTRACT
where 1=1 and CONT_CLASS1 in (select sap_DEPT_ID from user_org where ORG_TYPE='合同一级分类' 
)



WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct BUS_CONT_NAME from f_po_project_contract main
left join 
(
select sap_DEPT_ID from user_org where ORG_TYPE='事项审批分类' 
union 
select PRIV_VALUE from fr_user_priv where EMP_ID='${fine_username}'
)priv
on main.BUS_CONT_TYPE=priv.sap_DEPT_ID
where 1=1 and ifnull(priv.sap_DEPT_ID,'')!=''

SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PARTY_C_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PARTY_E_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","" ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CONT_TYPE3," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PAY_METH," ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CLASS1_NAME," ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CLASS2_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","CLASS3_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }


'' as aa,
sum(NUM) as NUM,
sum(CONT_CNY) as CONT_CNY,
sum(NEWQD_CONT) as NEWQD_CONT,
sum(CONT_AMT_NEW) as CONT_AMT_NEW,
sum(PROJ_BD_CONT) as PROJ_BD_CONT,
sum(PAY_NUM) as PAY_NUM
FROM F_PO_PROJECT_CONTRACT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(city_name) == 0,"","and city_name in ('" + city_name + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}

${if(len(CG_PATTERN) == 0,"","and CG_PATTERN in ('" + CG_PATTERN + "')")}
${if(len(CG_WAY) == 0,"","and CG_WAY in ('" + CG_WAY + "')")}
${if(len(CG_CLASS) == 0,"","and CG_CLASS in ('" + CG_CLASS + "')")}

${if(len(CONT_TYPE) == 0,"","and CONT_TYPE in ('" + CONT_TYPE + "')")}
${if(len(CLASS3_NAME) == 0,"","and CLASS3_NAME in ('" + CLASS3_NAME + "')")}
${if(len(CLASS2_NAME) == 0,"","and CLASS2_NAME in ('" + CLASS2_NAME + "')")}
${if(len(CLASS1_NAME) == 0,"","and CLASS1_NAME in ('" + CLASS1_NAME + "')")}
${if(len(CONT_TYPE3) == 0,"","and CONT_TYPE3 in ('" + CONT_TYPE3 + "')")}
${if(len(PAY_METH) == 0,"","and PAY_METH in ('" + PAY_METH + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(BUS_CONT_NAME) == 0,"","and BUS_CONT_NAME in ('" + BUS_CONT_NAME + "')")}

${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >='" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PARTY_C_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PARTY_E_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","" ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CONT_TYPE3," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PAY_METH," ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CLASS1_NAME," ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CLASS2_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","CLASS3_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
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
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PARTY_C_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PARTY_E_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","" ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CONT_TYPE3," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PAY_METH," ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CLASS1_NAME," ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CLASS2_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","CLASS3_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }


'' as aa,
sum(NUM) as NUM,
sum(CONT_CNY) as CONT_CNY,
sum(NEWQD_CONT) as NEWQD_CONT,
sum(CONT_AMT_NEW) as CONT_AMT_NEW,
sum(PROJ_BD_CONT) as PROJ_BD_CONT,
sum(PAY_NUM) as PAY_NUM,
sum(paid_amt) as paid_amt,
sum(PRO_SUM) as PRO_SUM,
sum(DYN_CONT) as DYN_CONT,
sum(SUPP_AMT) as SUPP_AMT
FROM 
(
SELECT * FROM `f_po_project_contract`
where 1=1
 and AREA_CODE in (select b.AREA_ORG_CODE from user_org a  join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union all select a.sap_dept_id from user_org a)
  and CITY_CODE in (select b.CITY_ORG_CODE from user_org a  join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union all select a.sap_dept_id from user_org a)
and PROJECT_NO in( select a.sap_dept_id from user_org a union all select b.PROJ_CODE from user_org a join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code) 
 and ( CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
       or BUS_CONT_TYPE in (select sap_dept_id from user_org where ORG_TYPE='事项审批分类' ) 
        )
)maintab
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(CG_PATTERN) == 0,"","and CG_PATTERN in ('" + CG_PATTERN + "')")}
${if(len(CG_WAY) == 0,"","and CG_WAY in ('" + CG_WAY + "')")}
${if(len(CG_CLASS) == 0,"","and CG_CLASS_CODE in ('" + CG_CLASS + "')")}
${if(len(CONT_TYPE) == 0,"","and CONT_TYPE in ('" + CONT_TYPE + "')")}
${if(len(CLASS3_NAME) == 0,"","and CLASS3_NAME in ('" + CLASS3_NAME + "')")}
${if(len(CLASS2_NAME) == 0,"","and CLASS2_NAME in ('" + CLASS2_NAME + "')")}
${if(len(CLASS1_NAME) == 0,"","and CLASS1_NAME in ('" + CLASS1_NAME + "')")}
${if(len(CONT_TYPE3) == 0,"","and CONT_TYPE3 in ('" + CONT_TYPE3 + "')")}
${if(len(PAY_METH) == 0,"","and PAY_METH in ('" + PAY_METH + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(BUS_CONT_NAME) == 0,"","and BUS_CONT_NAME in ('" + BUS_CONT_NAME + "')")}

${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >='" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","PARTY_C_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PARTY_E_NAME," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","" ) } 
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CONT_TYPE3," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PAY_METH," ) } 
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","CLASS1_NAME," ) } 
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CLASS2_NAME," ) }
${ if(INARRAY("19", SPLIT(show, ",")) = 0,"","CLASS3_NAME," ) }
${ if(INARRAY("20", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
${ if(INARRAY("21", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECT_NO,STAGE_NO," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CG_CLASS_CODE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CG_PATTERN_CODE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CG_WAY_CODE," ) } 
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","PARTY_A," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","PARTY_B," ) } 
aa

SELECT distinct
PARTY_D_NAME
FROM F_PO_PROJECT_CONTRACT

select distinct REL_AGREE_NAME,REL_AGREE_ARCH_ID from  f_po_project_contract
where 1=1
 ${if(len(AREA_NAME) == 0,"","and AREA_CODE in ('" + AREA_NAME + "')")} 
 ${if(len(CITY_NAME) == 0,"","and CITY_CODE in ('" + CITY_NAME + "')")}
  ${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT distinct
CLOS_FLAG, 
case when CLOS_FLAG ='Y' then '是'  when CLOS_FLAG ='N' THEN '否'  end CLOS_des
FROM F_PO_PROJECT_CONTRACT


SELECT distinct
CLOS_STAT_DESC
FROM F_PO_PROJECT_CONTRACT


SELECT distinct
PARTY_C_NAME
FROM F_PO_PROJECT_CONTRACT

