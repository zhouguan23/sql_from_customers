WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREA_ID,AREA_NAME
FROM F_MKT_SALE_FEE
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
FROM F_MKT_SALE_FEE
where city_id in(
select distinct c.city_id from user_org a 
left join dim_project b on a.SAP_DEPT_ID=b.proj_code
inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
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
FROM F_MKT_SALE_FEE
where proj_id in(
select distinct c.proj_id from user_org a 
left join dim_project b on a.SAP_DEPT_ID=b.proj_code
inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)
${if(len(AREA_ID) == 0,""," and AREA_ID in ('" + AREA_ID+ "')")}
${if(len(CITY_ID) == 0,""," and CITY_ID in ('" + CITY_ID+ "')")}



WITH RECURSIVE USER_ORG AS
(
  SELECT * FROM FR_ORG WHERE SAP_DEPT_ID IN (
		SELECT DEPT_ID FROM FR_USER_ORG WHERE USER_ID='${FINE_USERNAME}')
  UNION ALL
  SELECT T.* FROM FR_ORG T INNER JOIN USER_ORG TCTE ON T.SAP_PARENT_ID = TCTE.SAP_DEPT_ID
)
SELECT 
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,""," a.area_id,a.area_name, " ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,""," a.city_id,a.city_name, " ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,""," a.proj_id,a.proj_name, " ) }
	'fu' as fu,
	sum(A.PROMOTION_AMOUNT) as PROMOTION_AMOUNT, #推广费
	sum(A.AGENT_AMOUNT) as AGENT_AMOUNT, #代理费(支付口)
	sum(A.JS_AMOUNT) as AGENT_COST, #代理费(支付口)
	-- sum(B.AGENT_COST)*10000 as AGENT_COST, #代理费(发生口)
	sum(A.FIXED_AMOUNT) as FIXED_AMOUNT, #固定费
	sum(A.SELF_AMOUNT) as SELF_AMOUNT, #自持物业费
	sum(A.CUSTSERV_AMOUNT) as CUSTSERV_AMOUNT, #客户服务费
	sum(A.BRAND_AMOUNT) as BRAND_AMOUNT, #品牌费用
	sum(A.TOTAL_AMOUNT) as TOTAL_AMOUNT, #营销总费用
	sum(A.ORDER_AMOUNT) as ORDER_AMOUNT, #认购额
	sum(A.TOTAL_AMOUNT)/sum(A.ORDER_AMOUNT)  AS SALE_RAT #营销费率
FROM F_MKT_SALE_FEE A -- left JOIN ipt_mkt_agent_cost b on A.proj_id=( select MAKET_PROJ_ID  from  dim_project where  PROJ_CODE=B.STAGE_ID) and A.TMON =B.VERSION
WHERE 1=1
and TMON between '${YEARMONTH}' and '${YEARMONTHEND}'
${if(len(AREA_ID) == 0,"and a.area_id in(
	select distinct c.area_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and a.AREA_ID in ('" + AREA_ID + "')")}
${if(len(CITY_ID) == 0,"and a.city_id in(
	select distinct c.city_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and a.CITY_ID in ('" + CITY_ID + "')")}
${if(len(PROJ_ID) == 0," and a.proj_id in(
	select distinct c.proj_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and a.PROJ_ID in ('" + PROJ_ID + "')")}
group by 
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,""," area_id,area_name, " ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,""," city_id,city_name, " ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,""," proj_id,proj_name, " ) }
	fu


