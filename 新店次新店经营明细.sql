
select r.union_area_name,
       a.area_code,
       r.area_name,
       a.cus_code,
       c.cus_name,
       r.sorted,
       c.open_date,
       c.close_date,
       nvl(c.shop_area,0) shop_area,
       c.health_care,
      
       sum(no_tax_amount) no_tax_amount,
       count(distinct sale_date) day_cnt,
       nvl(sum(NO_tax_amount),0)-nvl(sum(NO_tax_cost),0) no_tax_profit
    
    
  from dm_sale_tmp a
  left join dim_region r
    on a.area_code = r.area_code
  left join dim_cus c
    on a.area_code = c.area_code
   and a.cus_code = c.cus_code
  
  left join dm_shop ds
    on a.area_code = ds.area_code
   and a.cus_code =ds.cus_code
   left join age_store s
   on a.area_code=s.area_code
   and a.cus_code=s.cus_code 
   and to_char(a.sale_date,'YYYY-MM')=s.date1,(select * from USER_AUTHORITY) u
  
 where c.attribute = '直营'
 and (r.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
   and ds.time in ('新店', '次新店')
   and ds.dimension=substr('${end_date}',1,4)
 and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(UNION_AREA)=0,"","and r.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(AREA)=0,"","and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(cus)=0,"","and a.cus_code in ('"+cus+"')")}
and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
and 1=1 ${if(close='是', "", " and c.close_date is null  ")}
group by r.union_area_name,
       a.area_Code,
       r.area_name,
       a.cus_code,
       c.cus_name,
       c.open_date,
       r.sorted,
       nvl(c.shop_area,0),
       c.close_date,
       c.health_care
       order by sorted,a.cus_code

select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
--${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
${if(len(AREA)=0,""," and a.area_code in ('" + SUBSTITUTE(AREA,",","','") + "')")}
--1=1 ${if(len(ORG_CODE) == 0,"","and  org_code in ('" + SUBSTITUTE(ORG_CODE,",","','") + "')")}
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1,2

select a.area_code,a.cus_code,sum(operating_profit) operating_profit,sum(employee_remuneration) employee_remuneration,sum(rental_fee) rental_fee,sum(subtotal_of_expenses) subtotal_of_expenses from fact_store_import a,dim_cus c
where a.area_code=c.area_code
and a.cus_code=c.cus_code
and c.attribute='直营'
and a.year ||'-'|| trim(to_char(a.month, '00')) between to_char(date'${start_date}','yyyy-mm') and to_char(date'${end_date}','yyyy-mm')
and 1=1 ${if(len(age)=0, "", " and s.age_store in ('" + age + "')")}
group by a.cus_code,a.area_code

select a.area_code,a.cus_code,count(distinct a.goods_code) sku from fact_sale a
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and c.attribute='直营'
group by a.area_code,a.cus_code

select area_code,cus_code ,count(distinct goods_code) total_sku from (
select a.area_code,a.cus_code,a.goods_code from fact_sale a
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and c.attribute='直营'
union all
select a.area_code,a.cus_code,a.goods_code from fact_stock_shop a
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where a.ddate=trunc(date'${end_date}','mm')-1
and c.attribute='直营'
)
group by area_code,cus_code

select a.area_code,a.cus_code,sum(NO_tax_amount) yibao from dm_goods_sale_payment a
left join dim_marketing_all m 
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and m.marketing_name like '%医保%'
and c.attribute='直营'
group by a.area_code,a.cus_code



select area_code,cus_code,min(ddate) mindate,months_between(min(ddate),trunc(open_date,'mm')) ylzq from (
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
   left join dm_shop ds
    on a.area_code = ds.area_code
   and a.cus_code =ds.cus_code
 where operating_profit>0
 and c.attribute='直营'
-- and a.area_code='22'
 and ds.time in ('新店','次新店')
 and ds.dimension=substr('${end_date}',1,4)
 and to_date(year || '-' || trim(to_char(month, '00')) || '-01','yyyy-mm-dd')>=c.open_date
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
   left join dm_shop ds
    on a.area_code = ds.area_code
   and a.cus_code =ds.cus_code
 where operating_profit>0
 and c.attribute='直营'
-- and a.area_code='22'
 and ds.time in ('新店','次新店')
 and ds.dimension=substr('${end_date}',1,4)
 and to_date(year || '-' || trim(to_char(month, '00')) || '-01','yyyy-mm-dd')>=c.open_date
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
where age_store like '%直营%'

