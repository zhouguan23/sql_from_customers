--当期销售
select b.sorted,b.union_area_name,a.area_code,b.area_name,a.marketing_code,m.marketing_name,m.small_cate,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量,
sum(tran_num) 销售单数

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
, (select * from USER_AUTHORITY) u
where  
--a.is_b2c='Y' 
m.large_cate='商保卡业务'

and (b.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
and 
1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}

and 1=1 ${if(len(marketing)=0, "", " and m.marketing_name in ('" + marketing + "')")}

and 1=1 ${if(len(small)=0, "", " and m.small_cate in ('" + small + "')")}
group by b.sorted,b.union_area_name,a.area_code,b.area_name,a.marketing_code,m.marketing_name,m.small_cate
order by b.sorted

--当期销售
select a.area_code,b.area_name,a.marketing_code,m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量,
sum(tran_num) 销售单数

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
where  
m.large_cate='商保卡业务'
and 
1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and   a.sale_date >=add_months(date '${start_date}',-12)
 and a.sale_date <=add_months(date '${end_date}',-12)
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}

and 1=1 ${if(len(marketing)=0, "", " and m.marketing_name in ('" + marketing + "')")}

and 1=1 ${if(len(small)=0, "", " and m.small_cate in ('" + small + "')")}
group by a.area_code,b.area_name,a.marketing_code,m.marketing_name
order by a.area_code,a.marketing_code

--当期销售
select a.area_code,b.area_name,a.marketing_code,m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量,
sum(tran_num) 销售单数

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
where  
m.large_cate='商保卡业务'
and 
1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date2}', 'yyyy-mm-dd') and
to_date('${end_date2}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}

and 1=1 ${if(len(marketing)=0, "", " and m.marketing_name in ('" + marketing + "')")}

and 1=1 ${if(len(small)=0, "", " and m.small_cate in ('" + small + "')")}
group by a.area_code,b.area_name,a.marketing_code,m.marketing_name
order by a.area_code,a.marketing_code

select a.area_code,a.area_name,a.UNION_AREA_NAME,a.sorted from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 
order by sorted

select distinct marketing_name,small_cate from 
(
select distinct area_code,marketing_code,marketing_name,large_cate,small_cate from dim_marketing_all
union all
select distinct '16',marketing_code,marketing_name ,large_cate,small_cate from dim_marketing_all 
where area_code='15')
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and large_cate='商保卡业务'


