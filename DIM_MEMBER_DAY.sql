select distinct a.union_area_name,a.area_code,a.area_name from dim_region a 
left join dim_cus b
on a.area_code=b.area_code
where 1=1 ${if(len(CUS_CODE)==0,"", " and B.CUS_CODE in ('" + CUS_CODE + "')")}
and 1=1
${if(len(union_area) = 0, "", " and a.union_area_name in ('" + union_area + "')")}

select b.union_area_name,b.area_code,b.area_name,a.cus_code,c.cus_name,a.day_type,a.member_day from DIM_MEMBER_DAY_pre a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where 1=1 
${if(len(AREA_CODE)==0,"", " and a.AREA_CODE in ('" + AREA_CODE + "')")}
and 1=1
${if(len(cus_code) = 0, "", " and a.cus_code in ('" + cus_code + "')")}
and 1=1
${if(len(union_area) = 0, "", " and b.union_area_name in ('" + union_area + "')")}
order by 2,4

select distinct B.CUS_CODE,B.CUS_NAME from dim_region a left join dim_cus b
on a.area_code=b.area_code
where 1=1 ${if(len(AREA_CODE)==0,"", " and a.AREA_CODE in ('" + AREA_CODE + "')")}


