SELECT MAX (INSERTIME) INSERTIME FROM F_MKT_PROJECT_SALE


WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
, T9 AS 
(SELECT --------------------------------年累计
  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	${SWITCH(subs,0,"SUM(ORDERSUIT)",1,"SUM(ORDERSUIT*RATIO)",2,"SUM(ORDERSUIT*HF_RATIO)")} ORDERSUIT,
	${SWITCH(subs,0,"SUM(ORDERAREA)",1,"SUM(ORDERAREA*RATIO)",2,"SUM(ORDERAREA*HF_RATIO)")} ORDERAREA,
	${SWITCH(subs,0,"SUM(ORDERAMOUNT)",1,"SUM(ORDERAMOUNT*RATIO)",2,"SUM(ORDERAMOUNT*HF_RATIO)")} ORDERAMOUNT,
	${SWITCH(subs,0,"SUM(SIGNSUIT)",1,"SUM(SIGNSUIT*RATIO)",2,"SUM(SIGNSUIT*HF_RATIO)")} SIGNSUIT,
	${SWITCH(subs,0,"SUM(SIGNAREA)",1,"SUM(SIGNAREA*RATIO)",2,"SUM(SIGNAREA*HF_RATIO)")} SIGNAREA,
	${SWITCH(subs,0,"SUM(SIGNAMOUNT)",1,"SUM(SIGNAMOUNT*RATIO)",2,"SUM(SIGNAMOUNT*HF_RATIO)")} SIGNAMOUNT,
	${SWITCH(subs,0,"SUM(DDNUM)",1,"SUM(DDNUM*RATIO)",2,"SUM(DDNUM*HF_RATIO)")} DDNUM,
	${SWITCH(subs,0,"SUM(DDAREA)",1,"SUM(DDAREA*RATIO)",2,"SUM(DDAREA*HF_RATIO)")} DDAREA,
	${SWITCH(subs,0,"SUM(DDAMOUNT)",1,"SUM(DDAMOUNT*RATIO)",2,"SUM(DDAMOUNT*HF_RATIO)")} DDAMOUNT,
	${SWITCH(subs,0,"SUM(WDNUM)",1,"SUM(WDNUM*RATIO)",2,"SUM(WDNUM*HF_RATIO)")} WDNUM,
	${SWITCH(subs,0,"SUM(WDAREA)",1,"SUM(WDAREA*RATIO)",2,"SUM(WDAREA*HF_RATIO)")} WDAREA,
	${SWITCH(subs,0,"SUM(WDAMOUNT)",1,"SUM(WDAMOUNT*RATIO)",2,"SUM(WDAMOUNT*HF_RATIO)")} WDAMOUNT,
	${SWITCH(subs,0,"SUM(INCOMEAMOUNT)",1,"SUM(INCOMEAMOUNT*RATIO)",2,"SUM(INCOMEAMOUNT*HF_RATIO)")} INCOMEAMOUNT,
	${SWITCH(subs,0,"SUM(DINCOMEAMOUNT)",1,"SUM(DINCOMEAMOUNT*RATIO)",2,"SUM(DINCOMEAMOUNT*HF_RATIO)")} DDH,
	${SWITCH(subs,0,"SUM(WINCOMEAMOUNT)",1,"SUM(WINCOMEAMOUNT*RATIO)",2,"SUM(WINCOMEAMOUNT*HF_RATIO)")} WDH
FROM
	F_MKT_PROJECT_SALE A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
LEFT JOIN F_MKT_PROJECT_SIGN C ON A.PERIODID=C.PERIODID AND A.PRODUCTID=C.PRODUCTID AND A.DATE=C.CREDATE
WHERE LEFT(DATE,4)=LEFT('${EDATE}',4)
AND DATE<='${EDATE}'
GROUP BY 
  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID
),        
T1 AS 
(SELECT -----------------------------------当期累计（实际）
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	${SWITCH(subs,0,"SUM(ORDERSUIT)",1,"SUM(ORDERSUIT*RATIO)",2,"SUM(ORDERSUIT*HF_RATIO)")} ORDERSUIT,
	${SWITCH(subs,0,"SUM(ORDERAREA)",1,"SUM(ORDERAREA*RATIO)",2,"SUM(ORDERAREA*HF_RATIO)")} ORDERAREA,
	${SWITCH(subs,0,"SUM(ORDERAMOUNT)",1,"SUM(ORDERAMOUNT*RATIO)",2,"SUM(ORDERAMOUNT*HF_RATIO)")} ORDERAMOUNT,
	${SWITCH(subs,0,"SUM(SIGNSUIT)",1,"SUM(SIGNSUIT*RATIO)",2,"SUM(SIGNSUIT*HF_RATIO)")} SIGNSUIT,
	${SWITCH(subs,0,"SUM(SIGNAREA)",1,"SUM(SIGNAREA*RATIO)",2,"SUM(SIGNAREA*HF_RATIO)")} SIGNAREA,
	${SWITCH(subs,0,"SUM(SIGNAMOUNT)",1,"SUM(SIGNAMOUNT*RATIO)",2,"SUM(SIGNAMOUNT*HF_RATIO)")} SIGNAMOUNT,
	${SWITCH(subs,0,"SUM(INCOMEAMOUNT)",1,"SUM(INCOMEAMOUNT*RATIO)",2,"SUM(INCOMEAMOUNT*HF_RATIO)")} INCOMEAMOUNT

FROM
	F_MKT_PROJECT_SALE A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
WHERE DATE BETWEEN '${SDATE}' and '${EDATE}'

GROUP BY 
  A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID
), T11 AS 
(SELECT -----------------------------------当期累计（扣减）
	A.PROJECTID,
	
	A.PERIODID,

	A.PRODUCTID,
	--CASE WHEN A.STATUS='1' THEN '已确认' ELSE '未确认' END AS STATUS ,
	${SWITCH(subs,0,"SUM(ORDERSUIT)",1,"SUM(ORDERSUIT*RATIO)",2,"SUM(ORDERSUIT*HF_RATIO)")} ORDERSUIT,
	${SWITCH(subs,0,"SUM(ORDERAREA)",1,"SUM(ORDERAREA*RATIO)",2,"SUM(ORDERAREA*HF_RATIO)")} ORDERAREA,
	${SWITCH(subs,0,"SUM(ORDERAMOUNT)",1,"SUM(ORDERAMOUNT*RATIO)",2,"SUM(ORDERAMOUNT*HF_RATIO)")} ORDERAMOUNT,
	${SWITCH(subs,0,"SUM(SIGNSUIT)",1,"SUM(SIGNSUIT*RATIO)",2,"SUM(SIGNSUIT*HF_RATIO)")} SIGNSUIT,
	${SWITCH(subs,0,"SUM(SIGNAREA)",1,"SUM(SIGNAREA*RATIO)",2,"SUM(SIGNAREA*HF_RATIO)")} SIGNAREA,
	${SWITCH(subs,0,"SUM(SIGNAMOUNT)",1,"SUM(SIGNAMOUNT*RATIO)",2,"SUM(SIGNAMOUNT*HF_RATIO)")} SIGNAMOUNT,
	${SWITCH(subs,0,"SUM(INCOMEAMOUNT)",1,"SUM(INCOMEAMOUNT*RATIO)",2,"SUM(INCOMEAMOUNT*HF_RATIO)")} INCOMEAMOUNT
FROM
	F_MKT_SALE_MONTHKPI A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
WHERE YEARMONTH BETWEEN SUBSTRING('${SDATE}', 1, 7)  and SUBSTRING('${EDATE}', 1, 7)
GROUP BY 
 	A.PROJECTID,

	A.PERIODID,

	A.PRODUCTID
	--A.STATUS
),     
T0 AS 
(SELECT ------------------------------总累计
   'FU' AS  FU, 
  TT.AREANAME,
  TT.CITYNAME,
	TT.PROJECTID,
  ISNULL(TT.SALERGROUPNAME,TT.PROJECTNAME) PROJECTNAME ,
	tt.PERIODNAME ,
	TT.PERIODID,
	TT.PRODUCTID,
  TT.PROJECTSORT,
	${SWITCH(subs,0,"SUM(ORDERSUIT)",1,"SUM(ORDERSUIT*RATIO)",2,"SUM(ORDERSUIT*HF_RATIO)")} ORDERSUIT,
	${SWITCH(subs,0,"SUM(ORDERAREA)",1,"SUM(ORDERAREA*RATIO)",2,"SUM(ORDERAREA*HF_RATIO)")} ORDERAREA,
	${SWITCH(subs,0,"SUM(ORDERAMOUNT)",1,"SUM(ORDERAMOUNT*RATIO)",2,"SUM(ORDERAMOUNT*HF_RATIO)")} ORDERAMOUNT,
	${SWITCH(subs,0,"SUM(SIGNSUIT)",1,"SUM(SIGNSUIT*RATIO)",2,"SUM(SIGNSUIT*HF_RATIO)")} SIGNSUIT,
	${SWITCH(subs,0,"SUM(SIGNAREA)",1,"SUM(SIGNAREA*RATIO)",2,"SUM(SIGNAREA*HF_RATIO)")} SIGNAREA,
	${SWITCH(subs,0,"SUM(SIGNAMOUNT)",1,"SUM(SIGNAMOUNT*RATIO)",2,"SUM(SIGNAMOUNT*HF_RATIO)")} SIGNAMOUNT,
	${SWITCH(subs,0,"SUM(INCOMEAMOUNT)",1,"SUM(INCOMEAMOUNT*RATIO)",2,"SUM(INCOMEAMOUNT*HF_RATIO)")} INCOMEAMOUNT
FROM
	DIM_MKT_PROJECT TT
LEFT JOIN F_MKT_PROJECT_SALE B ON TT.PERIODID=B.PERIODID AND TT.PRODUCTID=B.PRODUCTID
WHERE DATE <= '${EDATE}'
GROUP BY 
  TT.AREANAME,
  TT.CITYNAME,
	TT.PROJECTID,
	ISNULL(TT.SALERGROUPNAME,TT.PROJECTNAME),
	TT.PERIODID,
	tt.PERIODNAME,
	TT.PRODUCTID,
  TT.PROJECTSORT
)
 , QY AS (
SELECT 
   Q1.PERIODID,
   Q1.PRODUCTID,
   COUNT(Q1.ROOM_CODE) QYTS,
   SUM(DATEDIFF(DAY,ORDER_DATE,CONTRACT_DATE))QYDAYS
FROM 
(SELECT
  ORDER_NUMBER,
  A.PERIODID,
  A.PRODUCTID,
  ROOM_CODE,
  ORDER_DATE
FROM
	F_MKT_ORDER A
WHERE ORDER_DATE BETWEEN '${SDATE}' AND '${EDATE}'
AND ORDER_STATUS='20'
AND (MAIN_BUILDING_ID is NULL OR MAIN_BUILDING_ID='')
)Q1 INNER JOIN 
(SELECT 
  ROOM_CODE,
  ORDER_NUMBER,
  CONTRACT_DATE
FROM F_MKT_CONTRACT
WHERE CONTRACT_STATE ='20'
AND CONTRACT_DATE  BETWEEN '${SDATE}' AND '${EDATE}'
)Q2 ON Q1.ORDER_NUMBER=Q2.ORDER_NUMBER
GROUP BY 
   Q1.PERIODID,
   Q1.PRODUCTID
) ,
T5 AS ( 
SELECT  ------------------------货值
A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	${SWITCH(subs,0,"SUM(INSALESUIT)",1,"SUM(INSALESUIT*RATIO)",2,"SUM(INSALESUIT*HF_RATIO)")} INSALESUIT,
	${SWITCH(subs,0,"SUM(INSALEAREA)",1,"SUM(INSALEAREA*RATIO)",2,"SUM(INSALEAREA*HF_RATIO)")} INSALEAREA,
	${SWITCH(subs,0,"SUM(INSALE_INSIDE_AMOUNT)",1,"SUM(INSALE_INSIDE_AMOUNT*RATIO)",2,"SUM(INSALE_INSIDE_AMOUNT*HF_RATIO)")} INSALE_INSIDE_AMOUNT,

	${SWITCH(subs,0,"SUM(WT_SUIT)",1,"SUM(WT_SUIT*RATIO)",2,"SUM(WT_SUIT*HF_RATIO)")} WT_SUIT,
	${SWITCH(subs,0,"SUM(WT_AREA)",1,"SUM(WT_AREA*RATIO)",2,"SUM(WT_AREA*HF_RATIO)")} WT_AREA,
	${SWITCH(subs,0,"SUM(WT_INSAIDE_AMOUNT)",1,"SUM(WT_INSAIDE_AMOUNT*RATIO)",2,"SUM(WT_INSAIDE_AMOUNT*HF_RATIO)")} WT_INSAIDE_AMOUNT,

  ${SWITCH(subs,0,"SUM(KS_SUIT)+SUM(BKS_SUIT)",1," SUM(KS_SUIT*RATIO)+SUM(BKS_SUIT*RATIO)",2," SUM(KS_SUIT*HF_RATIO)+SUM(BKS_SUIT*HF_RATIO)")} YT_SUIT,
  ${SWITCH(subs,0,"SUM(KS_AREA)+SUM(BKS_AREA)",1," SUM(KS_AREA*RATIO)+SUM(BKS_AREA*RATIO)",2," SUM(KS_AREA*HF_RATIO)+SUM(BKS_AREA*HF_RATIO)")} YT_AREA,
  ${SWITCH(subs,0,"SUM(KS_INSIDE_AMOUNT)+SUM(BKS_INSIDE_AMOUNT)",1," SUM(KS_INSIDE_AMOUNT*RATIO)+SUM(BKS_INSIDE_AMOUNT*RATIO)",2," SUM(KS_INSIDE_AMOUNT*HF_RATIO)+SUM(BKS_INSIDE_AMOUNT*HF_RATIO)")}     YT_INSAIDE_AMOUNT,
	${SWITCH(subs,0,"SUM(KS_SUIT)",1,"SUM(KS_SUIT*RATIO)",2,"SUM(KS_SUIT*HF_RATIO)")} KS_SUIT,
	${SWITCH(subs,0,"SUM(KS_AREA)",1,"SUM(KS_AREA*RATIO)",2,"SUM(KS_AREA*HF_RATIO)")} KS_AREA,
	${SWITCH(subs,0,"SUM(KS_INSIDE_AMOUNT)",1,"SUM(KS_INSIDE_AMOUNT*RATIO)",2,"SUM(KS_INSIDE_AMOUNT*HF_RATIO)")} KS_INSIDE_AMOUNT,

	${SWITCH(subs,0,"SUM(BKS_SUIT)",1,"SUM(BKS_SUIT*RATIO)",2,"SUM(BKS_SUIT*HF_RATIO)")} BKS_SUIT,
	${SWITCH(subs,0,"SUM(BKS_AREA)",1,"SUM(BKS_AREA*RATIO)",2,"SUM(BKS_AREA*HF_RATIO)")} BKS_AREA,
	${SWITCH(subs,0,"SUM(BKS_INSIDE_AMOUNT)",1,"SUM(BKS_INSIDE_AMOUNT*RATIO)",2,"SUM(BKS_INSIDE_AMOUNT*HF_RATIO)")} BKS_INSIDE_AMOUNT
 from 
  F_MKT_PROJECT_STOCK_ALL A left join (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM  DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
 where A.YEARMONTH=left(CONVERT(VARCHAR(24),DATEADD(day,-1,getdate()),120),7)   -- 获取最新的存量情况
 group by  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID
)    
,TEMP_DQ_INCOME AS   -----------------------回款平均时长
(
	SELECT 
		A.PERIOD_ID,A.PERIOD_NAME,A.PRODUCT_ID,
		SUM(A.HKSC)/COUNT(A.HOUSE_ID) AS PJHKSC
	FROM (
		SELECT 
			PROJECT_ID,
			PROJECT_NAME,
			PERIOD_ID,
			PERIOD_NAME,
			PRODUCT_ID,
			HOUSE_ID,
			ORDER_CREATE_DATE,
			LASTREBACKDATE,
			DATEDIFF(DAY,ORDER_CREATE_DATE,LASTREBACKDATE)	AS HKSC
		FROM F_MKT_PROJECT_INCOME
		WHERE ISNULL(REBACKSUM,0) > 0 AND ISNULL(REBACKSUM,0)>= ISNULL(CONTRACT_TOTAL_PRICE,0)  --已开始回款且回款金额大于等于签约金额（即回款完成）
		AND (ORDER_CREATE_DATE BETWEEN '${SDATE}' and '${EDATE}')
		AND (LASTREBACKDATE BETWEEN '${SDATE}' and '${EDATE}')
		) A
		GROUP BY A.PERIOD_ID,A.PERIOD_NAME,A.PRODUCT_ID 
),TEMP_YEAR_INCOME AS
(
	SELECT 
		A.PERIOD_ID,A.PERIOD_NAME,A.PRODUCT_ID,
		SUM(A.HKSC)/COUNT(A.HOUSE_ID) AS PJHKSC
	FROM (
	SELECT 
		PROJECT_ID,
		PROJECT_NAME,
		PERIOD_ID,
		PERIOD_NAME,
		PRODUCT_ID,
		HOUSE_ID,
		ORDER_CREATE_DATE,
		LASTREBACKDATE,
		DATEDIFF(DAY,ORDER_CREATE_DATE,LASTREBACKDATE)	AS HKSC
	FROM F_MKT_PROJECT_INCOME
	WHERE ISNULL(REBACKSUM,0) > 0 AND ISNULL(REBACKSUM,0)>= ISNULL(CONTRACT_TOTAL_PRICE,0)  --已开始回款且回款金额大于等于签约金额（即回款完成）
	AND YEAR(ORDER_CREATE_DATE) = YEAR('${EDATE}')
	AND YEAR(LASTREBACKDATE) = YEAR('${EDATE}')
	) A
	GROUP BY A.PERIOD_ID,A.PERIOD_NAME,A.PRODUCT_ID 
),TEMP_INCOME AS
(
SELECT 
		A.PERIOD_ID,A.PERIOD_NAME,A.PRODUCT_ID,
		SUM(A.HKSC)/COUNT(A.HOUSE_ID) AS PJHKSC
	FROM (
		SELECT 
			PROJECT_ID,
			PROJECT_NAME,
			PERIOD_ID,
			PERIOD_NAME,
			PRODUCT_ID,
			HOUSE_ID,
			ORDER_CREATE_DATE,
			LASTREBACKDATE,
			DATEDIFF(DAY,ORDER_CREATE_DATE,LASTREBACKDATE)	AS HKSC
		FROM F_MKT_PROJECT_INCOME
		WHERE ISNULL(REBACKSUM,0) > 0 AND ISNULL(REBACKSUM,0)>= ISNULL(CONTRACT_TOTAL_PRICE,0)  --已开始回款且回款金额大于等于签约金额（即回款完成）
		) A
		GROUP BY A.PERIOD_ID,A.PERIOD_NAME,A.PRODUCT_ID 
),H1 AS (-----------------------------------------当期90天回齐全款率
SELECT 
   A.PERIODID,
   A.PRODUCTID,
   A.ORDER_DATE,
	 A.ROOM_CODE,
   A.ORDER_TOTAL_PRICE,
   A.MAIN_BUILDING_ID
FROM
	F_MKT_ORDER A
WHERE
 A.ORDER_STATUS NOT IN  ('30', '40', '50', '90')
AND ORDER_DATE BETWEEN  '${SDATE}' AND '${EDATE}'
),
H2 AS (
SELECT 
	ROOM_CODE,
  TOTAL_PRICE,
	TOTAL_CHARGE_SUM,
  MAX(COMPLETION_ACTUAL_DATE) COMPLETION_PLAN_DATE
FROM
	F_MKT_SALES_PROCESS_INFO
WHERE
	TOTAL_PRICE<=TOTAL_CHARGE_SUM
GROUP BY 
  ROOM_CODE,
	TOTAL_PRICE,
	TOTAL_CHARGE_SUM
),
H3 AS 
(SELECT 
   H1.PERIODID,
   H1.PRODUCTID,
   SUM(CASE WHEN (MAIN_BUILDING_ID is NULL OR MAIN_BUILDING_ID='') THEN 1 ELSE 0 END) HQTS,
   SUM(TOTAL_PRICE) TOTAL_PRICE
FROM H1 INNER JOIN H2 ON H1.ROOM_CODE=H2.ROOM_CODE
WHERE  DATEDIFF(DAY,ORDER_DATE,COMPLETION_PLAN_DATE)<=90
GROUP BY 
   H1.PERIODID,
    H1.PRODUCTID
),
H4 AS 
(SELECT 
   H1.PERIODID, H1.PRODUCTID,
   SUM(CASE WHEN (MAIN_BUILDING_ID is NULL OR MAIN_BUILDING_ID='') THEN 1 ELSE 0 END)  ZTS,
   SUM(ORDER_TOTAL_PRICE)  ORDER_TOTAL_PRICE
FROM H1 
GROUP BY 
   H1.PERIODID,
   H1.PRODUCTID
),
H5 AS (SELECT   
   H4.PERIODID,
   H4.PRODUCTID,
   HQTS,
   ZTS,
   TOTAL_PRICE/10000 HQJE,
   ORDER_TOTAL_PRICE/10000 ZJE
FROM H4 LEFT JOIN H3 ON H4.PERIODID=H3.PERIODID AND H4.PRODUCTID=H3.PRODUCTID 
),H6 AS(
	SELECT
		PROJECTNAME,
		PERIODID, 
		PRODUCTID,
		SUM (ORDERAMOUNT) as ORDERAMOUNT,
		SUM (INCOMEAMOUNT) as INCOMEAMOUNT,
		SUM (ORDERAMOUNT - INCOMEAMOUNT) as NOINCOME_AMT
	FROM F_MKT_PROJECT_SALE
	WHERE PROJECTID LIKE   'HZ%'
	GROUP BY PROJECTNAME, PERIODID, PRODUCTID
),M1 as ( select 
AREANAME,
CITYNAME,
${SWITCH(subs,0,"SUM(ORDERTARGET/10000)",1,"SUM(EQUITY_ORDERTARGET/10000)",2,"0")} ORDERTARGET,
${SWITCH(subs,0,"SUM(CONTRACTTARGET/10000)",1,"SUM(EQUITY_CONTRACTTARGET/10000)",2,"0")} CONTRACTTARGET,
${SWITCH(subs,0,"SUM(RECEIPTTARGET/10000)",1,"SUM(EQUITY_RECEIPTTARGET/10000)",2,"0")} RECEIPTTARGET

from  F_MKT_PROJECT_SALE_CITYTARGET  
 where YEARMONTH = left ('${EDATE}',4)

group by 
AREANAME,
CITYNAME  ),
-----------------------------------上面是城市的年目标，注意是只选城市的，如果涉及区域汇总的，还是用另一个数据集去过滤 ， 不要问我为什么,因为我现在暂时没想到好的办法描述 ，你预览看看就知道了
M2 AS (select 
AREANAME,
CITYNAME,
${SWITCH(subs,0,"SUM(ORDERTARGET/10000)",1,"SUM(EQUITY_ORDERTARGET/10000)",2,"0")} ORDERTARGET,
${SWITCH(subs,0,"SUM(CONTRACTTARGET/10000)",1,"SUM(EQUITY_CONTRACTTARGET/10000)",2,"0")} CONTRACTTARGET,
${SWITCH(subs,0,"SUM(RECEIPTTARGET/10000)",1,"SUM(EQUITY_RECEIPTTARGET/10000)",2,"0")} RECEIPTTARGET
 from  F_MKT_PROJECT_SALE_CITYTARGET  
 where YEARMONTH = left ('${EDATE}',7)
group by 
AREANAME,
CITYNAME
)
--------------------------------上面是城市的月目标，注意是只选城市的，如果涉及区域汇总的，还是用另一个数据集去过滤 ， 不要问我为什么,因为我现在暂时没想到好的办法描述 ，你预览看看就知道了
------------------------WITH AS 结束

SELECT 
  ${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","T0.AREANAME," ) }
	${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","T0.CITYNAME," ) }
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTID," ) }
  ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTNAME," ) }
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTSORT," ) }
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","T0.PERIODID," ) }
  ${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","T0.PERIODNAME," ) }
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,""," 	T3.SHORTNAME  PRODUCTNAME," ) }
--------------------------------------------------------------------------------------------以上是维度
  ${SWITCH(subs,0,"Convert(decimal(18,0),sum(DAY_ORDERNUM))",1,"Convert(decimal(18,1),sum(DAY_ORDERNUM*T4.RATIO))",2,"Convert(decimal(18,1),sum(DAY_ORDERNUM*T4.HF_RATIO))")} DAY_ORDERNUM,
	${SWITCH(subs,0,"Convert(decimal(18,0),sum(DAY_ORDERAREA))",1,"Convert(decimal(18,1),sum(DAY_ORDERAREA*T4.RATIO))",2,"Convert(decimal(18,1),sum(DAY_ORDERAREA*T4.HF_RATIO))")} DAY_ORDERAREA,
	${SWITCH(subs,0,"Convert(decimal(18,0),sum(DAY_ORDERPRICE/10000))",1,"Convert(decimal(18,1),sum(DAY_ORDERPRICE/10000*T4.RATIO))",2,"Convert(decimal(18,1),sum(DAY_ORDERPRICE/10000*T4.HF_RATIO))")} DAY_ORDERPRICE,
 
  Convert(decimal(18,0),sum(T1.ORDERSUIT))  as MORDERSUIT, --当期
  sum(T1.ORDERAREA) as MORDERAREA,
  sum(T1.ORDERAMOUNT/10000) as  MORDERAMOUNT,
  Convert(decimal(18,0),sum(T9.ORDERSUIT))  as YORDERSUIT, --年
  sum(T9.ORDERAREA) as  YORDERAREA,
  sum(T9.ORDERAMOUNT/10000) as YORDERAMOUNT,
	
	Convert(decimal(18,0),sum(T0.ORDERSUIT)) as ALLORDERSUIT, --总
  sum(T0.ORDERAREA) as ALLORDERAREA,
  sum(T0.ORDERAMOUNT/10000) as  ALLORDERAMOUNT,    --认购套数面积金额
  T0.FU,
	----------------------------------------------------------------以上是认购(实际)
  Convert(decimal(18,0),sum(T11.ORDERSUIT))  as SUB_MORDERSUIT, --当期
  sum(T11.ORDERAREA) as SUB_MORDERAREA,
  sum(T11.ORDERAMOUNT/10000) as  SUB_MORDERAMOUNT,	
	----------------------------------------------------------------以上是认购扣减	
  ${SWITCH(subs,0,"Convert(decimal(18,0),sum(DAY_CONTRACTNUM))",1,"Convert(decimal(18,1),sum(DAY_CONTRACTNUM*T4.RATIO))",2,"Convert(decimal(18,1),sum(DAY_CONTRACTNUM*T4.HF_RATIO))")} DAY_CONTRACTNUM,
	${SWITCH(subs,0,"Convert(decimal(18,0),sum(DAY_CONTRACTAREA))",1,"Convert(decimal(18,1),sum(DAY_CONTRACTAREA*T4.RATIO))",2,"Convert(decimal(18,1),sum(DAY_CONTRACTAREA*T4.HF_RATIO))")} DAY_CONTRACTAREA,
	${SWITCH(subs,0,"Convert(decimal(18,0),sum(DAY_CONTRACTPRICE/10000))",1,"Convert(decimal(18,1),sum(DAY_CONTRACTPRICE/10000*T4.RATIO))",2,"Convert(decimal(18,1),sum(DAY_CONTRACTPRICE/10000*T4.HF_RATIO))")} as DAY_CONTRACTPRICE,

  Convert(decimal(18,0),sum(T1.SIGNSUIT)) as MSIGNSUIT, --当期
  sum(T1.SIGNAREA) as MSIGNAREA,
  sum(T1.SIGNAMOUNT/10000) as  MSIGNAMOUNT,
	
  Convert(decimal(18,0),sum(T9.SIGNSUIT)) as YSIGNSUIT, --当年
  sum(T9.SIGNAREA) as  YSIGNAREA,
  sum(T9.SIGNAMOUNT/10000) as YSIGNAMOUNT,
  Convert(decimal(18,0),sum(T9.DDNUM)) as DDNUM, --当年认购当年签约
  sum(T9.DDAREA) as  DDAREA,
  sum(T9.DDAMOUNT/10000) as DDAMOUNT,
  Convert(decimal(18,0),sum(T9.WDNUM))  as WDNUM, --往年认购当年签约
  sum(T9.WDAREA) as  WDAREA,
  sum(T9.WDAMOUNT/10000) as WDAMOUNT,

	Convert(decimal(18,0),sum(T0.SIGNSUIT)) as ALLSIGNSUIT, --总
  sum(T0.SIGNAREA) as ALLSIGNAREA,
  sum(T0.SIGNAMOUNT/10000) as  ALLSIGNAMOUNT ,   --签约套数面积金额
------------------------------------------------------------------------以上是签约实际
  Convert(decimal(18,0),sum(T11.SIGNSUIT))  as SUB_MSIGNSUIT, --当期
  sum(T11.SIGNAREA) as SUB_MSIGNAREA,
  sum(T11.SIGNAMOUNT/10000) as  SUB_MSIGNAMOUNT,
------------------------------------------------------------------------以上是签约扣减

  ${SWITCH(subs,0,"sum(DAY_RECEIPT/10000) ",1,"sum(DAY_RECEIPT/10000*T4.RATIO) ",2,"sum(DAY_RECEIPT/10000*T4.HF_RATIO) ")} DAY_RECEIPT,
  sum(T1.INCOMEAMOUNT/10000) as  MINCOMEAMOUNT, --当期 
  sum(T9.INCOMEAMOUNT/10000) as YINCOMEAMOUNT,  --年
  sum(T9.DDH/10000) as DDH,  --当年认购当年回款
  sum(T9.WDH/10000) as WDH,  --往年认购当年回款
  sum(T0.INCOMEAMOUNT/10000) as  ALLINCOMEAMOUNT,    --回款金额
------------------------------------------------------------------------以上是回款
${SWITCH(subs,0,"Convert(decimal(18,0),sum(T5.INSALESUIT)) ",1," Convert(decimal(18,1),sum(T5.INSALESUIT))",2,"Convert(decimal(18,1),sum(T5.INSALESUIT))")} INSALESUIT,--存量
sum(T5.INSALEAREA)   as INSALEAREA, 
sum(T5.INSALE_INSIDE_AMOUNT/10000)  as INSALEAMOUNT,
${SWITCH(subs,0,"Convert(decimal(18,0),sum(T5.WT_SUIT)) ",1," Convert(decimal(18,1),sum(T5.WT_SUIT))",2," Convert(decimal(18,1),sum(T5.WT_SUIT))")} WT_SUIT,--已取证未推
sum(T5.WT_AREA)   as WT_AREA, 
sum(T5.WT_INSAIDE_AMOUNT/10000) as WT_INSAIDE_AMOUNT,
${SWITCH(subs,0,"Convert(decimal(18,0),sum(T5.YT_SUIT)) ",1," Convert(decimal(18,1),sum(T5.YT_SUIT))",2," Convert(decimal(18,1),sum(T5.YT_SUIT))")} YT_SUIT,--已推未售
sum(T5.YT_AREA) as YT_AREA, 
sum(T5.YT_INSAIDE_AMOUNT/10000)  as YT_INSAIDE_AMOUNT,
${SWITCH(subs,0,"Convert(decimal(18,0),sum(T5.KS_SUIT)) ",1," Convert(decimal(18,1),sum(T5.KS_SUIT))",2," Convert(decimal(18,1),sum(T5.KS_SUIT))")} KS_SUIT,--可售
sum(T5.KS_AREA)  as KS_AREA, 
sum(T5.KS_INSIDE_AMOUNT/10000)  as KS_INSIDE_AMOUNT,
${SWITCH(subs,0,"Convert(decimal(18,0),sum(T5.BKS_SUIT)) ",1," Convert(decimal(18,1),sum(T5.BKS_SUIT))",2," Convert(decimal(18,1),sum(T5.BKS_SUIT))")} BKS_SUIT,--不可售
sum(T5.BKS_AREA)  as BKS_AREA, 
sum(T5.BKS_INSIDE_AMOUNT/10000) as BKS_INSIDE_AMOUNT,
-----------以上是存量
${SWITCH(subs,0,"sum(T6.SIGN_WYQ/10000) ",1,"sum(T6.SIGN_WYQ/10000*T4.RATIO) ",2,"sum(T6.SIGN_WYQ/10000*T4.HF_RATIO) ")} SIGN_WYQ,  --签约未逾期
${SWITCH(subs,0,"sum(T6.SIGN_YQ/10000) ",1,"sum(T6.SIGN_YQ/10000*T4.RATIO) ",2,"sum(T6.SIGN_YQ/10000*T4.HF_RATIO) ")} SIGN_YQ,  --签约逾期
${SWITCH(subs,0,"sum(T6.ORDER_WYQ/10000) ",1,"sum(T6.ORDER_WYQ/10000*T4.RATIO) ",2,"sum(T6.ORDER_WYQ/10000*T4.HF_RATIO) ")} ORDER_WYQ,  --认购未逾期
${SWITCH(subs,0,"sum(T6.ORDER_YQ/10000) ",1,"sum(T6.ORDER_YQ/10000*T4.RATIO) ",2,"sum(T6.ORDER_YQ/10000*T4.HF_RATIO) ")} ORDER_YQ,  --认购逾期
${SWITCH(subs,0,"sum(H6.NOINCOME_AMT/10000) ",1,"sum(H6.NOINCOME_AMT/10000*T4.RATIO) ",2,"sum(H6.NOINCOME_AMT/10000*T4.HF_RATIO) ")} NOINCOME_AMT,  --认购未回款（合作项目）
----------以上是待回款
	AVG(TEMP_INCOME.PJHKSC) AS PJHKSC, 
	AVG(TEMP_DQ_INCOME.PJHKSC) AS DQ_PJHKSC, 
	AVG(TEMP_YEAR_INCOME.PJHKSC) AS YERA_PJHKSC ,
----------以上是平均回款时长回款
avg(M1.ORDERTARGET) as YORDERTARGET, --认购
avg(M1.CONTRACTTARGET) as YCONTRACTTARGET, --签约
avg(M1.RECEIPTTARGET) as YRECEIPTTARGET,--回款
-----------以上是年目标
avg(M2.ORDERTARGET) as MORDERTARGET, --认购
avg(M2.CONTRACTTARGET) as MCONTRACTTARGET, --签约
avg(M2.RECEIPTTARGET) as MRECEIPTTARGET,  --回款
--以上是月目标
SUM(QYTS) QYTS,--签约总套数
SUM(QYDAYS) QYDAYS,---签约总时长
SUM(HQTS) HQTS,--回齐套数
SUM(ZTS) ZTS,---总套数
SUM(HQJE) HQJE,--回齐金额
SUM(ZJE) ZJE--总金额
FROM T0 LEFT JOIN T9 ON T0.PERIODID=T9.PERIODID AND T0.PRODUCTID=T9.PRODUCTID 
LEFT JOIN T1 ON T0.PERIODID=T1.PERIODID AND T0.PRODUCTID=T1.PRODUCTID 
LEFT JOIN F_MKT_PROJECT_SALE_DAILY T2 ON T0.PERIODID=T2.PERIODID AND T0.PRODUCTID=T2.PRODUCTID AND T2.CREDATE='${EDATE}'
LEFT JOIN DIM_MKT_PROJECT T4 ON T0.PERIODID=T4.PERIODID AND T0.PRODUCTID=T4.PRODUCTID
LEFT JOIN DIM_PRODUCT_TYPE T3 ON T0.PRODUCTID=T3.PRODUCTID
LEFT JOIN  T5 ON T0.PERIODID=T5.PERIODID AND T0.PRODUCTID=T5.PRODUCTID  
LEFT JOIN F_MKT_PROJECT_NOREFUND T6 ON T0.PERIODID=T6.PERIODID AND T0.PRODUCTID=T6.PRODUCTID  and T6.YEARMONTH=left('${EDATE}',7)
LEFT JOIN TEMP_INCOME ON T0.PERIODID=TEMP_INCOME.PERIOD_ID AND T0.PRODUCTID=TEMP_INCOME.PRODUCT_ID 
LEFT JOIN TEMP_YEAR_INCOME ON T0.PERIODID=TEMP_YEAR_INCOME.PERIOD_ID AND T0.PRODUCTID=TEMP_YEAR_INCOME.PRODUCT_ID 
LEFT JOIN TEMP_DQ_INCOME ON T0.PERIODID=TEMP_DQ_INCOME.PERIOD_ID AND T0.PRODUCTID=TEMP_DQ_INCOME.PRODUCT_ID
LEFT JOIN QY ON  T0.PERIODID=QY.PERIODID AND T0.PRODUCTID=QY.PRODUCTID 
LEFT JOIN H5 ON  T0.PERIODID=H5.PERIODID AND T0.PRODUCTID=H5.PRODUCTID 
LEFT JOIN H6 ON T0.PERIODID=H6.PERIODID AND T0.PRODUCTID=H6.PRODUCTID 
LEFT JOIN M1 ON T0.AREANAME=M1.AREANAME and T0.CITYNAME=M1.CITYNAME 
LEFT JOIN M2 ON T0.AREANAME=M2.AREANAME and T0.CITYNAME=M2.CITYNAME 
LEFT JOIN T11 ON T0.PERIODID=T11.PERIODID AND T0.PRODUCTID=T11.PRODUCTID 
INNER JOIN user_org ON T0.PROJECTID =user_org.DEPT_ID
where T0.CITYNAME<>'盘锦'
and T0.AREANAME in ('${AREA}')
and T0.CITYNAME in ('${CITY}')
${if(len(PRO) == 0,"","and T0.PROJECTID  in ('" + PRO + "')")}
${if(len(DUCT) == 0,"","and T3.SHORTNAME  in ('" + DUCT + "')")}


GROUP BY
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","T0.AREANAME," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","T0.CITYNAME," ) }
${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTID," ) }
${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTNAME," ) }
${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTSORT," ) }
${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","T0.PERIODID," ) }
${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","T0.PERIODNAME," ) }
${ if(INARRAY("5", SPLIT(counts, ",")) = 0,""," T3.SHORTNAME, " ) }
	FU
ORDER BY 
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","charindex(T0.AREANAME,'珠海大区|华南大区|华东大区|北方大区|北京区域')," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","charindex(T0.CITYNAME,'珠海华欣|珠海华景|珠海西区|中山|广州|南宁|江门|惠州|深圳|湛江|长沙|重庆|汕尾|上海|无锡|苏州|南京|杭州|武汉独资|武汉合资|鄂州|郑州|威海|青岛|沈阳|大连|包头|北京|天津|西安|盘锦')," ) }
${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTSORT," ) }
${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTID," ) }
${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","T0.PERIODID," ) }
${ if(INARRAY("5", SPLIT(counts, ",")) = 0,""," charindex(T3.SHORTNAME,'住宅|别墅|商业|车位'), " ) }
FU

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

select AREANAME FROM (
SELECT  distinct AREANAME 
FROM   DIM_MKT_PROJECT 
WHERE PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)) A
ORDER BY 
charindex(AREANAME,'珠海大区|华南大区|华东大区|北方大区|北京区域')

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT CITYNAME FROM (
select distinct CITYNAME from DIM_MKT_PROJECT 
WHERE PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)
${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")} ) A
ORDER BY charindex(CITYNAME,'珠海华欣|珠海华景|珠海西区|斗门|中山|广州|南宁|上海|南京|沈阳|大连|包头|')

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT DISTINCT PROJECTID,'('+PROJECTID+')'+ ISNULL(SALERGROUPNAME,PROJECTNAME) PROJECTNAME FROM DIM_MKT_PROJECT
WHERE PROJECTID IN
(
	SELECT DISTINCT DEPT_ID FROM user_org 
)  
${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITYNAME in ('" + CITY + "')")}

with T1 as (select 'FU' AS FU  )
 select 
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME," ) }
 ${SWITCH(subs,0,"sum(ORDERTARGET)/10000",1,"sum(EQUITY_ORDERTARGET)/10000",2,"''")} ORDERTARGET,
 ${SWITCH(subs,0,"sum(CONTRACTTARGET)/10000",1,"sum(EQUITY_CONTRACTTARGET)/10000",2,"''")} CONTRACTTARGET,
 ${SWITCH(subs,0,"sum(RECEIPTTARGET)/10000",1,"sum(EQUITY_RECEIPTTARGET)/10000",2,"''")} RECEIPTTARGET
 from  F_MKT_PROJECT_SALE_CITYTARGET  left join T1 on 1=1
 where YEARMONTH = left ('${EDATE}',4)
${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITYNAME in ('" + CITY + "')")}
group by 
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME," ) }
T1.FU

with T1 as (select 'FU' AS FU  )
 select 
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME," ) }
 ${SWITCH(subs,0,"sum(ORDERTARGET)/10000",1,"sum(EQUITY_ORDERTARGET)/10000",2,"''")} ORDERTARGET,
 ${SWITCH(subs,0,"sum(CONTRACTTARGET)/10000",1,"sum(EQUITY_CONTRACTTARGET)/10000",2,"''")} CONTRACTTARGET,
 ${SWITCH(subs,0,"sum(RECEIPTTARGET)/10000",1,"sum(EQUITY_RECEIPTTARGET)/10000",2,"''")} RECEIPTTARGET
 from  F_MKT_PROJECT_SALE_CITYTARGET  left join T1 on 1=1
 where YEARMONTH = left ('${EDATE}',7)
${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITYNAME in ('" + CITY + "')")}
group by 
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME," ) }
T1.FU

