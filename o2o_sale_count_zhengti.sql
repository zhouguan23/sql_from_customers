
--当期销售
select m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
--sum(sale_qty) 销售数量,
count(distinct tran_no) 销售单数

from dm_sale_oto a
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
nvl(m.oto,'N')='Y' 
--1=1 ${if(len(B2C)=0, "", " and a.IS_B2C in ('" + B2C + "')")}
and  
1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1 ${if(len(large_cate)=0, "", " and m.large_cate in ('" + large_cate + "')")}
and 1=1 ${if(len(marketing)=0, "", " and m.small_cate in ('" + marketing + "')")}
group by  m.marketing_name


--同期销售
select m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
--sum(sale_qty) 销售数量,
count(distinct tran_no)  销售单数

from dm_sale_oto a
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
nvl(m.oto,'N')='Y'  
--a.is_b2c='Y' 
--1=1 ${if(len(B2C)=0, "", " and a.IS_B2C in ('" + B2C + "')")}
and 
1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and   a.sale_date >=add_months(date '${start_date}',-12)
 and a.sale_date <=add_months(date '${end_date}',-12)
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1 ${if(len(large_cate)=0, "", " and m.large_cate in ('" + large_cate + "')")}
and 1=1 ${if(len(marketing)=0, "", " and m.small_cate in ('" + marketing + "')")}
group by m.marketing_name


--对比期销售
select m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
--sum(sale_qty) 销售数量,
count(distinct tran_no)  销售单数

from dm_sale_oto a
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
nvl(m.oto,'N')='Y' 
--a.is_b2c='Y'
--1=1 ${if(len(B2C)=0, "", " and a.IS_B2C in ('" + B2C + "')")}
and 
1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date2}', 'yyyy-mm-dd') and
to_date('${end_date2}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1 ${if(len(large_cate)=0, "", " and m.large_cate in ('" + large_cate + "')")}
and 1=1 ${if(len(marketing)=0, "", " and m.small_cate in ('" + marketing + "')")}
group by m.marketing_name



select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 
order by 1,2

select distinct small_cate from dim_marketing_all
where nvl(oto,'N')='Y'

select distinct large_cate from dim_marketing_all
where nvl(oto,'N')='Y'

