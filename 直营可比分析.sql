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
 where sale_date>=date'${start}'
 and sale_date<date'${end}'+1
   and b.time not in ('新店','次新店')  
   and b.dImension = substr('${start}',1,4)
   and c.attribute='直营' 
   and a.oto='否'
   and a.dtp='否'
   and 1=1 ${if(len(region)=0,"","and a.area_code in ('"+region+"')")}
 group by a.area_code
 order by 1

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
 where  sale_date>=add_months(date'${start}',-12)
 and sale_date<add_months(date'${end}'+1,-12)
   and b.time not in ('新店','次新店')  
   and b.dImension = substr('${start}',1,4)-1
   and c.attribute='直营' 
   and a.oto='否'
   and a.dtp='否'
     and 1=1 ${if(len(region)=0,"","and a.area_code in ('"+region+"')")}
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
 where sale_date>=date'${start}'
 and sale_date<date'${end}'
   and b.time not in ('新店','次新店')  
   and b.dImension = substr('${start}',1,4)
   and c.attribute='直营' 
  -- and a.oto='否'
  -- and a.dtp='否'
    and 1=1 ${if(len(region)=0,"","and a.area_code in ('"+region+"')")}
 group by a.area_code

select a.area_code,sum(tran_num) tran_num from dm_transaction a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and to_char(a.cus_code) = b.cus_code
   left join dim_cus c
   on a.area_code=c.area_code
   and to_char(a.cus_code)=c.cus_code
  where sale_date>=date'${start}'
 and sale_date<date'${end}'+1
   and b.time not in ('新店','次新店') 
   and b.dImension =  substr('${start}',1,4)
   and c.attribute='直营' 
    and 1=1 ${if(len(region)=0,"","and a.area_code in ('"+region+"')")}
group by  a.area_code

select a.area_code,sum(tran_num) tran_num from dm_transaction a
  left join DM_SHOP b
    on a.area_code = b.area_code
   and to_char(a.cus_code) = b.cus_code
   left join dim_cus c
   on a.area_code=c.area_code
   and to_char(a.cus_code)=c.cus_code
  where sale_date>=add_months(date'${start}',-12)
 and sale_date<add_months(date'${end}'+1,-12)
   and b.time not in ('新店','次新店')  
   and b.dImension = substr('${start}',1,4)-1
   and c.attribute='直营' 
    and 1=1 ${if(len(region)=0,"","and a.area_code in ('"+region+"')")}
group by  a.area_code

select * from dim_region where 1=1
order by 2

select distinct area_code,sum(shop_area) shop_area,sum(employee_number) employee_number from dim_cus
where    1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
group by area_code


