select * from
(
select pssg.date1,
       ddc.goods_code,
       dr.area_name,
       dg.goods_name,
       dg.specification,
       dg.manufacturer,
       dg.sub_category,
       dg.composition,
       dg.sub_composition,
       pssg.jcsx,  --采购属性
       pssg.dtp, --是否dtp
       dg.season_attribute,
       pssg.area_code, 
       --pssg.goods_code,
       pssg.zyxs_amount,
       pssg.jmps_amount,
       pssg.pfps_amount,
       pssg.gljyps_amount,
       pssg.dckc_amount,
       pssg.zykc_amount,
       bdx_qty.datediff,
       case when (nvl(pssg.dckc_amount,0)+nvl(pssg.zykc_amount,0))=0 then 0
            when (nvl(pssg.zyxs_amount,0)+nvl(pssg.jmps_amount,0)+nvl(pssg.pfps_amount,0)+nvl(pssg.gljyps_amount,0))=0 then 999
             else round((nvl(pssg.dckc_amount,0)+nvl(pssg.zykc_amount,0))/(nvl(pssg.zyxs_amount,0)+nvl(pssg.jmps_amount,0)+nvl(pssg.pfps_amount,0)+nvl(pssg.gljyps_amount,0)) 
                  * (add_months(to_date('${date_month}', 'YYYY-MM'),1)-to_date('${date_month}', 'YYYY-MM'))
                  --(add_months(to_date('201910', 'YYYYMM'),1)-to_date('201910', 'YYYYMM'))
                  ) end trun_day
      --,(nvl(pssg.dckc_amount,0)+nvl(pssg.zykc_amount,0)) sum_kc,
      --(nvl(pssg.zyxs_amount,0)+nvl(pssg.jmps_amount,0)+nvl(pssg.pfps_amount,0)+nvl(pssg.gljyps_amount,0)) sum_xs,
      --(add_months(to_date('201910', 'YYYYMM'),1)-to_date('201910', 'YYYYMM')) a2
  from dm_purchase_sale_stock_goods pssg,
       dim_region dr,
       dim_goods dg,
       dim_disable_code ddc,
       (select dgfd.area_code,
       dgfd.goods_code,
       max(dgfd.date_max) date_max,
       --TO_NUMBER(trunc(sysdate) - max(dgfd.date_max)) datediff
       trunc(sysdate) - max(dgfd.date_max) datediff
       
  from dm_goods_Fixedpin_days dgfd
 where --dgfd.area_code=10
       1=1 ${if(len(region)=0,""," and dgfd.area_code in ('"+region+"')")}
 group by area_code, goods_code) bdx_qty
 where pssg.area_code=dr.area_code
   and pssg.goods_code=dg.goods_code
   and pssg.goods_code=ddc.disable_code(+)
   and pssg.area_code=bdx_qty.area_code(+)
   and pssg.goods_code=bdx_qty.goods_code(+)
   --and pssg.area_code=10
   --and pssg.date1='2019-10'
   --and  to_char(ss.sale_date,'yyyy-mm-dd')  between '${date_from}' and '${date_to}'
   and pssg.date1='${date_month}'
   AND 1=1 ${if(len(region)=0,""," and pssg.area_code in ('"+region+"')")}
   AND 1=1 ${if(len(item)=0,""," and pssg.goods_code in ('"+item+"')")}
   AND 1=1 ${if(len(sub_category)=0,""," and dg.sub_category in ('"+sub_category+"')")}
   AND 1=1 ${if(len(composition)=0,""," and dg.composition in ('"+composition+"')")}
   AND 1=1 ${if(len(cgsx)=0,""," and pssg.jcsx = '"+cgsx+"'")}
   AND 1=1 ${if(len(season_attr)=0,""," and dg.season_attribute = '"+season_attr+"'")}
   AND 1=1 ${if(len(dtp)=0,""," and pssg.dtp = '"+dtp+"'")}
   AND 1=1 ${if(len(cgsx)=0,""," and pssg.jcsx = '"+cgsx+"'")}
   AND 1=1 ${if(len(is_dtp)=0,""," and pssg.dtp = '"+is_dtp+"'")}
   AND 1=1 ${if(len(datediff)=0,""," and to_number(bdx_qty.datediff) >= "+datediff+"")}
 ) where  1=1 ${if(len(trun_day)=0,""," and to_number(nvl(trun_day,0)) >= "+trun_day+"")}
 order by date1,area_code,goods_code

select * from dim_region dr where ${if(len(region)=0, "1=1",  " dr.area_code in ('"+regiog+"')")} order by dr.area_code

select  distinct dc.cus_code,dc.cus_name from dim_cus dc,dm_sale_oto  dso 
where dc.area_code=dso.area_code and dc.cus_code=dso.cus_code 
 -- and to_char(dso.sale_date,'yyyy-mm-dd') between '${date_from}' and '${date_to}'

select  distinct dso.goods_code,dso.goods_code||'|'||dg.goods_name goods_name from dm_purchase_sale_stock_goods dso,dim_disable_code ddc,dim_goods dg  
where dso.goods_code=ddc.disable_code(+) 
  and dso.goods_code=dg.goods_code(+)
  and dso.date1='${date_month}'
  AND 1=1 ${if(len(region)=0,""," and dso.area_code in ('"+region+"')")}
 --and to_char(dso.sale_date,'yyyy-mm-dd') between '${date_from}' and '${date_to}'
--and rownum<5000
order by 1

select distinct pssg.jcsx from gygd_bi.dm_purchase_sale_stock_goods pssg

 select area_code, 
         goods_code,
         order_date from 
  (select fp.area_code, 
         fp.goods_code,
         fp.order_date,
         rank() over(partition by fp.area_code,fp.goods_code order by fp.order_date) r
         
    from fact_purchase fp,dim_disable_code ddc
   where fp.procurement_type = '采进'
     and fp.goods_code=ddc.disable_code(+)
     AND 1=1 ${if(len(region)=0,""," and fp.area_code in ('"+region+"')")}
     AND 1=1 ${if(len(item)=0,""," and fp.goods_code in ('"+item+"')")}
     --and fp.area_code=10
   ) where r=1
      and order_date between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')

select distinct dg.sub_category from dim_goods dg

select distinct dg.season_attribute from dim_goods dg

