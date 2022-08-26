select nvl(t1.area_code,t2.area_code) area_code,nvl(t1.area_name,t2.area_name) area_name,nvl(t1.stock_qty,0) dc_qty,nvl(t2.stock_qty,0) md_qty from 
(select r.area_code,r.area_name,sum(a.stock_qty) stock_qty from dm_stock_general_day a
left join dim_region r
on a.area_code=r.area_code
left join dim_goods_mapping m
on a.goods_code=m.area_goods_code
and a.area_code=m.area_code
left join dim_goods g
on a.goods_code=g.goods_code
left join dim_goods g1
on m.goods_code=g1.goods_code

where (g.goods_name like '%口罩%'
or g1.goods_name like '%口罩%')

group by r.area_code,r.area_name) t1
full join (select r.area_code,r.area_name,sum(a.stock_qty) stock_qty from dm_stock_shop_day a
left join dim_region r
on a.area_code=r.area_code
left join dim_goods_mapping m
on a.goods_code=m.area_goods_code
and a.area_code=m.area_code
left join dim_goods g
on a.goods_code=g.goods_code
left join dim_goods g1
on m.goods_code=g1.goods_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where (g.goods_name like '%口罩%'
or g1.goods_name like '%口罩%')
and  c.attribute='直营'
group by r.area_code,r.area_name) t2
on t1.area_code=t2.area_code
where 1=1
${if(len(area)=0,""," and nvl(t1.area_code,t2.area_code) in ('"+area+"')")}
order by 1

select * from dim_region
order by area_code

