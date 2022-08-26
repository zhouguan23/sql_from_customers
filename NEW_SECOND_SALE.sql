select --r.union_area_name,
       a.area_code,
       sum(no_tax_amount) no_tax_amount,
       --sum(nvl(c.shop_area,0)) shop_area,
       --count(distinct sale_date) day_cnt,
       nvl(sum(NO_tax_amount),0)-nvl(sum(NO_tax_cost),0) no_tax_profit
    
    
  from dm_sale_tmp a
  left join dim_region r
    on a.area_code = r.area_code
  left join dim_cus c
    on a.area_code = c.area_code
   and a.cus_code = c.cus_code
  

   left join age_store s
   on a.area_code=s.area_code
   and a.cus_code=s.cus_code 
   and to_char(a.sale_date,'YYYY-MM')=s.date1
   --,(select * from USER_AUTHORITY) u
  
 where c.attribute = '直营'
 --and (r.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
  --and ${"u.user_id='"+$fr_username+"'"}
   and s.age_store in ('直营新','直营次新')
 and a.sale_date between to_date('${start_date}', 'yyyy-mm') and
add_months(to_date('${end_date}','yyyy-mm'),1)-1
and 1=1 ${if(len(UNION_AREA)=0,"","and r.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(AREA)=0,"","and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(cus)=0,"","and a.cus_code in ('"+cus+"')")}
and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
group by --r.union_area_name,
       a.area_Code

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
--${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
${if(len(AREA)=0,""," and a.area_code in ('" + SUBSTITUTE(AREA,",","','") + "')")}
--1=1 ${if(len(ORG_CODE) == 0,"","and  org_code in ('" + SUBSTITUTE(ORG_CODE,",","','") + "')")}
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1,2

select a.area_code,sum(operating_profit) operating_profit,sum(employee_remuneration) employee_remuneration,sum(rental_fee) rental_fee,sum(subtotal_of_expenses) subtotal_of_expenses from fact_store_import a,dim_cus c,age_store ag
where a.area_code=c.area_code
and a.cus_code=c.cus_code
and c.attribute='直营'
and c.area_code=ag.area_code
and c.cus_code=ag.cus_code
and ag.age_store in('直营新','直营次新')
--and a.year=substr('${month}', 1, 4)
--and trim(to_char(a.month,'00'))=substr('${month}', 6, 2)
and ag.date1=a.year||'-'||trim(to_char(a.month,'00'))
and a.year ||'-'|| trim(to_char(a.month, '00')) between '${start_date}' and '${end_date}'
and 1=1 ${if(len(age)=0, "", " and ag.age_store in ('" + age + "')")}
group by a.area_code

select area_code,sum(total_sku) total_sku from
(
select area_code,cus_code ,count(distinct goods_code) total_sku from (
select a.area_code,a.cus_code,a.goods_code from fact_sale a
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
join age_store ag
on a.area_code=ag.area_code
and a.cus_code=ag.cus_code
and c.attribute='直营'
and ag.age_store in('直营新','直营次新')
and to_char(a.sale_date,'yyyy-mm')=ag.date1
where 
    --a.sale_date between to_date('2020-07', 'yyyy-mm') and to_date('2020-07', 'yyyy-mm')
    --and a.AREA_CODE=50
a.sale_date between to_date('${start_date}', 'yyyy-mm') and add_months(to_date('${end_date}','yyyy-mm'),1)-1
and 1=1 ${if(len(age)=0, "", " and ag.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
)
group by area_code,cus_code
)group by area_code

select area_code,sum(total_sku) total_sku from
(
select area_code,cus_code ,count(distinct goods_code) total_sku from (
select a.area_code,a.cus_code,a.goods_code from fact_sale a
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
join age_store ag
on a.area_code=ag.area_code
and a.cus_code=ag.cus_code
and to_char(a.sale_date,'yyyy-mm')=ag.date1
where a.sale_date between to_date('${start_date}', 'yyyy-mm') and
add_months(to_date('${end_date}','yyyy-mm'),1)-1
and c.attribute='直营'
and ag.age_store in('直营新','直营次新')
and 1=1 ${if(len(age)=0, "", " and ag.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
union all
select a.area_code,a.cus_code,a.goods_code from fact_stock_shop a
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
join age_store ag
on a.area_code=ag.area_code
and a.cus_code=ag.cus_code
where a.ddate=last_day(to_date('${end_date}','yyyy-mm'))
and c.attribute='直营'
and ag.date1='${end_date}'
and ag.age_store in('直营新','直营次新')
and 1=1 ${if(len(age)=0, "", " and ag.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
)
group by area_code,cus_code
)group by area_code

select a.area_code,sum(NO_tax_amount) yibao from dm_goods_sale_payment a
left join dim_marketing_all m 
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
join age_store ag
on a.area_code=ag.area_code
and a.cus_code=ag.cus_code
and to_char(a.sale_date,'yyyy-mm')=ag.date1
where a.sale_date between to_date('${start_date}', 'yyyy-mm') and
add_months(to_date('${end_date}','yyyy-mm'),1)-1
and ag.age_store in('直营新','直营次新')
and m.marketing_name like '%医保%'
and c.attribute='直营'
and 1=1 ${if(len(age)=0, "", " and ag.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
group by a.area_code



select area_code,cus_code,min(ddate) mindate,months_between(min(ddate),trunc(open_date,'mm'))+1 ylzq from (
select a.area_code,a.cus_code,a.ddate,months_between(a.ddate,b.ddate) diff,a.open_date from (
select a.area_code,
       a.cus_code,
       to_date(year || '-' || trim(to_char(month, '00')) || '-01','yyyy-mm-dd') ddate,
       c.open_date,
       operating_profit,
        row_number() over (partition by a.area_code, a.cus_code order by year || '-' || trim(to_char(month, '00')) || '-01') rn
  from fact_store_import a
  left join dim_cus c
  on a.area_code=c.area_code
  and a.cus_code=c.cus_code
   
   left join age_store s
   on a.area_code=s.area_code
   and a.cus_code=s.cus_code 
   and year || '-' || trim(to_char(month, '00'))=s.date1
 where operating_profit>0
 and c.attribute='直营'
-- and a.area_code='22'
 and s.age_store in ('直营新','直营次新')
 and to_date(year || '-' || trim(to_char(month, '00')) || '-01','yyyy-mm-dd')>=trunc(c.open_date,'mm')
 and a.year is not null and a.area_code is not null ) a
 join 
 (
select a.area_code,
       a.cus_code,
       to_date(year || '-' || trim(to_char(month, '00')) || '-01','yyyy-mm-dd') ddate,
       c.open_date,
       operating_profit,
        row_number() over (partition by a.area_code, a.cus_code order by year || '-' || trim(to_char(month, '00')) || '-01') rn
  from fact_store_import a
  left join dim_cus c
  on a.area_code=c.area_code
  and a.cus_code=c.cus_code
     left join age_store s
   on a.area_code=s.area_code
   and a.cus_code=s.cus_code 
   and year || '-' || trim(to_char(month, '00'))=s.date1
 where operating_profit>0
 and c.attribute='直营'
-- and a.area_code='22'
  and s.age_store in ('直营新','直营次新')
 and to_date(year || '-' || trim(to_char(month, '00')) || '-01','yyyy-mm-dd')>=trunc(c.open_date,'mm')
 and a.year is not null and a.area_code is not null )  b
 on a.rn=b.rn+1
 and a.area_code=b.area_code
 and a.cus_code=b.cus_code
 where 
 months_between(a.ddate,b.ddate)=1
 --and a.cus_code='103132'
 )
 group by area_code,cus_code,trunc(open_date,'mm')

select distinct age_store from age_store
where age_store in ('直营新','直营次新')

select union_area_name,area_code,area_name, sum(new_open_store) new_open_store, min(sorted),sum(shop_area) shop_area from 

(

 select dr1.union_area_name,dr1.area_code,dr1.area_name, count(*) new_open_store, min(sorted) sorted,sum(nvl(dc.shop_area,0)) shop_area
   from age_store dc1, dim_region dr1, USER_AUTHORITY ua,dim_cus dc
  where dc1.age_store in( '直营新','直营次新')
       
    and dc1.area_code = dr1.area_code
    and dc1.area_code=dc.area_code
    and dc1.cus_code=dc.cus_code
    and (dr1.UNION_AREA_NAME = ua.UNION_AREA_NAME or ua.UNION_AREA_NAME = 'ALL')
    and ${"ua.user_id='"+$fr_username+"'"}
      AND dc1.date1='${end_date}'
      and 1=1 ${if(len(UNION_AREA)=0,"","and dr1.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
      and 1=1 ${if(len(AREA)=0,"","and dr1.area_code in ('"+AREA+"')")}
      and 1=1 ${if(len(age)=0, "", " and dc1.age_store in ('" + age + "')")}
    --AND dc1.date1 = '2020-07'
    --AND dr1.union_area_name = '上海零售'
  group by dr1.union_area_name,dr1.area_code,dr1.area_name
  
  union all
  
   select dr1.union_area_name,dr1.area_code,dr1.area_name, count(*) new_open_store, min(sorted) sorted,sum(nvl(dc.shop_area,0)) shop_area
   from age_store dc1, dim_region dr1, USER_AUTHORITY ua,dim_cus dc
  where dc1.age_store in( '直营（关）')
    and dc1.area_code = dr1.area_code   
    and dc1.area_code = dc.area_code
    and dc1.cus_code= dc.cus_code
    and (dr1.UNION_AREA_NAME = ua.UNION_AREA_NAME or ua.UNION_AREA_NAME = 'ALL')
    and ${"ua.user_id='"+$fr_username+"'"}
      AND dc1.date1='${end_date}'
      and 1=1 ${if(len(UNION_AREA)=0,"","and dr1.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
      and 1=1 ${if(len(AREA)=0,"","and dr1.area_code in ('"+AREA+"')")}
      --and 1=1 ${if(len(age)=0, "", " and dc1.age_store in ('" + age + "')")}
      and 1=1 ${if(close='是', "", " and 1=2  ")}
      and to_char(dc.open_date,'yyyy')>=substr('${end_date}', 1, 4)-1
      --and to_char(dc.close_date,'yyyy') between '${start_date}' and '${end_date}'
    --AND dc1.date1 = '2020-07'
    --AND dr1.union_area_name = '上海零售'
    --and to_char(dc.open_date,'yyyy')>=2019
  group by dr1.union_area_name,dr1.area_code,dr1.area_name
  
  ) group by union_area_name,area_code,area_name  order by min(sorted)

select area_code,sum(day_cnt) day_cnt from
(

select --r.union_area_name,
       a.area_code,
       a.cus_code,
       --sum(no_tax_amount) no_tax_amount,
       count(distinct sale_date) day_cnt
       --nvl(sum(NO_tax_amount),0)-nvl(sum(NO_tax_cost),0) no_tax_profit
    
    
  from dm_sale_tmp a
  left join dim_region r
    on a.area_code = r.area_code
  left join dim_cus c
    on a.area_code = c.area_code
   and a.cus_code = c.cus_code
  

   left join age_store s
   on a.area_code=s.area_code
   and a.cus_code=s.cus_code 
   and to_char(a.sale_date,'YYYY-MM')=s.date1
   --,(select * from USER_AUTHORITY) u
  
 where c.attribute = '直营'
 --and (r.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
  --and ${"u.user_id='"+$fr_username+"'"}
   and s.age_store in ('直营新','直营次新')
 and a.sale_date between to_date('${start_date}', 'yyyy-mm') and
add_months(to_date('${end_date}','yyyy-mm'),1)-1
and 1=1 ${if(len(UNION_AREA)=0,"","and r.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(AREA)=0,"","and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(cus)=0,"","and a.cus_code in ('"+cus+"')")}
and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
group by --r.union_area_name,
       a.area_Code,
       a.cus_code
       ) group by area_Code

