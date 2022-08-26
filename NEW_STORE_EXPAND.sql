select 
distinct
f.union_area_name AREA_NAME
from
dim_region f

 select dr1.union_area_name, count(*) new_open_store
 --, min(sorted)
   from age_store dc1, dim_region dr1
   --, USER_AUTHORITY ua
  where dc1.age_store = '直营新'
       
    and dc1.area_code = dr1.area_code
    --and (dr1.UNION_AREA_NAME = ua.UNION_AREA_NAME or ua.UNION_AREA_NAME = 'ALL')
       AND dc1.date1='${month1}'
       
     --  and ${"ua.user_id='"+$fr_username+"'"}
     --  ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
    --AND dc1.date1 = '2020-07'
    --AND dr1.union_area_name = '上海零售'
  group by dr1.union_area_name
  --order by min(sorted)

 select dr1.union_area_name,count(*) new_open_store
                          from dim_region dr1
                               ,dim_cus dc
                         where  
                           
                           dc.area_code = dr1.area_code 
                           and ltrim(rtrim(dc.is_adjust_store)) is null
                           and dc.attribute='加盟'
                           and to_char(dc.open_date,'yyyy-mm') between '${month}' and  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc.open_date,'yyyy-mm') between '2020-01' and '2020-07'
                           group by dr1.union_area_name

 select dr1.union_area_name,count(*) new_close_store
                          from dim_cus dc2,dim_region dr1
                         where dc2.attribute = '加盟'
                          and dc2.area_code = dr1.area_code
                          and ltrim(rtrim(dc2.is_adjust_store)) is null 
                          -- and to_char(dc2.close_date,'YYYY') = substr('${month}', 1, 4)
                          and to_char(dc2.close_date,'YYYY-mm') BETWEEN '${month}' and '${month1}'
                          ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           group by dr1.union_area_name

select dr1.union_area_name,
                                count(*) new_hosp_store
                           from DIM_CUS_YBD dcy, dim_region dr1, dim_cus dc1
                          where dc1.area_code = dcy.area_code
                            and dc1.cus_code = dcy.cus_code
                            and dc1.area_code = dr1.area_code
                           and ltrim(rtrim(dc1.is_adjust_store)) is null
                           --and ltrim(rtrim(dc1.close_date)) is null
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc1.open_date,'yyyy-mm') <= '2020-07'
                           and to_char(dc1.open_date,'yyyy-mm') <= '${month1}'
                          ${if(len(area) = 0,"","and dr1.union_area_name IN ('" + area + "')") }
                          group by dr1.union_area_name

 select dr1.union_area_name,count(*) new_close_store
                          from dim_cus dc2,dim_region dr1
                         where dc2.attribute = '直营'
                          and dc2.area_code = dr1.area_code
                          and ltrim(rtrim(dc2.is_adjust_store)) is null 
                          -- and to_char(dc2.close_date,'YYYY') = substr('${month}', 1, 4)
                          and to_char(dc2.close_date,'YYYY-mm') BETWEEN '${month}' and '${month1}'
                          ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           group by dr1.union_area_name

select to_char(add_months(to_date(to_char(sysdate,'yyyy')-1||'-'||12,'yyyy-mm'),1),'yyyy-mm') begin_date from dual

select dr1.union_area_name,
                                count(*) new_open_store
                           from DIM_CUS_YBD dcy, dim_region dr1, dim_cus dc1
                          where dc1.area_code = dcy.area_code
                            and dc1.cus_code = dcy.cus_code
                            and dc1.area_code = dr1.area_code
                           and ltrim(rtrim(dc1.is_adjust_store)) is null
                           --and ltrim(rtrim(dc1.close_date)) is null
                           and to_char(dc1.open_date,'yyyy-mm') between '${month}' and  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc1.open_date,'yyyy-mm') between '2020-01' and '2020-07'
                          group by dr1.union_area_name

select dr1.union_area_name,
                                count(*) new_close_store
                           from DIM_CUS_YBD dcy, dim_region dr1, dim_cus dc1
                          where dc1.area_code = dcy.area_code
                            and dc1.cus_code = dcy.cus_code
                            and dc1.area_code = dr1.area_code
                           and ltrim(rtrim(dc1.is_adjust_store)) is null
                           --and ltrim(rtrim(dc1.close_date)) is null
                           and to_char(dc1.close_date,'yyyy-mm') between '${month}' and  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc1.close_date,'yyyy-mm') between '2020-01' and '2020-07'
                          group by dr1.union_area_name

select dr1.union_area_name,
                                count(*) new_open_store
                           from DIM_CUS_YBD dcy, dim_region dr1, dim_cus dc1
                          where dc1.area_code = dcy.area_code
                            and dc1.cus_code = dcy.cus_code
                            and dc1.area_code = dr1.area_code
                           and ltrim(rtrim(dc1.is_adjust_store)) is null
                           --and ltrim(rtrim(dc1.close_date)) is null
                           and to_char(dc1.open_date,'yyyy-mm') =  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc1.open_date,'yyyy-mm') between '2020-01' and '2020-07'
                          group by dr1.union_area_name

select dr1.union_area_name,
                                count(*) new_close_store
                           from DIM_CUS_YBD dcy, dim_region dr1, dim_cus dc1
                          where dc1.area_code = dcy.area_code
                            and dc1.cus_code = dcy.cus_code
                            and dc1.area_code = dr1.area_code
                           and ltrim(rtrim(dc1.is_adjust_store)) is null
                           --and ltrim(rtrim(dc1.close_date)) is null
                           and to_char(dc1.close_date,'yyyy-mm') =  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc1.close_date,'yyyy-mm') between '2020-01' and '2020-07'
                          group by dr1.union_area_name

 select dr1.union_area_name, count(*) new_open_store
   from age_store dc1, dim_region dr1,dim_cus dc
  where dc1.age_store = '直营新'
       
    and dc1.area_code = dr1.area_code
    and dc.area_code=dc1.area_code
    and dc.cus_code=dc1.cus_code
    AND dc1.date1='${month1}'
    and to_char(dc.open_date,'yyyy-mm') ='${month1}'
       ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
    --AND dc1.date1 = '2020-07'
    --AND dr1.union_area_name = '上海零售'
  group by dr1.union_area_name
 

 select dr1.union_area_name,count(*) new_open_store
                          from dim_region dr1
                               ,dim_cus dc
                         where  
                           
                           dc.area_code = dr1.area_code 
                           and ltrim(rtrim(dc.is_adjust_store)) is null
                           and dc.attribute='加盟'
                           and to_char(dc.open_date,'yyyy-mm') =  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc.open_date,'yyyy-mm') between '2020-01' and '2020-07'
                           group by dr1.union_area_name

 select dr1.union_area_name, count(*) new_open_store
   from age_store dc1, dim_region dr1,dim_cus dc
  where dc1.age_store = '直营（关）'
       
    and dc1.area_code = dr1.area_code
    and dc.area_code=dc1.area_code
    and dc.cus_code=dc1.cus_code
    AND dc1.date1='${month1}'
    and to_char(dc.close_date,'yyyy-mm') ='${month1}'
       ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
    --AND dc1.date1 = '2020-07'
    --AND dr1.union_area_name = '上海零售'
  group by dr1.union_area_name

 select dr1.union_area_name,count(*) new_open_store
                          from dim_region dr1
                               ,dim_cus dc
                         where  
                           
                           dc.area_code = dr1.area_code 
                           and ltrim(rtrim(dc.is_adjust_store)) is null
                           and dc.attribute='加盟'
                           and to_char(dc.close_date,'yyyy-mm') =  '${month1}'
                           ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
                           --and dr1.union_area_name='上海零售'
                           --and to_char(dc.open_date,'yyyy-mm') between '2020-01' and '2020-07'
                           group by dr1.union_area_name

 select dr1.union_area_name
   from dim_region dr1
   , USER_AUTHORITY ua
  where  
     (dr1.UNION_AREA_NAME = ua.UNION_AREA_NAME or ua.UNION_AREA_NAME = 'ALL')                     and ${"ua.user_id='"+$fr_username+"'"}
       ${if(len(area)=0,"","and dr1.union_area_name IN ('"+area+"')")}
    --and dr1.area_code<>'00'
    --AND dc1.date1 = '2020-07'
    --AND dr1.union_area_name = '上海零售'
  order by sorted

