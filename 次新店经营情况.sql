SELECT DISTINCT AREA_CODE,AREA_NAME,UNION_AREA_NAME
FROM 
DIM_REGION
WHERE 
1=1
and area_code<>'00'
order by AREA_CODE asc

select b.area_code,count(distinct b.cus_name) CUS_NUM　from DM_SHOP a 
join dim_cus b
on a.cus_code=b.cus_code and a.area_code=b.area_code where time  in ('次新店') and dImension=substr('${month}',1,4)
group by b.area_code
order by 2 desc 

select NVL(a.area_code,-99) area_code,
       SUM(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
       SUM(NO_TAX_COST) NO_TAX_COST,
       SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0) NO_TAX_PROFIT,
       (SUM(NO_TAX_AMOUNT) - nvl(SUM(NO_TAX_COST), 0)) /
       nullif(SUM(NO_TAX_AMOUNT), 0) no_tax_profit_percent,
       sum(case when c.attribute='直营' and a.oto='否'and a.dtp='否' then NO_TAX_AMOUNT else 0 end ) zy_amount
  from DM_SALE_TMP a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and a.cus_code = b.cus_code
   left join dim_cus c
   on a.area_code=c.area_code
   and a.cus_code=c.cus_code
 where sale_date >= trunc(DATE'${month}-01', 'yyyy')
   and b.time = '次新店'
   and b.dImension = to_char(DATE'${month}-01','yyyy')
 group by ROLLUP(a.area_code)

select r.area_code,count(distinct c.cus_code) GAINS_CUS_NUM from (
select A.CUS_CODE,a.area_code from DM_SALE_TMP a
left join DM_SHOP b
on a.cus_code=b.cus_code 
where  dImension=to_char(DATE'${month}-01','yyyy') AND time = '次新店'
AND A.SAle_DATE>= trunc(DATE'${month}-01', 'yyyy')
group by  A.CUS_CODE,a.area_code
having SUM(NO_TAX_AMOUNT)-nvl(SUM(NO_TAX_COST),0)>0 ) c
 join dim_Cus r
on c.CUS_CODE=r.cus_code and c.area_code=r.area_code
group by r.area_code

select * from fact_sale_index where create_month=SUBSTR('${month}',1，4)

select  nvl(a.area_code,'-99') area_code,
       SUM(NO_TAX_AMOUNT)/
       nullif(count(distinct c.cus_name),0) averge_amount
  from DM_SALE_TMP a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and a.cus_code = b.cus_code
   left join dim_cus c
   on a.area_code=c.area_code
   and a.cus_code=c.cus_code
 where sale_date >= date'${month}-01'
 and sale_date<add_months(trunc(date'${month}-01','mm'),1)
   and b.time = '次新店'
   and b.dImension = to_char(DATE'${month}-01','YYYY')
 group by   ROLLUP(a.area_code)
 


