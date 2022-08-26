--当期销售
select g.goods_code,g.goods_name,g.specification,g.manufacturer,g.bar_code,g.category,g.sub_category,
g.LEGAL_ATTRIBUTE,
(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
left join dim_goods g
on a.goods_code=g.goods_code, (select * from USER_AUTHORITY) u
where 
m.large_cate<>'移动支付'
and (b.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")} 
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1
${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
and 1=1
${if(len(manufacturer)=0, "", " and g.manufacturer in ('" + manufacturer + "')")}
and 1=1 ${if(len(large)=0, "", " and M.large_cate in ('" + large + "')")}
and 1=1 ${if(len(small)=0, "", " and M.small_cate in ('" + small + "')")}
group by g.goods_code,g.goods_name,g.specification,g.manufacturer,g.bar_code,g.category,g.sub_category,g.LEGAL_ATTRIBUTE
order by 11 desc 

--当期销售
select g.goods_code,g.goods_name,g.specification,g.manufacturer,g.bar_code,g.category,g.sub_category,
g.LEGAL_ATTRIBUTE,
(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
left join dim_goods g
on a.goods_code=g.goods_code, (select * from USER_AUTHORITY) u
where 
m.large_cate<>'移动支付'
and (b.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")} 
and a.sale_date >=add_months(date '${start_date}',-12)
 and a.sale_date <=add_months(date '${end_date}',-12)
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1
${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
and 1=1
${if(len(manufacturer)=0, "", " and g.manufacturer in ('" + manufacturer + "')")}
and 1=1 ${if(len(large)=0, "", " and M.large_cate in ('" + large + "')")}
and 1=1 ${if(len(small)=0, "", " and M.small_cate in ('" + small + "')")}
group by g.goods_code,g.goods_name,g.specification,g.manufacturer,g.bar_code,g.category,g.sub_category,g.LEGAL_ATTRIBUTE
order by g.goods_code

--当期销售
select g.goods_code,g.goods_name,g.specification,g.manufacturer,g.bar_code,g.category,g.sub_category,
g.LEGAL_ATTRIBUTE,
(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
left join dim_goods g
on a.goods_code=g.goods_code, (select * from USER_AUTHORITY) u
where 
m.large_cate<>'移动支付'
and (b.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")} 
and  a.sale_date between to_date('${start_date2}', 'yyyy-mm-dd') and
to_date('${end_date2}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1
${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
and 1=1
${if(len(manufacturer)=0, "", " and g.manufacturer in ('" + manufacturer + "')")}
and 1=1 ${if(len(large)=0, "", " and M.large_cate in ('" + large + "')")}
and 1=1 ${if(len(small)=0, "", " and M.small_cate in ('" + small + "')")}
group by g.goods_code,g.goods_name,g.specification,g.manufacturer,g.bar_code,g.category,g.sub_category,g.LEGAL_ATTRIBUTE
order by g.goods_code

select distinct union_area_name,area_name,area_code,trans_party_relation 
from dim_region
where 1=1 
${if(len(area)=0, "", " and area_code in ('"+area+"')")}
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code

select distinct large_cate,small_cate from dim_marketing_all 
where large_cate<>'移动支付'

select distinct manufacturer from dim_goods


