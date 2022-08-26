WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
), TT AS (SELECT '1' AS TT)
SELECT
	ROW_NUMBER() OVER (ORDER BY 
	${if(INARRAY("1", SPLIT(groupItems, ",")) = 0,"","charindex(AREANAME,'珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域'),	")}
	${if(INARRAY("2", SPLIT(groupItems, ",")) = 0,"","charindex(CITYNAME,'珠海华欣|珠海华景|珠海西区|斗门|中山|广州|南宁|上海|南京|沈阳|大连|包头|'),	")}
  	${if(INARRAY("3", SPLIT(groupItems, ",")) = 0,"","PROJECTNAME,")}
  	${if(INARRAY("4", SPLIT(groupItems, ",")) = 0,"","PERIODNAME,")}
  	${if(INARRAY("5", SPLIT(groupItems, ",")) = 0,"","A.PRODUCTID,")}
  	${if(INARRAY("6", SPLIT(groupItems, ",")) = 0,"","charindex(AREATYPE,'0~90㎡|90~120㎡|120~144㎡|144~180㎡|>180㎡'),")}
  	${if(INARRAY("7", SPLIT(groupItems, ",")) = 0,"","charindex(AGINGTYPE,'小于3个月|3-6个月|6-12个月|大于12个月'),")}
  C.TT) AS XH,
	${ if(INARRAY("1", SPLIT(groupItems, ",")) = 0,""," AREANAME," ) }
	${ if(INARRAY("2", SPLIT(groupItems, ",")) = 0,""," CITYNAME," ) }
	${ if(INARRAY("3", SPLIT(groupItems, ",")) = 0,""," PROJECTNAME," ) }
	${ if(INARRAY("4", SPLIT(groupItems, ",")) = 0,""," PERIODNAME," ) }
	${ if(INARRAY("5", SPLIT(groupItems, ",")) = 0,""," REPLACE(B.PARENTNAME, '-历史数据导入', '') PARENTNAME,
REPLACE(B.PRODUCTNAME, '-历史数据导入', '') PRODUCTNAME," ) }
	${ if(INARRAY("6", SPLIT(groupItems, ",")) = 0,""," AREATYPE," ) }
	${ if(INARRAY("7", SPLIT(groupItems, ",")) = 0,""," AGINGTYPE," ) }		
	SUM (INSALESUIT) INSALESUIT,
	SUM (INSALEAREA) INSALEAREA,
	SUM (INSALE_INSIDE_AMOUNT)/10000 INSALE_INSIDE_AMOUNT,
  SUM (WT_SUIT) WT_SUIT,
	SUM (WT_AREA) WT_AREA,
	SUM (WT_INSAIDE_AMOUNT)/10000 WT_INSAIDE_AMOUNT,
  SUM (KS_SUIT) KS_SUIT,
	SUM (KS_AREA) KS_AREA,
	SUM (KS_INSIDE_AMOUNT)/10000 KS_INSIDE_AMOUNT,
  SUM (BKS_SUIT) BKS_SUIT,
	SUM (BKS_AREA) BKS_AREA,
	SUM (BKS_INSIDE_AMOUNT)/10000 BKS_INSIDE_AMOUNT,
	C.TT
FROM
	F_MKT_PROJECT_STOCK_ALL A 
LEFT JOIN DIM_PRODUCT_TYPE B ON A.PRODUCTID=B.PRODUCTID
LEFT JOIN TT C ON 1=1
WHERE YEARMONTH='${YEARMONTH}'
--AND A.PRODUCTID<> '040620'
AND  PROJECTID IN
(
	 SELECT DISTINCT DEPT_ID FROM user_org
)
${if(len(AREANAME)=0,""," AND AREANAME IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,""," AND CITYNAME IN ('"+CITYNAME+"')")}
${if(len(PROJECTID)=0,""," AND PERIODID IN ('"+PROJECTID+"')")}
${if(len(PRODUCTID)=0,""," AND A.PRODUCTID IN ('"+PRODUCTID+"')")}
${if(len(AREATYPE)=0,""," AND AREATYPE IN ('"+AREATYPE+"')")}
${if(len(AGINGTYPE)=0,""," AND AGINGTYPE IN ('"+AGINGTYPE+"')")}
GROUP BY 
	--如果存在数组中，说明选中了
	${ if(INARRAY("1", SPLIT(groupItems, ",")) = 0,"","AREANAME, " ) }
  	${ if(INARRAY("2", SPLIT(groupItems, ",")) = 0,"","CITYNAME, ") }
	${ if(INARRAY("3", SPLIT(groupItems, ",")) = 0,"","PROJECTNAME, " ) }
	${ if(INARRAY("4", SPLIT(groupItems, ",")) = 0,"","PERIODNAME, " ) }
	${ if(INARRAY("5", SPLIT(groupItems, ",")) = 0,""," A.PRODUCTID,
	REPLACE(B.PARENTNAME, '-历史数据导入',''),
	REPLACE(B.PRODUCTNAME, '-历史数据导入', '')," )}
	${ if(INARRAY("6", SPLIT(groupItems, ",")) = 0,""," AREATYPE," )}
	${ if(INARRAY("7", SPLIT(groupItems, ",")) = 0,""," AGINGTYPE, " )}
	C.TT
  

SELECT MAX(INSERTIME) INSERTIME FROM F_MKT_PROJECT_STOCK_ALL
WHERE YEARMONTH='${YEARMONTH}'

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT  AREANAME FROM DIM_MKT_PROJECT
WHERE PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)
GROUP BY AREANAME
order by charindex(AREANAME,'珠海区域|华南区域|华东区域|华中区域|北方区域|山东区域|北京公司')

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT  DISTINCT PROJECTID,PERIODID,PROJECTNAME FROM DIM_MKT_PROJECT
WHERE  PROJECTID IN
(
 SELECT DISTINCT DEPT_ID FROM user_org
)
${if(len(AREANAME)=0,""," AND AREANAME IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,""," AND CITYNAME IN ('"+CITYNAME+"')")}

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT  DISTINCT CITYNAME FROM DIM_MKT_PROJECT
WHERE  PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)
${if(len(AREANAME)=0,""," AND AREANAME IN ('"+AREANAME+"')")}
AND CITYNAME<>'盘锦'

SELECT DISTINCT
	A.PRODUCTID,
  REPLACE(B.PRODUCTNAME, '-历史数据导入', '') PRODUCTNAME
FROM
	DIM_MKT_PROJECT A
LEFT JOIN DIM_PRODUCT_TYPE B ON A.PRODUCTID = B.PRODUCTID
WHERE
   PRODUCT_TYPE=03
${if(len(AREANAME)=0,""," AND AREANAME IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,""," AND CITYNAME IN ('"+CITYNAME+"')")}
${if(len(PROJECTID)=0,""," AND PERIODID IN ('"+PROJECTID+"')")}
ORDER BY A.PRODUCTID

