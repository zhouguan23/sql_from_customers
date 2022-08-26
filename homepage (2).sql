${IF(ROLE_LV<> 1 ,"/*","")}
select 
to_char(YWRQ,'yyyy') AS 年,
SUM(ZJSRHJ)/10000 AS 资金流入,
SUM(ZJZCHJ)/10000 AS 资金流出,
(SUM(ZJSRHJ)-SUM(ZJZCHJ))/10000 AS 本年收支差
from FR_R_NCF_TOTAL
where to_char(YWRQ,'yyyy')=to_char(SYSDATE,'yyyy')
and CWZQ IS NULL
GROUP BY to_char(YWRQ,'yyyy')
${IF(ROLE_LV<> 1 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 1 ,"/*","")}
--经营收入
select 
sum(BHSJE)/10000 as 本年累计
from FR_R_MAIN_BUSINESS_INCOME
where SRLX='服务收入' 
and YEAR=TO_CHAR(SYSDATE,'YYYY')
AND MONTH<=TO_CHAR(SYSDATE,'MM')

${IF(ROLE_LV<> 1 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 1 ,"/*","")}
--经营收入
select 
sum(BHSJE)/10000 as 本年累计
from FR_R_MAIN_BUSINESS_INCOME
where
YEAR=TO_CHAR(SYSDATE,'YYYY')
AND MONTH<=TO_CHAR(SYSDATE,'MM')
AND SRLX in('服务收入','贸易收入')
${IF(ROLE_LV<> 1 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 1 ,"/*","")}
with Q as (
select 
YWRQ as 年月,
YEAR as 年,
MONTH as 月,
sum(不含税金额)/10000 as 本月 --,
--lag(sum(不含税金额)/10000, 12, 0)over(order by to_char(业务日期,'yyyy-mm') asc) as 去年本月
from (
select 
YWRQ,YEAR,MONTH,
BHSJE as 不含税金额,
BMBM as 部门编码
from FR_R_MAIN_BUSINESS_COST
where zclx <> '协同成本'
)
--where 部门编码='36'--筛选
group by YWRQ,YEAR,MONTH
order by YEAR,MONTH asc
)

,R as (select 年,sum(本月) as 去年同期汇总
from Q
where 1=1
and 年=to_number(to_char(SYSDATE,'yyyy'))-1
and 月<=to_number(to_char(SYSDATE,'mm'))
group by 年)

,T as (select 年,sum(本月) as 本年同期汇总
from Q
where 1=1
and 年=to_number(to_char(SYSDATE,'yyyy'))
and 月<=to_number(to_char(SYSDATE,'mm'))
group by 年)

select a.*,c.*,b.*
from Q a left join T c on a.年=c.年 
left join R b on a.年=b.年+1
where 年月=TO_CHAR(SYSDATE,'yyyy-MM')
${IF(ROLE_LV<> 1 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 1 ,"/*","")}
with Q as (
select 
YWRQ as 年月,
YEAR as 年,
MONTH as 月,
sum(不含税金额)/10000 as 本月
from (
select 
	CASE WHEN aa.YEAR_MONTH IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE aa.YEAR_MONTH END AS YWRQ,
 TO_CHAR(CASE WHEN aa.YEAR_MONTH IS NULL THEN SYSDATE ELSE TO_DATE(aa.YEAR_MONTH,'YYYY-MM') END,'YYYY') AS YEAR,
	TO_CHAR(CASE WHEN aa.YEAR_MONTH IS NULL THEN SYSDATE ELSE TO_DATE(aa.YEAR_MONTH,'YYYY-MM') END,'MM') AS MONTH,
  aa.SGSZJSY+aa.QTTZ1+aa.QTTZ2+aa.QTTZ3+aa.QTTZ4+aa.QTTZ5+aa.QTTZ6+aa.QTTZ7 as 不含税金额,
  TO_CHAR(hh.fnumber) as 部门编码
FROM FR_BM_DASHBOARD_O_MONEY aa
LEFT JOIN T_DXQ_ProjectItem  ff  ON aa.PROJ_ID=ff.fnumber --项目
LEFT JOIN T_ORG_BaseUnit  gg ON ff.CFADMINORUNITID=gg.FID --部门
LEFT JOIN T_ORG_BaseUnit  hh ON ff.CFBIZORGID=hh.FID --业务科室
LEFT JOIN T_BD_Person  ii ON ff.FProjectManagerID=ii.FID  --项目经理
)
--where 部门编码='36'--筛选
group by YWRQ,YEAR,MONTH
order by YEAR,MONTH asc
)

,R as (select 年,sum(本月) as 去年同期汇总
from Q
where 1=1
and 年=to_number(to_char(SYSDATE,'yyyy'))-1
and 月<=to_number(to_char(SYSDATE,'mm'))
group by 年)

,T as (select 年,sum(本月) as 本年同期汇总
from Q
where 1=1
and 年=to_number(to_char(SYSDATE,'yyyy'))
and 月<=to_number(to_char(SYSDATE,'mm'))
group by 年)

select a.*,c.*,b.*
from Q a left join T c on a.年=c.年 
left join R b on a.年=b.年+1
where 年月=TO_CHAR(SYSDATE,'yyyy-MM')
${IF(ROLE_LV<> 1 ,"*/ SELECT 1 FROM DUAL","")}

SELECT DISTINCT ROLE_LV FROM TABLE(GET_PROJECT_TB('${fine_username}'))

 ${IF(ROLE_LV<> 2 ,"/*","")}
select
	sum(BHSJE)/10000 as 本年累计
from FR_R_MAIN_BUSINESS_INCOME A 
LEFT JOIN ( SELECT DISTINCT * FROM V_FR_DEPT_INFO )B 
ON A.YWKSBM = B.组织ID
where 1=1

AND SRLX='服务收入'
AND B.组织路径 LIKE '${P_SECTION}%'

AND YEAR=TO_CHAR(SYSDATE,'YYYY')
AND MONTH<=TO_CHAR(SYSDATE,'MM')
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
--ZJTX_ZJTXGS_35
 ${IF(ROLE_LV<> 2 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 2 ,"/*","")}
select 
	YEAR as "年份",
	sum(不含税金额)/10000 as 本年累计金额
from (
select 
	--YWRQ as 业务日期,
	A.YEAR,A.MONTH,
	A.BHSJE as 不含税金额
from FR_R_MAIN_BUSINESS_INCOME A
LEFT JOIN ( SELECT DISTINCT * FROM V_FR_DEPT_INFO ) B 
ON A.YWKSBM = B.组织ID 
where B.组织路径 LIKE '${P_SECTION}%'  --ZJTX_ZJTXGS_35
)
where
1=1
AND YEAR=TO_CHAR(SYSDATE,'YYYY')
AND MONTH<=TO_CHAR(SYSDATE,'MM')
group by YEAR
${IF(ROLE_LV<> 2 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 2 ,"/*","")}
select 
	YEAR as "年份",
	sum(不含税金额)/10000 as 本年累计金额
from (
select 
	--YWRQ as 业务日期,
	YEAR,
	BHSJE as 不含税金额
from FR_R_MAIN_BUSINESS_COST A
LEFT JOIN ( SELECT DISTINCT * FROM V_FR_DEPT_INFO ) B 
ON A.YWKSBM = B.组织ID 
where B.组织路径 LIKE '${P_SECTION}%'  --ZJTX_ZJTXGS_35
)
where 

YEAR=TO_CHAR(SYSDATE,'YYYY')

group by YEAR
${IF(ROLE_LV<> 2 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 2 ,"/*","")}
WITH Q AS (
SELECT DISTINCT 组织ID,组织名称,组织路径,组织级次 FROM V_FR_DEPT_INFO
WHERE 组织级次 = (SELECT DISTINCT 组织级次 FROM V_FR_DEPT_INFO WHERE 组织路径 = '${P_SECTION}') + 1
AND 组织路径 LIKE '${P_SECTION}%'  --ZJTX_ZJTXGS_35_3501_350101
)

, SRJB AS ( --收入基本
select 
 --YWRQ,
 YEAR,
 MONTH,
 SRLX,
 Q.组织路径 as 业务科室编码,
 Q.组织名称 as 业务科室,
 BHSJE
FROM FR_R_MAIN_BUSINESS_INCOME A
LEFT JOIN (
SELECT DISTINCT 组织ID,组织路径 FROM V_FR_DEPT_INFO
) B ON A.YWKSBM = B.组织ID
left JOIN Q ON B.组织路径 LIKE Q.组织路径||'%'
where B.组织路径 LIKE '${P_SECTION}%'
)
, ZCJB AS ( --支出基本
select 
 --YWRQ,
 YEAR,
 MONTH,
 ZCLX,
 Q.组织路径 as 业务科室编码,
 Q.组织名称 as 业务科室,
 BHSJE
FROM FR_R_MAIN_BUSINESS_COST A
LEFT JOIN (
SELECT DISTINCT 组织ID,组织路径 FROM V_FR_DEPT_INFO
) B ON A.YWKSBM = B.组织ID
left JOIN Q ON B.组织路径 LIKE Q.组织路径||'%'
where B.组织路径 LIKE '${P_SECTION}%'
)

, SRBQ AS   --收入本期
(SELECT 
 ROUND(SUM(BHSJE)/10000,2) AS BQSR
FROM SRJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
)
 
,SRTQ AS  --收入同期
(SELECT 
 ROUND(SUM(BHSJE)/10000,2) AS TQSR
FROM SRJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')-1
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
)
 
,ZCBQ AS   --支出本期
(SELECT 
 ROUND(SUM(BHSJE)/10000,2) AS BQZC
FROM ZCJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
)
 
,ZCTQ AS  --支出同期
(SELECT 
 ROUND(SUM(BHSJE)/10000,2) AS TQZC
FROM ZCJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')-1
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 )


,YSJCB AS (
SELECT
	TO_CHAR(CASE WHEN CWZQ IS NULL THEN SYSDATE ELSE TO_DATE(CWZQ,'YYYY-MM') END,'YYYY') AS 年,
	TO_CHAR(CASE WHEN CWZQ IS NULL THEN SYSDATE ELSE TO_DATE(CWZQ,'YYYY-MM') END,'MM') AS 月,
	KHJE
FROM FR_R_OVERDUE_RECEIVABLES
WHERE 1=1
${IF(LEN(P_SECTION)=0,"","AND EXISTS(SELECT DISTINCT 组织ID FROM V_FR_DEPT_INFO WHERE 组织路径 LIKE '"+P_SECTION+"'||'%' AND YWKSBM = 组织ID)")}---ZJTX_ZJTXGS_35
)
--应收本期
,YSBQ1 AS (
SELECT 
	SUM(KHJE) AS 考核金额
FROM YSJCB
WHERE --年=TO_CHAR(SYSDATE,'YYYY') AND 月=TO_CHAR(SYSDATE,'MM')
年=TO_CHAR(SYSDATE,'YYYY') 
AND 月=TO_CHAR(SYSDATE,'MM')
)
,YSBQ2 AS (
SELECT 
	SUM(KHJE) AS 考核金额
FROM YSJCB
WHERE --年=TO_CHAR(SYSDATE,'YYYY')-1 AND 月=12
年=TO_CHAR(SYSDATE,'YYYY')-1 
AND 月=12
)
,YSTQ1 AS (
SELECT 
	SUM(KHJE) AS 考核金额
FROM YSJCB
WHERE --年=TO_CHAR(SYSDATE,'YYYY') AND 月=TO_CHAR(SYSDATE,'MM')
年=TO_CHAR(SYSDATE,'YYYY') -1
AND 月=TO_CHAR(SYSDATE,'MM')
)
,YSTQ2 AS (
SELECT 
	SUM(KHJE) AS 考核金额
FROM YSJCB
WHERE --年=TO_CHAR(SYSDATE,'YYYY')-1 AND 月=12
年=TO_CHAR(SYSDATE,'YYYY')-2 
AND 月=12
)
,YSKH AS (
SELECT 
	(NVL(YSBQ1.考核金额,0)-NVL(YSBQ2.考核金额,0))/10000 AS 本期金额,
	(NVL(YSTQ1.考核金额,0)-NVL(YSTQ2.考核金额,0))/10000 AS 同期金额
FROM YSBQ1,YSBQ2,YSTQ1,YSTQ2
)
---------20210102 账期为累计，求出变动
, JKJCB AS (  --借款基础(其他应收)
select
	CWZQ AS 年月,
	YWKSBM,
	SUM(KHJE) as 考核金额
from (
SELECT 
	TO_DATE(CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE CWZQ END,'YYYY-MM') AS CWZQ,
	YWKSBM,KHJE
FROM FR_R_BORROWYING_DETAIL
)
GROUP BY CWZQ,YWKSBM
)

,JKBD AS (  --借款每月变动(其他应收)
SELECT
	A.YWKSBM,
	TO_CHAR(A.年月,'YYYY-MM') AS 年月,
	TO_CHAR(A.年月,'YYYY') AS YEAR,
	TO_CHAR(A.年月,'MM') AS MONTH,
	NVL(A.考核金额,0)-NVL(B.考核金额,0) AS KHJE
FROM JKJCB A
LEFT JOIN JKJCB B ON (add_months(A.年月,-1)=B.年月 AND A.YWKSBM=B.YWKSBM)
)

------------

, JKJB AS ( --借款基本(其他应收)
select 
 --DJRQ,
 YEAR,
 MONTH,
 Q.组织路径 as 业务科室编码,
 Q.组织名称 as 业务科室,
 KHJE
FROM JKBD A
LEFT JOIN (
SELECT DISTINCT 组织ID,组织路径 FROM V_FR_DEPT_INFO
) B ON A.YWKSBM = B.组织ID
left JOIN Q ON B.组织路径 LIKE Q.组织路径||'%'
where B.组织路径 LIKE '${P_SECTION}%'
)


,JKKH AS   --借款考核(其他应收)
(
select 
nvl(sum(BQ.本期金额),0)/10000 as 本期金额,
nvl(sum(TQ.同期金额),0)/10000 as 同期金额
from
(
SELECT 
SUM(KHJE) AS 本期金额
FROM JKJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 ) BQ,
(
SELECT 
SUM(KHJE) AS 同期金额
FROM JKJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')-1
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 ) TQ
 )

---------20210102 账期为累计，求出变动
, YFJCB AS (  --预付基础
select
	CWZQ AS 年月,
	YWKSBM,
	SUM(KHJE) as 考核金额
from (
SELECT 
	TO_DATE(CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE CWZQ END,'YYYY-MM') AS CWZQ,
	YWKSBM,KHJE
FROM FR_T_PREPAYMENT
)
GROUP BY CWZQ,YWKSBM
)

,YFBD AS (  --预付每月变动
SELECT
	A.YWKSBM,
	TO_CHAR(A.年月,'YYYY-MM') AS 年月,
	TO_CHAR(A.年月,'YYYY') AS YEAR,
	TO_CHAR(A.年月,'MM') AS MONTH,
	NVL(A.考核金额,0)-NVL(B.考核金额,0) AS KHJE
FROM YFJCB A
LEFT JOIN YFJCB B ON (add_months(A.年月,-1)=B.年月 AND A.YWKSBM=B.YWKSBM)
)

------------

,YFJB AS ( --预付基本
select 
 A.YEAR,
 A.MONTH,
 Q.组织路径 as 业务科室编码,
 Q.组织名称 as 业务科室,
 A.KHJE
FROM YFBD A
LEFT JOIN (
SELECT DISTINCT 组织ID,组织路径 FROM V_FR_DEPT_INFO
) B ON A.YWKSBM = B.组织ID
left JOIN Q ON B.组织路径 LIKE Q.组织路径||'%'
where B.组织路径 LIKE '${P_SECTION}%'
)


,YFKH AS   --预付考核
(
select 
nvl(sum(BQ.本期金额),0)/10000 as 本期金额,
nvl(sum(TQ.同期金额),0)/10000 as 同期金额
from
(
SELECT 
SUM(KHJE) AS 本期金额
FROM YFJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 ) BQ,
(
SELECT 
SUM(KHJE) AS 同期金额
FROM YFJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')-1
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 ) TQ
)

---------20210102 账期为累计，求出变动
, KCJCB AS (  --KC基础
select
	CWZQ AS 年月,
	YWKSBM,
	SUM(KHJE) as 考核金额
from (
SELECT 
	TO_DATE(CASE WHEN ZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE ZQ END,'YYYY-MM') AS CWZQ,
	YWKSBM,KHJE
FROM FR_INVENTORY
)
GROUP BY CWZQ,YWKSBM
)

,KCBD AS (  --KC每月变动
SELECT
	A.YWKSBM,
	TO_CHAR(A.年月,'YYYY-MM') AS 年月,
	TO_CHAR(A.年月,'YYYY') AS YEAR,
	TO_CHAR(A.年月,'MM') AS MONTH,
	NVL(A.考核金额,0)-NVL(B.考核金额,0) AS KHJE
FROM KCJCB A
LEFT JOIN KCJCB B ON (add_months(A.年月,-1)=B.年月 AND A.YWKSBM=B.YWKSBM)
)

------------

, KCJB AS ( --KC基本
select 
 A.YEAR,
 A.MONTH,
 Q.组织路径 as 业务科室编码,
 Q.组织名称 as 业务科室,
 A.KHJE
FROM KCBD A
LEFT JOIN (
SELECT DISTINCT 组织ID,组织路径 FROM V_FR_DEPT_INFO
) B ON A.YWKSBM = B.组织ID
left JOIN Q ON B.组织路径 LIKE Q.组织路径||'%'
where B.组织路径 LIKE '${P_SECTION}%'
)


,KCKH AS   --KC考核
(
select 
nvl(sum(BQ.本期金额),0)/10000 as 本期金额,
nvl(sum(TQ.同期金额),0)/10000 as 同期金额
from
(
SELECT 
	SUM(KHJE) AS 本期金额
FROM KCJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 ) BQ,
(
SELECT 
	SUM(KHJE) AS 同期金额
FROM KCJB
WHERE 1=1
 AND YEAR=TO_CHAR(SYSDATE,'YYYY')-1
 AND MONTH<=TO_CHAR(SYSDATE,'MM')
 ${IF(LEN(P_OFFICE)=0,"","AND 业务科室编码='"+P_OFFICE+"'")}
 ) TQ
)
--2021-01-27 净利润计算逻辑修改,添加利息和其它调整
,LXJCB AS (
--利息基础表
SELECT
	CASE WHEN INSERT_TIME IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE TO_CHAR(INSERT_TIME,'YYYY-MM') END AS 年月,
	TO_CHAR(CASE WHEN INSERT_TIME IS NULL THEN SYSDATE ELSE INSERT_TIME END,'YYYY') AS 年,
	TO_CHAR(CASE WHEN INSERT_TIME IS NULL THEN SYSDATE ELSE INSERT_TIME END,'MM') AS 月,
	FUNDS_INTERESTS_D AS 考核金额
from FR_T_CASH_DAILY_REPORT
where 1=1
${IF(LEN(P_SECTION)=0,"","AND EXISTS(SELECT DISTINCT 组织ID FROM V_FR_DEPT_INFO WHERE 组织路径 LIKE '"+P_SECTION+"'||'%' AND DEPT_CODE = 组织ID)")}---ZJTX_ZJTXGS_35
--AND to_char(INSERT_TIME,'yyyy')=TO_CHAR(SYSDATE,'YYYY')
--AND to_char(INSERT_TIME,'mm')<=TO_CHAR(SYSDATE,'MM')
)
--利息本期
,LXBQ AS (
SELECT 
	SUM(考核金额) AS 考核金额
FROM LXJCB
WHERE --年月=TO_CHAR(SYSDATE,'YYYY-MM')
年月=TO_CHAR(SYSDATE,'YYYY-MM')
)
--利息同期
,LXTQ AS (
SELECT 
	SUM(考核金额) AS 考核金额
FROM LXJCB
WHERE 1=1
--年月=TO_CHAR(SYSDATE,'YYYY-MM')
--年月=TO_CHAR(SYSDATE,'YYYY-MM')
AND 年 = TO_CHAR(SYSDATE,'YYYY') - 1
AND 月 = TO_CHAR(SYSDATE,'MM')
)
,LX AS (
--利息本期变动值
SELECT 
	NVL(LXBQ.考核金额,0) AS 本期金额,
	NVL(LXTQ.考核金额,0) AS 同期金额
FROM LXBQ,LXTQ
)
--其它调整基础表
,QTTZJCB AS (
SELECT
	CASE WHEN aa.YEAR_MONTH IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE aa.YEAR_MONTH END AS 年月,
	TO_CHAR(CASE WHEN aa.YEAR_MONTH IS NULL THEN SYSDATE ELSE TO_DATE(aa.YEAR_MONTH,'YYYY-MM') END,'YYYY') AS 年,
	TO_CHAR(CASE WHEN aa.YEAR_MONTH IS NULL THEN SYSDATE ELSE TO_DATE(aa.YEAR_MONTH,'YYYY-MM') END,'MM') AS 月,
	aa.QTTZ1+aa.QTTZ2+aa.QTTZ3+aa.QTTZ4+aa.QTTZ5+aa.QTTZ6+aa.QTTZ7 AS 考核金额 
FROM FR_BM_DASHBOARD_O_MONEY aa
LEFT JOIN T_DXQ_ProjectItem  ff  ON aa.PROJ_ID=ff.fnumber --项目
LEFT JOIN T_ORG_BaseUnit  gg ON ff.CFADMINORUNITID=gg.FID --部门
LEFT JOIN T_ORG_BaseUnit  hh ON ff.CFBIZORGID=hh.FID --业务科室
LEFT JOIN T_BD_Person  ii ON ff.FProjectManagerID=ii.FID  --项目经理
WHERE 1=1
${IF(LEN(P_SECTION)=0,"","AND EXISTS(SELECT DISTINCT 组织ID FROM V_FR_DEPT_INFO WHERE 组织路径 LIKE '"+P_SECTION+"'||'%' AND gg.FNumber = 组织ID)")}---ZJTX_ZJTXGS_35
--and aa.YEAR_MONTH=TO_CHAR(SYSDATE,'YYYY-MM')
)
--其它调整本期
,QTTZBQ AS (
SELECT 
	SUM(考核金额) AS 考核金额
FROM QTTZJCB
WHERE --年月=TO_CHAR(SYSDATE,'YYYY-MM')
年月=TO_CHAR(SYSDATE,'YYYY-MM')
)
--其它调整同期
,QTTZTQ AS (
SELECT 
	SUM(考核金额) AS 考核金额
FROM QTTZJCB
WHERE 1=1
--年=TO_CHAR(SYSDATE,'YYYY')-1 AND 月=12
AND 年=TO_CHAR(SYSDATE,'YYYY') -1  
AND 月=TO_CHAR(SYSDATE,'MM')
)
,QTTZ AS (
--其它调整
SELECT 
	NVL(QTTZBQ.考核金额,0)/10000 AS 本期金额,
	NVL(QTTZTQ.考核金额,0)/10000 AS 同期金额
FROM QTTZBQ,QTTZTQ
)
,XJJLR AS(
SELECT
 (SRBQ.BQSR-ZCBQ.BQZC+LX.本期金额)*0.8-YSKH.本期金额-JKKH.本期金额-YFKH.本期金额-KCKH.本期金额+QTTZ.本期金额  AS 累计,
 (SRTQ.TQSR-ZCTQ.TQZC+LX.同期金额)*0.8-YSKH.同期金额-JKKH.同期金额-YFKH.同期金额-KCKH.同期金额+QTTZ.同期金额 
 AS 同期累计
FROM 
 SRBQ,SRTQ,ZCBQ,ZCTQ,YSKH,JKKH,YFKH,KCKH,LX,QTTZ
 )

SELECT
--收入,支出,应收考核,其他应收,预付考核,库存考核,资金利息,其他调整,
ROUND(累计,2) AS 累计,
ROUND(同期累计,2) AS 同期累计
FROM XJJLR
${IF(ROLE_LV<> 2 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 2 ,"/*","")}
select 
	sum(BHSJE)/10000 as 本年累计
from FR_R_MAIN_BUSINESS_INCOME A
LEFT JOIN ( SELECT DISTINCT * FROM V_FR_DEPT_INFO ) B 
ON A.YWKSBM = B.组织ID 
where B.组织路径 LIKE '${P_SECTION}%'  --ZJTX_ZJTXGS_35
and A.SRLX in ('服务收入','贸易收入')
and A.YEAR=TO_CHAR(SYSDATE,'YYYY')
AND A.MONTH<=TO_CHAR(SYSDATE,'MM')
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
${IF(ROLE_LV<> 2 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 2 ,"/*","")}
select 
	sum(ZJLR)/10000 as 流入金额,
	sum(ZJLC)/10000 as 流出金额
from FR_R_NCF_IN_E_DETAIL A 
LEFT JOIN ( SELECT DISTINCT * FROM V_FR_DEPT_INFO )B 
ON A.YWKSBM = B.组织ID
where 
to_char(YWRQ,'yyyy')=TO_CHAR(SYSDATE,'YYYY') and CWZQ IS NULL
AND B.组织路径 LIKE '${P_SECTION}%'
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
--ZJTX_ZJTXGS_35
${IF(ROLE_LV<> 2 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 4 ,"/*","")}
WITH P AS(
--08其他直接运营成本不含税-费用成本（费用报销单差旅费报销单明细表）
SELECT 
 DJBH AS "单据编号",
 YWRQ AS "业务日期",
 YGBM AS "收款人员工编号",
 YGMC AS "收款人",
 SKJE AS "收款金额",
 FYLXBM AS "费用类型编码",
 FYLXMC AS "费用类型名称"

FROM
 FR_T_PROCEEDS_DETAILS)

SELECT SUM(收款金额) 收款金额
FROM P
WHERE 1=1
AND 收款人员工编号=(SELECT DISTINCT USERCODE FROM FR_DEPT_ROLE_USER WHERE USERNAME='${fine_username}')
AND TO_CHAR(业务日期,'yyyy') = TO_CHAR(sysdate,'yyyy')
${IF(ROLE_LV<> 4 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 4 ,"/*","")}
WITH P AS(
SELECT
  --DJBH AS 单据编号,
  FYLXBM AS 费用类型编码,
  SQRBM AS 申请人编码,
  --SQRMC AS 申请人,
  --KH AS 支付对象,
  --DJRQ AS 业务日期,
  JYJE AS 借款金额,
  --YHJE AS 已还金额,
  --WHJE AS 未还金额
  YEAR AS YEAR
FROM FR_R_BORROWYING_DETAIL
WHERE DJLX='借款单')

SELECT  
  SUM(借款金额) 借款金额
FROM P
WHERE 费用类型编码='003'
AND 申请人编码=(SELECT DISTINCT USERCODE FROM FR_DEPT_ROLE_USER WHERE USERNAME='${fine_username}')
AND YEAR = TO_CHAR(SYSDATE,'yyyy')
${IF(ROLE_LV<> 4 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 3 ,"/*","")}
WITH JCB AS (
SELECT * FROM (
SELECT
ZLYSRQ, CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') 
		ELSE CWZQ END AS 年月,
DJLX,ZT,
YSWBJEJY
FROM FR_R_OVERDUE_RECEIVABLES 
where 1=1
AND EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM)  --13316080228
) 
WHERE 年月=TO_CHAR(SYSDATE,'yyyy-MM') )
,LJYS as (
select 
	sum(YSWBJEJY)/10000 as 累计应收金额
from JCB
)

, JJYQ as (
select 
sum(YSWBJEJY)/10000 as 即将逾期金额
from JCB
where ZLYSRQ='下月到期应收'
AND ZT = '下月逾期'
)

, YYQ as (
select 
sum(YSWBJEJY)/10000 as 已逾期金额
from JCB
WHERE 1=1
AND ZT='逾期'
)

select 
	LJYS.累计应收金额,
	JJYQ.即将逾期金额,
	YYQ.已逾期金额
from LJYS,JJYQ,YYQ
${IF(ROLE_LV<> 3 ,"*/ SELECT 1 FROM DUAL","")}
--存在一个人有多个项目，不在一个科室的问题

${IF(ROLE_LV<> 3 ,"/*","")}
WITH P AS(
SELECT 
 YEAR,
 MONTH,
 YWRQ AS "业务日期", --单据日期
 BHSJE AS "不含税金额",--不含税金额
 XMBM AS "项目编码",--项目编码
 XMMC AS "项目", --项目名称
 XMJLBM AS "项目经理编码",--项目经理编码
 XMJLMC AS "项目经理"--项目经理名称
FROM FR_R_MAIN_BUSINESS_INCOME
where 1=1
and SRLX in ('服务收入','贸易收入')
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
)

SELECT
sum(NVL(A.年,0)) AS 本年
FROM(
SELECT 项目经理编码,SUM(不含税金额)/10000 AS 年
FROM P
WHERE 1=1
AND YEAR=EXTRACT(YEAR FROM SYSDATE)
AND MONTH<=EXTRACT(MONTH FROM SYSDATE)

GROUP BY 项目经理编码)A
${IF(ROLE_LV<> 3 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 3 ,"/*","")}
WITH P AS(
SELECT 
 YEAR,
 MONTH,
 YWRQ AS "业务日期", --单据日期
 BHSJE AS "不含税金额",--不含税金额
 XMBM AS "项目编码",--项目编码
 XMMC "项目", --项目名称
 XMJLBM AS "项目经理编码",--项目经理编码
 XMJLMC AS "项目经理",--项目经理名称
 BMBM AS "部门编码"
FROM FR_R_MAIN_BUSINESS_COST
where ZCLX not like '%人工成本%' and ZCLX <> '折旧摊销'
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
)

SELECT 
sum(NVL(A.年,0)) AS 本年
FROM(
SELECT 项目经理编码,SUM(不含税金额)/10000 AS 年
FROM P
WHERE 1=1
AND YEAR=EXTRACT(YEAR FROM SYSDATE)
AND MONTH<=EXTRACT(MONTH FROM SYSDATE)
GROUP BY 项目经理编码)A 

${IF(ROLE_LV<> 3 ,"*/ SELECT 1 FROM DUAL","")}

${IF(ROLE_LV<> 3 ,"/*","")}
--预付考核
with YFKH as (
select 

sum(KHJE)/10000 AS 预付考核金额
from FR_T_PREPAYMENT
where 1=1
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM ) 
and extract(year from DJRQ)=extract(year from sysdate)

)

--借款考核
,JKKH as (
select 

sum(KHJE)/10000 AS 借款考核金额
from FR_R_BORROWYING_DETAIL
where 1=1
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )

and YEAR=extract(year from sysdate)

)

--应收考核
,YSKH as (
select 

sum(KHJE)/10000 AS 应收考核金额
from FR_R_OVERDUE_RECEIVABLES
where 1=1
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
and DJLX='应收单' 
and YEAR=extract(year from sysdate)

)

, SR as 
( select 

sum(不含税金额)/10000 as 收入
from 
(select 
--YWRQ as 业务日期,
YEAR,
XMJLBM as 项目经理编码,
XMJLMC as 项目经理,
BHSJE as 不含税金额
from FR_R_MAIN_BUSINESS_INCOME --FR_T_MAIN_BUSINESS_COST
where 1=1
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM ) 
and YEAR=extract(year from sysdate)
)
)

,ZC as 
( select 

sum(不含税金额)/10000 as 支出
from 
(select 
--YWRQ as 业务日期,
YEAR,
XMJLBM as 项目经理编码,
XMJLMC as 项目经理,
BHSJE as 不含税金额
from FR_R_MAIN_BUSINESS_COST --FR_T_MAIN_BUSINESS_COST
where 1=1
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )
and YEAR=extract(year from sysdate)
)
 )


select
--nvl(YFKH.预付考核金额,0),
--nvl(JKKH.借款考核金额,0),
--nvl(YSKH.应收考核金额,0),
(nvl(SR.收入,0)-nvl(ZC.支出,0)-nvl(YFKH.预付考核金额,0)-nvl(JKKH.借款考核金额,0)-nvl(YSKH.应收考核金额,0))*0.8 as 现金净利润
from SR,ZC,YFKH,JKKH,YSKH 
${IF(ROLE_LV<> 3 ,"*/ SELECT 1 FROM DUAL","")}


SELECT DISTINCT REALNAME FROM FR_DEPT_ROLE_USER WHERE USERNAME='${FINE_USERNAME}'  --13316080228

SELECT DISTINCT DEPT_ID FROM FR_DEPT_ROLE_USER WHERE USERNAME = '${fine_username}'

select 
sum(XJJLR)/10000 as 本月现金净利润
from FR_T_COMP_NET_CASH_PROFIT
where
 YEAR=to_number(to_char(SYSDATE,'yyyy'))
and MONTH<=to_number(to_char(SYSDATE,'mm'))

select 
sum(XJJLR)/10000 as 本月现金净利润
--from FR_T_DEPT_NET_CASH_PROFIT
FROM ${IF(P_LV = "部门","FR_T_DEPT_NET_CASH_PROFIT","FR_T_PROJ_NET_CASH_PROFIT")}
where
 YEAR=to_number(to_char(SYSDATE,'yyyy'))
and MONTH<=to_number(to_char(SYSDATE,'mm'))
and YWKSLJ like '${P_SECTION}%'
and EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM )

${IF(ROLE_LV<> 3 ,"/*","")}
select 
sum(XJJLR)/10000 as 本月现金净利润
from FR_T_PROJ_NET_CASH_PROFIT
where
 YEAR=to_number(to_char(SYSDATE,'yyyy'))
and MONTH<=to_number(to_char(SYSDATE,'mm'))
--and YWKSLJ like '${P_SECTION}%'
AND EXISTS ( SELECT PROJ_CODE FROM TABLE(GET_PROJECT_TB('${fine_username}')) WHERE PROJ_CODE =  XMBM)  --13316080228
${IF(ROLE_LV<> 3 ,"*/ SELECT 1 FROM DUAL","")}


select 
	sum(SR)/10000 AS 收入,
	sum(CB)/10000 AS 支出,
	sum(YF)/10000 AS 预付,
	sum(YS)/10000 AS 应收,
	sum(QTYS)/10000 AS 其他应收,
	sum(KC)/10000 AS 库存,
	sum(LX)/10000 *0.8 AS 利息,
	sum(TZ)/10000 AS 其他调整,
	sum(XJJLR)/10000 AS 现金净利润
from FR_T_DEPT_NET_CASH_PROFIT
where
 YEAR=to_number(to_char(SYSDATE,'yyyy'))
and MONTH<=to_number(to_char(SYSDATE,'mm'))
AND YWKSLJ LIKE '${P_SECTION}%'


