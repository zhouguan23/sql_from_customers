select a.area_code,m.goods_code,c.goods_name,c.specification,c.manufacturer,gather,dtp,month_jj,
sum(a.stock_qty) as stock_qty,sum(a.no_tax_cost) as no_tax_cost

from 
( select area_code,goods_code,gather, stock_qty, no_tax_cost,'月末库存' month_jj,dtp

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
   AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
   AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
   --AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
   AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
   AND 1=1 ${if(len(goods)=0,""," and goods_code in ('"+goods+"')")}
   AND 1=1 ${if(len(kc_attr)=0,""," and 1=decode('"+kc_attr+"','月末库存',1,2)")}
   AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
     /*ddate = to_date('2019-09-30','yyyy-mm-dd')
     and area_code=10
     and Attribute='直营'*/
   and Attribute='直营'
union all
select area_code,goods_code,gather, stock_qty, no_tax_cost,month_jj,dtp

from dm_fact_stock_shop_xun
where 
   1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
   and to_char(ddate,'yyyy-mm')='${Date}'
   and 1=1 ${if(len(kc_attr)=0,""," and month_jj in ('"+kc_attr+"')")}
   AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
  -- AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
   AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
   AND 1=1 ${if(len(goods)=0,""," and goods_code in ('"+goods+"')")}
     /*to_char(ddate,'yyyy-mm') = '2019-10'
     and area_code=10
     and ATTRIBUTE='直营'*/
   and ATTRIBUTE='直营'
) a 

left join dim_disable_code M on a.goods_code=m.disable_code
left join dim_goods C on M.goods_code=c.goods_code

GROUP BY a.area_code,M.goods_code,c.goods_name,c.specification,c.manufacturer,gather,dtp,month_jj

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL

select area_name,area_code from dim_region

select distinct b.goods_code,b.goods_code||'|'||C.goods_name goods_name
from dm_stock_shop_goods A left join dim_disable_code B on a.goods_code=b.disable_code
left join dim_goods C on B.goods_code=c.goods_Code
where 
ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
and rownum<5000

select area_code,goods_Code,month_jj,count(*) from 
(

select  area_code,goods_code,cus_code,month_jj,count(*) from

(select A.area_code,b.goods_code,A.cus_code,ddate,
        case when substr(a.DDATE,1,2) between 10 and 18 then '上旬'
             when to_number(substr(a.DDATE,1,2)) between 19 and 27 then '中旬'
              else '月末库存' end month_jj
from DIM_CUS C,FACT_STOCK_SHOP A left join dim_disable_code B 
on a.goods_code=b.disable_code


where --ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
    to_char(ddate,'yyyy-mm')='${Date}'
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
--AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
AND 1=1 ${if(len(goods)=0,""," and b.goods_code in ('"+goods+"')")}
and A.AREA_CODE=C.AREA_CODE and A.CUS_CODE=C.CUS_CODE
and C.ATTRIBUTE='直营'
--and a.AREA_CODE='10'
and 1=1 ${if(len(kc_attr)=0,""," and (case when substr(a.DDATE,1,2) between 10 and 18 then '上旬'
             when to_number(substr(a.DDATE,1,2)) between 19 and 27 then '中旬'
              else '月末库存' end ) in ('"+kc_attr+"')")}
--and to_char(a.DDATE,'yyyy-mm')='2019-10'
--and a.GOODS_CODE='2027537' 
--and a.CUS_CODE=100086
)

group by area_code,goods_Code,cus_code,month_jj

) group by area_code,goods_Code,month_jj

select dst.area_code,dst.GOODS_CODE,count(*) amount
from
(select dst.area_code,
       ddc.GOODS_CODE,
       dst.CUS_CODE
  from fact_sale dst, dim_cus dc,dim_disable_code ddc,DIM_NET_CATALOGUE_GENERAL_ALL dncg,
       (select goods_code,
               area_code,
               to_CHAR(ADD_MONTHS(to_date(create_month, 'YYYY-MM'), 1),
                       'YYYY-MM') create_month
          from dim_dtp) dd
 where dst.area_code = dc.area_code
   and dst.cus_code = dc.cus_code
   and dst.GOODS_CODE=ddc.disable_code(+)
   and dst.area_code = dncg.area_code(+)
   and dst.goods_code = dncg.goods_code(+)
   and to_char(dst.sale_date, 'yyyy-mm') = dncg.create_month(+)
    and dst.area_code = dd.area_code(+)
   and dst.goods_code = dd.goods_code(+)
   and to_char(dst.sale_date, 'yyyy-mm') = dd.create_month(+)
   and dc.attribute='直营'
   and to_char(dst.sale_date,'yyyy-mm') = '${Date}'
   AND 1=1 ${if(len(area)=0,""," and dst.area_code in ('"+area+"')")}
   AND 1=1 ${if(len(dtp)=0,""," and decode(dd.create_month,'','否','是') = '"+dtp+"'")}
   AND 1=1 ${if(len(gather)=0,""," and dncg.new_attribute in ('"+gather+"')")}
   AND 1=1 ${if(len(goods)=0,""," and ddc.goods_code in ('"+goods+"')")}
   --and dst.AREA_CODE=10
   --and dst.SALE_DATE between to_date('2019-09-01','yyyy-mm-dd') and to_date('2019-09-30','yyyy-mm-dd')
   group by dst.area_code,
       ddc.GOODS_CODE,
       dst.CUS_CODE) dst group by dst.area_code,dst.GOODS_CODE

