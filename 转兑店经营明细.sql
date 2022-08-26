
select  r.union_area_name,
       a.area_code,
       r.area_name,
       r.sorted,
       a.cus_code,
       c.cus_name,
       t.transfer_type,
       t.transfer_year,
       sum(NO_tax_amount) no_tax_amount,
        nvl(sum(NO_tax_amount),0)-nvl(sum(NO_tax_cost),0) no_tax_profit,
     count(distinct sale_date) sale_day,
     count(distinct to_char(sale_date,'yyyymm')) sale_month
  from dm_sale_tmp a
  left join dim_region r
    on a.area_code = r.area_code
  left join dim_cus c
    on a.area_code = c.area_code
   and a.cus_code = c.cus_code
  join dim_cus_transfer t
  on a.area_code=t.area_code
  and a.cus_code=t.cus_code,(select * from USER_AUTHORITY) u
  
 where  (r.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}
 
 and 
   sale_date between to_date('${start_date}','YYYY-MM')
and to_date('${end_date}','YYYY-MM')
and 1=1 ${if(len(UNION_AREA)=0,"","and r.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(AREA)=0,"","and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(cus)=0,"","and a.cus_code in ('"+cus+"')")}
and  t.transfer_year='${transfer_year}'
group by r.union_area_name,
       a.area_code,
       r.area_name,
       r.sorted,
       a.cus_code,
       c.cus_name,
       t.transfer_type,
       t.transfer_year
       order by sorted,a.cus_code

select a.area_code,a.cus_code,sum(operating_profit) operating_profit,sum(employee_remuneration) employee_remuneration,sum(rental_fee) rental_fee,sum(subtotal_of_expenses) subtotal_of_expenses from fact_store_import a,dim_cus_transfer c
where a.area_code=c.area_code
and a.cus_code=c.cus_code

and a.year ||'-'|| trim(to_char(a.month, '00')) between '${start_date}' and '${end_date}'

group by a.cus_code,a.area_code

  select area_code,
           cus_code,
           investment_cost_recovery,
           case
             when months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1<=12 then
              sum(sales_target_first)/12*months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1
             when months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1 between 13 and 24 then
              sum(sales_target_first)+ sum(sales_target_second)/12*(months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))-11)
             when months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1 >24 then
              sum(sales_target_first)+sum(sales_target_second)+sum(sales_target_third)/12*(months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))-23)
           end sales_traget,
           case
             when months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1<=12 then
              sum(profit_forecast_first)/12*months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1
             when months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1 between 13 and 24 then
              sum(profit_forecast_first)+ sum(profit_forecast_second)/12*(months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))-11)
             when months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))+1 >24 then
              sum(profit_forecast_first)+sum(profit_forecast_second)+sum(profit_forecast_third)/12*(months_between(to_date('${end_date}','yyyy-mm'),to_date(open_date,'yyyy-mm'))-23)
           end  profit_forecast
      from dim_cus_transfer t
      where   t.transfer_year='${transfer_year}'
     group by area_code, cus_code, open_date,investment_cost_recovery

    select area_code,cus_code ,months_between(to_date(min(sale_month),'yyyy-mm'),to_date(min(open_date),'yyyy-mm'))+1 diffmonth from (
     select area_code,cus_code,sale_month,tax_investment_amount,open_date,sum(tax_amount) over (partition  by area_code,cus_code order by sale_month) finish_amount from (
          select  a.area_code,a.cus_code,to_char(sale_date,'yyyy-mm') sale_month,open_date,t.tax_investment_amount,sum(tax_amount) tax_amount from dm_sale_tmp a,dim_cus_transfer t
          where a.area_code=t.area_code
          and a.cus_code=t.cus_code
          and to_char(a.sale_date,'yyyy-mm')>=open_date
          group by  a.area_code,a.cus_code,to_char(sale_date,'yyyy-mm'),t.tax_investment_amount,open_date
        )
       ) where finish_amount>=tax_investment_amount
        group by area_code,cus_code
         

select distinct transfer_year from dim_cus_transfer

