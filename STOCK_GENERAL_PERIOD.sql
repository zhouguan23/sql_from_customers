select 
area_code,
period,
sum(stock_qty),
sum(no_tax_cost)


from
(
Select a.area_code,E.goods_code,ddate,(Case when effective_period < ddate then '过效期' 
when effective_period < add_months(ddate,6) and ddate<= effective_period then '近效期' end) as period,

(case when new_attribute is null then '地采' else new_attribute end) as attribute,(case when D.goods_code is not null then '是' else '否' end) as dtp,sum(stock_qty) as stock_qty,
sum(no_tax_cost)  as no_tax_cost from fact_stock_general A left join
dim_goods B on a.goods_code=b.goods_code left join dim_net_catalogue_general_all C on a.area_code=c.area_code and a.goods_code=c.goods_code 
and c.create_month=to_char(ddate,'yyyy-mm') left join DIM_DTP D on a.area_code=d.area_code and a.goods_code=d.goods_code
 and d.create_month=to_char(add_months(ddate,-1),'yyyy-mm') 

left join DIM_DISABLE_CODE E on A.goods_code = E.disable_code

 
 
 where (effective_period <= ddate) or (effective_period <= add_months(ddate,6) and ddate<= effective_period)
 
 group by a.area_code,new_attribute,(case when D.goods_code is not null then '是' else '否' end) ,ddate,(Case when effective_period < ddate then '过效期' 
when effective_period < add_months(ddate,6) and ddate<= effective_period then '近效期' end),E.goods_code)

where ddate=add_months(to_date('${Date}'||'-01','yyyy/mm/dd)'),1)-1
 and period in('过效期','近效期')
and 
1=1 ${if(len(area)=0,"","and area_code in ('"+area+"')")} and
1=1 ${if(len(goods)=0,"","and goods_code in ('"+goods+"')")} and 
1=1 ${if(len(period)=0,"","and period in ('"+period+"')")}  and 
1=1 ${if(len(dtp)=0,"","and dtp in ('"+dtp+"')")}  and 
1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")} 


  group by area_code,period
  --,goods_code
  order by area_code,period

select distinct c.goods_code,C.goods_code||'|'||b.goods_name goods_name from fact_stock_general a LEFT JOIN DIM_GOODS B ON A.GOODS_CODE =B.GOODS_CODE left join dim_disable_code C on a.goods_code=c.disable_code

where ddate=add_months(to_date('${Date}'||'-01','yyyy/mm/dd)'),1)-1

and ((effective_period < ddate) or (effective_period <= add_months(ddate,6) and ddate<= effective_period) )
 
and 
1=1 ${if(len(area)=0,"","and area_code in ('"+area+"')")}
and rownum<5000
order by 1

select area_code,area_name from dim_region

select distinct new_attribute from dim_net_catalogue_general_all
UNION
SELECT '地采' from dual

