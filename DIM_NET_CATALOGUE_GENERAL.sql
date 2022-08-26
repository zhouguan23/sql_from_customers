select a.*,b.GOODS_NAME,b.SPECIFICATION,b.MANUFACTURER,b.PRODUCT_PLACE from DIM_NET_CATALOGUE_GENERAL a left join 
DIM_GOODS b
on a.GOODS_CODE=b.GOODS_CODE
where 1=1

${if(len(gcode)=0,""," and A.goods_code in ('"+gcode+"')")} 

and

1=1 ${if(len(date1)=0,""," and  create_month = ('"+date1+"')" )}
${if(len(NEW_ATTRIBUTE)=0,""," and NEW_ATTRIBUTE in ('"+NEW_ATTRIBUTE+"')")} 
order by 2

select distinct a.goods_code,a.goods_code||'|'||b.goods_name goods_name from DIM_NET_CATALOGUE_GENERAL A
LEFT JOIN DIM_GOODS B
ON A.GOODS_code=b.goods_code
order by 1

select NEW_ATTRIBUTE from DIM_NET_CATALOGUE_GENERAL where 1=1

 ${if(len(date1)=0,""," and  create_month = ('"+date1+"')" )}


