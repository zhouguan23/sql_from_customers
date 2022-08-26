select * from DIM_REGION 
where 1=1
${if(len(area)=0,"","and Area_code in ('"+area+"')")}
and 1=1
${if(len(union)=0,"","and union_area_name in ('"+union+"')")}
order by sorted

select * from dim_region
order by sorted

