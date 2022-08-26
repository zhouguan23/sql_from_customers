select a.area_code,
       a.cus_code,
       b.cus_name,
       year ,
       month,
       total_revenue_main_business,
       total_cost_main_business,
       gross_profit,
       rebate,
       total_gp_main_business,
       gir_main_business,
       employee_remuneration,
       depreciation_charge,
       rental_fee,
       property_fee,
       long_term_expenses,
       logistics_cost,
       water_electricity_charges,
       communication_fee,
       promotion_fee,
       office_supplies,
       repair_cost,
       other,
       subtotal_of_expenses,
       operating_profit
  from fact_store_import a,dim_cus b
 where 1 = 1
 and a.area_code=b.area_code(+)
 and a.cus_code=b.cus_code(+)
 ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and year || trim(to_char(month, '00')) = '${month}'
   order by 1,2

select area_code,area_name from dim_region 

