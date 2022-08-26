select r.union_area_name,r.area_code,r.area_name,c.cus_code,c.cus_name,c.IS_ELECTRONIC_COMMERCE,c.eb_id,c.mt_id,c.jd_id,c.attribute,c.BUSINESS_CYCLE,case when c.close_date is not null then '是' else '否' end is_close,c.address,c.OPENING_HOURS,c.IS_IMPORT_E from dim_cus c,dim_region r
where c.area_code=r.area_code
and c.attribute in ('直营','加盟')
and
1=1 ${if(len(union_area)=0,""," and r.union_area_name in('"+union_area+"')" )}
and
1=1 ${if(len(area)=0,""," and r.area_code in('"+area+"')" )}
and
1=1 ${if(len(CUS)=0,""," and c.cus_code in('"+CUS+"')" )}
and
1=1 ${if(len(ELECTRONIC)=0,""," and c.IS_ELECTRONIC_COMMERCE in('"+ELECTRONIC+"')" )}
and
1=1 ${if(len(IMPORT)=0,""," and c.IS_IMPORT_E in('"+IMPORT+"')" )}

