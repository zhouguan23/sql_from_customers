

select 
	   dst.area_code,
	   extract(month from dst.sale_date) sale_month,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) prof,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP dst,
     age_store da

 where --sale_date>=to_date('2019-01','yyyy-mm') and sale_date<=to_date('2019-03','yyyy-mm')
   dst.sale_date BETWEEN date'${start}' and date'${end}'
   and  dst.area_code= da.area_code
   and  dst.cus_code=  da.cus_code
   and to_char(dst.sale_date,'YYYY-MM') = da.date1
   --and dst.oto='否'
   --and dst.dtp='否'
    ${if(len(acode)=0,""," and dst.area_code in ('"+acode+"')")} 
   and da.age_store='直营次新'
 group by dst.area_code,
     extract(month from dst.sale_date)  
     order by 1,2

select distinct area_code,area_name from dim_region
where 1=1 and area_code<>'00'
  ${if(len(acode)=0,""," and area_code in ('"+acode+"')")} 
order by 1

select distinct extract(year from sale_date) year  from DM_SHOP_COMPANY

select 
       extract(month from sale_date)  sale_month,
       sum(no_tax_amount) no_tax_amount,
       (nvl(sum(no_tax_amount), 0) - nvl(sum(no_tax_cost), 0)) /
       nullif(sum(no_tax_amount), 0) profit_percent
  from DM_SHOP_COMPANY
 where sale_date>=date'${start}'
 and sale_date<date'${end}'+1
 and time='次新店'
  ${if(len(acode)=0,""," and area_code in ('"+acode+"')")} 
 group by  extract(month from sale_date) 


select a.month,a.area_code,sum(operating_profit) profit 
from fact_store_import a
--left join dm_shop b
--left join age_store  da 
--on a.area_code=da.area_code and a.cus_code=a.cus_code   
--and a.year=to_number(substr(da.date1,1,4)) and a.month=to_number(substr(da.date1,6,2))
--on a.area_code=b.area_code
--and a.cus_code=b.cus_code
left join age_store da
on a.area_code=da.area_code and a.cus_code=da.cus_code

and a.year=to_number(substr(date1,1,4)) and a.month=to_number(substr(da.date1,6,2))
where year=substr('${start}',1,4)
and da.age_store='直营次新'
${if(len(acode)=0,""," and a.area_code in ('"+acode+"')")} 
--and b.dimension=substr('${start}',1,4)
--and b.time='次新店'
--and da.age_store='直营次新'
group by a.month,a.area_code
ORDER BY 1,2

