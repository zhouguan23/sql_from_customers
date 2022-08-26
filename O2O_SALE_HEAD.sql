select dso.marketing_code,
       dso.marketing_name,
       dr.area_code,
       dr.area_name,
       sum(dso.sale_qty) sale_qty,
       sum(dso.tax_amount) tax_amount ,
       sum(dso.no_tax_amount) no_tax_amount
  from dm_sale_oto dso,
       dim_region dr
 where dso.area_code=dr.area_code
   --and dso.sale_date between to_date('2019-10-01', 'yyyy-mm-dd') and to_date('2019-10-31', 'yyyy-mm-dd')
   --and dso.area_code=10
   and dso.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
   AND 1=1 ${if(len(market)=0,""," and dso.marketing_code in ('"+market+"')")}
   group by dso.marketing_code,dso.marketing_name,dr.area_code,dr.area_name

select * from dim_region dr where ${if(len(region)=0, "1=1",  " dr.area_code in ('"+region+"')")}

select  distinct ddc.goods_code,dg.goods_name from dm_sale_oto dso,dim_disable_code ddc,dim_goods dg  
where dso.goods_code=ddc.disable_code(+) and dso.goods_code=dg.goods_code(+)
  and to_char(dso.sale_date,'yyyy-mm-dd') between '${date_from}' and '${date_to}'
and rownum<5000

select * from DIM_MARKETING a where a.oto='是'

select dst.area_code,
          sum(dst.no_tax_amount) no_tax_amount,
          sum(dst.tax_amount) tax_amount
     from dm_sale_tmp dst
    where  
    --dst.sale_date between to_date('2019-10-01', 'yyyy-mm-dd') and to_date('2019-10-31', 'yyyy-mm-dd')
      --and dst.area_code=10
      dst.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
      AND 1=1 ${if(len(region)=0,""," and dst.area_code in ('"+region+"')")}
    group by dst.area_code

select marketing_code,area_code,count(*) amount from
   (
   select dso.marketing_code,dso.area_code,dso.tran_no, count(*)
     from dm_sale_oto dso
    where 
    --dso.sale_date between to_date('2019-10-01', 'yyyy-mm-dd') and to_date('2019-10-31', 'yyyy-mm-dd')
     --and dso.area_code=10
    dso.sale_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
    group by dso.marketing_code,dso.area_code, dso.tran_no
    ) group by marketing_code,area_code

select dso.marketing_code,
       dr.area_code,
       --dso.sale_date,
       sum(dso.sale_qty) sale_qty,
       sum(dso.tax_amount) tax_amount ,
       sum(dso.no_tax_amount) no_tax_amount
  from dm_sale_oto dso,
       dim_region dr
 where dso.area_code=dr.area_code
   --and dso.sale_date between to_date('2019-09-01', 'yyyy-mm-dd') and to_date('2019-09-30', 'yyyy-mm-dd')
   --and dso.area_code=10
   and dso.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1) 
   AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
   AND 1=1 ${if(len(market)=0,""," and dso.marketing_code in ('"+market+"')")}
   group by dso.marketing_code,dr.area_code

select dso.marketing_code,
       dr.area_code,
       --dso.sale_date,
       sum(dso.sale_qty) sale_qty,
       sum(dso.tax_amount) tax_amount ,
       sum(dso.no_tax_amount) no_tax_amount
  from dm_sale_oto dso,
       dim_region dr
 where dso.area_code=dr.area_code
   --and dso.sale_date between to_date('2018-10-01', 'yyyy-mm-dd') and to_date('2018-10-31', 'yyyy-mm-dd')
   --and dso.area_code=10
   and dso.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
   AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
   AND 1=1 ${if(len(market)=0,""," and dso.marketing_code in ('"+market+"')")}
   group by dso.marketing_code,dr.area_code

select marketing_code,area_code,count(*) amount from
   (
   select dso.marketing_code,dso.area_code,dso.tran_no, count(*)
     from dm_sale_oto dso
    where 
    --dso.sale_date between to_date('2019-09-01', 'yyyy-mm-dd') and to_date('2019-09-30', 'yyyy-mm-dd')
      --and dso.area_code=10
      dso.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-1) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-1) 
   AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
    group by dso.marketing_code,dso.area_code, dso.tran_no
    ) group by marketing_code,area_code

select marketing_code,area_code,count(*) amount from
   (
   select dso.marketing_code,dso.area_code,dso.tran_no, count(*)
     from dm_sale_oto dso
    where 
    --dso.sale_date between to_date('2018-10-01', 'yyyy-mm-dd') and to_date('2018-10-31', 'yyyy-mm-dd')
      --and dso.area_code=10
     dso.sale_date between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
   AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
    group by dso.marketing_code,dso.area_code, dso.tran_no
    ) group by marketing_code,area_code

