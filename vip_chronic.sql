 select distinct area_name ,area_code from dim_region 
 where 1=1
 and area_code not in ('00')
 ${if(len(uarea)==0,""," and union_area_name in ('"+uarea+"')")}
 --${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
 order by 2

/*with a as
 (select b.area_code, a.insiderid
    from gygd_bi.dm_available_sale_vip a, dm_vip_chronic b ,dim_cus c
   where a.insiderid = b.insiderid
         and a.area_code=c.area_code
         and a.cus_code=c.cus_code
         and a.area_code=b.area_code
          ${if(len(AREA)=0,""," and b.area_code in ('"+AREA+"')")}
          ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
     and  sale_date between date'${start_date}' and date'${end_date}'
     and exists
   (select 'Y' from dm_vip_chronic_detail v where b.insiderid = v.insiderid 
   and b.area_code=v.area_code
   ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}))
select count(1) hys, area_code
          from (select count(1), area_code, insiderid
                  from a
                 group by area_code, insiderid
                having count(1) >= 1)
         group by area_code */
with a as
 (select c.area_code, a.insiderid
    from gygd_bi.dm_available_sale_vip a, dim_cus c, dim_region dr
   where a.area_code = c.area_code
     and a.cus_code = c.cus_code
     and a.area_code = c.area_code
     and c.area_code=dr.area_code
--          ${if(len(AREA)=0,""," and c.area_code in ('"+AREA+"')")}
and dr.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
          ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
   ${if(len(union_area)=0,""," and  dr.union_area_name in ('"+union_area+"')")}
      and a.sale_date between  date'${start_date}' and date'${end_date}'
     and exists
   (select 'Y'
            from dm_vip_chronic_detail v
           where a.insiderid = v.insiderid
             and a.area_code = v.area_code
             and v.member_date <= a.sale_date
                ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")})
             )
select count(1) hys, area_code
  from (select count(1), area_code, insiderid
          from a
         group by area_code, insiderid
        having count(1) >= 1)
 group by area_code

select dc.area_code,
       --       t2.store_name as cus_name,
       --       t3.ext_org_code as cus_code,
       count(1) as H_NEW
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
  join dim_region dr
   on zro.brancode=dr.area_code
   ${if(len(union_area)=0,""," and  dr.union_area_name in ('"+union_area+"')")}
  left join member_card m
    on m.member_id = t1.member_id
   and m.card_depart_id = t2.depart_member_id
 where t1.status = '1'
       ${if(len(chronic)=0,""," and pd.prj_name in ('"+chronic+"')")}
 --      ${if(len(AREA)=0,""," and dc.area_code in ('"+AREA+"')")}
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
   and trunc(t1.crt_time) between date'${start_date}' and date'${end_date}'
 group by dc.area_code


/*select count(*) H_NEW,to_char(zro.brancode) area_code
  from member_info_health mi
  join prj_member_specialist pms
    on pms.member_id = mi.id
   and pms.status = '1'
  join base_new_store s
    on s.id = pms.bind_store_id
  join base_new_depart d
    on s.parent_id = d.id
  join prj_project_define pd
    on pms.project_id = pd.id
    ${if(len(chronic)=0,""," and pd.prj_name in ('"+chronic+"')")}
   join pub_company pc
    on d.ext_org_code = to_char(pc.companyid)
   and pc.levelno = 3
   and pc.companyid not in ('1922')
  join zux_region_ou zro
    on pc.momcode = to_char(zro.region)
 ${if(len(AREA)=0,""," and  zro.brancode in ('"+AREA+"')")}    
   and pms.crt_time   between date'${start_date}' and date'${end_date}'
   
   join dim_region dr
   on zro.brancode=dr.area_code
   ${if(len(UAREA)=0,""," and  dr.union_area_name in ('"+UAREA+"')")}
   group by to_char(zro.brancode)*/


select dc.area_code,
       --       t2.store_name as cus_name,
       --       t3.ext_org_code as cus_code,
       count(1) as H_TOTAL
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
  join dim_region dr
   on zro.brancode=dr.area_code
   ${if(len(union_area)=0,""," and  dr.union_area_name in ('"+union_area+"')")}
  left join member_card m
    on m.member_id = t1.member_id
   and m.card_depart_id = t2.depart_member_id
 where t1.status = '1'
       ${if(len(chronic)=0,""," and pd.prj_name in ('"+chronic+"')")}
--       ${if(len(AREA)=0,""," and dc.area_code in ('"+AREA+"')")}
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
 group by dc.area_code

/*select count(*) h_total,to_char(zro.brancode) area_code
  from member_info_health mi
  join prj_member_specialist pms
    on pms.member_id = mi.id
   and pms.status = '1'
  join base_new_store s
    on s.id = pms.bind_store_id
  join base_new_depart d
    on s.parent_id = d.id
  join prj_project_define pd
    on pms.project_id = pd.id
    ${if(len(chronic)=0,""," and pd.prj_name in ('"+chronic+"')")}
   join pub_company pc
    on d.ext_org_code = to_char(pc.companyid)
   and pc.levelno = 3
   and pc.companyid not in ('1922')
  join zux_region_ou zro
    on pc.momcode = to_char(zro.region)
 ${if(len(AREA)=0,""," and  zro.brancode in ('"+AREA+"')")}    
--   and pms.crt_time   between date'${start_date}' and date'${end_date}'
join dim_region dr
   on zro.brancode=dr.area_code
   ${if(len(UAREA)=0,""," and  dr.union_area_name in ('"+UAREA+"')")}
   group by to_char(zro.brancode)*/

/*with a as
 (select b.area_code, a.insiderid
    from gygd_bi.dm_available_sale_vip a, dm_vip_chronic b ,dim_cus c
   where a.insiderid = b.insiderid
         and a.area_code=c.area_code
         and a.cus_code=c.cus_code
         and a.area_code=b.area_code
          ${if(len(AREA)=0,""," and b.area_code in ('"+AREA+"')")}
          ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
     and  sale_date between date'${start_date}' and date'${end_date}'
     and exists
   (select 'Y' from dm_vip_chronic_detail v where b.insiderid = v.insiderid 
   and b.area_code=v.area_code
   ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}))
*/
with a as
 (select c.area_code, a.insiderid
    from gygd_bi.dm_available_sale_vip a, dim_cus c, dim_region dr
   where a.area_code = c.area_code
     and a.cus_code = c.cus_code
     and a.area_code = c.area_code
     and c.area_code=dr.area_code
--          ${if(len(AREA)=0,""," and c.area_code in ('"+AREA+"')")}
and c.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
          ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
   ${if(len(union_area)=0,""," and  dr.union_area_name in ('"+union_area+"')")}
      and a.sale_date between  date'${start_date}' and date'${end_date}'
     and exists
   (select 'Y'
            from dm_vip_chronic_detail v
           where a.insiderid = v.insiderid
             and a.area_code = v.area_code
             and v.member_date <=a.sale_date
                ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")})
             ) 
       select count(1) wdhys, area_code
          from (select count(1), area_code, insiderid
                  from a
                 group by area_code, insiderid
                having count(1) >= 3)
         group by area_code

/*with a as
 (select b.area_code, a.insiderid
    from gygd_bi.dm_available_sale_vip a, dm_vip_chronic b ,dim_cus c
   where a.insiderid = b.insiderid
         and a.area_code=c.area_code
         and a.cus_code=c.cus_code
         and a.area_code=b.area_code
          ${if(len(AREA)=0,""," and b.area_code in ('"+AREA+"')")}
          ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
     and  sale_date between date'${start_date}' and date'${end_date}'
     and exists
   (select 'Y' from dm_vip_chronic_detail v where b.insiderid = v.insiderid 
   and b.area_code=v.area_code
   ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}))
*/
with a as
 (select c.area_code, a.insiderid
    from gygd_bi.dm_available_sale_vip a, dim_cus c, dim_region dr
   where a.area_code = c.area_code
     and a.cus_code = c.cus_code
     and a.area_code = c.area_code
     and c.area_code=dr.area_code
--          ${if(len(AREA)=0,""," and c.area_code in ('"+AREA+"')")}
and c.area_code in (select a.area_code
  from dim_region a, (select * from user_authority) b
 where (a.union_area_name = b.union_area_name or b.union_area_name = 'ALL')
   and ${"b.user_id='" + $fr_username + "'"}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")} 
${if(len(union_area)=0,"","and a.UNION_AREA_NAME in('"+union_area+"')")} 
)
          ${if(len(attribute)=0,""," and c.attribute in ('"+attribute+"')")}
   ${if(len(union_area)=0,""," and  dr.union_area_name in ('"+union_area+"')")}
      and a.sale_date between  date'${start_date}' and date'${end_date}'
     and exists
   (select 'Y'
            from dm_vip_chronic_detail v
           where a.insiderid = v.insiderid
             and a.area_code = v.area_code
             and v.member_date <= a.sale_date 
                ${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")})
             )
       select count(1) cjwdhys, area_code
          from (select count(1), area_code, insiderid
                  from a
                 group by area_code, insiderid
                having count(1) >= 10)
         group by area_code

select distinct  union_area_name from dim_region
 where 1=1
 and area_code not in ('00')
 
 --${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}

select distinct ill_type from dim_illness_catalogue

