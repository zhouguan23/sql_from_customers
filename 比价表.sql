select
nvl(a.area_code,b.area_code) area_code,
nvl(a.goods_code,b.goods_code) goods_code,
c.goods_name,
--d.area_code,
d.area_name,
d.UNION_AREA_NAME,
c.CATEGORY,
c.COMPOSITION,
c.SUB_COMPOSITION,
--c.goods_code,
c.DOSAGE_FORM,
c.CONTENT,
c.LOAD,
c.FINISHING_SPECIFICATION,
c.FINISHING_MANUFACTURER,
c.BRAND_DEFINITION,
c.SPECIFICATION,
c.MANUFACTURER,
a.attribute,
a.TAX_PRICE,
a.num,
a.amount,
a.ml,
b.TAX_PRICE as CB,
b.SUPPLIER_NAME,
b.order_date,
e.area_price
from
(
select
a.area_code,
a.goods_code,
nvl(e.new_attribute, '未维护挂网目录') attribute,
TAX_PRICE,
sum(SALE_QTY) num,
sum(TAX_AMOUNT) amount,
sum(TAX_AMOUNT-TAX_COST) ml
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
left join dim_goods c on a.goods_code=c.goods_code
--left join dim_region d on a.area_code=d.area_code
left join dim_net_catalogue_general_all e ON 
A.AREA_CODE = e.AREA_CODE
AND 
A.GOODS_CODE = e.GOODS_CODE 
AND 
TO_CHAR(A.SALE_DATE,'YYYY-MM') = e.CREATE_MONTH 
where 
a.SALE_DATE between date'${date1}' and date'${date2}'
and b.attribute='直营'
${if(len(area)=0,"","and a.area_code IN ('"+area+"')")}
${if(len(cate)=0,"","and c.CATEGORY IN ('"+cate+"')")}
${if(len(cont)=0,"","and c.COMPOSITION IN ('"+cont+"')")}
${if(len(subcont)=0,"","and c.SUB_COMPOSITION IN ('"+subcont+"')")}
${if(len(goods)=0,"","and A.GOODS_CODE IN ('"+goods+"')")}
group by
a.area_code,
a.goods_code,
nvl(e.new_attribute, '未维护挂网目录'),
TAX_PRICE
)a 
left join
(
select a.AREA_CODE,a.GOODS_CODE,TAX_PRICE,SUPPLIER_NAME,order_date from
(select t.*,
ROW_NUMBER() OVER(partition by AREA_CODE,GOODS_CODE order by order_date desc nulls last) rn
 from
 FACT_PURCHASE t
 where procurement_type='采进'
 ) a left join dim_goods b on a.goods_code=b.goods_code
 where rn=1
 ${if(len(area)=0,"","and a.area_code IN ('"+area+"')")}
${if(len(cate)=0,"","and b.CATEGORY IN ('"+cate+"')")}
${if(len(cont)=0,"","and b.COMPOSITION IN ('"+cont+"')")}
${if(len(subcont)=0,"","and b.SUB_COMPOSITION IN ('"+subcont+"')")}
)b on a.area_code=b.area_code and a.goods_code=b.goods_code
left join dim_goods c on nvl(a.goods_code,b.goods_code)=c.goods_code
left join dim_region d on nvl(a.area_code,b.area_code)=d.area_code
left join(select max(area_price) area_price,area_code,goods_code from DIM_GOODS_MAPPING
where 1=1
 ${if(len(area)=0,"","and area_code IN ('"+area+"')")}
group by area_code,goods_code) e on a.area_code=e.area_code and a.goods_code=e.goods_code
order by a.area_code,c.CATEGORY,a.goods_code

select AREA_CODE,GOODS_CODE,TAX_PRICE,SUPPLIER_NAME,order_date from
(select t.*,
ROW_NUMBER() OVER(partition by AREA_CODE,GOODS_CODE order by order_date desc nulls last) rn
 from
 FACT_PURCHASE t)
 where rn=1

select 
distinct
CATEGORY
from 
dim_goods

select 
distinct
COMPOSITION
from 
dim_goods

select 
distinct
SUB_COMPOSITION
from 
dim_goods

select distinct
area_code,
area_name
from
dim_region

select max(area_price) area_price,area_code,goods_code from DIM_GOODS_MAPPING
where 1=1
 ${if(len(area)=0,"","and area_code IN ('"+area+"')")}
group by area_code,goods_code


select 
goods_code,
goods_name,
goods_code||'|'||goods_name
from dim_goods
order by goods_code

