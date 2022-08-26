select 
distinct
f.union_area_name AREA_NAME
from
dim_region f

 select        dr.union_area_name,
               count(*) sale_day_sum,
               sum(ddss.sale_amount) sale_sum,
               sum(nvl(ddss.sale_amount, 0) - nvl(ddss.sale_cost, 0)) sale_ml_sum,
               sum(ddss.sale_amount-ddss.dtp_sale_amount) no_dtp_sale,
               sum(ddss.dtp_sale_amount) dtp_sale,
               sum(nvl(ddss.dtp_sale_amount, 0) - nvl(ddss.dtp_sale_cost, 0)) dtp_sale_ml,
               sum(ddss.oto_sale_amount) oto_sale,
               sum(nvl(ddss.oto_sale_amount, 0) - nvl(ddss.oto_sale_cost, 0)) oto_sale_ml,
               sum(nvl(ddss.sale_amount, 0) - nvl(ddss.dtp_sale_amount, 0) - nvl(oto_sale_amount, 0)) cg_sale
          from dm_delivery_sale_stock ddss, dim_cus dc, dim_region dr /*,age_store da*/
         where ddss.area_code = dc.area_code
           and ddss.cus_code = dc.cus_code
           and ddss.area_code = dr.area_code
           --and ddss.area_code = da.area_code
           --and ddss.cus_code = da.cus_code
           /*and ddss.date1 between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('2019-03-31', 'yyyy-mm-dd')
           and to_char(ddss.open_date,'yyyy')='2018'
           and (dc.close_date is null or dc.close_date>to_date('2019-03-31', 'yyyy-mm-dd'))
            --and da.date1='${month1}'
           --and da.age_store='直营次新'*/
           
       and dc.attribute='直营'
       and to_char(dc.open_date,'YYYY') = to_char(sysdate,'yyyy')-1
       --and ddss.date1 between to_date('2020-05-01', 'yyyy-mm-dd') and to_date('2020-06-30', 'yyyy-mm-dd')
       --and dr.union_area_name ='上海零售'
       and to_char(ddss.date1,'YYYY-MM') BETWEEN '${month}' and '${month1}'
       ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")} 
       and ddss.sale_amount is not null 
         group by dr.union_area_name order by dr.union_area_name

select   union_area_name,
               sum(operating_profit) operating_profit,
               sum(store_fu_ml) store_fu_ml,
               sum(store_zh_ml) store_zh_ml
          from (select dr1.union_area_name,
                       fsi.cus_code,
                       sum(fsi.operating_profit) operating_profit,
                       case
                         when sum(fsi.operating_profit) >= 0 then
                          0
                         else
                          1
                       end store_fu_ml,
                       case
                         when sum(fsi.operating_profit) >= 0 then
                         1
                         else
                         0
                       end store_zh_ml
                  from fact_store_import fsi, dim_region dr1, dim_cus dc/*,age_store da*/
                 where --.month >= to_number(substr('2019-01', 6, 2)) and fsi.month <= to_number(substr('2019-03', 6, 2))
                   fsi.area_code = dr1.area_code 
                   and fsi.area_code = dc.area_code
                   and fsi.cus_code = dc.cus_code
                   and dc.attribute='直营'
                   and to_char(dc.open_date,'YYYY') = to_char(sysdate,'yyyy')-1
                   --and fsi.area_code=da.area_code and fsi.cus_code=da.cus_code
                   --and da.age_store='直营次新'
                   --and da.date1='${month1}'
                   and fsi.year>=substr('${month}', 1, 4) and fsi.year<=substr('${month1}', 1, 4)
                   and fsi.month >= to_number(substr('${month}', 6, 2)) and fsi.month <= to_number(substr('${month1}', 6, 2))
                   ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                 /*and fsi.year='2020'
                 and fsi.month >=1 and fsi.month <=6
                 and dr1.union_area_name='上海零售'*/
                 group by dr1.union_area_name, fsi.cus_code) fsib
                 group by fsib.union_area_name

select dr2.union_area_name,
               sum(new_open_store) new_open_store
          from (select area_code,
                       count(*) new_open_store
                  from age_store da
                 where 1=1
                 --dc.attribute = '直营'
                    --and to_char(dc.open_date,'yyyy')='2018'
                    --and to_char(dc.open_date,'yyyy')=substr('${month}', 1, 4)-1
                   -- and dc.area_code=da.area_code and dc.cus_code=da.cus_code
                    and da.age_store='直营次新'
                    and da.date1='${month1}'
                    --and (dc.close_date is null or dc.close_date>=to_date('2019-03-31', 'yyyy-mm-dd'))
                    --and (dc.close_date is null or to_char(dc.close_date,'yyyy-mm')>='${month1}')
                 group by area_code) cc,
               dim_region dr2
         where cc.area_code = dr2.area_code
         ${if(len(area)=0,"","and dr2.union_area_name IN ('"+area+"')")}         
         group by dr2.union_area_name

select dr3.union_area_name,
                count(*)  begin_open_store  
                  from dim_cus dc, dim_region dr3,age_store da
                 where 
                    dc.area_code = dr3.area_code
                   and dc.area_code=da.area_code and dc.cus_code=da.cus_code
                   and da.age_store='直营次新'
                   /*and da.date1='2019-12'
                   and dr3.union_area_name='上海零售'*/
                  and da.date1 = substr('${month}', 1, 4)-1||'-'||'12'
                  ${if(len(area)=0,"","and dr3.union_area_name IN ('"+area+"')")} 
                   group by dr3.union_area_name

 select dr.union_area_name,
        sum(fsi.second_new_value) second_new_value,
        sum(fsi.second_new_gpb) second_new_gpb,
        sum(fsi.second_new_pb)  second_new_pb
   from FACT_SALE_INDEX fsi,
        dim_region dr 
  where fsi.area_code = dr.area_code 
    and fsi.create_month =substr('${month}', 1, 4)
    ${if(len(area)=0,"","and dr.union_area_name IN ('"+area+"')")}
  group by dr.union_area_name 

