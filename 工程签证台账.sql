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
FROM f_cost_eng_visa_rept
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

${if(len(QZ_TYPE) == 0,"","and QZ_TYPE in ('" + QZ_TYPE + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_CLASS1_NAME) == 0,"","and CONT_CLASS1_NAME in ('" + CONT_CLASS1_NAME + "')")}
${if(len(CLOS_STATUS) == 0,"","and CLOS_STATUS in ('" + CLOS_STATUS + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(SUPPLY_NAME) == 0,"","and SUPPLY_NAME in ('" + SUPPLY_NAME + "')")}
${if(len(CONTRACT_NO) == 0,"","and CONTRACT_NO in ('" + CONTRACT_NO + "')")}
${if(len(QZ_MON_YG1) != 0&&len(QZ_MON_YG2) != 0," and ((QZ_MON_YG >='"+QZ_MON_YG1+"' and QZ_MON_YG <='"+QZ_MON_YG2+"') or (QZ_MON_SD >='"+QZ_MON_YG1+"' and QZ_MON_SD <='"+QZ_MON_YG2+"') or (FINISH_HZSJ >='"+QZ_MON_YG1+"' and FINISH_HZSJ <='"+QZ_MON_YG2+"'))","")}
${if(len(QZ_MON_YG1) != 0&&len(QZ_MON_YG2) == 0," and (QZ_MON_YG >='"+QZ_MON_YG1+"' or QZ_MON_SD >='"+QZ_MON_YG1+"' or FINISH_HZSJ >='"+QZ_MON_YG1+"')","")}
${if(len(QZ_MON_YG1) = 0&&len(QZ_MON_YG2) != 0," and (QZ_MON_YG <='"+QZ_MON_YG2+"' or QZ_MON_SD <='"+QZ_MON_YG2+"' or FINISH_HZSJ <='"+QZ_MON_YG2+"')","")}

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
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","QZ_TYPE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
'' as aa,
sum(QZ_MONEY_YGSD) as QZ_MONEY_YGSD,
sum(QZ_MONEY_YG) as QZ_MONEY_YG,
sum(QZ_MONEY_SD) as QZ_MONEY_SD,
sum(QZ_CNT_YGSD) as QZ_CNT_YGSD,
sum(QZ_CNT_YG) as QZ_CNT_YG,
sum(QZ_CNT_SD) as QZ_CNT_SD,
sum(QZ_CNT_SH_SD) as QZ_CNT_SH_SD,
sum(QZ_MONEY) as QZ_MONEY
from f_cost_eng_visa_rept
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
${if(len(QZ_TYPE) == 0,"","and QZ_TYPE in ('" + QZ_TYPE + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_CLASS1_NAME) == 0,"","and CONT_CLASS1_NAME in ('" + CONT_CLASS1_NAME + "')")}
${if(len(CLOS_STATUS) == 0,"","and CLOS_STATUS in ('" + CLOS_STATUS + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(SUPPLY_NAME) == 0,"","and SUPPLY_NAME in ('" + SUPPLY_NAME + "')")}

${if(len(QZ_MON_YG1) != 0&&len(QZ_MON_YG2) != 0," and ((QZ_MON_YG >='"+QZ_MON_YG1+"' and QZ_MON_YG <='"+QZ_MON_YG2+"') or (QZ_MON_SD >='"+QZ_MON_YG1+"' and QZ_MON_SD <='"+QZ_MON_YG2+"') or (FINISH_HZSJ >='"+QZ_MON_YG1+"' and FINISH_HZSJ <='"+QZ_MON_YG2+"'))","")}
${if(len(QZ_MON_YG1) != 0&&len(QZ_MON_YG2) == 0," and (QZ_MON_YG >='"+QZ_MON_YG1+"' or QZ_MON_SD >='"+QZ_MON_YG1+"' or FINISH_HZSJ >='"+QZ_MON_YG1+"')","")}
${if(len(QZ_MON_YG1) = 0&&len(QZ_MON_YG2) != 0," and (QZ_MON_YG <='"+QZ_MON_YG2+"' or QZ_MON_SD <='"+QZ_MON_YG2+"' or FINISH_HZSJ <='"+QZ_MON_YG2+"')","")}
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
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","QZ_TYPE," ) } 
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","CONTRACT_NO," ) }
aa) as b 
on
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","a.AREA_NAME=b.AREA_NAME and" ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","a.CITY_NAME=b.CITY_NAME and" ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","a.PROJ_NAME=b.PROJ_NAME and" ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","a.STAGE_NAME=b.STAGE_NAME and a.pron1=b.pron1 and " ) }
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
FROM f_cost_eng_visa_rept
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
FROM f_cost_eng_visa_rept
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
SELECT 
distinct	PROJ_NAME
FROM f_cost_eng_visa_rept
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
FROM f_cost_eng_visa_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT max(W_INSERT_DT) as time FROM f_cost_eng_visa_rept

select distinct
QZ_TYPE
from f_cost_eng_visa_rept

select distinct
CONT_TYPE
from f_cost_eng_visa_rept

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
from f_cost_eng_visa_rept
where 1 = 1
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}
and CONT_CLASS1 in (select sap_DEPT_ID from user_org where ORG_TYPE='合同一级分类' 
)


select distinct
clos_status
from f_cost_eng_visa_rept
where 1 =1
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}

select distinct
CONT_ARCH_NO
from f_cost_eng_visa_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

select distinct
CONT_NAME
from f_cost_eng_visa_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")} 
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_NO in ('" + CONT_ARCH_NO + "')")}

select distinct
SUPPLY_NAME
from f_cost_eng_visa_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and city_name in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(CONT_ARCH_NO) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_NO + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}

select distinct
CONTRACT_NO
from f_cost_eng_visa_rept
where 1=1 
${if(len(AREA_NAME) == 0,"","and AREA_NAME in ('" + AREA_NAME + "')")}
${if(len(CITY_NAME) == 0,"","and CITY_NAME in ('" + CITY_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}

