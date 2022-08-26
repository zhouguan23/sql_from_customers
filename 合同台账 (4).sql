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
union
 select distinct a.sap_dept_id from user_org a
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
FROM f_cost_dashboard 
where 1=1 
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union
 select distinct a.sap_dept_id from user_org a
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union
 select distinct a.sap_dept_id from user_org a
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
FROM f_cost_dashboard
where 1=1 
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union
 select distinct a.sap_dept_id from user_org a
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
union
 select distinct a.sap_dept_id from user_org a
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
union
 select distinct a.sap_dept_id from user_org a
)

SELECT 
distinct	STAGE_NAME
FROM f_cost_dashboard
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
SELECT
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
sum(CONT_AMT) as CONT_AMT,
sum(REP_CONT_AMT) as REP_CONT_AMT,
sum(CURR_SIGN_AMT) as CURR_SIGN_AMT,
sum(CONT_NEW_AMT) as CONT_NEW_AMT,
sum(SUB_CONT_AMT) as SUB_CONT_AMT,
sum(ADJ_CONT_AMT) as ADJ_CONT_AMT,
sum(CONTW_AMT) as CONTW_AMT,
sum(CHG_CN) as CHG_CN,
sum(CHG_AMT) as CHG_AMT,
sum(CHG_CONT_RATE) as CHG_CONT_RATE,
sum(CHG_OFF_SUBCONT_AMT) as CHG_OFF_SUBCONT_AMT,
sum(DUTY_DISC_AMT) as DUTY_DISC_AMT,
sum(OV_AMT) as OV_AMT,
sum(OV_AMT)/sum(CONT_NEW_AMT) as OV_AMT_RATE,
sum(PAYOV_AMT) as PAYOV_AMT,
sum(PREPAY_AMT) as PREPAY_AMT,
sum(PROCESS_PRE_AMT) as PROCESS_PRE_AMT,
sum(UNPAID_PRE_AMT) as UNPAID_PRE_AMT,
sum(PAYABLE_AMT) as PAYABLE_AMT,
sum(PAY_APP_AMT) as PAY_APP_AMT,
sum(PAY_APP_CN) as PAY_APP_CN,
sum(PAID_AMT) as PAID_AMT,
sum(UNPAID_AMT) as UNPAID_AMT,
sum(DIFF_CONT_PAY_AMT) as DIFF_CONT_PAY_AMT,
sum(DIFF_CONT_PAID_AMT) as DIFF_CONT_PAID_AMT,
sum(DIFF_SIGN_PAY_AMT) as DIFF_SIGN_PAY_AMT,
sum(INVOICE_AMT) as INVOICE_AMT,
sum(CLARM_AMT) as CLARM_AMT,
sum(GUARANTEE_AMT) as GUARANTEE_AMT,
sum(PAID_GUARANTEE_AMT) as PAID_GUARANTEE_AMT,
sum(REBACK_GUARANTEE_AMT) as REBACK_GUARANTEE_AMT,
sum(BOD_AMT) as BOD_AMT,
sum(PAID_BOD_AMT) as PAID_BOD_AMT,
sum(REBACK_BOD_AMT) as REBACK_BOD_AMT,
sum(PAID_FINE_AMT) as PAID_FINE_AMT,
sum(UNPAY_FINE_AMT) as UNPAY_FINE_AMT,
sum(UNCANCEL_FINE_AMT) as UNCANCEL_FINE_AMT,
sum(CANCEL_FINE_AMT) as CANCEL_FINE_AMT,

'' as aa
FROM 
(select main_tab.* from f_cost_dashboard main_tab
left join ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) area_tab
 on main_tab.AREA_ORG_CODE=area_tab.AREA_ORG_CODE
left join ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) city_tab
 on main_tab.CITY_ORG_CODE=city_tab.CITY_ORG_CODE
left join ( select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code union
 select distinct a.sap_dept_id from user_org a) proj_tab
 on main_tab.PROJ_CODE=proj_tab.PROJ_CODE
 left join (select distinct  sap_dept_id from user_org where ORG_TYPE='合同一级分类' 
             union select distinct sap_dept_id from user_org where ORG_TYPE='事项审批分类'
              union select distinct PRIV_VALUE from fr_user_priv where EMP_ID='${fr_username}') con_tab
  on (main_tab.CONT_CLASS1=con_tab.sap_dept_id or main_tab.BUS_CONT_TYPE=con_tab.sap_dept_id)
where 1=1
and ifnull(area_tab.AREA_ORG_CODE,'')!=''
and ifnull(city_tab.CITY_ORG_CODE,'')!=''
and ifnull(PROJ_tab.PROJ_CODE,'')!=''
and ifnull(con_tab.sap_dept_id,'')!=''
)a 
where 1=1 

${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}

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
${if(len(CLOS_STAT) == 0,"","and CLOS_STAT_DESC in ('" + CLOS_STAT+ "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}
${if(len(HG_CONT_FLAG) == 0,"","and HG_CONT_FLAG in ('" + HG_CONT_FLAG + "')")}
${if(len(BUS_CONT_NAME) == 0,"","and BUS_CONT_NAME in ('" + BUS_CONT_NAME + "')")}
${if(len(CONTRACT_NO) == 0,"","and CONTRACT_NO in ('" + CONTRACT_NO + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_NAME," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASSNAME3," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_CLASS1," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS2," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_CLASS3," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","CONT_KIND_NAME," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_TYPE_NAME," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("13", SPLIT(show, ",")) = 0,"","CLOS_STAT_DESC," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("16", SPLIT(show, ",")) = 0,"","HG_CONT_FLAG," ) }
${ if(INARRAY("17", SPLIT(show, ",")) = 0,"","BUS_CONT_NAME," ) }
${ if(INARRAY("18", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
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
select distinct CONT_CLASSNAME1 from f_cost_dashboard
where 1=1 and CONT_CLASS1 in (select sap_DEPT_ID from user_org where ORG_TYPE='合同一级分类' 
)


select distinct CONT_CLASSNAME2  from f_cost_dashboard
where 1=1
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}

select distinct CONT_CLASSNAME3  from f_cost_dashboard
where 1=1
${if(len(CONT_CLASSNAME1) == 0,"","and CONT_CLASSNAME1 in ('" + CONT_CLASSNAME1 + "')")}
${if(len(CONT_CLASSNAME2) == 0,"","and CONT_CLASSNAME2 in ('" + CONT_CLASSNAME2 + "')")}

select distinct CONT_KIND_NAME FROM f_cost_dashboard

select distinct CONT_TYPE_NAME FROM f_cost_dashboard

select distinct CLOS_FLAG FROM f_cost_dashboard

select distinct CLOS_STAT_DESC FROM f_cost_dashboard

select CONT_ARCH_ID from f_cost_dashboard
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select CONT_NAME from f_cost_dashboard
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select PARTY_A_NAME from f_cost_dashboard
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CONT_ARCH_ID ) == 0,"","and CONT_ARCH_ID  in ('" + CONT_ARCH_ID  + "')")}


select PARTY_B_NAME from  f_cost_dashboard
where 1=1
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(CONT_ARCH_ID ) == 0,"","and CONT_ARCH_ID  in ('" + CONT_ARCH_ID  + "')")}


WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct BUS_CONT_NAME from f_cost_dashboard main
left join 
(
select sap_DEPT_ID from user_org where ORG_TYPE='事项审批分类' 
union 
select PRIV_VALUE from fr_user_priv where EMP_ID='${fine_username}'
)priv
on main.BUS_CONT_TYPE=priv.sap_DEPT_ID
where 1=1 and ifnull(priv.sap_DEPT_ID,'')!=''


select CONTRACT_NO from f_cost_dashboard
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

