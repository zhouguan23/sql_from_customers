select a.*,b.GOODS_NAME,b.SPECIFICATION,b.MANUFACTURER,b.PRODUCT_PLACE,r.sorted,r.area_name area_name1 from DIM_NET_CATALOGUE_GENERAL_ALL a left join DIM_GOODS b
on a.GOODS_CODE=b.GOODS_CODE
left join dim_region r
on a.area_code=r.area_code
left join dim_disable_code c
on a.goods_code=c.goods_code
where 1=1

${if(len(gcode)=0,""," and b.goods_code in ('"+gcode+"')")} 

and

1=1 ${if(len(date1)=0,""," and  create_month = ('"+date1+"')" )}

and 1=1 ${if(len(area)=0,""," and a.Area_code in ('"+area+"')")}
and 1=1
${if(len(NEW_ATTRIBUTE)=0,""," and NEW_ATTRIBUTE in ('"+NEW_ATTRIBUTE+"')")} 
and 1=1 
${if(len(status)=0,"","and case
         when c.goods_code is null then
          '废止'
         when c.goods_code <> c.disable_code then
          '禁用'
         WHEN c.goods_code = c.disable_code AND c.disable_code LIKE '6%' THEN
          '临购码'
         else
          '正常'
       end in ('"+status+"')")}
order by sorted

select distinct a.goods_code,a.goods_code||'|'||b.goods_name goods_name from DIM_NET_CATALOGUE_GENERAL_all a
left join dim_goods b 
on a.goods_code=b.goods_code where 1=1
 ${if(len(area)=0,""," and Area_code in ('"+area+"')")}

select distinct area_code, area_name ,union_area_name,sorted from  dim_region 
order by sorted

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL
where 1=1
${if(len(date1)=0,""," and  create_month = ('"+date1+"')" )}

