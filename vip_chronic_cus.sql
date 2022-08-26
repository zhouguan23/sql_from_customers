with a as
 (select c.area_code, a.insiderid ,a.cus_code,c.cus_name,c.attribute,nvl2(c.close_date,'关','开') cus_status
    from gygd_bi.dm_available_sale_vip a, dim_cus c
   where a.area_code = c.area_code
     and a.cus_code = c.cus_code
     and a.area_code = c.area_code
--      ${if(len(AREA)=0,""," and c.area_code in ('"+AREA+"')")}
and c.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
      ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
      ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
     and a.sale_date between  date'${start_date}' and date'${end_date}'
     and exists (select 'Y'
            from dm_vip_chronic_detail v
           where a.insiderid = v.insiderid
             and a.area_code = v.area_code
             and v.member_date <= a.sale_date
             ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}))
select count(1) hys, area_code，cus_code,cus_name,attribute,cus_status
  from (select count(1), area_code, insiderid，cus_code,cus_name,attribute,cus_status
          from a
         group by area_code, insiderid,cus_code,cus_name,attribute,cus_status
        having count(1) >= 1)
 group by area_code,cus_code,cus_name,attribute,cus_status

select dc.area_code,
       t2.store_name as cus_name,
       t3.ext_org_code as cus_code,
       count(1) as num1
  from prj_member_specialist t1
  join base_new_store t2
    on t1.bind_store_id = t2.depart_id
  join base_new_depart t3
    on t2.depart_id = t3.id
  join base_new_depart t4
    on t2.depart_member_id = t4.id
  join prj_project_define pd
    on t1.project_id = pd.id
  join pub_company pc
    on t4.ext_org_code = to_char(pc.companyid)
  join zux_region_ou zro
    on pc.momcode = to_char(zro.region)
  join dim_cus dc
    on t3.ext_org_code = dc.cus_code
   and zro.brancode = dc.area_code
  left join member_card m
    on m.member_id = t1.member_id
   and m.card_depart_id = t2.depart_member_id
 where t1.status = '1'
   ${if(len(chronic)=0,""," and pd.prj_name in ('"+chronic+"')")}
--   ${if(len(AREA)=0,""," and dc.area_code in ('"+AREA+"')")}
and dc.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
   ${if(len(attribute)=0,""," and dc.attribute in ('"+attribute+"')")}
   and pc.levelno = 3
   and pc.companyid not in ('1922')
   and trunc(t1.crt_time)  between date'${start_date}' and date'${end_date}'
 group by dc.area_code, t2.store_name, t3.ext_org_code


select dc.area_code,
       t2.store_name as cus_name,
       t3.ext_org_code as cus_code,
       count(1) as num1
  from prj_member_specialist t1
  join base_new_store t2
    on t1.bind_store_id = t2.depart_id
  join base_new_depart t3
    on t2.depart_id = t3.id
  join base_new_depart t4
    on t2.depart_member_id = t4.id
  join prj_project_define pd
    on t1.project_id = pd.id
  join pub_company pc
    on t4.ext_org_code = to_char(pc.companyid)
  join zux_region_ou zro
    on pc.momcode = to_char(zro.region)
  join dim_cus dc
    on t3.ext_org_code = dc.cus_code
   and zro.brancode = dc.area_code
  left join member_card m
    on m.member_id = t1.member_id
   and m.card_depart_id = t2.depart_member_id
 where t1.status = '1'
   ${if(len(chronic)=0,""," and pd.prj_name in ('"+chronic+"')")}
--   ${if(len(AREA)=0,""," and dc.area_code in ('"+AREA+"')")}
and dc.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
   ${if(len(attribute)=0,""," and dc.attribute in ('"+attribute+"')")}
   and pc.levelno = 3
   and pc.companyid not in ('1922')
 group by dc.area_code, t2.store_name, t3.ext_org_code


with a as
 (select c.area_code, a.insiderid ,a.cus_code,c.cus_name,c.attribute,nvl2(c.close_date,'关','开') cus_status
    from gygd_bi.dm_available_sale_vip a, dim_cus c
   where a.area_code = c.area_code
     and a.cus_code = c.cus_code
     and a.area_code = c.area_code
--      ${if(len(AREA)=0,""," and c.area_code in ('"+AREA+"')")}
and c.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
      ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
      ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
     and a.sale_date between  date'${start_date}' and date'${end_date}'
     and exists (select 'Y'
            from dm_vip_chronic_detail v
           where a.insiderid = v.insiderid
             and a.area_code = v.area_code
             and v.member_date <= a.sale_date
             ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}))
select count(1) wdhys, area_code，cus_code,cus_name,attribute,cus_status
  from (select count(1), area_code, insiderid，cus_code,cus_name,attribute,cus_status
          from a
         group by area_code, insiderid,cus_code,cus_name,attribute,cus_status
        having count(1) >= 3)
 group by area_code,cus_code,cus_name,attribute,cus_status

with a as
 (select c.area_code, a.insiderid ,a.cus_code,c.cus_name,c.attribute,nvl2(c.close_date,'关','开') cus_status
    from gygd_bi.dm_available_sale_vip a, dim_cus c
   where a.area_code = c.area_code
     and a.cus_code = c.cus_code
     and a.area_code = c.area_code
--      ${if(len(AREA)=0,""," and c.area_code in ('"+AREA+"')")}
and c.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
      ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
      ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
     and a.sale_date between  date'${start_date}' and date'${end_date}'
     and exists (select 'Y'
            from dm_vip_chronic_detail v
           where a.insiderid = v.insiderid
             and a.area_code = v.area_code
             and v.member_date <= a.sale_date
             ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}))
select count(1) cjwdhys, area_code，cus_code,cus_name,attribute,cus_status
  from (select count(1), area_code, insiderid，cus_code,cus_name,attribute,cus_status
          from a
         group by area_code, insiderid,cus_code,cus_name,attribute,cus_status
        having count(1) >= 10)
 group by area_code,cus_code,cus_name,attribute,cus_status

select distinct ill_type from dim_illness_catalogue

