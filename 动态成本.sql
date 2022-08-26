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
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_DES," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FTSX," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","ACC_CODE,ACC_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${if(show != 7,"","ACC_NAME,")}
${if(show != 7,"","ACC_CODE,")}
sum(DC_OBJ_COST_ADJ_AMT) as DC_OBJ_COST_ADJ_AMT, -- C版目标成本(A1)
sum(DC_OBJ_ADJ_AMT) as DC_OBJ_ADJ_AMT, -- 调整(A2)
sum(DC_OBJ_ADJREL_AMT) as DC_OBJ_ADJREL_AMT, -- 调剂(A3)
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT, -- 调整或调剂后C版目标成本
sum(DC_HYGH_AMT) as DC_HYGH_AMT, -- 合约规划金额
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT, -- 动态成本金额（含税）
sum(DC_DIFF_AMT) as DC_DIFF_AMT, -- 科目结余成本(动态成本偏差额)
case when sum(DC_OBJ_COST_AMT)=0 then '' else sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT) end as DIFF_RATE, -- 超支/结余率(动态成本偏差率)
sum(DC_CTR_SIGN_AMT) as DC_CTR_SIGN_AMT, -- 已签合同金额
sum(DC_PROVISIONAL_AMT) as DC_PROVISIONAL_AMT, -- 其中：暂列金额及暂估价
sum(DC_REPEAT_WITHOUT_AMT) as DC_REPEAT_WITHOUT_AMT, -- 重量度调整金额(还未签订补充协议)
sum(DC_REPEAT_WITH_AMT) as DC_REPEAT_WITH_AMT, -- 重新量度调整金额(已签订补充协议)
sum(DC_CTR_ADJ_AMT) as DC_CTR_ADJ_AMT, -- 非重量度调整金额（还未签订补充协议）
sum(DC_SUP_AGR_AMT) as DC_SUP_AGR_AMT, -- 非重量度调整金额（已签订补充协议）
sum(DC_EXTR_FEE_AMT) as DC_EXTR_FEE_AMT, -- 合同外费用金额
sum(DC_DES_CHNG_AMT) as DC_DES_CHNG_AMT, -- 设计变更H(含税)
sum(DC_PROJ_VISA_AMT) as DC_PROJ_VISA_AMT, -- 现场签证金额
sum(DC_CTR_SETTLE_AMT) as DC_CTR_SETTLE_AMT, -- 结算金额
sum(DC_COST_INCURRED_AMT) as DC_COST_INCURRED_AMT, -- 已发生成本合计
sum(DC_CTR_DEC_AMT) as DC_CTR_DEC_AMT, -- 合约分解待发生金额D(含税)
sum(DC_TO_BE_AMT) as DC_TO_BE_AMT, -- 待发生变更J(含税)
aa
from
(
select AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,PRODTYPE_COMP_DES,FTSX,ACC_NAME,ACC_CODE,
sum(DC_OBJ_COST_ADJ_AMT) as DC_OBJ_COST_ADJ_AMT, -- C版目标成本(A1)
sum(DC_OBJ_ADJ_AMT) as DC_OBJ_ADJ_AMT, -- 调整(A2)
sum(DC_OBJ_ADJREL_AMT) as DC_OBJ_ADJREL_AMT, -- 调剂(A3)
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT, -- 调整或调剂后C版目标成本
sum(DC_HYGH_AMT) as DC_HYGH_AMT, -- 合约规划金额
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT, -- 动态成本金额（含税）
sum(DC_DIFF_AMT) as DC_DIFF_AMT, -- 科目结余成本(动态成本偏差额)
case when sum(DC_OBJ_COST_AMT)=0 then '' else sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT) end as DIFF_RATE, -- 超支/结余率(动态成本偏差率)
sum(DC_CTR_SIGN_AMT) as DC_CTR_SIGN_AMT, -- 已签合同金额
sum(DC_PROVISIONAL_AMT) as DC_PROVISIONAL_AMT, -- 其中：暂列金额及暂估价
sum(DC_REPEAT_WITHOUT_AMT) as DC_REPEAT_WITHOUT_AMT, -- 重量度调整金额(还未签订补充协议)
sum(DC_REPEAT_WITH_AMT) as DC_REPEAT_WITH_AMT, -- 重新量度调整金额(已签订补充协议)
sum(DC_CTR_ADJ_AMT) as DC_CTR_ADJ_AMT, -- 非重量度调整金额（还未签订补充协议）
sum(DC_SUP_AGR_AMT) as DC_SUP_AGR_AMT, -- 非重量度调整金额（已签订补充协议）
sum(DC_EXTR_FEE_AMT) as DC_EXTR_FEE_AMT, -- 合同外费用金额
sum(DC_DES_CHNG_AMT) as DC_DES_CHNG_AMT, -- 设计变更H(含税)
sum(DC_PROJ_VISA_AMT) as DC_PROJ_VISA_AMT, -- 现场签证金额
sum(DC_CTR_SETTLE_AMT) as DC_CTR_SETTLE_AMT, -- 结算金额
sum(DC_COST_INCURRED_AMT) as DC_COST_INCURRED_AMT, -- 已发生成本合计
sum(DC_CTR_DEC_AMT) as DC_CTR_DEC_AMT, -- 合约分解待发生金额D(含税)
sum(DC_TO_BE_AMT) as DC_TO_BE_AMT, -- 待发生变更J(含税)
'' as aa
FROM f_cost_dyncost
where 1=1 
and PRODTYPE_COMP_DES is not null #and ACC_CODE='5001'
and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)

${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}


${if(len(ACC_CODE) == 0,"","and ACC_CODE in ('" + ACC_CODE + "')")}
${if(len(PRODTYPE_COMP_DES) == 0,"","and PRODTYPE_COMP_DES in ('" + PRODTYPE_COMP_DES + "')")}

and ZLEVEL <= '${KLEVEL}'

${if(FTSX == 'Y',"and FTSX='Y'","and FTSX ='N'")}
${if(PeriodOfValidity == '1',"","and DC_OBJ_COST_ZERO_FLAG='Y'")}
#分期的汇总目标成本为0时，标识N，否则Y
group by AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE
,PRODTYPE_COMP_DES,FTSX,ACC_NAME,ACC_CODE,aa

)maintab
where 1=1 
 -- and ifnull(DC_DIFF_AMT,0)<0  
    ${if(len(DC_DIFF_RATE_AMT1) == 0,"","and DIFF_RATE>'" + DC_DIFF_RATE_AMT1 + "'")}
    ${if(len(DC_DIFF_RATE_AMT2) == 0,"","and DIFF_RATE<'" + DC_DIFF_RATE_AMT2 + "'")}
		
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) }  
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_DES," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FTSX," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","ACC_CODE,ACC_NAME," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${if(show != 7,"","ACC_NAME,")}
${if(show != 7,"","ACC_CODE,")}
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) } 
${if(show != 7,"","ACC_CODE,")}
aa

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
select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
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
FROM F_COST_DYNCOST
where 1=1 and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}


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
FROM F_COST_DYNCOST
where 1=1 
and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}


SELECT 
distinct	STAGE_NAME
FROM F_COST_DYNCOST
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"","and PROJ_NAME in ('" + PROJ_NAME + "')")}

SELECT DISTINCT CONCAT(PERIOD_WID,"-01 ") as time FROM F_COST_DYNCOST

SELECT 
distinct	CONCAT(ACC_CODE,CONCAT(' ',ACC_NAME)) as ACC_NAME,ACC_CODE,ZLEVEL
FROM F_COST_DYNCOST
where 1=1
and ZLEVEL <= '${KLEVEL}'
order by ACC_CODE,ZLEVEL

SELECT 
distinct	PRODTYPE_COMP_DES
FROM F_COST_DYNCOST
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
SELECT
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_DES," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_CODE," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${if(len(ZLEVEL) == 0,"","ACC_NAME,")}
${if(len(ZLEVEL) == 0,"","ACC_CODE,")}
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT,
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT,
sum(DC_DIFF_AMT) as DC_DIFF_AMT,
'' as aa
FROM f_cost_dyncost
where 1=1 
and PRODTYPE_COMP_DES is not null and ftsx='N'

${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and AREA_ORG_NAME in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and CITY_ORG_NAME in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and PROJ_NAME in ('" + PROJ_NAME + "')")}

${if(PeriodOfValidity == '1',"","and DC_OBJ_COST_AMT>0")}
${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ACC_CODE) == 0,"","and ACC_CODE in ('" + ACC_CODE + "')")}
${if(len(PRODTYPE_COMP_DES) == 0,"","and PRODTYPE_COMP_DES in ('" + PRODTYPE_COMP_DES + "')")}
${if(len(ZLEVEL) == 0,"","and ZLEVEL <=" + ZLEVEL)}

group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_DES," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_CODE," ) }
${if(len(ZLEVEL) == 0,"","ACC_NAME,")}
${if(len(ZLEVEL) == 0,"","ACC_CODE,")}
aa
having 1=1
${if(len(DC_DIFF_RATE_AMT1) == 0,"","and sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)*100>'" + DC_DIFF_RATE_AMT1 + "'")}
${if(len(DC_DIFF_RATE_AMT2) == 0,"","and sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)*100<'" + DC_DIFF_RATE_AMT2 + "'")}
		
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_CODE," ) }
${if(len(ZLEVEL) == 0,"","ACC_CODE,")}
aa


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_DES," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_CODE," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FTSX," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${if(len(ZLEVEL) == 0,"","ACC_NAME,")}
${if(len(ZLEVEL) == 0,"","ACC_CODE,")}
sum(DC_OBJ_COST_AMT) as DC_OBJ_COST_AMT,
sum(DC_DYN_COST_AMT) as DC_DYN_COST_AMT,
sum(DC_DIFF_AMT) as DC_DIFF_AMT,
'' as aa
FROM f_cost_dyncost
where 1=1 
and PRODTYPE_COMP_DES is not null

${if(len(AREA_ORG_NAME) == 0,"and AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"and CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_NAME) == 0,"and PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and PROJ_NAME in ('" + PROJ_NAME + "')")}


${if(len(STAGE_NAME) == 0,"","and STAGE_NAME in ('" + STAGE_NAME + "')")}
${if(len(ACC_CODE) == 0,"","and ACC_CODE in ('" + ACC_CODE + "')")}
${if(len(PRODTYPE_COMP_DES) == 0,"","and PRODTYPE_COMP_DES in ('" + PRODTYPE_COMP_DES + "')")}
${if(len(ZLEVEL) == 0,"","and ZLEVEL <=" + ZLEVEL)}
${if(FTSX == 'Y',"and ftsx='Y'","and ftsx='N'")}
group by

${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE," ) } 
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_DES," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FTSX," ) }
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_CODE," ) }
${if(len(ZLEVEL) == 0,"","ACC_NAME,")}
${if(len(ZLEVEL) == 0,"","ACC_CODE,")}
aa
having 1=1
${if(len(DC_DIFF_RATE_AMT1) == 0,"","and sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)*100>'" + DC_DIFF_RATE_AMT1 + "'")}
${if(len(DC_DIFF_RATE_AMT2) == 0,"","and sum(DC_DIFF_AMT)/sum(DC_OBJ_COST_AMT)*100<'" + DC_DIFF_RATE_AMT2 + "'")}
${if(PeriodOfValidity == '1',"","and sum(ifnull(DC_OBJ_COST_AMT,0))!=0")}
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREA_ORG_CODE," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITY_ORG_CODE," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJ_CODE," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","STAGE_CODE," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODTYPE_COMP_CODE," ) }
${if(len(ZLEVEL) == 0,"","ACC_CODE,")}
aa

