select 
distinct
f.union_area_name AREA_NAME
from
dim_region f

select dr.union_area_name,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP dst,
       --DM_SHOP ds,
       --dim_cus dc,
       dim_region dr,
	   age_store da

 where --sale_date>=to_date('2019-01','yyyy-mm') and sale_date<=to_date('2019-03','yyyy-mm')
        to_char(dst.sale_date,'YYYY-MM') BETWEEN '${month}' and '${month1}'
 
   and  dst.area_code=dr.area_code 
   and  dst.area_code= da.area_code
   and  dst.cus_code=  da.cus_code
   and to_char(dst.sale_date,'YYYY-MM') = da.date1
   --and ds.time not in ('新店','次新店')  
   --and ds.dImension  ='2019'
   --and ds.dImension  = substr('${month}', 1, 4)
   --and dc.attribute='直营' 
   and dst.oto='否'
   and dst.dtp='否'
   and da.age_store in('直营（关）','直营不可比','直营不可比-计销售不计门店数','直营可比','直营可比-计销售不计门店数')
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
 group by dr.union_area_name order by dr.union_area_name

 select dr.union_area_name,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP dst,
       --DM_SHOP ds,
       --dim_cus dc,
       dim_region dr,
	   age_store da

 where  --sale_date>=to_date('2018-01','yyyy-mm') and sale_date<=to_date('2018-03','yyyy-mm')
        to_char(dst.sale_date,'YYYY-MM') BETWEEN to_char(add_months(to_date('${month}','yyyy-mm'), -12),'yyyy-mm')  and to_char(add_months(to_date('${month1}','yyyy-mm'), -12),'yyyy-mm')
   --and  dst.area_code = ds.area_code
   --and  dst.cus_code = ds.cus_code
  -- and  dst.area_code= dc.area_code
  -- and  dst.cus_code=  dc.cus_code
  and  dst.area_code= da.area_code
   and  dst.cus_code=  da.cus_code
   and to_char(dst.sale_date,'YYYY-MM') =da.date1
   and  dst.area_code=dr.area_code 
   --and ds.time not in ('新店','次新店')  
   --and ds.dImension  ='2018'
   --and ds.dImension =substr('${month}',1,4)-1
   --and dc.attribute='直营' 
   and da.age_store in('直营（关）','直营不可比','直营不可比-计销售不计门店数','直营可比','直营可比-计销售不计门店数')
   and dst.oto='否'
   and dst.dtp='否'
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
 group by dr.union_area_name

select dr.union_area_name,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP dst,
       --DM_SHOP ds,
       dim_cus dc,
       dim_region dr,
       age_store ast
       

 where --sale_date>=to_date('2019-01','yyyy-mm') and sale_date<=to_date('2019-03','yyyy-mm')
       to_char(dst.sale_date,'YYYY-MM') BETWEEN '${month}' and '${month1}'
   and  dst.area_code= dc.area_code
   and  dst.cus_code=  dc.cus_code
   and  dst.area_code=dr.area_code 
   and dst.area_code=ast.area_code
   and dst.cus_code=ast.cus_code
   and to_char(dst.sale_date,'yyyy-mm')=ast.date1
   and ast.age_store='直营可比'
   --and dc.attribute='直营' 
   and dst.oto='否'
   and dst.dtp='否' 
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
 group by dr.union_area_name

select dr.union_area_name,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP dst,
       --DM_SHOP ds,
       dim_cus dc,
       dim_region dr,
       age_store ast
       

 where --sale_date>=to_date('2018-01','yyyy-mm') and sale_date<=to_date('2018-03','yyyy-mm')
       to_char(dst.sale_date,'YYYY-MM') BETWEEN to_char(add_months(to_date('${month}','yyyy-mm'), -12),'yyyy-mm')  and to_char(add_months(to_date('${month1}','yyyy-mm'), -12),'yyyy-mm')
   and  dst.area_code= dc.area_code
   and  dst.cus_code=  dc.cus_code
   and  dst.area_code=dr.area_code 
   and dst.area_code=ast.area_code
   and dst.cus_code=ast.cus_code
   --and ast.date1 between '2019-01' and  '2019-03'
   --and ast.date1 BETWEEN '${month}' and '${month1}'
   --and to_char(dst.sale_date,'yyyy-mm')=to_char(add_months(to_date(date1,'yyyy-mm'), -12),'yyyy-mm')

and to_char(dst.sale_date,'yyyy-mm')=ast.date1   
   and ast.age_store='直营可比'
--   and dc.attribute='直营' 
   and dst.oto='否'
   and dst.dtp='否'
   ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
 group by dr.union_area_name

select dr.union_area_name,
        sum(fsi.old_value) old_value
   from FACT_SALE_INDEX fsi,
        dim_region dr 
  where fsi.area_code = dr.area_code
    and fsi.create_month =substr('${month}', 1, 4)
    ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
  group by dr.union_area_name

