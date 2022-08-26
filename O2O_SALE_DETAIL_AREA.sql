select dso.marketing_name,
       dr.area_code,
       dr.sorted,
       dr.area_name,
       dso.sale_date,
       '' order_no,
       dso.goods_code,
       dg.bar_code,
       dg.goods_name,
       dg.specification,
       dg.manufacturer,
       dg.category,
       dg.sub_category,
       dso.sale_qty,
       dso.tax_amount,
       dso.tax_cost,
       '' bt_amount,
       '' pt_amount,
       '' bus_profit,
       '' old_profit,
       dso.front_rate,
       '' old_rate,
       (select iu.uda_value_desc from item_uda iu where dso.disable_code=iu.item and iu.uda_id=6)  uda_value    
  from 
       (select ss.marketing_name,ss.area_code,ss.sale_date,nvl(m.goods_code,ss.goods_code) goods_code, ss.goods_code disable_code,sum(ss.sale_qty) sale_qty,sum(ss.tax_amount) tax_amount,sum(ss.tax_cost) tax_cost, 
              decode(sum(ss.tax_amount),0,0,round((sum(ss.tax_amount)-sum(ss.tax_cost))/sum(ss.tax_amount),2)) front_rate 
       from dm_sale_oto ss,dim_goods_mapping m,dim_marketing_all ma
       where  ss.goods_code=m.area_goods_code(+)
       and ss.area_code=m.area_code(+)
       and ss.marketing_code=ma.marketing_code(+)
       and ss.area_code=ma.area_code(+)
         and  to_char(ss.sale_date,'yyyy-mm-dd')  between '${date_from}' and '${date_to}'
         AND 1=1 ${if(len(large)=0,""," and ma.large_cate in ('"+large+"')")}
          AND 1=1 ${if(len(small)=0,""," and ma.small_cate in ('"+small+"')")}
         AND 1=1 ${if(len(item)=0,""," and m.goods_code in ('"+item+"')")}
         AND 1=1 ${if(len(region)=0,""," and ss.area_code in ('"+region+"')")}
         --and ss.sale_date between to_date('2019-10-01', 'yyyy-mm-dd') and to_date('2019-10-01', 'yyyy-mm-dd')
         --and ss.area_code=10 
         group by ss.marketing_name,ss.area_code,ss.sale_date,nvl(m.goods_code,ss.goods_code), ss.goods_code) dso,
       dim_region dr,
       dim_goods dg
 where  dso.area_code=dr.area_code(+)
   and dso.goods_code=dg.goods_code(+)  
   AND 1=1 ${if(len(bar_code)=0,""," and dg.bar_code = '"+bar_code+"'")}
   order by dr.sorted

select * from dim_region dr order by dr.sorted

select  distinct ddc.goods_code,dg.goods_name from dm_sale_oto dso,dim_disable_code ddc,dim_goods dg  
where dso.goods_code=ddc.disable_code(+) and dso.goods_code=dg.goods_code(+)
  and to_char(dso.sale_date,'yyyy-mm-dd') between '${date_from}' and '${date_to}'
and rownum<5000

select * from DIM_MARKETING_all a where a.oto='Y'
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}

