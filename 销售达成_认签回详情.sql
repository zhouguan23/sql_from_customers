WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),tmp_sale_mth as(#当期
select 
	AREA_ID,
	AREA_NAME,
	CITY_ID,
	CITY_NAME,
	PROJ_ID,
	PROJ_NAME,
	STAGE_ID,
	STAGE_NAME,
	PROD_TYPE_ID,
	sum(ORDER_SUIT) AS ORDER_SUIT, #认购套数
	sum(ORDER_AREA) AS ORDER_AREA, #认购面积
	sum(ORDER_AMOUNT) AS ORDER_AMOUNT, #认购金额
	sum(SIGN_SUIT) AS SIGN_SUIT, #签约套数
	sum(SIGN_AREA) AS SIGN_AREA, #签约面积
	sum(SIGN_AMOUNT) AS SIGN_AMOUNT, #签约金额
	sum(INCOME_AMOUNT) AS INCOME_AMOUNT #回款金额
from f_mkt_project_sale a
where TDATE BETWEEN '${SDATE}' and '${EDATE}'
group by 
	AREA_ID,
	AREA_NAME,
	CITY_ID,
	CITY_NAME,
	PROJ_ID,
	PROJ_NAME,
	STAGE_ID,
	STAGE_NAME,
	PROD_TYPE_ID
),tmp_sale_year as(#当年
select 
	AREA_ID,
	AREA_NAME,
	CITY_ID,
	CITY_NAME,
	PROJ_ID,
	PROJ_NAME,
	STAGE_ID,
	STAGE_NAME,
	PROD_TYPE_ID,
	sum(ORDER_SUIT) AS ORDER_SUIT, #认购套数
	sum(ORDER_AREA) AS ORDER_AREA, #认购面积
	sum(ORDER_AMOUNT) AS ORDER_AMOUNT, #认购金额
	sum(SIGN_SUIT) AS SIGN_SUIT, #签约套数
	sum(SIGN_AREA) AS SIGN_AREA, #签约面积
	sum(SIGN_AMOUNT) AS SIGN_AMOUNT, #签约金额
	sum(INCOME_AMOUNT) AS INCOME_AMOUNT #回款金额
from f_mkt_project_sale a
where LEFT(TDATE,4)=LEFT('${EDATE}',4)
group by 
	AREA_ID,
	AREA_NAME,
	CITY_ID,
	CITY_NAME,
	PROJ_ID,
	PROJ_NAME,
	STAGE_ID,
	STAGE_NAME,
	PROD_TYPE_ID
),tmp_sale_all as(#累计
select 
	AREA_ID,
	AREA_NAME,
	CITY_ID,
	CITY_NAME,
	PROJ_ID,
	PROJ_NAME,
	STAGE_ID,
	STAGE_NAME,
	PROD_TYPE_ID,
	sum(ORDER_SUIT) AS ORDER_SUIT, #认购套数
	sum(ORDER_AREA) AS ORDER_AREA, #认购面积
	sum(ORDER_AMOUNT) AS ORDER_AMOUNT, #认购金额
	sum(SIGN_SUIT) AS SIGN_SUIT, #签约套数
	sum(SIGN_AREA) AS SIGN_AREA, #签约面积
	sum(SIGN_AMOUNT) AS SIGN_AMOUNT, #签约金额
	sum(INCOME_AMOUNT) AS INCOME_AMOUNT #回款金额
from f_mkt_project_sale a
group by 
	AREA_ID,
	AREA_NAME,
	CITY_ID,
	CITY_NAME,
	PROJ_ID,
	PROJ_NAME,
	STAGE_ID,
	STAGE_NAME,
	PROD_TYPE_ID
),tmp_fund as(#回款情况
select 
	areaid,
	areaname,
	cityid,
	cityname,
	projectid,
	projectname,
	PERIODID,
	PERIODNAME,
	PRODUCTID,
	PRODUCTNAME,
	sum(PLAN_COLLECTION) as PLAN_COLLECTION, #应收未收金额
	sum(YQ_COLLECTION) AS YQ_COLLECTION, #逾期金额
	sum(WYQ_COLLECTION) AS WYQ_COLLECTION #未逾期金额
from f_mkt_project_fund a
where CREATEDATE=LAST_DAY('${EDATE}')
group by
	areaid,
	areaname,
	cityid,
	cityname,
	projectid,
	projectname,
	PERIODID,
	PERIODNAME,
	PRODUCTID,
	PRODUCTNAME
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","a.AREA_ID,a.AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","a.CITY_ID,a.CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","a.PROJ_ID,a.PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","a.STAGE_ID,a.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","left(a.PROD_TYPE_ID,2) as PROD_TYPE_ID,SUBSTRING(p.name,1,LOCATE('-',p.name)-1) as PROD_TYPE_NAME," ) }
sum(b.ORDER_SUIT) AS DQ_ORDER_SUIT, #当期_认购套数
sum(b.ORDER_AREA) AS DQ_ORDER_AREA, #当期_认购面积
sum(b.ORDER_AMOUNT)/10000 AS DQ_ORDER_AMOUNT, #当期_认购金额
sum(b.SIGN_SUIT) AS DQ_SIGN_SUIT, #当期_签约套数
sum(b.SIGN_AREA) AS DQ_SIGN_AREA, #当期_签约面积
sum(b.SIGN_AMOUNT)/10000 AS DQ_SIGN_AMOUNT, #当期_签约金额
sum(b.INCOME_AMOUNT)/10000 AS DQ_INCOME_AMOUNT, #当期_回款金额

sum(c.ORDER_SUIT) AS YEAR_ORDER_SUIT, #当年_认购套数
sum(c.ORDER_AREA) AS YEAR_ORDER_AREA, #当年_认购面积
sum(c.ORDER_AMOUNT)/10000 AS YEAR_ORDER_AMOUNT, #当年_认购金额
sum(c.SIGN_SUIT) AS YEAR_SIGN_SUIT, #当年_签约套数
sum(c.SIGN_AREA) AS YEAR_SIGN_AREA, #当年_签约面积
sum(c.SIGN_AMOUNT)/10000 AS YEAR_SIGN_AMOUNT, #当年_签约金额
sum(c.INCOME_AMOUNT)/10000 AS YEAR_INCOME_AMOUNT, #当年_回款金额

sum(a.ORDER_SUIT) AS ORDER_SUIT, #累计_认购套数
sum(a.ORDER_AREA) AS ORDER_AREA, #累计_认购面积
sum(a.ORDER_AMOUNT)/10000 AS ORDER_AMOUNT, #累计_认购金额
sum(a.SIGN_SUIT) AS SIGN_SUIT, #累计_签约套数
sum(a.SIGN_AREA) AS SIGN_AREA, #累计_签约面积
sum(a.SIGN_AMOUNT)/10000 AS SIGN_AMOUNT, #累计_签约金额
sum(a.INCOME_AMOUNT)/10000 AS INCOME_AMOUNT, #累计_回款金额

sum(d.PLAN_COLLECTION)/10000 as PLAN_COLLECTION, #应收未收
sum(d.YQ_COLLECTION)/10000 as YQ_COLLECTION, #逾期
sum(d.WYQ_COLLECTION)/10000 as WYQ_COLLECTION, #未逾期

sum(a.SIGN_AMOUNT)-sum(d.YQ_COLLECTION) AS UNREFUND_YQ,# 已签约未回款-未逾期
sum(a.SIGN_AMOUNT)-sum(d.WYQ_COLLECTION) AS UNREFUND_WYQ,# 已签约未回款-未逾期
'' aa
from tmp_sale_all a 
left join tmp_sale_mth b on a.STAGE_ID=b.STAGE_ID and a.prod_type_id=b.prod_type_id
left join tmp_sale_year c on a.STAGE_ID=c.STAGE_ID and a.prod_type_id=c.prod_type_id
left join tmp_fund d on a.STAGE_ID=d.PERIODID and a.prod_type_id=d.PRODUCTID
left join dim_mkt_product_type p on a.PROD_TYPE_ID=p.PRODUCTS_ID #业态
where 1=1
${if(len(AREA_ID) == 0,"and a.area_id in(
	select distinct c.area_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and a.AREA_ID in ('" + AREA_ID + "')")}
${if(len(CITY_ID) == 0,"and a.city_id in(
	select distinct c.city_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and a.CITY_ID in ('" + CITY_ID + "')")}
${if(len(PROJ_ID) == 0,"and a.proj_id in(
	select distinct c.proj_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and a.PROJ_ID in ('" + PROJ_ID + "')")}
${if(len(STAGE_ID) == 0,"","and a.STAGE_ID in ('" + STAGE_ID + "')")}
${if(len(PROD_TYPE_ID) == 0,"","and left(a.PROD_TYPE_ID,2) in ('" + PROD_TYPE_ID + "')")}
group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","a.AREA_ID,a.AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","a.CITY_ID,a.CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","a.PROJ_ID,a.PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","a.STAGE_ID,a.STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","a.PROD_TYPE_ID,p.NAME," ) }
aa

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREA_ID,AREA_NAME
FROM f_mkt_project_sale
where area_name in(
	select distinct c.area_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)




WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	CITY_ID,CITY_NAME
FROM f_mkt_project_sale
where city_id in(
	select distinct c.city_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) 
${if(len(AREA_ID) == 0,"","and AREA_ID in ('" + AREA_ID+ "')")}

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJ_ID,PROJ_NAME
FROM f_mkt_project_sale
where proj_id in(
	select distinct c.proj_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)
${if(len(AREA_ID) == 0,"","and AREA_ID in ('" + AREA_ID + "')")}
${if(len(CITY_ID) == 0,"","and CITY_ID in ('" + CITY_ID + "')")}

SELECT 
distinct	STAGE_ID,STAGE_NAME
FROM f_mkt_project_sale
where 1=1 
${if(len(AREA_ID) == 0,"","and AREA_ID in ('" + AREA_ID + "')")}
${if(len(CITY_ID) == 0,"","and CITY_ID in ('" + CITY_ID + "')")}
${if(len(PROJ_ID) == 0,"","and PROJ_ID in ('" + PROJ_ID + "')")}

SELECT 
distinct	
	left(a.PROD_TYPE_ID,2) as PROD_TYPE_ID,
	SUBSTRING(p.name,1,LOCATE('-',p.name)-1) as PROD_TYPE_NAME
FROM f_mkt_project_sale a
left join dim_mkt_product_type p on a.PROD_TYPE_ID=p.PRODUCTS_ID #业态
where 1=1 
${if(len(AREA_ID) == 0,"","and AREA_ID in ('" + AREA_ID + "')")}
${if(len(CITY_ID) == 0,"","and CITY_ID in ('" + CITY_ID + "')")}
${if(len(PROJ_ID) == 0,"","and PROJ_ID in ('" + PROJ_ID + "')")}
${if(len(STAGE_ID) == 0,"","and STAGE_ID in ('" + STAGE_ID + "')")}

SELECT max(W_INSERT_DT) as time FROM f_mkt_project_sale

