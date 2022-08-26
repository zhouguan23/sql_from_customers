select *
from(
select 
a.area_code,
a.goods_code,
a.supplier_code,
a.SUPPLIER_NAME,
a.order_date,

row_number()over(partition by a.goods_code  order by a.order_date desc )rn
from fact_purchase a,DIM_NET_CATALOGUE_GENERAL_ALL b

where  
a.area_code=b.area_code and a.goods_code=b.goods_code
and a.procurement_type='采进'
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
--and no_tax_price>=0
and a.area_code='00'
)where rn=1

select 
goods_code,
goods_name,
SPECIFICATION,
MANUFACTURER,
UNIT,
(select UDA_VALUE_DESC from item_uda a where uda_id = 17 and b.goods_code=a.ITEM) LOAD,
goods_code||'|'||goods_name
from dim_goods b
order by goods_code

select 
a.area_code,
a.goods_code,
sum(ORDER_QTY) ORDER_QTY
from fact_purchase a,DIM_NET_CATALOGUE_GENERAL_ALL b
where 
order_date between date'${date1}' and date'${date2}'
${if(len(goodn)=0,"","and a.goods_code IN ('"+goodn+"')")}
and a.area_code=b.area_code and a.goods_code=b.goods_code
and a.procurement_type='采进'
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
--and no_tax_price>=0
and a.area_code='00'
group by a.area_code,
a.goods_code

select 
a.area_code,
a.goods_code,
sum(DELIVERY_QTY) DELIVERY_QTY
from FACT_DELIVERY a,DIM_NET_CATALOGUE_GENERAL_ALL b
where 
SALE_DATE between date'${date1}' and date'${date2}'
${if(len(goodn)=0,"","and a.goods_code IN ('"+goodn+"')")}
and a.area_code=b.area_code and a.goods_code=b.goods_code
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
--and no_tax_price>=0
and a.area_code='00'
group by a.area_code,
a.goods_code


select goods_code,AVI_QTY from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(sysdate-1) and area_code='00'
${if(len(goodn)=0,"","and goods_code IN ('"+goodn+"')")}

select 
area_code,
goods_code，
BUYER MANAGER
from
DIM_NET_CATALOGUE_GENERAL_ALL
where  area_code='00'
and  create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
${if(len(goodn)=0,"","and goods_code IN ('"+goodn+"')")}
${if(len(manag)=0,"","and BUYER IN ('"+manag+"')")}
order by goods_code

select distinct
BUYER
from 
DIM_NET_CATALOGUE_GENERAL_ALL
where
1=1
and  create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 

