select a.*,b.GOODS_NAME,b.SPECIFICATION,b.MANUFACTURER,b.PRODUCT_PLACE,r.area_name from DIM_NET_CATALOGUE_GENERAL3 a left join DIM_GOODS b
on a.GOODS_CODE=b.GOODS_CODE
left join dim_region r
on a.area_code=r.area_code

where 1=1

${if(len(gcode)=0,""," and b.goods_code in ('"+gcode+"')")} 

and

1=1 ${if(len(date1)=0,""," and  create_month = ('"+date1+"')" )}

and 1=1 ${if(len(area)=0,""," and r.Area_code in ('"+area+"')")}
order by r.area_code,a.goods_code

select distinct a.goods_code,a.goods_code||'|'||b.goods_name goods_name from DIM_NET_CATALOGUE_GENERAL3 a
left join dim_goods b
on a.goods_code=b.goods_code where 1=1
 ${if(len(area)=0,""," and Area_code in ('"+area+"')")}
 order by 1

select distinct a.area_code, b.area_name from DIM_NET_CATALOGUE_GENERAL3 a
left join dim_region b
on a.area_code=b.area_code

