select 
distinct
f.union_area_name AREA_NAME
from
dim_region f

select dr.union_area_name,
               count(*) sale_day_sum,
               sum(ddss.sale_amount) sale_sum,
               sum(nvl(ddss.sale_amount, 0) - nvl(ddss.sale_cost, 0)) sale_ml_sum,
               sum(ddss.dtp_sale_amount) dtp_sale,
               sum(nvl(ddss.dtp_sale_amount, 0) - nvl(ddss.dtp_sale_cost, 0)) dtp_sale_ml,
               sum(ddss.oto_sale_amount) oto_sale,
               sum(nvl(ddss.oto_sale_amount, 0) -
                   nvl(ddss.oto_sale_cost, 0)) oto_sale_ml,
               sum(nvl(ddss.sale_amount, 0) - nvl(ddss.dtp_sale_amount, 0) -
                   nvl(oto_sale_amount, 0)) cg_sale
          from dm_delivery_sale_stock ddss,   dim_region dr,
      age_store  da
         where 1=1
           and ddss.area_code = dr.area_code
           and to_char(ddss.date1,'YYYY-MM') BETWEEN '${month}' and '${month1}'
           --and to_char(ddss.date1,'YYYY-MM') BETWEEN '2020-05' and '2020-06'
      and ddss.area_code=da.area_code and ddss.cus_code=da.cus_code
      and to_char(ddss.date1,'YYYY-MM')=da.date1
      and da.age_store='直营新'
      and ddss.sale_amount is not null
      --and da.date1 ='2020-06'
      --and dr.union_area_name='上海零售'
           ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
         group by dr.union_area_name
         order by dr.union_area_name

 select dr.union_area_name,
        sum(fsi.new_value) new_value
   from FACT_SALE_INDEX fsi,
        dim_region dr 
  where fsi.area_code = dr.area_code 
    and fsi.create_month =substr('${month}', 1, 4)
    ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
  group by dr.union_area_name 

select union_area_name,
               sum(store_fu_ml) store_fu_ml
          from (select dr1.union_area_name,
                       fsi.cus_code,
                       case
                         when sum(fsi.operating_profit) >= 0 then
                          0
                         else
                          1
                       end store_fu_ml
                  from fact_store_import fsi,  dim_region dr1,age_store  da
                 where fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
                   and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
                   and fsi.year=substr('${month}', 1, 4)
                   and fsi.area_code = dr1.area_code
                   and fsi.area_code=da.area_code and fsi.cus_code=da.cus_code
                   and da.age_store='直营新'
                   and da.date1='${month1}'
                   ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                 group by dr1.union_area_name, fsi.cus_code) fsib
         group by fsib.union_area_name

select dr1.union_area_name,
                       sum(operating_profit) operating_profit
                  from fact_store_import fsi,  dim_region dr1,age_store  da
                 where fsi.month >= to_char(to_number(substr('${month}', 6, 2)))
                   and fsi.month <= to_char(to_number(substr('${month1}', 6, 2)))
                   and fsi.year=substr('${month}', 1, 4)
                   and fsi.area_code = dr1.area_code
                   and fsi.area_code=da.area_code and fsi.cus_code=da.cus_code
                   and da.age_store='直营新'
                   and fsi.year||'-'||'0'||fsi.month=da.date1
                   ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                 group by dr1.union_area_name

 select dr1.union_area_name,count(*) new_open_store
                          from age_store dc1,dim_region dr1
                         where  dc1.age_store = '直营新'
                           --and to_char(dc1.open_date,'YYYY') = substr('${month}', 1, 4)
                           and dc1.date1= '${month1}'
                           and dc1.area_code = dr1.area_code 
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           group by dr1.union_area_name

select dr1.union_area_name,count(*) new_hosp_store
                          from age_store dc1,DIM_CUS_YBD dcy,dim_region dr1
                         where dc1.area_code=dcy.area_code
                           and dc1.cus_code=dcy.cus_code
                           and dc1.age_store = '直营新'
                           --and to_char(dc1.open_date,'YYYY') = substr('${month}', 1, 4)
                           and dc1.date1= '${month1}'
                           and dc1.area_code = dr1.area_code 
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           group by dr1.union_area_name

 select dr1.union_area_name,count(*) new_close_store
                          from dim_cus dc2,dim_region dr1
                         where dc2.attribute = '直营'
                          and dc2.area_code = dr1.area_code 
                          -- and to_char(dc2.close_date,'YYYY') = substr('${month}', 1, 4)
                          and to_char(dc2.close_date,'YYYY-mm') BETWEEN '${month}' and '${month1}'
                          ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           group by dr1.union_area_name

select to_char(add_months(to_date(to_char(sysdate,'yyyy')-1||'-'||12,'yyyy-mm'),1),'yyyy-mm') begin_date from dual

