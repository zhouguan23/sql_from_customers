select DISTINCT A.area_Code,a.cus_code,b.cus_name,b.attribute
from dm_stock_shop_shop A left join dim_cus b ON A.AREA_cODE=B.AREA_CODE AND A.CUS_CODE=B.CUS_CODE
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(typ)=0,""," and b.attribute in ('"+typ+"')")}
AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}



select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL

select area_name,area_code from dim_region

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

select area_code,cus_code,sum(stock_qty),sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(stock_qty),sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(stock_qty),sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and gather !='地采'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and gather !='地采'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and gather !='地采'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and DTP='是'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and DTP='是'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and DTP='是'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='过效期成本'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='过效期成本'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='过效期成本'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='近效期成本'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='过效期成本'
GROUP BY AREA_CODE,cus_code


select area_code,cus_code,sum(no_tax_cost)
from dm_stock_shop_shop
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and EFFECTIVE='过效期成本'
GROUP BY AREA_CODE,cus_code


SELECT DISTINCT AREA_NAME
FROM  
DIM_REGION 
WHERE  
AREA_CODE IN ('${area}')

