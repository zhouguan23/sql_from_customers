  select * from new_shop_reaserch nsr where ${if(len(item) = 0, "1=1", "  nsr.item in ('"+item+"')") }
and to_date(nsr.order_date,'yyyy-mm-dd') between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
and ${if(len(region) = 0, "1=1", "  nsr.region in ('"+region+"')") }
order by nsr.region,nsr.item,nsr.order_date

select distinct nsr.region,nsr.region||'|'||nsr.region_name from new_shop_reaserch nsr order by 1

select distinct sub_category from dim_goods

select distinct nsr.item,nsr.item||'|'||nsr.goods_name goods_name from new_shop_reaserch nsr
where to_date(nsr.order_date,'yyyy-mm-dd') between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')

