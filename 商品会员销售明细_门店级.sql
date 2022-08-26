select 
goods_code,
area_code,
INSIDERID,
sum(SALE_QTY) SALE_QTY,
sum(tax_amount) tax_amount
from FACT_SALE_VIP
where sale_date>date'2019-10-01'
group by goods_code,
area_code,
INSIDERID

select 
*
from 
dim_goods

select 
distinct
INSIDERID,
INSIDERNAME,
IDCARD,
MOBILE,
INSIDERCARDNO,
MEMBERNO
 from 
dim_vip

select 
a.goods_code,
a.area_code,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name,
a.INSIDERID,
a.SALE_QTY,
a.tax_amount,
a.cnt,
b.goods_name，
b.specification,
b.manufacturer,
b.large_cate,
b.medium_cate,
b.small_cate,
b.unit,
b.product_place,
c.INSIDERNAME,
c.IDCARD,
c.MOBILE,
c.INSIDERCARDNO,
c.MEMBERNO  
from 
(
select 
a.goods_code,
a.area_code,
c.area_name,c.union_area_name,
a.cus_code,
b.cus_name,
a.INSIDERID,
count(distinct sale_date) cnt,
sum(SALE_QTY) SALE_QTY,
sum(tax_amount) tax_amount
from FACT_SALE_VIP a ,dim_cus b , dim_region c
where sale_date  between date'${date1}' and date'${date2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
${if(len(area)=0,"","and a.area_code IN ('"+area+"')")}
${if(len(cus)=0,"","and a.cus_code IN ('"+cus+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(insid)=0,"","and a.INSIDERID IN ('"+insid+"')")}
${if(len(union_area)=0,"","and c.union_area_name IN ('"+union_area+"')")}
group by a.goods_code,a.cus_code,b.cus_name,c.area_name,c.sorted,c.union_area_name,
a.area_code,
a.INSIDERID
order by c.sorted
)a 
left join
(
select 
*
from 
dim_goods
where 1=1
${if(len(manu)=0,"","and MANUFACTURER IN ('"+manu+"')")}
)b 
on a.goods_code=b.goods_code
left join
(
select 
INSIDERID,
INSIDERNAME,
IDCARD,
MOBILE,
INSIDERCARDNO,
MEMBERNO
 from 
dim_vip
where 
INSIDERNAME not  like '%公卡%' 
or INSIDERNAME not  like '%工卡%'
or INSIDERNAME not  like '%药店%'
or INSIDERNAME not  like '%药房%'
)c 
on a.INSIDERID=c.INSIDERID


select 
distinct
area_code,
area_name,
union_area_name
from dim_region

select distinct 
goods_code,
goods_code||'|'||goods_name as goods_name
from dim_goods
order by goods_code

select distinct
area_code,
cus_code，
cus_name
from dim_cus
where 1=1
${if(len(area)=0,"","and area_code IN ('"+area+"')")}

