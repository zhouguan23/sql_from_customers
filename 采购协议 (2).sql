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
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FROM_DATE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","TO_DATE," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUP_LEVEL," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","ARCHIVE_DATE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
'' as aa,
sum(SIGN_AMT) as SIGN_AMT,
count(1) as AGREE_CN,
sum(SUB_CONT_CN) as SUB_CONT_CN,
sum(SUB_NEWCONT_AMT) as SUB_NEWCONT_AMT,
sum(SUB_AGREE_CN) as SUB_AGREE_CN,
sum(paid_amt) as paid_amt

FROM (select *,case when FROM_DATE<=DATE_FORMAT(now(),'%Y%m%d')  then 'N'
		 when FROM_DATE>=DATE_FORMAT(now(),'%Y%m%d') and FROM_DATE<=DATE_FORMAT(now(),'%Y%m%d') then 'Y' else null end as POV 
		 from f_po_proc_agree
		 where 1=1 and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union select distinct a.sap_dept_id from user_org a)
		 and CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code   union select distinct a.sap_dept_id from user_org a)
		 and CATEGORY in (select sap_dept_id from user_org where ORG_TYPE='立项分类')
		 )a

where 1=1 
${if(len(TO_DATE1) == 0,"","and TO_DATE >= '" + TO_DATE1 + "'")}
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}

${if(len(PeriodOfValidity) == 0,"","and POV in ('" + PeriodOfValidity + "')")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}

${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(SUP_LEVEL) == 0,"","and SUP_LEVEL in ('" + SUP_LEVEL + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}
${if(len(CATEGORY_NAME) == 0,"","and CATEGORY_NAME in ('" + CATEGORY_NAME + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FROM_DATE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","TO_DATE," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUP_LEVEL," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) }
${ if(INARRAY("14", SPLIT(show, ",")) = 0,"","CATEGORY_NAME," ) }
${ if(INARRAY("15", SPLIT(show, ",")) = 0,"","ARCHIVE_DATE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) } 
aa


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
TEMP_AREA AS(
SELECT distinct
	AREA_ORG_NAME,AREA_ORG_CODE
from f_po_proc_agree
)
SELECT
AREA_ORG_NAME,AREA_ORG_CODE
FROM TEMP_AREA
where area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
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
SELECT 
distinct CITY_ORG_NAME,CITY_ORG_CODE
from f_po_proc_agree
where 1=1 
and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code   union
 select distinct a.sap_dept_id from user_org a)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
and CITY_ORG_CODE in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
  union
 select distinct a.sap_dept_id from user_org a
)


SELECT max(W_INSERT_DT) as time FROM F_COST_DYNCOST


select  distinct SUP_TYPE,SUP_TYPE_NAME from f_po_proc_agree  
order by SUP_TYPE

select distinct  PROC_MODE,PROC_MODE_NAME from f_po_proc_agree

select distinct  PROC_WAY_NAME from f_po_proc_agree

SELECT distinct
PARTY_A_NAME
from f_po_proc_agree

SELECT distinct
PARTY_B_NAME
from f_po_proc_agree

select distinct 
SUP_LEVEL
from f_po_proc_agree

SELECT distinct
CONT_ARCH_ID
from f_po_proc_agree

SELECT distinct
CONT_NAME
from f_po_proc_agree

SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FROM_DATE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","TO_DATE," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUP_LEVEL," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }

'' as aa,
sum(SIGN_AMT) as SIGN_AMT,
count(1) as AGREE_CN,
sum(SUB_CONT_CN) as SUB_CONT_CN,
sum(SUB_NEWCONT_AMT) as SUB_NEWCONT_AMT,
sum(SUB_AGREE_CN) as SUB_AGREE_CN

FROM f_po_proc_agree

where 1=1 
${if(len(ARCHIVE_DATE1) == 0,"","and ARCHIVE_DATE >= '" + ARCHIVE_DATE1 + "'")}
${if(len(ARCHIVE_DATE2) == 0,"","and ARCHIVE_DATE <= '" + ARCHIVE_DATE2 + "'")}

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(PeriodOfValidity == '1'," and TO_DATE>=DATE_FORMAT(now(),'%Y%m%d') and FROM_DATE<=DATE_FORMAT(now(),'%Y%m%d')"," and TO_DATE<=DATE_FORMAT(now(),'%Y%m%d') ")}
${if(len(SUP_TYPE_NAME) == 0,"","and SUP_TYPE_NAME in ('" + SUP_TYPE_NAME + "')")}
${if(len(PARTY_A_NAME) == 0,"","and PARTY_A_NAME in ('" + PARTY_A_NAME + "')")}
${if(len(PARTY_B_NAME) == 0,"","and PARTY_B_NAME in ('" + PARTY_B_NAME + "')")}

${if(len(TO_DATE) == 0,"","and TO_DATE in ('" + TO_DATE + "')")}
${if(len(CONT_ARCH_ID) == 0,"","and CONT_ARCH_ID in ('" + CONT_ARCH_ID + "')")}
${if(len(SUP_LEVEL) == 0,"","and SUP_LEVEL in ('" + SUP_LEVEL + "')")}
${if(len(CONT_NAME) == 0,"","and CONT_NAME in ('" + CONT_NAME + "')")}
${if(len(PROC_MODE_NAME) == 0,"","and PROC_MODE_NAME in ('" + PROC_MODE_NAME + "')")}
${if(len(PROC_WAY_NAME) == 0,"","and PROC_WAY_NAME in ('" + PROC_WAY_NAME + "')")}

group by
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FROM_DATE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","TO_DATE," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUP_LEVEL," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","CONT_ARCH_ID," ) } 
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","CONT_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PARTY_A_NAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","PARTY_B_NAME," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FROM_DATE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","TO_DATE," ) } 
${ if(INARRAY("9", SPLIT(show, ",")) = 0,"","SUP_TYPE_NAME," ) } 
${ if(INARRAY("10", SPLIT(show, ",")) = 0,"","SUP_LEVEL," ) }
${ if(INARRAY("11", SPLIT(show, ",")) = 0,"","PROC_MODE_NAME," ) }
${ if(INARRAY("12", SPLIT(show, ",")) = 0,"","PROC_WAY_NAME," ) }

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
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
select distinct CATEGORY_NAME FROM f_po_proc_agree
where CATEGORY in (select sap_DEPT_ID from user_org where ORG_TYPE='立项分类'
)

