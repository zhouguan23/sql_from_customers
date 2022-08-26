select
a.*,b.AREA_NAME 
from DIM_SUPPLIER a,DIM_REGION b
where 
a.AREA_CODE=b.AREA_CODE
${if(len(AREA_CODE) = 0, "", " and a.AREA_CODE='" + AREA_CODE + "'")}
${if(len(SUPPLIER_CODE) = 0, "", " and a.SUPPLIER_CODE='" + SUPPLIER_CODE + "'")}
${if(len(KEY_SUPPLIER) = 0, "", " and a.KEY_SUPPLIER='" + KEY_SUPPLIER + "'")}
order by a.area_code,a.supplier_code

select SUPPLIER_CODE,SUPPLIER_NAME from DIM_SUPPLIER

select AREA_CODE,AREA_NAME from DIM_REGION
order by 1

