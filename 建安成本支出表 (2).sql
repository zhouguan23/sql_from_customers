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
FROM f_cost_ja
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
FROM f_cost_ja
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
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
distinct	PROJ_NAME,PROJ_CODE
FROM f_cost_ja
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)

SELECT max(W_INSERT_DT) as time FROM f_cost_adjcont

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select * from 
(
select '5001.02' as acc_code2,'项目建设前期费' as acc_name2
union
select '5001.03','建筑安装工程费'
union
select '5001.04','基础设施建设费'
union
select '5001.05','公共配套设施费'
union
select '5001.09','地下室建安成本（按地下室面积计算）'
)a
left join 
(
select 
a.ACC_CODE,a.ACC_NAME,a.DC_OBJ_COST_AMT,a.totalACT_AMT,a.2013ACT_AMT,
a.yearsub3q1ACT_AMT,a.yearsub3q2ACT_AMT,a.yearsub3q3ACT_AMT,a.yearsub3q4ACT_AMT,
a.yearsub2q1ACT_AMT,a.yearsub2q2ACT_AMT,a.yearsub2q3ACT_AMT,a.yearsub2q4ACT_AMT,
a.yearsub1q1ACT_AMT,a.yearsub1q2ACT_AMT,a.yearsub1q3ACT_AMT,a.yearsub1q4ACT_AMT,
${if(month(now()) >= 4 && month(now()) <= 12,"a.thisyearq1ACT_AMT as thisyearq1ACT_AMT,","b.TQ1 as thisyearq1ACT_AMT,")}
${if(month(now()) >= 7 && month(now()) <= 12,"a.thisyearq2ACT_AMT as thisyearq2ACT_AMT,","b.TQ2 as thisyearq2ACT_AMT,")}
${if(month(now()) >= 9 && month(now()) <= 12,"a.thisyearq3ACT_AMT as thisyearq3ACT_AMT,","b.TQ3 as thisyearq3ACT_AMT,")}
b.TQ4 as thisyearq4ACT_AMT,
b.NQ1,B.NQ2,B.NQ3,B.NQ4
from
(
select Total.ACC_CODE,Total.ACC_NAME
,max(Total.DC_OBJ_COST_AMT)  DC_OBJ_COST_AMT
,sum(Total.ACT_AMT) totalACT_AMT
,sum(year2013.ACT_AMT) as 2013ACT_AMT
,sum(yearsub3.yearsub3q1ACT_AMT) yearsub3q1ACT_AMT
,sum(yearsub3.yearsub3q2ACT_AMT) yearsub3q2ACT_AMT
,sum(yearsub3.yearsub3q3ACT_AMT) yearsub3q3ACT_AMT
,sum(yearsub3.yearsub3q4ACT_AMT) yearsub3q4ACT_AMT
,sum(yearsub2.yearsub2q1ACT_AMT) yearsub2q1ACT_AMT
,sum(yearsub2.yearsub2q2ACT_AMT) yearsub2q2ACT_AMT
,sum(yearsub2.yearsub2q3ACT_AMT) yearsub2q3ACT_AMT
,sum(yearsub2.yearsub2q4ACT_AMT) yearsub2q4ACT_AMT
,sum(yearsub1.yearsub1q1ACT_AMT) yearsub1q1ACT_AMT
,sum(yearsub1.yearsub1q2ACT_AMT) yearsub1q2ACT_AMT
,sum(yearsub1.yearsub1q3ACT_AMT) yearsub1q3ACT_AMT
,sum(yearsub1.yearsub1q4ACT_AMT) yearsub1q4ACT_AMT
,sum(thisyear.thisyearq1ACT_AMT) thisyearq1ACT_AMT
,sum(thisyear.thisyearq2ACT_AMT) thisyearq2ACT_AMT
,sum(thisyear.thisyearq3ACT_AMT) thisyearq3ACT_AMT
,sum(thisyear.thisyearq4ACT_AMT) thisyearq4ACT_AMT
from
(SELECT  ACC_CODE,ACC_NAME,TYEAR,QUARTER
, max(DC_OBJ_COST_AMT) as  DC_OBJ_COST_AMT
, sum(ACT_AMT)  as ACT_AMT 
FROM `f_cost_ja`
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
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and STAGE_CODE in ('" + STAGE_CODE + "')")}
and ACC_CODE not in ('5001.01','5001.06','5001.07')
#不显示土地、开发间接费、借款费用
group by  TYEAR,ACC_CODE,ACC_NAME,QUARTER
) as Total   
#列出全部年份季度科目的目标成本和实际成本
left join 
(SELECT  ACC_CODE,ACC_NAME,TYEAR,QUARTER
,sum(ACT_AMT) as ACT_AMT
FROM `f_cost_ja`
where 1=1 and TYEAR<year(DATE_SUB(now(),INTERVAL 3 year))
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and STAGE_CODE in ('" + STAGE_CODE + "')")}
and ACC_CODE not in ('5001.01','5001.06','5001.07')
#不显示土地、开发间接费、借款费用
group by  TYEAR,ACC_CODE,ACC_NAME,QUARTER
) as year2013
on Total.ACC_CODE=year2013.ACC_CODE and Total.Tyear=year2013.Tyear and Total.QUARTER=year2013.QUARTER
#以科目、年度、季度拼接，2013年前的数据
left join 
(SELECT  ACC_CODE,ACC_NAME,TYEAR,QUARTER
,case when QUARTER='Q1' then  sum(ACT_AMT)   else null end  as 'yearsub3q1ACT_AMT' 
,case when QUARTER='Q2' then  sum(ACT_AMT)   else null end  as 'yearsub3q2ACT_AMT' 
,case when QUARTER='Q3' then  sum(ACT_AMT)   else null end  as 'yearsub3q3ACT_AMT' 
,case when QUARTER='Q4' then  sum(ACT_AMT)   else null end  as 'yearsub3q4ACT_AMT' 
FROM `f_cost_ja`
where 1=1  and  TYEAR=year(DATE_SUB(now(),INTERVAL 3 year))
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and STAGE_CODE in ('" + STAGE_CODE + "')")}
and ACC_CODE not in ('5001.01','5001.06','5001.07')
#不显示土地、开发间接费、借款费用
group by  TYEAR,ACC_CODE,ACC_NAME,QUARTER
) as yearsub3
on Total.ACC_CODE=yearsub3.ACC_CODE and Total.Tyear=yearsub3.Tyear and Total.QUARTER=yearsub3.QUARTER
#以现在日期为基准，列算3年前的数据
left join 
(SELECT  ACC_CODE,ACC_NAME,TYEAR,QUARTER
,case when QUARTER='Q1' then  sum(ACT_AMT)   else null end  as 'yearsub2q1ACT_AMT' 
,case when QUARTER='Q2' then  sum(ACT_AMT)   else null end  as 'yearsub2q2ACT_AMT' 
,case when QUARTER='Q3' then  sum(ACT_AMT)   else null end  as 'yearsub2q3ACT_AMT' 
,case when QUARTER='Q4' then  sum(ACT_AMT)   else null end  as 'yearsub2q4ACT_AMT' 
FROM `f_cost_ja`
where 1=1  and  TYEAR=year(DATE_SUB(now(),INTERVAL 2 year))
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and STAGE_CODE in ('" + STAGE_CODE + "')")}
and ACC_CODE not in ('5001.01','5001.06','5001.07')
#不显示土地、开发间接费、借款费用
group by  TYEAR,ACC_CODE,ACC_NAME,QUARTER
) as yearsub2
on Total.ACC_CODE=yearsub2.ACC_CODE and Total.Tyear=yearsub2.Tyear and Total.QUARTER=yearsub2.QUARTER
left join 
(SELECT  ACC_CODE,ACC_NAME,TYEAR,QUARTER
,case when QUARTER='Q1' then  sum(ACT_AMT)   else null end  as 'yearsub1q1ACT_AMT' 
,case when QUARTER='Q2' then  sum(ACT_AMT)   else null end  as 'yearsub1q2ACT_AMT' 
,case when QUARTER='Q3' then  sum(ACT_AMT)   else null end  as 'yearsub1q3ACT_AMT' 
,case when QUARTER='Q4' then  sum(ACT_AMT)   else null end  as 'yearsub1q4ACT_AMT' 
FROM `f_cost_ja`
where 1=1  and  TYEAR=year(DATE_SUB(now(),INTERVAL 1 year))
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and STAGE_CODE in ('" + STAGE_CODE + "')")}
and ACC_CODE not in ('5001.01','5001.06','5001.07')
#不显示土地、开发间接费、借款费用
group by  TYEAR,ACC_CODE,ACC_NAME,QUARTER
) as yearsub1
on Total.ACC_CODE=yearsub1.ACC_CODE and Total.Tyear=yearsub1.Tyear and Total.QUARTER=yearsub1.QUARTER
left join 
(SELECT  ACC_CODE,ACC_NAME,TYEAR,QUARTER
,case when QUARTER='Q1' then  sum(ACT_AMT)   else null end  as 'thisyearq1ACT_AMT' 
,case when QUARTER='Q2' then  sum(ACT_AMT)   else null end  as 'thisyearq2ACT_AMT' 
,case when QUARTER='Q3' then  sum(ACT_AMT)   else null end  as 'thisyearq3ACT_AMT' 
,case when QUARTER='Q4' then  sum(ACT_AMT)   else null end  as 'thisyearq4ACT_AMT' 
FROM `f_cost_ja`
where 1=1  and  TYEAR=year(now())
and area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and STAGE_CODE in ('" + STAGE_CODE + "')")}
and ACC_CODE not in ('5001.01','5001.06','5001.07')
#不显示土地、开发间接费、借款费用
group by  TYEAR,ACC_CODE,ACC_NAME,QUARTER
) as thisyear
on Total.ACC_CODE=thisyear.ACC_CODE and Total.Tyear=thisyear.Tyear and Total.QUARTER=thisyear.QUARTER
#列算本年各季度
 group by Total.ACC_CODE,Total.ACC_NAME
)a
left join 
(select * 
from fr_cost_buildsafeamt 
where STAGE_CODE='${STAGE_CODE}' and TYEAR=year(now()))b
on a.acc_code=b.acc_code
)b
on a.acc_code2=b.acc_code

SELECT 
distinct	Stage_NAME,stage_code
FROM f_cost_ja
where 1=1 
${if(len(AREA_ORG_NAME) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_NAME + "')")}
${if(len(CITY_ORG_NAME) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_NAME + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}

