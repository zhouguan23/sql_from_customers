 select r.union_area_name, count(distinct s.cus_code) zy_new_store_num

   from age_store s, dim_region r

  where s.age_store = '直营新'
       
    and r.area_code =s.area_code
   
       AND s.date1 between '${month}' and  '${month1}'
       
  group by r.union_area_name
 

 select r.union_area_name, count(distinct s.cus_code) jm_new_store_num

   from age_store s, dim_region r

  where s.age_store = '非直营新'
       
    and r.area_code =s.area_code
   
       AND s.date1 between '${month}' and  '${month1}'
       
  group by r.union_area_name
 

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
                
                           group by dr1.union_area_name

 select dr1.union_area_name,count(*) new_close_store
                          from dim_cus dc2,dim_region dr1
                         where dc2.attribute = '直营'
                          and dc2.area_code = dr1.area_code
                          and ltrim(rtrim(dc2.is_adjust_store)) is null 
                          -- and to_char(dc2.close_date,'YYYY') = substr('${month}', 1, 4)
                          and to_char(dc2.close_date,'YYYY-mm') BETWEEN '${month}' and '${month1}'
                   
                           group by dr1.union_area_name

 select  sales_scale,r.union_area_name,min(sorted) sorted
   from dim_region r
   , USER_AUTHORITY ua,age_store s
  where  
     (r.UNION_AREA_NAME = ua.UNION_AREA_NAME or ua.UNION_AREA_NAME = 'ALL')           
     and  r.area_code=s.area_code
     and s.age_store is not null
     and  s.date1 between '${month}' and  '${month1}'
     and ${"ua.user_id='"+$fr_username+"'"}
       ${if(len(union_area)=0,"","and dr1.union_area_name IN ('"+union_area+"')")}
   group by sales_scale,r.union_area_name
  order by decode(sales_scale,'>10亿',1,'>5亿',2,'>2亿',3,'<2亿',4,sales_scale)  ,sorted

select r.union_area_name,count(distinct s.cus_code) zy_total_num from age_store s,dim_region r
where s.area_code=r.area_code
and s.date1='${month1}'
and s.age_store in ('直营不可比','直营可比','直营新','直营次新','直营收购')
group by r.union_area_name

select r.union_area_name,count(distinct s.cus_code) jm_total_num from age_store s,dim_region r
where  s.area_code=r.area_code
and s.date1='${month1}'
and s.age_store in ('非直营','非直营新','加盟收购')
group by r.union_area_name

select r.union_area_name,sum(nvl(DIRECT_STORES_NUM,0))+sum(nvl(FRANCHISED_STORE_NUM,0)) target_store_num from fact_sale_index a,dim_region r
where a.area_code=r.area_code
and a.create_month =substr('${month1}',1,4)
group by r.union_area_name

 select r.union_area_name, count(distinct s.cus_code) sg_store_num

   from age_store s, dim_region r

  where s.age_store in ( '加盟收购','直营收购')
       
    and r.area_code =s.area_code
   
       AND s.date1 between '${month}' and  '${month1}'
       
  group by r.union_area_name
 

