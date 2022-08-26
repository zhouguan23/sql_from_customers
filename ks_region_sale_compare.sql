select fsi.area_code,
       sum(fsi.total_revenue_main_business) total_revenue_main_business,
       sum(fsi.total_gp_main_business) total_gp_main_business,
       sum(fsi.employee_remuneration) employee_remuneration,
       sum(fsi.rental_fee) rental_fee,
       sum(fsi.subtotal_of_expenses) subtotal_of_expenses,
       sum(fsi.operating_profit) operating_profit
       
  from 
       fact_store_import fsi,
       dim_region dr,
       dim_cus dc
       
 where fsi.area_code=dr.area_code
   and fsi.area_code=dc.area_code
   and fsi.cus_code=dc.cus_code
   and dc.attribute='直营'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and  fsi.year =substr('${date_from}',1,4)
   and  fsi.month=to_number(substr('${date_from}',6,2))
   --and fsi.area_code=68
   --and fsi.year='2019' and fsi.month='5'
   group by fsi.area_code

select dst.area_code,
       sum(dst.no_tax_amount) no_tax_amount,
       sum((dst.no_tax_amount-dst.no_tax_cost)) no_ml,
       sum((dst.origin_amount-dst.no_tax_amount)) dis_amount
  from DM_SALE_TMP dst,
       dim_cus dc
   
      
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dst.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   --and dst.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd')
   --and dst.area_code=68
   group by dst.area_code

select dst.area_code,
       sum(dst.no_tax_amount) no_tax_amount,
       sum((dst.no_tax_amount-dst.no_tax_cost)) no_ml,
       sum((dst.origin_amount-dst.no_tax_amount)) dis_amount
  from DM_SALE_TMP dst,
       dim_cus dc
   
      
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
    and dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1) --and dst.sale_date between add_months(date'2019-05-01',-1) and add_months(date'2019-05-31',-1)
  -- and dst.area_code=68
   group by dst.area_code

select dst.area_code,
       sum(dst.no_tax_amount) no_tax_amount,
       sum((dst.no_tax_amount-dst.no_tax_cost)) no_ml,
       sum((dst.origin_amount-dst.no_tax_amount)) dis_amount
  from DM_SALE_TMP dst,
       dim_cus dc
   
      
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)   --and dst.sale_date between add_months(date'2019-05-01',-12) and add_months(date'2019-05-31',-12)
   --and dst.area_code=68
   group by dst.area_code

select ft.area_code,
          count(*) tran_num 
     from FACT_TRANSACTION ft,
          dim_cus dc 
    where ft.area_code=dc.area_code
      and to_char(ft.cus_code)=dc.cus_code
      and dc.attribute='直营'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and ft.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
      --and ft.Area_Code='68' 
      --and ft.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
     group by ft.area_code

select ft.area_code,
          count(*) tran_num 
     from FACT_TRANSACTION ft,
          dim_cus dc 
    where ft.area_code=dc.area_code
      and to_char(ft.cus_code)=dc.cus_code
      and dc.attribute='直营'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
      --and ft.Area_Code='68' 
      --and ft.sale_date between add_months(date'2019-05-01',-1) and add_months(date'2019-05-31',-1)
     group by ft.area_code

select ft.area_code,
          count(*) tran_num 
     from FACT_TRANSACTION ft,
          dim_cus dc 
    where ft.area_code=dc.area_code
      and to_char(ft.cus_code)=dc.cus_code
      and dc.attribute='直营'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
      --and ft.Area_Code='68' 
      --and ft.sale_date between add_months(date'2019-05-01',-12) and add_months(date'2019-05-31',-12)
     group by ft.area_code

select dssd.AREA_CODE,
          count(*) sku_amount 
     from DM_STOCK_SHOP_DETAIL dssd,
          dim_cus dc 
    where dssd.area_code=dc.area_code
      and dssd.cus_code=dc.cus_code
      and dc.attribute='直营'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and dssd.DDATE=last_day(add_months(to_date('${date_from}', 'yyyy-mm-dd'), -1))
      --and dssd.AREA_CODE=68 
      --and dssd.DDATE=last_day(add_months(date'2019-05-01', -1))  
group by dssd.AREA_CODE

 select dssd.AREA_CODE,
          count(*) sku_amount 
     from DM_STOCK_SHOP_DETAIL dssd,
          dim_cus dc 
    where dssd.area_code=dc.area_code
      and dssd.cus_code=dc.cus_code
      and dc.attribute='直营'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and dssd.DDATE=last_day(add_months(to_date('${date_from}', 'yyyy-mm-dd'), -2))
      --and dssd.AREA_CODE=68 
      --and dssd.DDATE=last_day(add_months(date'2019-05-01', -1))  
group by dssd.AREA_CODE

 select dssd.AREA_CODE,
          count(*) sku_amount 
     from DM_STOCK_SHOP_DETAIL dssd,
          dim_cus dc 
    where dssd.area_code=dc.area_code
      and dssd.cus_code=dc.cus_code
      and dc.attribute='直营'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and dssd.DDATE=last_day(add_months(to_date('${date_from}', 'yyyy-mm-dd'), -13))
      --and dssd.AREA_CODE=68 
      --and dssd.DDATE=last_day(add_months(date'2019-05-01', -1))  
group by dssd.AREA_CODE

select AREA_CODE,count(*) dx_sku_amount
     from (select fs.AREA_CODE,
                  fs.GOODS_CODE 
             from fact_sale fs,
                  dim_cus dc 
            where fs.area_code=dc.area_code
              and fs.cus_code=dc.cus_code
              and dc.attribute='直营'
              and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
              and fs.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
              --and fs.AREA_CODE=68 
              --and fs.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
              group by fs.AREA_CODE,fs.GOODS_CODE
    ) group by AREA_CODE

 select AREA_CODE,count(*) dx_sku_amount
     from (select fs.AREA_CODE,
                  fs.GOODS_CODE 
             from fact_sale fs,
                  dim_cus dc 
            where fs.area_code=dc.area_code
              and fs.cus_code=dc.cus_code
              and dc.attribute='直营'
              and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
              and fs.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
              --and fs.AREA_CODE=10 
              --and fs.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
              group by fs.AREA_CODE,fs.GOODS_CODE
    ) group by AREA_CODE

 select AREA_CODE,count(*) dx_sku_amount
     from (select fs.AREA_CODE,
                  fs.GOODS_CODE 
             from fact_sale fs,
                  dim_cus dc 
            where fs.area_code=dc.area_code
              and fs.cus_code=dc.cus_code
              and dc.attribute='直营'
             -- and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
             -- and fs.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
              and fs.AREA_CODE=68 
              and fs.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
              group by fs.AREA_CODE,fs.GOODS_CODE
    ) group by AREA_CODE

select dv.area_code,
       count(*) vip_count
from
(
select dv.area_code,
       dv.insidercardno
  from dim_vip dv, 
       dm_available_vip  dav,
       dim_cus dc 
 where dv.area_code=dc.area_code
   and dv.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dv.insiderid=dav.insiderid
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dav.sale_date between trunc(add_months(to_date('${date_from}', 'yyyy-mm-dd'), -12), 'mm') and last_day(add_months(to_date('${date_to}', 'yyyy-mm-dd'), -1))
   --and dav.sale_date between trunc(add_months(date'2019-05-01', -12), 'mm') and last_day(add_months(date'2019-05-01', -1))   
   --and dv.area_code=68
 group by dv.area_code,dv.insidercardno
 ) dv group by dv.area_code

select dv.area_code,
       count(*) vip_count
from
(
select dv.area_code,
       dv.insidercardno
  from dim_vip dv, 
       dm_available_vip  dav,
       dim_cus dc 
 where dv.area_code=dc.area_code
   and dv.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dv.insiderid=dav.insiderid
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }  
   and dav.sale_date between trunc(add_months(to_date('${date_from}', 'yyyy-mm-dd'), -13), 'mm') and last_day(add_months(to_date('${date_to}', 'yyyy-mm-dd'), -2))
   --and dav.sale_date between trunc(add_months(date'2019-05-01', -12), 'mm') and last_day(add_months(date'2019-05-01', -1))   
   --and dv.area_code=68
 group by dv.area_code,dv.insidercardno
 ) dv group by dv.area_code

select dv.area_code,
       count(*) vip_count
from
(
select dv.area_code,
       dv.insidercardno
  from dim_vip dv, 
       dm_available_vip  dav,
       dim_cus dc 
 where dv.area_code=dc.area_code
   and dv.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dv.insiderid=dav.insiderid
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dav.sale_date between trunc(add_months(to_date('${date_from}', 'yyyy-mm-dd'), -24), 'mm') and last_day(add_months(to_date('${date_to}', 'yyyy-mm-dd'), -13))
   --and dav.sale_date between trunc(add_months(date'2019-05-01', -12), 'mm') and last_day(add_months(date'2019-05-01', -1))   
   --and dv.area_code=68
 group by dv.area_code,dv.insidercardno
 ) dv group by dv.area_code

select dst.area_code,
       sum(dst.no_tax_amount) no_tax_amount
  from DM_SALE_TMP dst,
       dim_cus dc  
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dst.vip='是'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dst.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   --and dst.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd')
   --and dst.area_code=68
   group by dst.area_code

select dst.area_code,
       sum(dst.no_tax_amount) no_tax_amount
  from DM_SALE_TMP dst,
       dim_cus dc  
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dst.vip='是'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
   --and dst.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd')
   --and dst.area_code=68
   group by dst.area_code

select dst.area_code,
       sum(dst.no_tax_amount) no_tax_amount
  from DM_SALE_TMP dst,
       dim_cus dc  
 where dst.area_code=dc.area_code
   and dst.cus_code=dc.cus_code
   and dc.attribute='直营'
   and dst.vip='是'
   and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
   and dst.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
   --and dst.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd')
   --and dst.area_code=68
   group by dst.area_code

select ft.area_code,
          count(*) vip_tran_num 
     from FACT_TRANSACTION ft,
          dim_cus dc 
    where ft.area_code=dc.area_code
      and to_char(ft.cus_code)=dc.cus_code
      and dc.attribute='直营'
      and ft.is_vip='Y'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and ft.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
      --and ft.Area_Code='68'
      --and ft.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
      group by ft.area_code

select ft.area_code,
          count(*) vip_tran_num 
     from FACT_TRANSACTION ft,
          dim_cus dc 
    where ft.area_code=dc.area_code
      and to_char(ft.cus_code)=dc.cus_code
      and dc.attribute='直营'
      and ft.is_vip='Y'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1)
      --and ft.Area_Code='68'
      --and ft.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
      group by ft.area_code

select ft.area_code,
          count(*) vip_tran_num 
     from FACT_TRANSACTION ft,
          dim_cus dc 
    where ft.area_code=dc.area_code
      and to_char(ft.cus_code)=dc.cus_code
      and dc.attribute='直营'
      and ft.is_vip='Y'
      and ${if(len(region) = 0, "1=1", "  dc.area_code in ('"+region+"')") }
      and ft.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
      --and ft.Area_Code='68'
      --and ft.sale_date between to_date('2019-05-01','yyyy-mm-dd') and to_date('2019-05-31','yyyy-mm-dd') 
      group by ft.area_code

Select area_code,area_name from DIM_REGION 
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN ('"+UNION_AREA+"') ")}

ORDER BY AREA_CODE ASC

SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION

