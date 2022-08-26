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
b.* ,a.CONT_MONEY,a.CONT_MONEY_NOW,a.CONT_MONEY_NEW,a.CONT_CNY_RE
FROM 
(SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS1_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_TYPE3_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_ARCH_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUPPLY_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }

'' as aa,
sum(CONT_MONEY) as CONT_MONEY,
sum(CONT_MONEY_NOW) as CONT_MONEY_NOW,
sum(CONT_MONEY_NEW) as CONT_MONEY_NEW,
sum(CONT_CNY_RE) as CONT_CNY_RE
FROM (SELECT distinct
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as pron1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS1_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_TYPE3_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_ARCH_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUPPLY_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
CONT_MONEY,
CONT_MONEY_NOW,
CONT_MONEY_NEW,
CONT_CNY_RE
FROM f_cost_design_change_rept
where 1=1
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and PROJECT_NO in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
  and CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}


${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(BG_TYPE) == 0,"","and BG_TYPE in ('" + BG_TYPE + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_CLASS1_NAME) == 0,"","and CONT_CLASS1_NAME in ('" + CONT_CLASS1_NAME + "')")}
${if(len(CLOS_STATUS) == 0,"","and CLOS_STATUS in ('" + CLOS_STATUS + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(SUPPLY_NAME) == 0,"","and SUPPLY_NAME in ('" + SUPPLY_NAME + "')")}
${if(len(CONTRACT_NO) == 0,"","and CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BG_MON_YG1) != 0&&len(BG_MON_YG2) != 0,
" and ((BG_MON_YG >='"+BG_MON_YG1+"' and BG_MON_YG <='"+BG_MON_YG2+"')
or (BG_MON_SD >='"+BG_MON_YG1+"' and BG_MON_SD <='"+BG_MON_YG2+"')
or (FINISH_HZSJ >='"+BG_MON_YG1+"' and FINISH_HZSJ <='"+BG_MON_YG2+"'))","")}
${if(len(BG_MON_YG1) != 0&&len(BG_MON_YG2) == 0,
" and (BG_MON_YG >='"+BG_MON_YG1+"'
or BG_MON_SD >='"+BG_MON_YG1+"' 
or FINISH_HZSJ >='"+BG_MON_YG1+"')","")}
${if(len(BG_MON_YG1) = 0&&len(BG_MON_YG2) != 0,
" and (BG_MON_YG <='"+BG_MON_YG2+"'
or BG_MON_SD <='"+BG_MON_YG2+"' 
or FINISH_HZSJ <='"+BG_MON_YG2+"')","")}
) as a
GROUP BY
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","pron1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS1_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_TYPE3_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_ARCH_NO," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUPPLY_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
aa) as a
inner join
(select
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME as pron1,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS1_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_TYPE3_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_ARCH_NO," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CLOS_STATUS," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"",
"case clos_flag 
when 'Y' then '是' 
when 'N' then '否' 
else clos_flag end as 合同是否需要结算," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUPPLY_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","BG_TYPE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
'' as aa,
sum(BG_MONEY_YGSD) as BG_MONEY_YGSD,
sum(BG_MONEY_YG) as BG_MONEY_YG,
sum(BG_MONEY_SD) as BG_MONEY_SD,
sum(BG_CNT_YGSD) as BG_CNT_YGSD,
sum(BG_CNT_YG) as BG_CNT_YG,
sum(BG_CNT_SD) as BG_CNT_SD,
sum(BG_CNT_SH_SD) as BG_CNT_SH_SD,
sum(BG_MONEY) as BG_MONEY
from F_COST_DESIGN_CHANGE_REPT
where 1=1
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and PROJECT_NO in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
  and CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

${if(len(BG_TYPE) == 0,"","and BG_TYPE in ('" + BG_TYPE + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_CLASS1_NAME) == 0,"","and CONT_CLASS1_NAME in ('" + CONT_CLASS1_NAME + "')")}
${if(len(CLOS_STATUS) == 0,"","and CLOS_STATUS in ('" + CLOS_STATUS + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(SUPPLY_NAME) == 0,"","and SUPPLY_NAME in ('" + SUPPLY_NAME + "')")}
${if(len(CONTRACT_NO) == 0,"","and CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(BG_MON_YG1) != 0&&len(BG_MON_YG2) != 0,
" and ((BG_MON_YG >='"+BG_MON_YG1+"' and BG_MON_YG <='"+BG_MON_YG2+"')
or (BG_MON_SD >='"+BG_MON_YG1+"' and BG_MON_SD <='"+BG_MON_YG2+"')
or (FINISH_HZSJ >='"+BG_MON_YG1+"' and FINISH_HZSJ <='"+BG_MON_YG2+"'))","")}
${if(len(BG_MON_YG1) != 0&&len(BG_MON_YG2) == 0,
" and (BG_MON_YG >='"+BG_MON_YG1+"'
or BG_MON_SD >='"+BG_MON_YG1+"' 
or FINISH_HZSJ >='"+BG_MON_YG1+"')","")}
${if(len(BG_MON_YG1) = 0&&len(BG_MON_YG2) != 0,
" and (BG_MON_YG <='"+BG_MON_YG2+"'
or BG_MON_SD <='"+BG_MON_YG2+"' 
or FINISH_HZSJ <='"+BG_MON_YG2+"')","")}

group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECT_NO," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","CONT_TYPE," ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","CONT_CLASS1_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","CONT_TYPE3_NAME," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_NAME," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CONT_ARCH_NO," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CLOS_STATUS," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","CLOS_FLAG," ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","合同是否需要结算," ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUPPLY_NAME," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","BG_TYPE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
aa) as b 
on
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","a.AREA_NAME=b.AREA_NAME and" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","a.CITY_NAME=b.CITY_NAME and" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","a.PROJ_NAME=b.PROJ_NAME and" ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","a.STAGE_NAME=b.STAGE_NAME and  a.pron1=b.pron1 and" ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","a.CONT_TYPE=b.CONT_TYPE and" ) } 
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","a.CONT_CLASS1_NAME=b.CONT_CLASS1_NAME and" ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","a.CONT_TYPE3_NAME=b.CONT_TYPE3_NAME and" ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","" ) }
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","a.CONT_NAME=b.CONT_NAME and" ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","a.CONT_ARCH_NO=b.CONT_ARCH_NO and" ) }
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","a.SUPPLY_NAME=b.SUPPLY_NAME and" ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","a.CONTRACT_NO=b.CONTRACT_NO and" ) }
a.aa=b.aa

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
	AREA_NAME
FROM F_COST_DESIGN_CHANGE_REPT
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
distinct	city_name
FROM F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
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

SELECT distinct	
PROJ_NAME 
FROM F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
and area_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and PROJECT_NO in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)

SELECT 
distinct	STAGE_NAME
FROM F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(city_name) == 0,"","and city_name in ('" + city_name + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM F_COST_DESIGN_CHANGE_REPT

select distinct
BG_TYPE
from F_COST_DESIGN_CHANGE_REPT

select distinct
CONT_ARCH_NO
from F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}

WITH RECURSIVE user_org as
(
select a.* from fr_org a
left join fr_user_org b
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type
			where user_id='${fine_username}'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct
CONT_CLASS1_NAME
from F_COST_DESIGN_CHANGE_REPT
where 1 = 1
  and CONT_CLASS1 in (select sap_dept_id from user_org where ORG_TYPE='合同一级分类' )
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}

select distinct
clos_status
from F_COST_DESIGN_CHANGE_REPT
where 1 = 1
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}

select distinct
CONT_NAME
from F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}

select distinct
SUPPLY_NAME
from F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and city_name in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}

select distinct
CONTRACT_NO
from F_COST_DESIGN_CHANGE_REPT
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}

