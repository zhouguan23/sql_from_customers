
SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='直营'

and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${Month}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)

and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')





select distinct nvl(sub_category,'空')sub_category from dim_goods

select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc



SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='加盟'

and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${Month}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)

and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')





SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='批发'

and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${Month}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)

and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')





SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='B2C'

and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${Month}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)

and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')





SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='直营'
and to_char(SALE_DATE,'yyyy') = '${Month}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')





SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='批发'
and to_char(SALE_DATE,'yyyy') = '${Month}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')




SELECT DISTINCT AREA_CODE,AREA_NAME,UNION_AREA_NAME,sorted
FROM 
DIM_REGION
WHERE 
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
order by sorted


SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='加盟'
and to_char(SALE_DATE,'yyyy') = '${Month}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')





SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and busy_type='B2C'
and to_char(SALE_DATE,'yyyy') = '${Month}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')




SELECT DISTINCT AREA_CODE,AREA_NAME,UNION_AREA_NAME ,sorted
FROM 
DIM_REGION
WHERE
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")}
order by  sorted

/*SELECT wm_concat(distinct AREA_NAME)AREA_NAME from  DIM_REGION
WHERE 
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}*/

select listagg(area_name,',') within group (order by sorted)area_name from dim_region
WHERE 
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}

SELECT  DISTINCT  UNION_AREA_NAME ,area_code,sorted
FROM
DIM_REGION
order by sorted


select distinct gather from dw_sale_dept_type


SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
to_char(SALE_DATE,'mm') as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 无税销售额

from dw_sale_dept_type a,dim_region b
where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = '${Month}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(sub_category)=0,"","and nvl(sub_category,'空') in ('"+sub_category+"')")}
and 1=1 ${if(len(gather)=0,"","and gather in ('"+gather+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
to_char(SALE_DATE,'mm')




