

WITH RECURSIVE USER_ORG AS
(
  SELECT * FROM FR_ORG WHERE SAP_DEPT_ID IN (
		SELECT DEPT_ID FROM FR_USER_ORG WHERE USER_ID='${FINE_USERNAME}')
  UNION ALL
  SELECT T.* FROM FR_ORG T INNER JOIN USER_ORG TCTE ON T.SAP_PARENT_ID = TCTE.SAP_DEPT_ID
)

select 
AREA_NAME,
CITY_NAME,
PROJ_NAME,
STAGE_NAME,
PROD_TYPE_NAME,
BUILD_ID,
BUILD_NAME,
date_format(push_date,'%Y/%m/%d') as push_date, #推盘日期
(case when push_cn=1 then '首开' else concat(push_cn,'批次') end) as push_cn,
	sum(push_amount)/10000 as push_amount, #推盘货值
	sum(DAY_SALE_AMOUNT)/10000 as DAY_SALE_AMOUNT, #当天内销售金额（认购）
	sum(1W_SALE_AMOUNT)/10000 as 1W_SALE_AMOUNT, #1周内销售金额（认购）
	sum(2W_SALE_AMOUNT)/10000 as 2W_SALE_AMOUNT, #2周内销售金额（认购）
	sum(mon_sale_amount)/10000 as mon_sale_amount,  #30天内认购金额
	sum(2MON_SALE_AMOUNT)/10000 as 2MON_SALE_AMOUNT, #60天内认购金额
	sum(YEAR_SALE_AMOUNT)/10000 as YEAR_SALE_AMOUNT, #360天内销售金额（认购）
	sum(DAY_SALE_AMOUNT)/sum(push_amount) as day_quhua,
	sum(1W_SALE_AMOUNT)/sum(push_amount) as 1w_quhua,
	sum(2W_SALE_AMOUNT)/sum(push_amount) as 2w_quhua,
	sum(mon_sale_amount)/sum(push_amount) as mon_quhua,
	sum(2MON_SALE_AMOUNT)/sum(push_amount) as 2mon_quhua,
	sum(YEAR_SALE_AMOUNT)/sum(push_amount) as year_quhua
from f_mkt_quhua
where 1=1
and TMON between '${bdate}' and '${edate}'
${if(len(STAGE) == 0,"","and STAGE_ID in ('" + STAGE + "')")}
${if(len(pArea) == 0,"and area_id in(
	select distinct c.area_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and AREA_ID in ('" + pArea + "')")}
${if(len(pCity) == 0,"and city_id in(
	select distinct c.city_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and CITY_ID in ('" + pCity + "')")}
${if(len(PROJ) == 0," and proj_id in(
	select distinct c.proj_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and PROJ_ID in ('" + PROJ + "')")}

group by AREA_NAME,
CITY_NAME,
PROJ_NAME,
STAGE_NAME,
PROD_TYPE_NAME,
BUILD_ID,
BUILD_NAME,
date_format(push_date,'%Y/%m/%d') ,
(case when push_cn=1 then '首开' else concat(push_cn,'批次') end)
order by AREA_NAME,
CITY_NAME,
PROJ_NAME,
STAGE_NAME,
push_date,
PROD_TYPE_NAME,
BUILD_ID

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREA_ID,AREA_NAME
FROM f_mkt_quhua
where area_id in(
select distinct c.area_id from user_org a 
left join dim_project b on a.SAP_DEPT_ID=b.proj_code
inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
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
FROM f_mkt_quhua
where city_id in(
select distinct c.city_id from user_org a 
left join dim_project b on a.SAP_DEPT_ID=b.proj_code
inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)
${if(len(pArea) == 0,"","and AREA_ID in ('" + pArea+ "')")}

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJ_ID,PROJ_NAME
FROM f_mkt_quhua
where proj_id in(
select distinct c.proj_id from user_org a 
left join dim_project b on a.SAP_DEPT_ID=b.proj_code
inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)
${if(len(pArea) == 0,"","and AREA_ID in ('" + pArea + "')")}
${if(len(pCity) == 0,"","and CITY_ID in ('" + pCity + "')")}

SELECT DISTINCT
	A.STAGE_ID,
	A.STAGE_NAME
FROM f_mkt_quhua  A
WHERE 1=1 
${if(len(pArea) == 0,"","and AREA_ID in ('" + pArea + "')")}
${if(len(pCity) == 0,"","and CITY_ID in ('" + pCity + "')")}
${if(len(PROJ) == 0,"","and A.PROJ_ID in ('" + PROJ + "')")}

select 
(case when push_cn=1 then '首开' else concat(push_cn,'批次') end) as push_cn

from f_mkt_quhua
where 1=1
${if(len(pArea) == 0,"","and AREA_ID in ('" + pArea + "')")}
${if(len(pCity) == 0,"","and CITY_ID in ('" + pCity + "')")}
${if(len(PROJ) == 0,"","and A.PROJ_ID in ('" + PROJ + "')")}
${if(len(STAGE) == 0,"","and A.STAGE_ID in ('" + STAGE + "')")}

