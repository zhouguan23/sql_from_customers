select ss.marketing_name,
       dr.area_code,
       dr.area_name,
       dr.sorted,
       dc.cus_code,
       dc.cus_name,
       ss.sale_date,
       '' order_no,
       nvl(m.goods_code,ss.goods_code) goods_code,
       dg.bar_code,
       dg.goods_name,
       dg.specification,
       dg.manufacturer,
       dg.category,
       dg.sub_category,
       ss.sale_qty,
       ss.tax_amount,
       ss.tax_cost,
       '' bt_amount,
       '' pt_amount,
       '' bus_profit,
       '' old_profit,
       decode(ss.tax_amount,0,0,round((ss.tax_amount-ss.tax_cost)/ss.tax_amount,2)) front_rate,
       '' old_rate,
       (select iu.uda_value_desc from item_uda iu where nvl(m.goods_code,ss.goods_code)=iu.item and iu.uda_id=6)  uda_value    
  from dm_sale_oto ss,
       dim_cus dc,
       dim_region dr,
       dim_goods_mapping m,
       dim_goods dg,
       dim_marketing_all ma
 where ss.area_code = dc.area_code
   and ss.cus_code=dc.cus_code
   and ss.area_code=dr.area_code
    and ss.goods_code=m.area_goods_code(+)
   and ss.area_code=m.area_code(+)
   and nvl(m.goods_code,ss.goods_code)=dg.goods_code
   and ss.marketing_code=ma.marketing_code(+)
   and ss.area_code=ma.area_code(+)
--and ss.sale_date between to_date('2019-10-01', 'yyyy-mm-dd') and to_date('2019-10-01', 'yyyy-mm-dd')
   --and ss.area_code=10   
   and  to_char(ss.sale_date,'yyyy-mm-dd')  between '${date_from}' and '${date_to}'
       AND 1=1 ${if(len(large)=0,""," and ma.large_cate in ('"+large+"')")}
          AND 1=1 ${if(len(small)=0,""," and ma.small_cate in ('"+small+"')")}
   AND 1=1 ${if(len(store)=0,""," and ss.cus_code in ('"+store+"')")}
   AND 1=1 ${if(len(item)=0,""," and dg.goods_code in ('"+item+"')")}
   AND 1=1 ${if(len(region)=0,""," and ss.area_code in ('"+region+"')")}
   AND 1=1 ${if(len(bar_code)=0,""," and dg.bar_code = '"+bar_code+"'")}
   order by  dr.sorted

select * from dim_region dr order by sorted

select  distinct dc.cus_code,dc.cus_name from dim_cus dc,dm_sale_oto  dso 
where dc.area_code=dso.area_code and dc.cus_code=dso.cus_code 
  and to_char(dso.sale_date,'yyyy-mm-dd') between '${date_from}' and '${date_to}'

select  distinct ddc.goods_code,dg.goods_name from dm_sale_oto dso,dim_disable_code ddc,dim_goods dg  
where dso.goods_code=ddc.disable_code(+) and dso.goods_code=dg.goods_code(+)
  and to_char(dso.sale_date,'yyyy-mm-dd') between '${date_from}' and '${date_to}'
and rownum<5000

select * from DIM_MARKETING_all a where a.oto='Y'
AND 1=1 ${if(len(region)=0,""," and area_code in ('"+region+"')")}

