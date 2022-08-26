SELECT MAX (INSERTIME) INSERTIME FROM F_MKT_PROJECT_SALE_DAILY


WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
, T9 AS 
(SELECT
  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREA_TYPE,
 ${switch(subs,1," SUM(ORDERSUIT)  ",2," SUM(ORDERSUIT*RATIO) ",3," SUM(ORDERSUIT*HF_RATIO) ")}  as ORDERSUIT,
	${switch(subs,1," SUM(ORDERAREA)  ",2," SUM(ORDERAREA*RATIO) ",3," SUM(ORDERAREA*HF_RATIO) ")}  as ORDERAREA,
  ${switch(subs,1," SUM(ORDERAMOUNT)  ",2," SUM(ORDERAMOUNT*RATIO) ",3,"SUM(ORDERAMOUNT*HF_RATIO) ")}  as ORDERAMOUNT,  --认购套数面积金额
	${switch(subs,1," SUM(SIGNSUIT)  ",2," SUM(SIGNSUIT*RATIO) ",3," SUM(SIGNSUIT*HF_RATIO) ")}  as SIGNSUIT,
	${switch(subs,1," SUM(SIGNAREA)  ",2," SUM(SIGNAREA*RATIO) ",3," SUM(SIGNAREA*HF_RATIO) ")}  as SIGNAREA,
  ${switch(subs,1," SUM(SIGNAMOUNT)  ",2," SUM(SIGNAMOUNT*RATIO) ",3," SUM(SIGNAMOUNT*HF_RATIO) ")}  as SIGNAMOUNT,  --签约套数面积金额
	 ${switch(subs,1," SUM(INCOMEAMOUNT)  ",2," SUM(INCOMEAMOUNT*RATIO) ",3," SUM(INCOMEAMOUNT*HF_RATIO) ")}  as INCOMEAMOUNT --回款金额
FROM
	F_MKT_PROJECT_SALE_AREATYPE A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
WHERE LEFT(DATE,4)=LEFT('${EDATE}',4)



GROUP BY 
  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREA_TYPE
),         --------------------------------年累计
T1 AS 
(SELECT
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREA_TYPE,
 ${switch(subs,1," SUM(ORDERSUIT)  ",2," SUM(ORDERSUIT*RATIO) ",3," SUM(ORDERSUIT*HF_RATIO) ")}  as ORDERSUIT,
	${switch(subs,1," SUM(ORDERAREA)  ",2," SUM(ORDERAREA*RATIO) ",3," SUM(ORDERAREA*HF_RATIO) ")}  as ORDERAREA,
  ${switch(subs,1," SUM(ORDERAMOUNT)  ",2," SUM(ORDERAMOUNT*RATIO) ",3,"SUM(ORDERAMOUNT*HF_RATIO) ")}  as ORDERAMOUNT,  --认购套数面积金额
	${switch(subs,1," SUM(SIGNSUIT)  ",2," SUM(SIGNSUIT*RATIO) ",3," SUM(SIGNSUIT*HF_RATIO) ")}  as SIGNSUIT,
	${switch(subs,1," SUM(SIGNAREA)  ",2," SUM(SIGNAREA*RATIO) ",3," SUM(SIGNAREA*HF_RATIO) ")}  as SIGNAREA,
  ${switch(subs,1," SUM(SIGNAMOUNT)  ",2," SUM(SIGNAMOUNT*RATIO) ",3," SUM(SIGNAMOUNT*HF_RATIO) ")}  as SIGNAMOUNT,  --签约套数面积金额
	 ${switch(subs,1," SUM(INCOMEAMOUNT)  ",2," SUM(INCOMEAMOUNT*RATIO) ",3," SUM(INCOMEAMOUNT*HF_RATIO) ")}  as INCOMEAMOUNT --回款金额
FROM
	F_MKT_PROJECT_SALE_AREATYPE A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
WHERE DATE BETWEEN '${SDATE}' and '${EDATE}'

GROUP BY 
  A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREA_TYPE
),    -----------------------------------当期累计
T0 AS 
(SELECT
   'FU' AS  FU, 
  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREA_TYPE,
  B.PROJECTSORT,
 ${switch(subs,1," SUM(ORDERSUIT)  ",2," SUM(ORDERSUIT*RATIO) ",3," SUM(ORDERSUIT*HF_RATIO) ")}  as ORDERSUIT,
	${switch(subs,1," SUM(ORDERAREA)  ",2," SUM(ORDERAREA*RATIO) ",3," SUM(ORDERAREA*HF_RATIO) ")}  as ORDERAREA,
  ${switch(subs,1," SUM(ORDERAMOUNT)  ",2," SUM(ORDERAMOUNT*RATIO) ",3,"SUM(ORDERAMOUNT*HF_RATIO) ")}  as ORDERAMOUNT,  --认购套数面积金额
	${switch(subs,1," SUM(SIGNSUIT)  ",2," SUM(SIGNSUIT*RATIO) ",3," SUM(SIGNSUIT*HF_RATIO) ")}  as SIGNSUIT,
	${switch(subs,1," SUM(SIGNAREA)  ",2," SUM(SIGNAREA*RATIO) ",3," SUM(SIGNAREA*HF_RATIO) ")}  as SIGNAREA,
  ${switch(subs,1," SUM(SIGNAMOUNT)  ",2," SUM(SIGNAMOUNT*RATIO) ",3," SUM(SIGNAMOUNT*HF_RATIO) ")}  as SIGNAMOUNT,  --签约套数面积金额
	 ${switch(subs,1," SUM(INCOMEAMOUNT)  ",2," SUM(INCOMEAMOUNT*RATIO) ",3," SUM(INCOMEAMOUNT*HF_RATIO) ")}  as INCOMEAMOUNT --回款金额
FROM
	F_MKT_PROJECT_SALE_AREATYPE A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO,PROJECTSORT FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 


GROUP BY 
  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREA_TYPE,
  B.PROJECTSORT) ,     ------------------------------总累计
T5 AS ( 
SELECT 
A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREATYPE,
	 ${switch(subs,1," SUM(INSALESUIT)  ",2," SUM(INSALESUIT*RATIO) ",3," SUM(INSALESUIT*HF_RATIO) ")}  as INSALESUIT,
	 ${switch(subs,1," SUM(INSALEAREA)  ",2," SUM( INSALEAREA*RATIO) ",3," SUM( INSALEAREA*HF_RATIO)")}  as  INSALEAREA,
 ${switch(subs,1," SUM(INSALE_INSIDE_AMOUNT)  ",2," SUM(INSALE_INSIDE_AMOUNT*RATIO) ",3,"SUM(INSALE_INSIDE_AMOUNT*HF_RATIO)")}  as   INSALE_INSIDE_AMOUNT
 from 
F_MKT_PROJECT_STOCK_ALL A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) B ON A.PERIODID=B.PERIODID 
 where A.YEARMONTH=left('${EDATE}',7)
 group by  A.AREANAME,
  A.CITYNAME,
	A.PROJECTID,
	A.PROJECTNAME,
	A.PERIODID,
	A.PERIODNAME,
	A.PRODUCTID,
	A.AREATYPE
)     ------------------------货值


------------------------WITH AS 结束

SELECT 
  ${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","T0.AREANAME," ) }
	${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","T0.CITYNAME," ) }
  ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTNAME," ) }
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTSORT," ) }
	-- ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,""," T0.PERIODNAME," ) }
 ${ if(INARRAY("4", SPLIT(counts, ",")) = 0,""," 	T3.SHORTNAME  PRODUCTNAME," ) }
 ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,""," 	T0.AREA_TYPE  ," ) }
--------------------------------------------------------------------------------------------以上是维度

 
  ${if(subs=1,"  	Convert(decimal(18,0),sum(T1.ORDERSUIT))   ","  	Convert(decimal(18,0),sum(T1.ORDERSUIT))  ")}  as MORDERSUIT, --当期
  sum(T1.ORDERAREA) as MORDERAREA,
  sum(T1.ORDERAMOUNT/10000) as  MORDERAMOUNT,
${if(subs=1," 	Convert(decimal(18,0),sum(T9.ORDERSUIT))   "," 	Convert(decimal(18,0),sum(T9.ORDERSUIT))  ")}  as YORDERSUIT, --年
  sum(T9.ORDERAREA) as  YORDERAREA,
  sum(T9.ORDERAMOUNT/10000) as YORDERAMOUNT,
	
	${if(subs=1," Convert(decimal(18,0),sum(T0.ORDERSUIT))  "," Convert(decimal(18,0),sum(T0.ORDERSUIT))  ")}  as ALLORDERSUIT, --总
  sum(T0.ORDERAREA) as ALLORDERAREA,
  sum(T0.ORDERAMOUNT/10000) as  ALLORDERAMOUNT,    --认购套数面积金额
  T0.FU,
	----------------------------------------------------------------以上是认购
	  

  ${if(subs=1,"   Convert(decimal(18,0),sum(T1.SIGNSUIT))   ","  Convert(decimal(18,0),sum(T1.SIGNSUIT))  ")}  as MSIGNSUIT, --当期
  sum(T1.SIGNAREA) as MSIGNAREA,
  sum(T1.SIGNAMOUNT/10000) as  MSIGNAMOUNT,
	
  ${if(subs=1," Convert(decimal(18,0),sum(T9.SIGNSUIT))   "," Convert(decimal(18,0),sum(T9.SIGNSUIT))  ")}  as YSIGNSUIT, --当年
  sum(T9.SIGNAREA) as  YSIGNAREA,
  sum(T9.SIGNAMOUNT/10000) as YSIGNAMOUNT,

	 ${if(subs=1," 	Convert(decimal(18,0),sum(T0.SIGNSUIT))   "," 	Convert(decimal(18,0),sum(T0.SIGNSUIT))  ")}  as ALLSIGNSUIT, --总
  sum(T0.SIGNAREA) as ALLSIGNAREA,
  sum(T0.SIGNAMOUNT/10000) as  ALLSIGNAMOUNT,    --签约套数面积金额
------------------------------------------------------------------------以上是签约

 
${if(subs=1," Convert(decimal(18,0),sum(T5.INSALESUIT))  "," Convert(decimal(18,1),sum(T5.INSALESUIT)) ")}  as INSALESUIT, --存量
${if(subs=1," sum(T5.INSALEAREA)  ","sum(T5.INSALEAREA) ")}  as INSALEAREA, 
${if(subs=1," sum(T5.INSALE_INSIDE_AMOUNT/10000)  "," sum(T5.INSALE_INSIDE_AMOUNT/10000) ")}  as INSALEAMOUNT



-----------以上是存量


FROM T0 LEFT JOIN T9 ON T0.PERIODID=T9.PERIODID AND T0.PRODUCTID=T9.PRODUCTID  and T0.AREA_TYPE=T9.AREA_TYPE
LEFT JOIN T1 ON T0.PERIODID=T1.PERIODID AND T0.PRODUCTID=T1.PRODUCTID  and T0.AREA_TYPE=T1.AREA_TYPE
LEFT JOIN DIM_PRODUCT_TYPE T3 ON T0.PRODUCTID=T3.PRODUCTID
LEFT JOIN  T5 ON T0.PERIODID=T5.PERIODID AND T0.PRODUCTID=T5.PRODUCTID  and T0.AREA_TYPE=T5.AREATYPE


where  T0.PROJECTID IN
(
	
 SELECT DISTINCT DEPT_ID FROM user_org
)
and T0.AREANAME in ('${AREA}')
and T0.CITYNAME in ('${CITY}')
${if(len(PRO) == 0,"","and T0.PERIODID  in ('" + PRO + "')")}
${if(len(DUCT) == 0,"","and T3.SHORTNAME  in ('" + DUCT + "')")}
${if(len(AREATYPE) == 0,"","and T0.AREA_TYPE  in ('" + AREATYPE + "')")}

GROUP BY
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","T0.AREANAME," ) }
  	${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","T0.CITYNAME," ) }
	-- ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTID," ) }
  ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTNAME," ) }
 ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTSORT," ) }
  -- ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,""," T0.PERIODNAME," ) }
	 ${ if(INARRAY("4", SPLIT(counts, ",")) = 0,""," T3.SHORTNAME, " ) }
	  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,""," 	T0.AREA_TYPE  ," ) }
	FU
ORDER BY 
${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","charindex(T0.AREANAME,'珠海大区|华南大区|华东大区|北方大区|北京区域')," ) }
${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","charindex(T0.CITYNAME,'珠海华欣|珠海华景|珠海西区|中山|广州|南宁|江门|惠州|深圳|湛江|长沙|重庆|汕尾|上海|无锡|苏州|南京|杭州|武汉独资|武汉合资|鄂州|郑州|威海|青岛|沈阳|大连|包头|北京|天津|西安|盘锦')," ) }
${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","T0.PROJECTSORT," ) }
${ if(INARRAY("4", SPLIT(counts, ",")) = 0,""," charindex(T3.SHORTNAME,'住宅|商业|车位|'), " ) }
${ if(INARRAY("5", SPLIT(counts, ",")) = 0,""," charindex(T0.AREA_TYPE,'0~90㎡|90~120㎡|120~144㎡|144~180㎡|>180㎡|其他|'), " ) }
 ALLORDERAMOUNT

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

select AREANAME FROM (
SELECT  distinct AREANAME FROM DIM_MKT_PROJECT 
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
where  PROJECTID IN
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

SELECT DISTINCT PERIODID,'('+PERIODID+')'+CITYNAME+PROJECTNAME PROJECTNAME FROM F_MKT_PROJECT_SALE WHERE 1=1
AND PROJECTID IN
(
 SELECT DISTINCT DEPT_ID FROM user_org
)
${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITYNAME in ('" + CITY + "')")}

select  AREATYPE FROM F_MKT_PROJECT_STOCK_ALL
order by
charindex(AREATYPE,'0~90㎡|90~120㎡|120~144㎡|144~180㎡|>180㎡|车位|其他|')

