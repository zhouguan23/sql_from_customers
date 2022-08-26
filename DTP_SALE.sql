select a.area_code,
b.area_name,
sorted,
to_char(sale_date,'mm')as 月份,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额
from dm_dtp a,dim_region b
where a.area_code=b.area_code
and to_char(sale_date,'yyyy-mm')>='${start_date}'
and to_char(sale_date,'yyyy-mm')<='${end_date}'
--and to_char(sale_date,'yyyy') = '${year}'
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(attribute)=0,""," and a.attribute in ('"+attribute+"')")}
and 1=1 ${if(len(attribute)=0,""," and a.attribute1 in ('"+attribute+"')")}
group by a.area_code,b.area_name,sorted,to_char(sale_date,'mm')
order by sorted,to_char(sale_date,'mm')



SELECT DISTINCT a.union_area_name,a.area_name,a.area_code,a.trans_party_relation,a.sorted
FROM 
DIM_REGION a,dm_dtp b
WHERE 
a.area_code=b.area_code
and to_char(sale_date,'yyyy')=substr('${start_date}',1,4)

and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and  1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by sorted



select  a.UNION_AREA_NAME,a.area_code from dim_region a 
order by sorted

select a.area_code,
b.area_name,
sorted,
to_char(sale_date,'mm')as 月份 ,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额
from dm_dtp a,dim_region b
where a.area_code=b.area_code
and to_char(sale_date,'yyyy-mm')>=to_char(add_months(to_date('${start_date}','yyyy-mm'),-12),'yyyy-mm')
--and to_char(sale_date,'yyyy-mm')<='${end_date}'
and to_char(sale_date,'yyyy-mm')<=to_char(add_months(to_date('${end_date}','yyyy-mm'),-12),'yyyy-mm')
/*and to_char(sale_date,'yyyy') = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')*/
and sale_date<=add_months(sysdate-1,-12)
and 1=1 ${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and 1=1 ${if(len(attribute)=0,""," and a.attribute in ('"+attribute+"')")}
and 1=1 ${if(len(attribute)=0,""," and a.attribute1 in ('"+attribute+"')")}
group by a.area_code,b.area_name,sorted,to_char(sale_date,'mm')
order by sorted,to_char(sale_date,'mm')

SELECT  DISTINCT ATTRIBUTE1 FROM DM_DTP

select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select a.area_code,a.area_name from dim_region a 
where 
 1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by sorted


/*select distinct to_char(sale_date,'mm')as 月份 from dm_dtp
where to_char(sale_date,'yyyy-mm')>='${start_date}'
and to_char(sale_date,'yyyy-mm')<='${end_date}'
order by 1*/


select distinct substr(month_id,6,2) as 月份 from  dim_day
where month_id>='${start_date}'
and month_id<='${end_date}'
order by 1

