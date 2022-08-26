select c.area_name,c.union_area_name,b.area_code,b.cus_code,a.cus_name,a.business_cycle,a.health_care,c.sorted
from dim_cus a ,dim_o2o_import_cus b,dim_region c
where a.cus_code=b.cus_code 
and a.area_code=b.area_code
and a.area_code=c.area_code
and
1=1 ${if(len(union_area)=0,""," and c.union_area_name in('"+union_area+"')" )}
and
1=1 ${if(len(area)=0,""," and b.area_code in('"+area+"')" )}
and 1=1 
${if(len(cus)=0,""," and  b.cus_code in ('"+cus+"')" )}
order by c.sorted,b.cus_code

