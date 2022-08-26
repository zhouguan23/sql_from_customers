select 
f.union_area_name AREA_NAME,
sum(case when gather in ('集采高毛','集采品牌高毛','集采贴牌','集采专销') then no_tax_amount end) as 集采销售合计,
sum(case when gather='集采高毛' then no_tax_amount end) as 集采高毛,
sum(case when gather='集采品牌高毛' then no_tax_amount end) as 集采品牌高毛,
sum(case when gather='集采品牌' then no_tax_amount end) as 集采品牌,
sum(case when gather='集采专销' then no_tax_amount end) as 集采专销,
sum(case when gather='集采贴牌' then no_tax_amount end) as 集采贴牌,
sum(case when gather='集采DTP' then no_tax_amount end) as 集采DTP
from DM_SALE_TMP t, 
dim_region f ,
dim_cus b
where 
t.AREA_CODE=f.AREA_CODE
and t.CUS_CODE=b.CUS_CODE
and t.AREA_CODE=b.AREA_CODE
and t.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
and b.ATTRIBUTE ='直营'
and gather <> '地采'
${if(len(area)=0,"","and f.union_area_name IN ('"+area+"')")}

group by 
f.union_area_name
order by f.union_area_name

select 
f.union_area_name AREA_NAME,
sum(case when gather in ('集采高毛','集采品牌高毛','集采贴牌','集采专销') then no_tax_amount end) as 集采销售合计,
sum(case when gather='集采高毛' then no_tax_amount end) as 集采高毛,
sum(case when gather='集采品牌高毛' then no_tax_amount end) as 集采品牌高毛,
sum(case when gather='集采品牌' then no_tax_amount end) as 集采品牌,
sum(case when gather='集采专销' then no_tax_amount end) as 集采专销,
sum(case when gather='集采贴牌' then no_tax_amount end) as 集采贴牌,
sum(case when gather='集采DTP' then no_tax_amount end) as 集采DTP
from DM_SALE_TMP t, 
dim_region f ,
dim_cus b
where 
t.AREA_CODE=f.AREA_CODE
and t.CUS_CODE=b.CUS_CODE
and t.AREA_CODE=b.AREA_CODE
and t.sale_date between ADD_MONTHS(TO_DATE('${sale_date1}','YYYY-MM-DD'),-12)  and ADD_MONTHS(TO_DATE('${sale_date2}','YYYY-MM-DD'),-12)
and b.ATTRIBUTE ='直营'
and gather <> '地采'
${if(len(area)=0,"","and f.union_area_name IN ('"+area+"')")}
group by 
f.union_area_name

select g.AREA_NAME,sum(no_tax_amount), sum(no_tax_amount - no_tax_cost) 
from DM_MONTHLY_SALE t
left join DIM_REGION g on t.area_code=g.area_code
where  ACCOUNTNAME = '直营常规'
and sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
group by g.AREA_NAME

select g.AREA_NAME,sum(no_tax_amount), sum(no_tax_amount - no_tax_cost) 
from DM_MONTHLY_SALE t
left join DIM_REGION g on t.area_code=g.area_code
where  ACCOUNTNAME = '直营常规'
and sale_date between ADD_MONTHS(to_date('${sale_date1}', 'yyyy-mm-dd'),-12) and ADD_MONTHS(to_date('${sale_date2}', 'yyyy-mm-dd'),-12)
group by g.AREA_NAME

select 
distinct
f.union_area_name AREA_NAME
from
dim_region f 

