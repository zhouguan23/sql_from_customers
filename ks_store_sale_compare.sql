select fsi.area_code,
       dr.area_name,
       fsi.cus_code,
       dc.cus_name,
       dc.open_date,
       ass.age_store,
       fsi.total_revenue_main_business,
       fsi.total_gp_main_business,
       fsi.employee_remuneration,
       fsi.rental_fee,
       fsi.subtotal_of_expenses,
       fsi.operating_profit
       
  from 
       fact_store_import fsi,
       dim_region dr,
       dim_cus dc,
       age_store ass
       
 where fsi.area_code=dr.area_code
   and fsi.area_code=dc.area_code
   and fsi.cus_code=dc.cus_code
   and fsi.area_code=ass.area_code
   and fsi.cus_code=ass.cus_code
   and dc.attribute='直营'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dc.CUS_CODE in ('"+store+"')") }
   and  fsi.year =substr('${date_from}',1,4)
   and  fsi.month=to_number(substr('${date_from}',6,2))
   and  ass.date1 =substr('${date_from}',1,7)

select dst.area_code,
       dr.area_name,
       dst.cus_code,
       dc.cus_name,
       sum(dst.no_tax_amount) no_tax_amount,
       sum((dst.no_tax_amount-dst.no_tax_cost)) no_ml,
       sum((dst.origin_amount-dst.no_tax_amount)) dis_amount,
       decode(sum(dst.origin_amount),0,0,sum((dst.origin_amount-dst.no_tax_amount))/sum(dst.origin_amount)) ,
       sum(dst.sale_qty) sale_qty
  from DM_SALE_TMP dst,
       dim_cus dc,
       dim_region dr
      
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dst.area_code=dr.area_code
   and dst.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(region) = 0, "1=1", "  dst.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dst.CUS_CODE in ('"+store+"')") }
   group by dst.area_code,
       dr.area_name,
       dst.cus_code,
       dc.cus_name
       order by dr.area_name

select dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount) no_tax_amount,
       sum((dst.no_tax_amount-dst.no_tax_cost)) no_ml,
       sum((dst.origin_amount-dst.no_tax_amount)) dis_amount,
       decode(sum(dst.origin_amount),0,0,sum((dst.origin_amount-dst.no_tax_amount))/sum(dst.origin_amount)) ,
       sum(dst.sale_qty) sale_qty
  from DM_SALE_TMP dst
      
 where dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
   and ${if(len(region) = 0, "1=1", "  dst.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dst.CUS_CODE in ('"+store+"')") }
   group by dst.area_code,
       dst.cus_code

select dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount) no_tax_amount,
       sum((dst.no_tax_amount-dst.no_tax_cost)) no_ml,
       sum((dst.origin_amount-dst.no_tax_amount)) dis_amount,
       decode(sum(dst.origin_amount),0,0,sum((dst.origin_amount-dst.no_tax_amount))/sum(dst.origin_amount)) ,
       sum(dst.sale_qty) sale_qty
  from DM_SALE_TMP dst
      
 where dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
   and ${if(len(region) = 0, "1=1", "  dst.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dst.CUS_CODE in ('"+store+"')") }
   group by dst.area_code,
       dst.cus_code

select ft.area_code,ft.cus_code,count(*) tran_num 
  from FACT_TRANSACTION ft 
 where ${if(len(region) = 0, "1=1", "  ft.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  ft.CUS_CODE in ('"+store+"')") }
   and ft.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
group by ft.area_code,ft.cus_code

select ft.area_code,ft.cus_code,count(*) tran_num 
  from FACT_TRANSACTION ft 
 where ${if(len(region) = 0, "1=1", "  ft.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  ft.CUS_CODE in ('"+store+"')") }
   and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
group by ft.area_code,ft.cus_code

select ft.area_code,ft.cus_code,count(*) tran_num 
  from FACT_TRANSACTION ft 
 where ${if(len(region) = 0, "1=1", "  ft.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  ft.CUS_CODE in ('"+store+"')") }
   and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
group by ft.area_code,ft.cus_code

select dssd.AREA_CODE,dssd.CUS_CODE,count(*) sku_amount 
 from DM_STOCK_SHOP_DETAIL dssd
 where ${if(len(region) = 0, "1=1", "  dssd.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "   dssd.CUS_CODE in ('"+store+"')") }
   and dssd.DDATE=last_day(add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1))  
group by dssd.AREA_CODE,dssd.CUS_CODE

select dssd.AREA_CODE,dssd.CUS_CODE,count(*) sku_amount 
 from DM_STOCK_SHOP_DETAIL dssd
 where ${if(len(region) = 0, "1=1", "  dssd.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "   dssd.CUS_CODE in ('"+store+"')") }
   and dssd.DDATE=last_day(add_months(to_date('${date_from}', 'yyyy-mm-dd'),-2))  
group by dssd.AREA_CODE,dssd.CUS_CODE

select dssd.AREA_CODE,dssd.CUS_CODE,count(*) sku_amount 
 from DM_STOCK_SHOP_DETAIL dssd
 where ${if(len(region) = 0, "1=1", "  dssd.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "   dssd.CUS_CODE in ('"+store+"')") }
   and dssd.DDATE=last_day(add_months(to_date('${date_from}', 'yyyy-mm-dd'),-13)) 
group by dssd.AREA_CODE,dssd.CUS_CODE

select AREA_CODE,CUS_CODE,count(*) dx_sku_amount
from (select fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE from fact_sale fs 
       where ${if(len(region) = 0, "1=1", "  fs.area_code in ('"+region+"')") }
         and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
         and fs.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
group by fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE
) group by AREA_CODE,CUS_CODE

select AREA_CODE,CUS_CODE,count(*) dx_sku_amount
from (select fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE from fact_sale fs 
       where ${if(len(region) = 0, "1=1", "  fs.area_code in ('"+region+"')") }
         and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
         and fs.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
group by fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE
) group by AREA_CODE,CUS_CODE

select AREA_CODE,CUS_CODE,count(*) dx_sku_amount
from (select fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE from fact_sale fs 
       where ${if(len(region) = 0, "1=1", "  fs.area_code in ('"+region+"')") }
         and ${if(len(store) = 0, "1=1", "  fs.CUS_CODE in ('"+store+"')") }
         and fs.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
group by fs.AREA_CODE,fs.CUS_CODE,fs.GOODS_CODE
) group by AREA_CODE,CUS_CODE

select dv.area_code,
       dv.cus_code,
       count(*) vip_count
from
(
select dv.area_code,
       dv.cus_code,
       dv.insidercardno
  from dim_vip dv, 
       dm_available_vip  dav
 where dv.insiderid=dav.insiderid
   and ${if(len(region) = 0, "1=1", "  dv.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dv.CUS_CODE in ('"+store+"')") }
   and dav.sale_date between trunc(add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12), 'mm') and last_day(add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1))   
 group by dv.area_code,dv.cus_code,dv.insidercardno
 ) dv group by dv.area_code,dv.cus_code

select dv.area_code,
       dv.cus_code,
       count(*) vip_count
from
(
select dv.area_code,
       dv.cus_code,
       dv.insidercardno
  from dim_vip dv, 
       dm_available_vip  dav
 where dv.insiderid=dav.insiderid
   and ${if(len(region) = 0, "1=1", "  dv.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dv.CUS_CODE in ('"+store+"')") }
   and dav.sale_date between trunc(add_months(to_date('${date_from}', 'yyyy-mm-dd'),-13), 'mm') and last_day(add_months(to_date('${date_to}', 'yyyy-mm-dd'),-2))   
 group by dv.area_code,dv.cus_code,dv.insidercardno
 ) dv group by dv.area_code,dv.cus_code

select dv.area_code,
       dv.cus_code,
       count(*) vip_count
from
(
select dv.area_code,
       dv.cus_code,
       dv.insidercardno
  from dim_vip dv, 
       dm_available_vip  dav
 where dv.insiderid=dav.insiderid
   and ${if(len(region) = 0, "1=1", "  dv.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dv.CUS_CODE in ('"+store+"')") }
   and dav.sale_date between trunc(add_months(to_date('${date_from}', 'yyyy-mm-dd'),-24), 'mm') and last_day(add_months(to_date('${date_to}', 'yyyy-mm-dd'),-13))   
 group by dv.area_code,dv.cus_code,dv.insidercardno
 ) dv group by dv.area_code,dv.cus_code

select dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount) no_tax_amount
  from DM_SALE_TMP dst 
 where ${if(len(region) = 0, "1=1", "  dst.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dst.CUS_CODE in ('"+store+"')") }
   and dst.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and dst.vip='是'
   group by dst.area_code,
       dst.cus_code

select dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount) no_tax_amount
  from DM_SALE_TMP dst 
 where ${if(len(region) = 0, "1=1", "  dst.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dst.CUS_CODE in ('"+store+"')") }
   and dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
   and dst.vip='是'
   group by dst.area_code,
       dst.cus_code

select dst.area_code,
       dst.cus_code,
       sum(dst.no_tax_amount) no_tax_amount
  from DM_SALE_TMP dst 
 where ${if(len(region) = 0, "1=1", "  dst.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  dst.CUS_CODE in ('"+store+"')") }
   and dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
   and dst.vip='是'
   group by dst.area_code,
       dst.cus_code

select ft.area_code,ft.cus_code,count(*) vip_tran_num 
  from FACT_TRANSACTION ft 
 where ${if(len(region) = 0, "1=1", "  ft.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  ft.CUS_CODE in ('"+store+"')") } 
   and ft.is_vip='Y'
   and ft.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
group by ft.area_code,ft.cus_code

select ft.area_code,ft.cus_code,count(*) vip_tran_num 
  from FACT_TRANSACTION ft 
 where ${if(len(region) = 0, "1=1", "  ft.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  ft.CUS_CODE in ('"+store+"')") } 
   and ft.is_vip='Y'
   and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
group by ft.area_code,ft.cus_code

select ft.area_code,ft.cus_code,count(*) vip_tran_num 
  from FACT_TRANSACTION ft 
 where ${if(len(region) = 0, "1=1", "  ft.area_code in ('"+region+"')") }
   and ${if(len(store) = 0, "1=1", "  ft.CUS_CODE in ('"+store+"')") } 
   and ft.is_vip='Y'
   and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
group by ft.area_code,ft.cus_code

Select area_code,area_name from DIM_REGION 
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN ('"+UNION_AREA+"') ")}

ORDER BY AREA_CODE ASC

select dc.cus_code,dc.cus_code||'|'||dc.cus_name cus_name from fact_store_import fsi,dim_cus dc
where  fsi.area_code=dc.area_code
  and fsi.cus_code=dc.cus_code
  and dc.attribute='直营'
  and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
  and fsi.year =substr('${date_from}',1,4)

SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION

