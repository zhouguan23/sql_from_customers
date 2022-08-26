select DISTINCT A.area_Code,a.cus_code,b.cus_name,b.attribute
from DAY_DM_STOCK_SHOP_DETAIL A 
left join dim_region dr on a.area_code=dr.area_code 
join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"} 
left join dim_cus b ON A.AREA_CODE=B.AREA_CODE AND A.CUS_CODE=B.CUS_CODE
where --ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
    -- ddate='${Date}'AND 
     1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
order by A.area_Code,a.cus_code

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL

select dr.area_name,dr.area_code from dim_region dr,USER_AUTHORITY  ua

where (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
--and ${"ua.user_id='"+$fr_username+"'"}

select distinct dc.cus_code,dc.cus_code||'|'||dc.cus_name cus_name from DIM_CUS dc
where 1=1 ${if(len(area)=0,""," and dc.area_code in ('"+area+"')")}

select distinct b.goods_code,c.goods_name
from dm_stock_shop_detail A left join dim_disable_code B on a.goods_code=b.disable_code
left join dim_goods C on B.goods_code=c.goods_Code
where 
ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}

select a.area_code,a.cus_code,sum(a.stock_qty),sum(a.no_tax_cost)
from DAY_DM_STOCK_SHOP_DETAIL a,dim_cus b
where 
    a.area_code=b.area_code
and a.cus_code=b.cus_code
--ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
GROUP BY a.AREA_CODE,a.cus_code


select area_code,cus_code,sum(no_tax_cost)
from DAY_DM_STOCK_SHOP_DETAIL
where 
--ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 AND 
1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and gather !='地采'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from DAY_DM_STOCK_SHOP_DETAIL
where 
--ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 AND 
1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and DTP='是'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from DAY_DM_STOCK_SHOP_DETAIL
where 
--ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 AND 
1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='过效期成本'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from DAY_DM_STOCK_SHOP_DETAIL
where 
--ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 AND 
1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='近效期成本'
GROUP BY AREA_CODE,cus_code


SELECT DISTINCT dr.AREA_NAME
FROM  
DIM_REGION dr,USER_AUTHORITY  ua

where (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}   
and 1=1 ${if(len(area)=0,""," and dr.area_code in ('"+area+"')")}

select a.area_code,a.cus_code,sum(a.no_tax_cost) no_tax_cost from 
dm_stock_shop_shop a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code,a.cus_code

select a.area_code,a.cus_code,sum(a.no_tax_cost) no_tax_cost from 
dm_stock_shop_shop a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and ddate = to_date('${Date}'||'-01','yyyy/mm/dd')-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code,a.cus_code

select aa.area_code,aa.cus_code,aa.no_tax_cost from 
 
(select a.area_code,a.cus_code,sum(a.no_tax_cost) no_tax_cost from 
dm_sale_tmp a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and to_char(sale_date,'yyyy-mm') = '${Date}'
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code,a.cus_code) aa

 select add_months(to_date('${Date}', 'YYYY-MM'),1) -to_date('${Date}', 'YYYY-MM') now_day,
        add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-12) -add_months(to_date('${Date}', 'YYYY-MM'),-12) last_year_day, 
        add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-1) -add_months(to_date('${Date}', 'YYYY-MM'),-1) last_day from dual

select aa.area_code,aa.cus_code,aa.no_tax_cost no_stock_cost,bb.no_tax_cost no_stock_cost1,cc.no_tax_cost no_stock_cost2 from 
 
(select a.area_code,a.cus_code,sum(a.no_tax_cost) no_tax_cost from 
dm_stock_shop_avg a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and a.ddate = '${Date}'
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code,a.cus_code) aa,

(select a.area_code,a.cus_code,sum(a.no_tax_cost) no_tax_cost from 
dm_stock_shop_avg a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and a.ddate = to_char(add_months(to_date('${Date}','yyyy-mm'),-12),'yyyy-mm')
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code,a.cus_code) bb,

(select a.area_code,a.cus_code,sum(a.no_tax_cost) no_tax_cost from 
dm_stock_shop_avg a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and a.ddate = to_char(add_months(to_date('${Date}','yyyy-mm'),-1),'yyyy-mm')
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code,a.cus_code) cc

where aa.area_code=bb.area_code(+)
  and aa.cus_code=bb.cus_code(+)
  and aa.area_code=cc.area_code(+)
  and aa.cus_code=cc.cus_code(+)

