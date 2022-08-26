select b.union_area_name area_name,
       case
         when to_char(sale_date, 'DD') >= '01' and
              to_char(sale_date, 'DD') < '11' then
          '上旬'
         when to_char(sale_date, 'DD') >= '11' and
              to_char(sale_date, 'DD') < '21' then
          '中旬'
         else
          '下旬'
       end as 旬报,
       sum(no_tax_amount) as 直营常规销售,
       count(1) as 天数,
       sum(no_tax_amount) / count(1) as 日均销售额
  from dm_monthly_sale a, dim_region b
 where 
 1=1
 and to_char(sale_date， 'YYYY-MM') = '${month}'
 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 and a.area_code=b.area_code
 and a.ACCOUNTNAME = '直营常规'
 group by case
            when to_char(sale_date, 'DD') >= '01' and
                 to_char(sale_date, 'DD') < '11' then
             '上旬'
            when to_char(sale_date, 'DD') >= '11' and
                 to_char(sale_date, 'DD') < '21' then
             '中旬'
            else
             '下旬'
          end，
          b.union_area_name

select b.union_area_name area_name,
       case
         when to_char(sale_date, 'DD') >= '01' and
              to_char(sale_date, 'DD') < '11' then
          '上旬'
         when to_char(sale_date, 'DD') >= '11' and
              to_char(sale_date, 'DD') < '21' then
          '中旬'
         else
          '下旬'
       end as 旬报,
       sum(no_tax_amount) as 直营常规销售，count(1) as 天数,
       sum(no_tax_amount) / count(1) as 日均销售额
  from dm_monthly_sale a, dim_region b
 where 1=1
 and to_char(sale_date， 'YYYY-MM')=
 to_char(add_months(to_date('${month}'||'-01','YYYY-MM-DD'),-12),'YYYY-MM') 
 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 and a.area_code=b.area_code
  and a.ACCOUNTNAME = '直营常规'
 group by case
            when to_char(sale_date, 'DD') >= '01' and
                 to_char(sale_date, 'DD') < '11' then
             '上旬'
            when to_char(sale_date, 'DD') >= '11' and
                 to_char(sale_date, 'DD') < '21' then
             '中旬'
            else
             '下旬'
          end，
          b.union_area_name

select b.union_area_name area_name,
       case
         when to_char(sale_date, 'DD') >= '01' and
              to_char(sale_date, 'DD') < '11' then
          '上旬'
         when to_char(sale_date, 'DD') >= '11' and
              to_char(sale_date, 'DD') < '21' then
          '中旬'
         else
          '下旬'
       end as 旬报,
       sum(no_tax_amount) as 直营常规销售，count(1) as 天数,
       sum(no_tax_amount) / count(1) as 日均销售额
  from dm_monthly_sale a, dim_region b
 where  1=1
 and to_char(sale_date， 'YYYY-MM')=
 to_char(add_months(to_date('${month}'||'-01','YYYY-MM-DD'),-1),'YYYY-MM') 
 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 and a.area_code=b.area_code
  and a.ACCOUNTNAME = '直营常规'
 group by case
            when to_char(sale_date, 'DD') >= '01' and
                 to_char(sale_date, 'DD') < '11' then
             '上旬'
            when to_char(sale_date, 'DD') >= '11' and
                 to_char(sale_date, 'DD') < '21' then
             '中旬'
            else
             '下旬'
          end，
          b.union_area_name

SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION
order by 1

select 
count(1) as 天数
from
dim_day
where 
1=1
and
to_char(ddate，'YYYY-MM') = '${month}'

