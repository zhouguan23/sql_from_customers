SELECT DISTINCT AREA_CODE,AREA_NAME,UNION_AREA_NAME
FROM 
DIM_REGION
WHERE 
1=1
and area_code<>'00'
order by AREA_CODE asc

select a.area_code,
       a.cus_code,
       c.cus_name,     
      SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
      sum(no_tax_cost) no_tax_cost,
       sum(no_tax_amount) - sum(no_tax_cost) profit
  from DM_SALE_TMP a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and a.cus_code = b.cus_code
  left join dim_cus c
    on a.area_code = c.area_code
   and a.cus_code = c.cus_code
 where extract(year from a.sale_date) = '${year}'
   and b.time not in ('次新店', '新店')
   and b.dImension = '${year}'
 group by a.area_code, a.cus_code, c.cus_name


SELECT distinct extract(year from ddate) year from dim_day
where extract(year from ddate)<=extract(year from sysdate)
order by 1 desc 

