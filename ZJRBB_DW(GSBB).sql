with BNLX as (
select
	DEPT_CODE as 部门编码,
	DEPT_NAME as 部门,
	SUM(FUNDS_INTERESTS_D) AS 本年利息
from FR_T_CASH_DAILY_REPORT
where 1=1
--to_char(INSERT_TIME,'yyyy')=to_char(sysdate-1,'yyyy')
AND to_char(INSERT_TIME-1,'yyyy')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
AND to_char(INSERT_TIME-1,'mm')<=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
group by DEPT_CODE,DEPT_NAME
)
, JCB as ( 
select * from(
select 
	BMBM as 部门编码,
	BMMC as 部门,
	CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	sum(ZJLR)/10000 as 资金流入,
	sum(ZJLC)/10000 as 资金流出,
	(nvl(sum(ZJLR),0)-nvl(sum(ZJLC),0))/10000 as 本年收支差
from FR_R_NCF_IN_E_DETAIL
where 1=1
--AND CWZQ IS NULL
--TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE-1,'YYYY')
AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')<=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
${if(P_SFBZJ='不含保证金'," and LRLCLX NOT IN ('拍卖保证金','招标保证金') ","")}
group by BMBM,BMMC,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where 年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')
)
, QNJCB as ( 
select * from(
select 
	BMBM as 部门编码,
	BMMC as 部门,
	CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'YYYY') END AS 年,
	sum(ZJLR)/10000 as 资金流入,
	sum(ZJLC)/10000 as 资金流出,
	(nvl(sum(ZJLR),0)-nvl(sum(ZJLC),0))/10000 as 本年收支差
from FR_R_NCF_IN_E_DETAIL
where 1=1
--AND CWZQ IS NULL
AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(ADD_MONTHS(TO_DATE('${P_DATE}','YYYY-MM'),-12),'YYYY')
-- TO_CHAR(YWRQ,'YYYY')=TO_CHAR(ADD_MONTHS(SYSDATE-1,-12),'YYYY')
${if(P_SFBZJ='不含保证金'," and LRLCLX NOT IN ('拍卖保证金','招标保证金') ","")}
group by BMBM,BMMC,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'YYYY') END
) P
where 年=TO_CHAR(ADD_MONTHS(TO_DATE('${P_DATE}','YYYY-MM'),-12),'YYYY')
)
, QNJCB2 as ( 
select 
	BMBM as 部门编码,
	BMMC as 部门,
	sum(ZJLR)/10000 as 资金流入,
	sum(ZJLC)/10000 as 资金流出,
	(nvl(sum(ZJLR),0)-nvl(sum(ZJLC),0))/10000 as 本年收支差
from FR_R_NCF_IN_E_DETAIL
where 1=1
AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')='2020' and LRLCLX='填报'
${if(P_SFBZJ='不含保证金'," and LRLCLX NOT IN ('拍卖保证金','招标保证金') ","")}
group by BMBM,BMMC
)

,SYBM AS (
SELECT DISTINCT 
	BMBM as 部门编码,
	BMMC as 部门
FROM FR_R_NCF_IN_E_DETAIL
WHERE CWZQ IS NULL
)

select 
	SYBM.部门编码,
	SYBM.部门,
	case when to_char(sysdate,'yyyy')='2021' then nvl(QNJCB2.本年收支差,0)
	when to_char(sysdate,'yyyy')='2022' then nvl(QNJCB2.本年收支差,0)+nvl(QNJCB.本年收支差,0)
	else nvl(QNJCB.本年收支差,0) end AS 年初收支差,
	JCB.资金流入,
	JCB.资金流出,
	JCB.本年收支差,
	--JCB.本年收支差+nvl(QNJCB.本年收支差,0) AS 滚动收支差,
	BNLX.本年利息
from SYBM
left join JCB on JCB.部门编码=SYBM.部门编码
left join QNJCB on QNJCB.部门编码=SYBM.部门编码
left join QNJCB2 on QNJCB2.部门编码=SYBM.部门编码
LEFT JOIN BNLX ON BNLX.部门编码=SYBM.部门编码
where SYBM.部门编码 in ('35','32','31','33','34','36','37','91')
order by decode(SYBM.部门编码, '35', 1, '32', 2, '31', 3, '33', 4, '34', 5, '36', 6, '37', 7, '91', 8)


with BNLX as (
select
	DEPT_CODE as 部门编码,
	DEPT_NAME as 部门,
	SUM(FUNDS_INTERESTS_D) AS 本月利息
from FR_T_CASH_DAILY_REPORT
where 1=1
AND to_char(INSERT_TIME-1,'yyyy-mm')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')
--to_char(INSERT_TIME,'yyyy-mm')=to_char(sysdate-1,'yyyy-mm')
group by DEPT_CODE,DEPT_NAME
)
, JCB as ( 
select * from(
select 
	BMBM as 部门编码,
	BMMC as 部门,
	CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	sum(ZJLR)/10000 as 资金流入,
	sum(ZJLC)/10000 as 资金流出,
	(nvl(sum(ZJLR),0)-nvl(sum(ZJLC),0))/10000 as 本月收支差
from FR_R_NCF_IN_E_DETAIL
where 1=1
--AND CWZQ IS NULL
AND TO_CHAR(YWRQ,'YYYY-MM')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')
--TO_CHAR(YWRQ,'yyyy-mm')=TO_CHAR(SYSDATE-1,'yyyy-mm')
${if(P_SFBZJ='不含保证金'," and LRLCLX NOT IN ('拍卖保证金','招标保证金') ","")}
group by BMBM,BMMC,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where 年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')
)
, QNJCB as ( --上月
select * from(
select 
	BMBM as 部门编码,
	BMMC as 部门,
	CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	sum(ZJLR)/10000 as 资金流入,
	sum(ZJLC)/10000 as 资金流出,
	case when TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'mm')='01' then 0 else (nvl(sum(ZJLR),0)-nvl(sum(ZJLC),0))/10000 end as 本月收支差
from FR_R_NCF_IN_E_DETAIL
where 1=1
--AND CWZQ IS NULL
AND TO_CHAR(YWRQ,'YYYY-MM')=TO_CHAR(ADD_MONTHS(TO_DATE('${P_DATE}','YYYY-MM'),-1),'YYYY-MM')
--TO_CHAR(YWRQ,'yyyy-mm')=TO_CHAR(ADD_MONTHS(SYSDATE-1,-1),'yyyy-mm')
${if(P_SFBZJ='不含保证金'," and LRLCLX NOT IN ('拍卖保证金','招标保证金') ","")}
group by BMBM,BMMC,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where 年月=TO_CHAR(ADD_MONTHS(TO_DATE('${P_DATE}','YYYY-MM'),-1),'YYYY-MM')
)
, JCBNoRG as (--不含人工资金流出
select * from(
select 
	BMBM as 部门编码,
	BMMC as 部门,
	CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	--sum(ZJLR)/10000 as 资金流入,
	sum(ZJLC)/10000 as 资金流出
from FR_R_NCF_IN_E_DETAIL
where 1=1
--AND CWZQ IS NULL
AND TO_CHAR(YWRQ,'YYYY-MM')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')
--TO_CHAR(YWRQ,'yyyy-mm')=TO_CHAR(SYSDATE-1,'yyyy-mm')
${if(P_SFBZJ='不含保证金'," and LRLCLX NOT IN ('拍卖保证金','招标保证金') ","")}
and ZJLCLX NOT IN ('社保成本','工资')
group by BMBM,BMMC,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where 年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')
)
,SYBM AS (
SELECT DISTINCT 
	BMBM as 部门编码,
	BMMC as 部门
FROM FR_R_NCF_IN_E_DETAIL
WHERE CWZQ IS NULL
)

select 
	SYBM.部门编码,
	SYBM.部门,
	nvl(QNJCB.本月收支差,0) AS 月初收支差,
	JCB.资金流入,
	JCB.资金流出,
	JCB.本月收支差,
	JCB.资金流入-JCBNoRG.资金流出 AS 本月收支差无人工,
	--JCB.本月收支差+nvl(QNJCB.本月收支差,0) AS 滚动收支差,
	BNLX.本月利息
from SYBM
left join JCB on JCB.部门编码=SYBM.部门编码
left join QNJCB on QNJCB.部门编码=SYBM.部门编码
left join JCBNoRG on JCBNoRG.部门编码=SYBM.部门编码
LEFT JOIN BNLX ON BNLX.部门编码=SYBM.部门编码
where SYBM.部门编码 in ('35','32','31','33','34','36','37','91')
order by decode(SYBM.部门编码, '35', 1, '32', 2, '31', 3, '33', 4, '34', 5, '36', 6, '37', 7, '91', 8)


select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	SUM(ZJSRHJ)/10000 AS 资金收入合计,
	SUM(ZJZCHJ)/10000 AS 资金支出合计,
	SUM(ZJSRHJ_ZB)/10000 AS 招标收入,
	SUM(ZJSRHJ_PM)/10000 AS 拍卖收入,
	SUM(ZJZCHJ_ZB)/10000 AS 招标支出,
	SUM(ZJZCHJ_PM)/10000 AS 拍卖支出,
	SUM(WJSHK)/10000 AS 未结算回款,
	SUM(WQFBZJ)/10000 AS 未清分保证金,
	SUM(QTYXS)/10000 AS 其他影响数
FROM FR_R_NCF_TOTAL
WHERE 1=1
--AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')<=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
--TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE-1,'YYYY')
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')

select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	SUM(ZJSRHJ)/10000 AS 资金收入合计,
	SUM(ZJZCHJ)/10000 AS 资金支出合计,
	SUM(ZJSRHJ_ZB)/10000 AS 招标收入,
	SUM(ZJSRHJ_PM)/10000 AS 拍卖收入,
	SUM(ZJZCHJ_ZB)/10000 AS 招标支出,
	SUM(ZJZCHJ_PM)/10000 AS 拍卖支出,
	SUM(WJSHK)/10000 AS 未结算回款,
	SUM(WQFBZJ)/10000 AS 未清分保证金,
	SUM(QTYXS)/10000 AS 其他影响数
FROM FR_R_NCF_TOTAL
WHERE 1=1
--AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
--TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE-1,'YYYY')
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')

SELECT DISTINCT REALNAME FROM FR_DEPT_ROLE_USER WHERE USERNAME = '${fine_username}'

select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
SUM(ZJLR)/10000 as 资金流入,
SUM(ZJLC)/10000 as 资金流出,
(SUM(ZJLR)-SUM(ZJLC))/10000 AS 本年收支差
from FR_R_NCF_IN_E_DETAIL
WHERE 1=1
--AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')<=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
--AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
and LRLCLX = '招标保证金'
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')

select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
SUM(ZJLR)/10000 as 资金流入,
SUM(ZJLC)/10000 as 资金流出,
(SUM(ZJLR)-SUM(ZJLC))/10000 AS 本年收支差
from FR_R_NCF_IN_E_DETAIL
WHERE 1=1
--AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')<=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
--AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
and LRLCLX = '拍卖保证金'
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')

select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
SUM(ZJLR)/10000 as 资金流入,
SUM(ZJLC)/10000 as 资金流出,
(SUM(ZJLR)-SUM(ZJLC))/10000 AS 本年收支差
from FR_R_NCF_IN_E_DETAIL
WHERE 1=1
--AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
--AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
and LRLCLX = '招标保证金'
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')

select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
SUM(ZJLR)/10000 as 资金流入,
SUM(ZJLC)/10000 as 资金流出,
(SUM(ZJLR)-SUM(ZJLC))/10000 AS 本年收支差
from FR_R_NCF_IN_E_DETAIL
WHERE 1=1
--AND CWZQ IS NULL
and TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and TO_CHAR(YWRQ,'MM')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')
--AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
and LRLCLX = '拍卖保证金'
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY-MM')

SELECT DISTINCT 组织ID,组织名称,组织路径,组织级次 FROM V_FR_DEPT_INFO

select 
--年,
--月,
未结算回款
from
(
SELECT
CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'YYYY') END AS 年,
CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'MM') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'MM') END AS 月,
	SUM(WJSHK)/10000 AS 未结算回款
FROM FR_R_NCF_TOTAL
GROUP BY CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'YYYY') END,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'MM') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'MM') END
) p
WHERE 1=1
--AND CWZQ IS NULL
and 年=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and 月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')

SELECT TO_CHAR(ADD_MONTHS(TO_DATE('${P_DATE}','YYYY-MM'),-12),'YYYY-MM') FROM DUAL

SELECT
sum(CASH_IN)/10000 AS 资金流入,
sum(CASH_OUT)/10000 AS 资金流出,
sum(CASH_IN-CASH_OUT)/10000 AS 年初收支差
FROM FR_CASH_GROUP_DEPT
where TO_CHAR(YWRQ,'YYYY')= TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')-1
AND DEPT='公司本部'

select * from(
SELECT
     CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END AS 年月,
	SUM(ZJSRHJ)/10000 AS 资金收入合计,
	SUM(ZJZCHJ)/10000 AS 资金支出合计,
	SUM(ZJSRHJ_ZB)/10000 AS 招标收入,
	SUM(ZJSRHJ_PM)/10000 AS 拍卖收入,
	SUM(ZJZCHJ_ZB)/10000 AS 招标支出,
	SUM(ZJZCHJ_PM)/10000 AS 拍卖支出,
	--SUM(WJSHK)/10000 AS 未结算回款,
	SUM(WQFBZJ)/10000 AS 未清分保证金,
	SUM(QTYXS)/10000 AS 其他影响数,
	SUM(ZJSRHJ-ZJZCHJ)/10000 AS 月初收支差
FROM FR_R_NCF_TOTAL
WHERE 1=1
group by CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY-MM') ELSE CWZQ END
) P
where  年月=TO_CHAR(add_months(TO_DATE('${P_DATE}','YYYY-MM'),-1),'YYYY-MM')

select 
--年,
--月,
未结算回款
from
(
SELECT
--CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'YYYY') END AS 年,
TO_CHAR(YWRQ,'YYYY') AS 年, 
TO_CHAR(YWRQ,'MM') AS 月, 
--CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'MM') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'MM') END AS 月,
	SUM(WJSHK)/10000 AS 未结算回款
FROM FR_R_NCF_TOTAL
GROUP BY 
TO_CHAR(YWRQ,'YYYY'), 
TO_CHAR(YWRQ,'MM') 
--CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'YYYY') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'YYYY') END,CASE WHEN CWZQ IS NULL THEN TO_CHAR(SYSDATE,'MM') ELSE TO_CHAR(TO_DATE(CWZQ,'YYYY-MM'),'MM') END
) p
WHERE 1=1
--AND CWZQ IS NULL
and 年=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
and 月=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM')

WITH P1 AS(SELECT 
SUM(QTYXS)/10000 AS 本月其他影响数
FROM FR_CASH_GROUP_COMPANY
WHERE TO_CHAR(YWRQ,'YYYY-MM')='${P_DATE}')

,P2 AS(SELECT 
sum(QTYXS)/10000 AS 本年其他影响数
FROM FR_CASH_GROUP_COMPANY
WHERE 1=1
AND TO_CHAR(YWRQ,'YYYY')=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'YYYY')
AND TO_CHAR(YWRQ,'MM')<=TO_CHAR(TO_DATE('${P_DATE}','YYYY-MM'),'MM'))

SELECT
P1.本月其他影响数,
P2.本年其他影响数
from P1,P2

