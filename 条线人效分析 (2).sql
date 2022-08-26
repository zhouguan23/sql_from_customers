select 
DISTINCT BUSI_LINE_NAME
FROM  
f_ehr_manager_struct_d A 
inner join f_ehr_org_struc B ON A.ORG_CODE = B.ORG_ID 
WHERE  B.SMART_ORGNO_FULLPATH  like '%50023969%' -- 房产主业各业务条线名称
and BUSI_LINE_NAME in ("工程","设计","成本","招采","报建","运营","财务","行政","人力")
-- ORDER BY BUSI_LINE_NAME DESC
order by FIND_IN_SET(BUSI_LINE_NAME,'运营,财务,设计,招采,报建,成本,工程,人力,行政')

with TIME AS 
(
select distinct 
the_month
,QUARTER_NAME
from dim_time
where right(the_month,2) in ("03","06","09","12")

) -- 月和月份和半年度对应关系


,TOTAL_1 AS 
(

select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS TOTAL_EMPCN -- 总人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围总人数

,TOTAL_2 AS 
(
select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS TOTAL_EMPCN -- 总人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}'  -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围子层级总人数

,T1 AS 
(

select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS EMPCN -- 人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围条线总人数 

,T2 AS 
(
select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS EMPCN -- 人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
AND c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围子层级条线总人数 

select
c.level -- 所属层级
,c.SMART_ORDER
,B.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,T1.EMPCN -- 条线人数
,TOTAL_EMPCN -- 总人数
,AC_BUILD_PROJ as AC_BUILD_PROJ -- 在建项目数
,CONST_AREA as CONST_AREA -- 在建面积_万平方米
,T1.EMPCN/AC_BUILD_PROJ AS 每1项目配置人数
,T1.EMPCN*10/(CONST_AREA) 每10万方配置人数 -- 底表单位为万M²
,TOTAL_EMPCN/T1.EMPCN AS 服务配置比
from 
f_ehr_org_effi_info_d B 
LEFT JOIN f_ehr_org_struc C -- 关联此表，与下拉树统一组织名称写法
ON B.ORG_CODE=C.ORG_ID
LEFT JOIN (select * from ipt_hr_const_area where the_month = '${pDATES}') D ON B.ORG_CODE=D.COMPANY_ID  -- 限制在建面积补录表的时间为所选月份
LEFT JOIN T1 ON B.ORG_CODE = T1.ORG_CODE
LEFT JOIN TOTAL_1 ON B.ORG_CODE = TOTAL_1.ORG_CODE
WHERE B.TMON = '${pDATES}'  -- 限制时间
and B.ORG_CODE = '${pORG_ID}'

UNION ALL 

select
c.level -- 所属层级
,c.SMART_ORDER
,B.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,T2.EMPCN -- 条线人数
,TOTAL_EMPCN -- 总人数
,AC_BUILD_PROJ as AC_BUILD_PROJ -- 在建项目数
,CONST_AREA as CONST_AREA  -- 在建面积_万平方米
,T2.EMPCN/AC_BUILD_PROJ AS 每1项目配置人数
,T2.EMPCN*10/(CONST_AREA) 每10万方配置人数 -- 底表单位为万M²
,TOTAL_EMPCN/T2.EMPCN AS 服务配置比
from 
f_ehr_org_effi_info_d B 
LEFT JOIN f_ehr_org_struc C -- 关联此表，与下拉树统一组织名称写法
ON B.ORG_CODE=C.ORG_ID
LEFT JOIN (select * from ipt_hr_const_area where the_month = '${pDATES}') D ON B.ORG_CODE=D.COMPANY_ID  -- 限制在建面积补录表的时间为所选月份
LEFT JOIN T2 ON B.ORG_CODE = T2.ORG_CODE
LEFT JOIN TOTAL_2 ON B.ORG_CODE = TOTAL_2.ORG_CODE
WHERE B.TMON = '${pDATES}' -- 限制时间
and B.P_ORG_CODE = '${pORG_ID}'
and c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据

ORDER BY LEVEL,SMART_ORDER


with TOTAL_1 AS 
(

select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS TOTAL_EMPCN -- 总人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围条线总人数

,TOTAL_2 AS 
(
select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS TOTAL_EMPCN -- 总人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
AND c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围子层级条线总人数

, t1 as 
(
select
ORG_CODE -- 组织ID
,SUM(EMPCN) AS 高层
from 
f_ehr_emp_struct_d 
WHERE TMON ='${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and MANAGER_LEVEL = "高层" 
GROUP BY ORG_CODE
) -- 所选范围，高层人数

,t2 as 
(
select
ORG_CODE -- 组织ID
,SUM(EMPCN) AS 中层
from 
f_ehr_emp_struct_d 
WHERE TMON = '${pDATES}'-- 限制时间
and ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and MANAGER_LEVEL = "中层" 
GROUP BY ORG_CODE
) -- 所选范围，中层人数


,t4 as 
(
select
ORG_CODE -- 组织ID
,SUM(EMPCN) AS 基层
from 
f_ehr_emp_struct_d 
WHERE TMON = '${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and MANAGER_LEVEL = "基层" 
GROUP BY ORG_CODE
) -- 所选范围，基层人数


,t5 as 
(
select
ORG_CODE -- 组织ID
,SUM(EMPCN) AS 高层
from 
f_ehr_emp_struct_d 
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and MANAGER_LEVEL = "高层" 
and ORG_LEVEL <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
GROUP BY ORG_CODE
) -- 所选范围子层级，高层人数

,t6 as 
(
select
ORG_CODE -- 组织ID
,SUM(EMPCN) AS 中层
from 
f_ehr_emp_struct_d 
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and MANAGER_LEVEL = "中层" 
and ORG_LEVEL <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
GROUP BY ORG_CODE
) -- 所选范围子层级，中层人数


,t8 as 
(
select
ORG_CODE -- 组织ID
,SUM(EMPCN) AS 基层
from 
f_ehr_emp_struct_d 
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and MANAGER_LEVEL = "基层" 
and ORG_LEVEL <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
GROUP BY ORG_CODE
) -- 所选范围子层级，基层人数


select
TOTAL_1.ORG_CODE
,B.SMART_SHORTNAME
,B.LEVEL
,B.SMART_ORDER
,高层
,高层/TOTAL_EMPCN AS 高层占比
,中层
,中层/TOTAL_EMPCN AS 中层占比
,基层
,基层/TOTAL_EMPCN AS 基层占比
from 
TOTAL_1
LEFT JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON TOTAL_1.ORG_CODE=B.ORG_ID
LEFT JOIN T1 ON TOTAL_1.ORG_CODE=T1.ORG_CODE
LEFT JOIN T2 ON TOTAL_1.ORG_CODE = T2.ORG_CODE
LEFT JOIN T4 ON TOTAL_1.ORG_CODE = T4.ORG_CODE
 -- 所选范围
 
UNION ALL  


select
TOTAL_2.ORG_CODE
,B.SMART_SHORTNAME
,B.LEVEL
,B.SMART_ORDER
,高层
,高层/TOTAL_EMPCN AS 高层占比
,中层
,中层/TOTAL_EMPCN AS 中层占比
,基层
,基层/TOTAL_EMPCN AS 基层占比
from 
TOTAL_2
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON TOTAL_2.ORG_CODE=B.ORG_ID
LEFT JOIN T5 ON TOTAL_2.ORG_CODE=T5.ORG_CODE
LEFT JOIN T6 ON TOTAL_2.ORG_CODE = T6.ORG_CODE
LEFT JOIN T8 ON TOTAL_2.ORG_CODE = T8.ORG_CODE
and B.LEVEL <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
 -- 所选范围子层级

ORDER BY LEVEL,SMART_ORDER

WITH RECURSIVE user_org as
(
  select * from f_ehr_org_struc where ORG_ID in
  (
		select dept_id from fr_user_org_hr
			where user_id='${fr_username}')
  UNION ALL
  select t.* from f_ehr_org_struc t inner join user_org tcte on t.SMART_PARENTID = tcte.ORG_ID
  
) -- 递归获取用户权限下相应的组织ID

, TEMP AS (
SELECT distinct
	ORG_ID -- 组织ID
	,SMART_SHORTNAME -- 组织名称
	,SMART_PARENTID -- 组织父ID
	,LEVEL -- 组织所属层级
	,SMART_ORGNO_FULLPATH
	,SMART_ORDER
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL in (2,3,4) -- 第二至四层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_ORGNO_FULLPATH like '%50023969%' -- 该页面仅房产主业数据
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
and ORG_ID <> 50031939 -- 剔除香港区域
and ORG_ID not in (50020656,50023633,50044186,50022373,50017331,50044909) -- 业务需求，在下拉框中剔除这几个公司不让用户进行筛选
ORDER BY LEVEL
) -- 获得用户权限下，生成下拉树的所需字段，但下一步需要清空根节点的父ID 

SELECT 
ORG_ID
,SMART_SHORTNAME
,CASE WHEN LEVEL = (SELECT DISTINCT MIN(LEVEL) FROM TEMP ) THEN REPLACE(SMART_PARENTID,SMART_PARENTID,"") 
ELSE SMART_PARENTID END AS SMART_PARENTID -- 将根节点（即所属层级为当前最小值的组织ID）其父ID清空，保证下拉树的形式正确及传参正常
FROM TEMP
ORDER BY LEVEL,SMART_ORDER

select distinct quarter_name from dim_time
 where the_month <= left(DATE_ADD(curdate(),INTERVAL -3 month),7)
order by quarter_name desc
limit 1 

select distinct quarter_name from dim_time
 where the_month <= left(DATE_ADD(curdate(),INTERVAL -3 month),7)
order by quarter_name desc
limit 1 

with TOTAL_1 AS 
(

select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS TOTAL_EMPCN -- 总人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围总人数

,TOTAL_2 AS 
(
select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS TOTAL_EMPCN -- 总人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围子层级总人数

,T1 AS 
(

select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS EMPCN -- 人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围条线总人数 

,T2 AS 
(
select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,SUM(EMPCN) AS EMPCN -- 人数
from 
f_ehr_emp_struct_d A
LEFT JOIN f_ehr_org_struc C ON A.ORG_CODE=C.ORG_ID
WHERE TMON = '${pDATES}' -- 限制时间
and P_ORG_CODE = '${pORG_ID}'
AND BUSI_LINE_NAME = '${pLINE}' -- 限制条线
AND c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
) -- 所选范围子层级条线总人数 

select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,T1.EMPCN -- 条线人数
,TOTAL_EMPCN -- 总人数
,sum(AC_BUILD_PROJ) as AC_BUILD_PROJ -- 在建项目数
,sum(AC_BUILD_AREA)/10000 as AC_BUILD_AREA -- 在建面积
,T1.EMPCN/sum(AC_BUILD_PROJ) AS 每1项目配置人数
,T1.EMPCN/(sum(AC_BUILD_AREA)/100000) 每10万方配置人数 -- 底表单位为M²，每10万方故除100000
,TOTAL_EMPCN/T1.EMPCN AS 服务配置比
from 
f_ehr_emp_struct_d A
left join 
f_ehr_org_effi_info_d B 
ON A.ORG_CODE = B.ORG_CODE AND A.TMON=B.TMON
LEFT JOIN f_ehr_org_struc C -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE=C.ORG_ID
LEFT JOIN T1 ON A.ORG_CODE = T1.ORG_CODE
LEFT JOIN TOTAL_1 ON A.ORG_CODE = TOTAL_1.ORG_CODE
WHERE A.TMON = '${pDATES}' -- 限制时间
and A.ORG_CODE = '${pORG_ID}'
AND A.BUSI_LINE_NAME = '${pLINE}' -- 限制条线
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
,TOTAL_EMPCN
,T1.EMPCN 

UNION ALL 


select
c.level -- 所属层级
,A.ORG_CODE -- 组织ID
,C.SMART_SHORTNAME -- 组织名称
,T2.EMPCN -- 条线人数
,TOTAL_EMPCN -- 总人数
,sum(AC_BUILD_PROJ) as AC_BUILD_PROJ -- 在建项目数
,sum(AC_BUILD_AREA)/10000 as AC_BUILD_AREA -- 在建面积_万平方米
,T2.EMPCN/sum(AC_BUILD_PROJ) AS 每1项目配置人数
,T2.EMPCN/(sum(AC_BUILD_AREA)/100000) 每10万方配置人数 -- 底表单位为M²，每10万方故除100000
,TOTAL_EMPCN/T2.EMPCN AS 服务配置比
from 
f_ehr_emp_struct_d A
left join 
f_ehr_org_effi_info_d B 
ON A.ORG_CODE = B.ORG_CODE AND A.TMON=B.TMON
LEFT JOIN f_ehr_org_struc C -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE=C.ORG_ID
LEFT JOIN T2 ON A.ORG_CODE = T2.ORG_CODE
LEFT JOIN TOTAL_2 ON A.ORG_CODE = TOTAL_2.ORG_CODE
WHERE A.TMON = '${pDATES}' -- 限制时间
and A.P_ORG_CODE = '${pORG_ID}'
AND A.BUSI_LINE_NAME = '${pLINE}' -- 限制条线
and c.level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
group by 
c.level 
,A.ORG_CODE
,C.SMART_SHORTNAME 
,TOTAL_EMPCN
,T2.EMPCN 

ORDER BY LEVEL,ORG_CODE



select distinct the_month from dim_time
 where the_month <= left(now(),7)
order by the_month desc


