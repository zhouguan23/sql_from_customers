SELECT DISTINCT AREA_CODE,AREA_NAME,UNION_AREA_NAME
FROM 
DIM_REGION
WHERE 
1=1
and area_code<>'00'
order by AREA_CODE asc

select nvl(area_code,-99) area_code, count(distinct case when time not in ('新店','次新店') then cus_code end )/count(distinct cus_code) percent from DM_SHOP 
where dImension='${year}'
group by rollup(area_code)


select a.area_code,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and a.cus_code = b.cus_code
   left join dim_cus c
   on a.area_code=c.area_code
   and a.cus_code=c.cus_code
 where sale_date >= DATE'${YEAR}-01-01'
 and sale_date<trunc(sysdate)
   and b.time not in ( '次新店','新店')
   and b.dImension = to_char(sysdate-1,'YYYY')
   and c.attribute='直营' 
   and a.oto='否'
   and a.dtp='否'
 group by a.area_code

select a.area_code,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent
      
  from DM_SALE_TMP a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and a.cus_code = b.cus_code
   left join dim_cus c
   on a.area_code=c.area_code
   and a.cus_code=c.cus_code
 where sale_date >= ADD_MONThS(date'${YEAR}-01-01',-12)
 and sale_date<trunc(add_months(sysdate,-12))
   and b.time not in ( '次新店','新店')
   and b.dImension = to_char(sysdate-1,'YYYY')
   and c.attribute='直营' 
   and a.oto='否'
   and a.dtp='否'
 group by a.area_code

SELECT distinct extract(year from ddate) year from dim_day
where extract(year from ddate)<=extract(year from sysdate)
order by 1 desc 

