select a.area_code,m.goods_code,c.goods_name,c.specification,c.manufacturer,gather,dtp,
sum(d.stock_qty) as stock_qty,sum(d.no_tax_cost) as no_tax_cost,
sum(e.gxq_cost) as gxq_cost,
sum(f.jxq_cost) as jxq_cost,
sum(g.stock_qty_ly) as stock_qty_ly,sum(g.no_tax_cost_ly) as no_tax_cost_ly,
sum(h.gxq_cost_ly) as gxq_cost_ly,
sum(i.jxq_cost_ly) as jxq_cost_ly,
sum(j.stock_qty_lm) as stock_qty_lm,sum(j.no_tax_cost_lm) as no_tax_Cost_lm,
sum(k.gxq_cost_lm) as gxq_cost_Lm,
sum(l.jxq_cost_lm) as jxq_Cost_lm

from 

(select distinct area_code,goods_code,dtp,gather,ddate from dm_stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
) A  
---当期库存额，成本


left join 
( select area_code,goods_code,sum(stock_qty) as stock_qty, sum(no_Tax_cost) as no_tax_cost

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
group by area_code,goods_code
) D on a.area_code=d.area_code and a.goods_code=d.goods_code
--- 当期过效期 


left join 
(select area_code,goods_Code, sum(no_tax_cost) as gxq_cost 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
and effective='过效期成本'
group by area_code,goods_Code
) E on a.area_code=e.area_code and a.goods_code=e.goods_code 

--- 当期近效期
left join 
(select area_code,goods_Code, sum(no_tax_cost) as jxq_cost 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")} 
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
 and effective='近效期成本'
 group by area_code,GOODS_CODE
) F on a.area_code=F.area_code and a.goods_code=F.goods_code


---同比库存额，成本
left join 
( select area_code,goods_code,sum(stock_qty) as stock_qty_ly, sum(no_Tax_cost) as no_tax_cost_ly

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}

group by area_code,goods_code



) G on a.area_code=G.area_code  and a.goods_code=G.goods_code
--- 同比过效期

left join 
(select area_code,goods_Code,sum(no_tax_cost) as gxq_cost_ly 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
 and effective='过效期成本' 
 group by area_code,Goods_code
) H on a.area_code=H.area_code and a.goods_code=H.goods_code 

--- 同比近效期

left join 
(select area_code,goods_Code, sum(no_tax_cost) as jxq_cost_Ly 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
 and effective='近效期成本'
 AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
 group by area_code,GOODS_CODE
) I on a.area_code=I.area_code and a.goods_code=I.goods_code

---环比库存额，成本
left join 
( select area_code,goods_code,sum(stock_qty) as stock_qty_lm, sum(no_Tax_cost) as no_tax_cost_lm

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}


group by area_code,goods_code



) J on a.area_code=j.area_code and a.goods_code=j.goods_code

--- 环比过效期

left join 
(select area_code,goods_Code, sum(no_tax_cost) as gxq_cost_lm 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
 and effective='过效期成本' 
 group by area_code,GOODS_CODE
) k on a.area_code=k.area_code and a.goods_code=k.goods_code

--- 环比近效期

left join 
(select area_code,goods_Code, sum(no_tax_cost) as jxq_cost_lm 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
AND 1=1 ${if(len(attribute)=0,""," and attribute in ('"+attribute+"')")}
 and effective='近效期成本'
 group by area_code,goods_code
) l on a.area_code=l.area_code and a.goods_code=l.goods_code
 
inner join dim_disable_code M on a.goods_code=m.disable_code

inner join dim_goods C on M.goods_code=c.goods_code

where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
AND 1=1 ${if(len(goods)=0,""," and m.goods_code in ('"+goods+"')")}


GROUP BY a.area_code,M.goods_code,c.goods_name,c.specification,c.manufacturer,gather,dtp

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL
union
select '地采' as new_attribute from dual

select area_name,area_code from dim_region

select distinct c.goods_code,c.goods_code||'|'||c.goods_name as goods_name
from   Dm_Stock_Shop_goods a left join dim_disable_code b on a.goods_code=b.disable_code
inner join dim_goods c
on b.goods_code=c.goods_code
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
order by 1

select a.area_code,
sum(d.stock_qty) as stock_qty,sum(d.no_tax_cost) as no_tax_cost,
sum(e.gxq_cost) as gxq_cost,
sum(f.jxq_cost) as jxq_cost,
sum(g.stock_qty_ly) as stock_qty_ly,sum(g.no_tax_cost_ly) as no_tax_cost_ly,
sum(h.gxq_cost_ly) as gxq_cost_ly,
sum(i.jxq_cost_ly) as jxq_cost_ly,
sum(j.stock_qty_lm) as stock_qty_lm,sum(j.no_tax_cost_lm) as no_tax_Cost_lm,
sum(k.gxq_cost_lm) as gxq_cost_Lm,
sum(l.jxq_cost_lm) as jxq_Cost_lm

from (select distinct area_code,goods_code,dtp,gather,ddate from dm_stock_shop_goods

) A  left join dim_goods C on a.goods_code=c.goods_code
---当期库存额，成本
left join 
( select area_code,goods_code,sum(stock_qty) as stock_qty, sum(no_Tax_cost) as no_tax_cost

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

group by area_code,goods_code



) D on a.area_code=d.area_code and a.goods_code=d.goods_code
--- 当期过效期 
left join 
(select area_code,goods_Code, no_tax_cost as gxq_cost 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

and effective='过效期成本'
) E on a.area_code=e.area_code and a.goods_code=e.goods_code 

--- 当期近效期
left join 
(select area_code,goods_Code, no_tax_cost as jxq_cost 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")} 

 and effective='近效期成本'
) F on a.area_code=F.area_code and a.goods_code=F.goods_code


---同比库存额，成本
left join 
( select area_code,goods_code,sum(stock_qty) as stock_qty_ly, sum(no_Tax_cost) as no_tax_cost_ly

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}



group by area_code,goods_code



) G on a.area_code=G.area_code  and a.goods_code=G.goods_code
--- 同比过效期

left join 
(select area_code,goods_Code,no_tax_cost as gxq_cost_ly 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

 and effective='过效期成本' 
) H on a.area_code=H.area_code and a.goods_code=H.goods_code 

--- 同比近效期

left join 
(select area_code,goods_Code, no_tax_cost as jxq_cost_Ly 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-11)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
 and effective='近效期成本'
) I on a.area_code=I.area_code and a.goods_code=I.goods_code

---环比库存额，成本
left join 
( select area_code,goods_code,sum(stock_qty) as stock_qty_lm, sum(no_Tax_cost) as no_tax_cost_lm

from dm_Stock_shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}



group by area_code,goods_code



) J on a.area_code=j.area_code and a.goods_code=j.goods_code

--- 环比过效期

left join 
(select area_code,goods_Code, no_tax_cost as gxq_cost_lm 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

 and effective='过效期成本' 
) k on a.area_code=k.area_code and a.goods_code=k.goods_code

--- 环比近效期

left join 
(select area_code,goods_Code, no_tax_cost as jxq_cost_lm 
from Dm_Stock_Shop_goods
where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),0)-1
AND 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}

 and effective='近效期成本'
) l on a.area_code=l.area_code and a.goods_code=l.goods_code 
left join dim_disable_code M on a.goods_code=m.disable_code

where ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
AND 1=1 ${if(len(goods)=0,""," and m.goods_code in ('"+goods+"')")}


GROUP BY a.area_code

