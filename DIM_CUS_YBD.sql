select c.union_area_name,b.area_code,b.hospital_name,b.hospital_level,b.cus_code,a.cus_name,a.open_date
from dim_cus a ,dim_cus_ybd b,dim_region c
where a.cus_code=b.cus_code 
and a.area_code=b.area_code
and a.area_code=c.area_code
and
1=1 ${if(len(area)=0,""," and c.union_area_name in('"+area+"')" )}
and 1=1 
${if(len(hospital_level)=0,""," and  b.hospital_level in ('"+hospital_level+"')" )}
and 1=1 
${if(len(cus_code)=0,""," and  b.cus_code in ('"+cus_code+"')" )}
order by c.union_area_name,b.cus_code

select b.cus_code as cus_code,b.cus_code||'|'||a.cus_name as cus_name
from dim_cus a ,dim_cus_ybd b,dim_region c
where a.cus_code=b.cus_code
and a.area_code=b.area_code
and a.area_code=c.area_code
and
1=1 ${if(len(area)=0,""," and c.union_area_name in('"+area+"')" )}
and 1=1 
${if(len(hospital_level)=0,""," and  b.hospital_level in ('"+hospital_level+"')" )}




select distinct b.hospital_level
from dim_cus a ,dim_cus_ybd b,dim_region c
where a.cus_code=b.cus_code 
and a.area_code=b.area_code
and a.area_code=c.area_code
and 1=1 ${if(len(area)=0,""," and c.union_area_name in('"+area+"')" )}

select distinct c.union_area_name
from dim_cus a ,dim_cus_ybd b,dim_region c
where a.cus_code=b.cus_code 
and a.area_code=b.area_code
and a.area_code=c.area_code
 

