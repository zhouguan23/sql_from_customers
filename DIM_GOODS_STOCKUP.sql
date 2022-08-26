SELECT A.area_code,A.GOODS_CODE,B.GOODS_NAME,A.GOODS_CODE||'|'||GOODS_NAME GOODS_NAME1,SPECIFICATION,MANUFACTURER,PRODUCT_PLACE,r.area_name FROM DIM_GOODS_STOCKUP_pre A LEFT JOIN DIM_GOODS B 
ON A.GOODS_CODE=B.GOODS_CODE
left join dim_region r
on a.area_code=r.area_code
where 1=1 
${if(len(GOODS_CODE)=0,"","and A.GOODS_CODE in ('"+GOODS_CODE+"')")}
and 1=1 
${if(len(AREA)=0,"","and A.area_code in ('"+AREA+"')")}

order by 1 ,2

