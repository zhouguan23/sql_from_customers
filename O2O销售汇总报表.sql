select
a.area_code,
b.area_name,
SALE_DATE,
c.MARKETING_NAME,
sale_date-1 hb_date,
add_months(sale_date,-1) tb_date,
count(distinct TRAN_NO) TRAN_NO,
sum(SALE_QTY) SALE_QTY,
sum(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
sum(TAX_AMOUNT) TAX_AMOUNT,
sum(NO_TAX_COST) NO_TAX_COST,
sum(TAX_COST) TAX_COST
 from DM_SALE_OTO a,dim_region b,DIM_MARKETING_all c
where 
decode(a.area_code,'16','15',a.area_code)=c.area_code and a.marketing_code=c.marketing_code
and a.area_code=b.area_code
and a.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
${if(len(AREA)=0,"","and a.area_code IN ('"+AREA+"')")}
${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME IN ('"+UNION_AREA+"')")}
${if(len(large_cate)=0, "", " and c.large_cate in ('" + large_cate + "')")}
${if(len(marketing)=0, "", " and c.small_cate in ('" + marketing + "')")}
group by 
a.area_code,
b.area_name,
SALE_DATE,
c.MARKETING_NAME,
sale_date-1,
add_months(sale_date,-1)
order by a.area_code,c.MARKETING_NAME

select
a.area_code,
b.area_name,
SALE_DATE,
c.MARKETING_NAME,
count(distinct TRAN_NO) TRAN_NO,
sum(SALE_QTY) SALE_QTY,
sum(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
sum(TAX_AMOUNT) TAX_AMOUNT
from DM_SALE_OTO a,dim_region b,DIM_MARKETING_all c
where 
decode(a.area_code,'16','15',a.area_code)=c.area_code and a.marketing_code=c.marketing_code
and a.area_code=b.area_code
and a.sale_date between ADD_MONTHS(TO_DATE('${sale_date1}','YYYY-MM-DD'),-1)  and ADD_MONTHS(TO_DATE('${sale_date2}','YYYY-MM-DD'),-1)
${if(len(AREA)=0,"","and a.area_code IN ('"+AREA+"')")}
${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME IN ('"+UNION_AREA+"')")}
${if(len(large_cate)=0, "", " and c.large_cate in ('" + large_cate + "')")}
${if(len(marketing)=0, "", " and c.small_cate in ('" + marketing + "')")}
group by 
a.area_code,
b.area_name,
SALE_DATE,
c.MARKETING_NAME

select
a.area_code,
b.area_name,
SALE_DATE,
c.MARKETING_NAME,
count(distinct TRAN_NO) TRAN_NO,
sum(SALE_QTY) SALE_QTY,
sum(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
sum(TAX_AMOUNT) TAX_AMOUNT
from DM_SALE_OTO a,dim_region b,DIM_MARKETING_all c
where 
decode(a.area_code,'16','15',a.area_code)=c.area_code and a.marketing_code=c.marketing_code
and a.area_code=b.area_code
and a.sale_date between TO_DATE('${sale_date1}','YYYY-MM-DD')-1  and TO_DATE('${sale_date2}','YYYY-MM-DD')-1
${if(len(AREA)=0,"","and a.area_code IN ('"+AREA+"')")}
${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME IN ('"+UNION_AREA+"')")}
${if(len(large_cate)=0, "", " and c.large_cate in ('" + large_cate + "')")}
${if(len(marketing)=0, "", " and c.small_cate in ('" + marketing + "')")}
group by 
a.area_code,
b.area_name,
SALE_DATE,
c.MARKETING_NAME

select 
a.area_code,
a.sale_date,
sum(TAX_AMOUNT) TAX_AMOUNT
from 
fact_sale a 
where
a.sale_date between to_date('${sale_date1}', 'yyyy-mm-dd') and to_date('${sale_date2}', 'yyyy-mm-dd')
group by 
a.area_code,
a.sale_date

select distinct marketing_code,marketing_name from DIM_MARKETING_all a where a.oto='Y'

select 
distinct
area_code,
area_name
from dim_region
where 1=1
${if(len(AREA)=0,"","and area_code IN ('"+AREA+"')")}


select distinct large_cate from dim_marketing_all
where nvl(oto,'N')='Y'

select distinct small_cate from dim_marketing_all
where nvl(oto,'N')='Y'

