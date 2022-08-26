select 
ORDER_DATE,
a.area_code,
d.AREA_NAME,
a.goods_code,
c.goods_name,
SUPPLIER_CODE,
SUPPLIER_NAME,
c.SPECIFICATION,
c.MANUFACTURER,
sum(ORDER_QTY) ORDER_QTY,
sum(NO_TAX_AMOUNT) NO_TAX_AMOUNT,
sum(TAX_AMOUNT) TAX_AMOUNT,
b.new_attribute,
b.NEW_OR_OLD
from 
fact_purchase a,dim_net_catalogue_general_all b,dim_goods c,dim_region d
where ORDER_DATE between date'${date1}' and date'${date2}' 
${if(len(good_c)=0,"","and a.goods_code IN ('"+good_c+"')")}
${if(len(good_n)=0,"","and a.goods_name IN ('"+good_n+"')")}
${if(len(new_a)=0,"","and b.new_attribute IN ('"+new_a+"')")}
${if(len(area)=0,"","and a.area_code IN ('"+area+"')")}
${if(len(sup)=0,"","and SUPPLIER_CODE IN ('"+sup+"')")}
and to_char(a.ORDER_DATE,'yyyy-mm')=b.CREATE_MONTH
and a.area_code=b.area_code and a.goods_code=b.goods_code
and a.goods_code=c.goods_code
and a.area_code=d.area_code

group by 
ORDER_DATE,
a.area_code,
d.AREA_NAME,
a.goods_code,
c.goods_name,
SUPPLIER_CODE,
SUPPLIER_NAME,
c.SPECIFICATION,
c.MANUFACTURER,
b.new_attribute,
b.NEW_OR_OLD
order by a.area_code,SUPPLIER_CODE,a.goods_code

select * from Dim_Gifts

select 
distinct
goods_code,
goods_code||'|'||goods_name,
goods_name
from dim_goods
where 1=1
${if(len(good_c)=0,"","and goods_code IN ('"+good_c+"')")}
order by goods_code

select
distinct
new_attribute 
from
dim_net_catalogue_general_all

select 
area_code,
area_name
from dim_region

select distinct
SUPPLIER_CODE,
SUPPLIER_name,
SUPPLIER_CODE||'|'||SUPPLIER_name
from 

fact_purchase


where ORDER_DATE between date'${date1}' and date'${date2}'

