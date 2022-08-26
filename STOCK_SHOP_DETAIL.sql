select a.area_code,a.cus_code,B.CUS_NAME,b.attribute,m.goods_code,c.goods_name,c.specification,c.manufacturer,gather,dtp,
sum(d.stock_qty) as stock_qty,sum(d.no_tax_cost) as no_tax_cost,
sum(e.gxq_cost) as gxq_cost,
sum(f.jxq_cost) as jxq_cost,
sum(g.stock_qty_ly) as stock_qty_ly,sum(g.no_tax_cost_ly) as no_tax_cost_ly,
sum(h.gxq_cost_ly) as gxq_cost_ly,
sum(i.jxq_cost_ly) as jxq_cost_ly,
sum(j.stock_qty_lm) as stock_qty_lm,sum(j.no_tax_cost_lm) as no_tax_Cost_lm,
sum(k.gxq_cost_lm) as gxq_cost_Lm,
sum(l.jxq_cost_lm) as jxq_Cost_lm

from dm_Stock_shop_detail A left join dim_cus B on a.cus_code=b.cus_Code AND A.AREA_CODE=B.AREA_CODE  
---当期库存额，成本
left join 
( select area_code,cus_code,goods_code,effective,sum(stock_qty) as stock_qty, sum(no_Tax_cost) as no_tax_cost

from dm_Stock_shop_detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
group by area_code,cus_code,goods_code,effective



) D on a.area_code=d.area_code and a.cus_code=d.cus_code and a.goods_code=d.goods_code
and a.effective=d.effective
--- 当期过效期
left join 
(select area_code,cus_code,goods_Code, no_tax_cost as gxq_cost ,effective
from Dm_Stock_Shop_Detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
and effective='过效期成本'
) E on a.area_code=e.area_code and a.goods_code=e.goods_code and a.cus_code=e.cus_code
and a.effective=e.effective

--- 当期近效期
left join 
(select area_code,cus_code,goods_Code, no_tax_cost as jxq_cost ,effective
from Dm_Stock_Shop_Detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")} and effective='近效期成本'
) F on a.area_code=F.area_code and a.goods_code=F.goods_code and a.cus_code=F.cus_code
and a.effective=f.effective


---同比库存额，成本
left join 
( select area_code,cus_code,goods_code,sum(stock_qty) as stock_qty_ly, sum(no_Tax_cost) as no_tax_cost_ly,effective

from dm_Stock_shop_detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}

group by area_code,cus_code,goods_code,effective



) G on a.area_code=G.area_code and a.cus_code=G.cus_code and a.goods_code=G.goods_code
and a.effective=G.effective
--- 同比过效期

left join 
(select area_code,cus_code,goods_Code,no_tax_cost as gxq_cost_ly ,effective
from Dm_Stock_Shop_Detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")} and effective='过效期成本' 
) H on a.area_code=H.area_code and a.goods_code=H.goods_code and a.cus_code=H.cus_code
and a.effective=H.effective

--- 同比近效期

left join 
(select area_code,cus_code,goods_Code, no_tax_cost as jxq_cost_Ly ,effective
from Dm_Stock_Shop_Detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}

 and effective='近效期成本'
) I on a.area_code=I.area_code and a.goods_code=I.goods_code and a.cus_code=I.cus_code
and a.effective=I.effective

---环比库存额，成本
left join 
( select area_code,cus_code,goods_code,sum(stock_qty) as stock_qty_lm, sum(no_Tax_cost) as no_tax_cost_lm,effective

from dm_Stock_shop_detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}

group by area_code,cus_code,goods_code,effective



) J on a.area_code=j.area_code and a.cus_code=j.cus_code and a.goods_code=j.goods_code
and a.effective=J.effective

--- 环比过效期

left join 
(select area_code,cus_code,goods_Code, no_tax_cost as gxq_cost_lm ,effective
from Dm_Stock_Shop_Detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")} and effective='过效期成本' 
) k on a.area_code=k.area_code and a.goods_code=k.goods_code and a.cus_code=k.cus_code
and a.effective=k.effective

--- 环比近效期

left join 
(select area_code,cus_code,goods_Code, no_tax_cost as jxq_cost_lm ,effective
from Dm_Stock_Shop_Detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}

 and effective='近效期成本'
) l on a.area_code=l.area_code and a.goods_code=l.goods_code and a.cus_code=l.cus_code
and a.effective=l.effective

inner join dim_disable_code M on a.goods_code=m.disable_code
inner join dim_goods C on M.goods_code=c.goods_code
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
AND 1=1 ${if(len(goods)=0,""," and m.goods_code in ('"+goods+"')")}

group by a.area_code,a.cus_code,B.CUS_NAME,b.attribute,m.goods_code,c.goods_name,c.specification,c.manufacturer,gather,dtp

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL

select area_name,area_code from dim_region

select cus_code,cus_name from DIM_CUS
where 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

select distinct b.goods_code,b.goods_code||'|'||c.goods_name goods_name
from dm_stock_shop_detail A left join dim_disable_code B on a.goods_code=b.disable_code
left join dim_goods C on B.goods_code=c.goods_Code
where 
ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
--and rownum<5000
order by 1

SELECT  DISTINCT  
AREA_CODE,
AREA_NAME 
FROM 
DIM_REGION
WHERE  
1=1
${if(len(area)=0,"", "AND AREA_CODE IN ('"+area+"')")}

SELECT  DISTINCT  
CUS_CODE,
CUS_NAME 
FROM 
DM_DTP
WHERE  
1=1
${if(len(area)=0,"", "AND AREA_CODE IN ('"+area+"')")}

${if(len(cus)=0,"", "AND CUS_CODE IN ('"+cus+"')")}

select sum(STOCK_QTY) from (
select a.area_code,a.cus_code,B.CUS_NAME,b.attribute,m.goods_code,gather,dtp,
sum(d.stock_qty) as stock_qty

from dm_Stock_shop_detail A inner join dim_cus B on a.cus_code=b.cus_Code AND A.AREA_CODE=B.AREA_CODE  
---当期库存额，成本
left join 
( select area_code,cus_code,goods_code,effective,sum(stock_qty) as stock_qty, sum(no_Tax_cost) as no_tax_cost

from dm_Stock_shop_detail
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
group by area_code,cus_code,goods_code,effective



) D on a.area_code=d.area_code and a.cus_code=d.cus_code and a.goods_code=d.goods_code
and a.effective=d.effective



left join dim_disable_code M on a.goods_code=m.disable_code

where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
AND 1=1 ${if(len(goods)=0,""," and m.goods_code in ('"+goods+"')")}

group by a.area_code,a.cus_code,B.CUS_NAME,b.attribute,m.goods_code,gather,dtp)

