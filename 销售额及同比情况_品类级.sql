select distinct nvl(sub_category,'空')sub_category from dim_goods
 where 1=1 ${if(len(cate)=0,"","and  nvl(sub_category,'空') in ('"+cate+"')")}

select distinct gather from dw_sale_dept_type


select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = '${year}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='直营'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='直营'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = '${year}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='加盟'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='加盟'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = '${year}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='批发'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)

and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='批发'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = '${year}'
and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='B2C'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select to_char(SALE_DATE,'mm') as sale_date,nvl(sub_category,'空') as sub_category,(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额  

from dw_sale_dept_type a,dim_region b

where a.area_code=b.area_code
and to_char(SALE_DATE,'yyyy') = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')
and sale_date<=add_months(sysdate-1,-12)

and 1=1 ${if(len(dtp)=0,"","and is_dtp in ('"+dtp+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cate)=0,"","and nvl(sub_category,'空') in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and gather in ('"+attr+"')")}
and 1=1 ${if(len(gljy)=0,"","and is_gljy in ('"+gljy+"')")}
and busy_type='B2C'
group by to_char(SALE_DATE,'mm') ,nvl(sub_category,'空')

select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc


select distinct nvl(sub_category,'空')sub_category from dim_goods

select distinct union_area_name,area_code,sorted from dim_region
--order by decode(area_code,'00','AA',union_area_name),area_code
order by sorted

select distinct area_code,area_name,union_area_name,sorted from dim_region 
where  1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in ('"+UNION_AREA+"')")}
--order by decode(area_code,'00','AA',union_area_name),area_code
order by sorted

/*SELECT wm_concat(distinct AREA_NAME)AREA_NAME from  DIM_REGION
WHERE 
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}*/


select listagg(area_name,',') within group (order by sorted)area_name from dim_region
WHERE 
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
and   1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in ('"+UNION_AREA+"')")}

