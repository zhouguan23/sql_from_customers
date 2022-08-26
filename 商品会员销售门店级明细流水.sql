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
a.cus_code,
a.cus_name,
a.union_area_name,
a.INSIDERID,
a.SALE_QTY,
a.tax_amount,
a.tax_ml,
a.TRAN_NO,
a.sale_date,
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
c.area_name,
b.cus_code,
b.cus_name,
c.union_area_name,
a.INSIDERID,
a.TRAN_NO,
a.sale_date,
sum(SALE_QTY) SALE_QTY,
sum(tax_amount) tax_amount,
sum(tax_amount-TAX_COST) tax_ml
from (
select a.CUS_CODE,c.area_code,a.SALE_QTY,to_char(b.insiderid) as insiderid,to_char(TRAN_NO) TRAN_NO,SALE_DATE,
a.goods_code,a.tax_amount,a.TAX_COST
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_goods g
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and a.goods_code=g.goods_code
and SALE_DATE between date'${date1}' and date'${date2}' 
${if(len(area)=0,"","and c.area_code IN ('"+area+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and c.attribute IN ('"+attribute+"')")}
${if(len(manu)=0,"","and g.MANUFACTURER IN ('"+manu+"')")}
union all
select trim(a.cus_code) cus_code,trim(a.area_code) area_code,a.SALE_QTY,a.area_code || a.vip_no as insiderid,
trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
,SALE_DATE,g.goods_code,a.tax_amount,a.TAX_COST
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,dim_goods g 
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code and c.goods_code=g.goods_code
and SALE_DATE between date'${date1}' and date'${date2}' 
${if(len(area)=0,"","and trim(a.area_code) IN ('"+area+"')")}
${if(len(goods)=0,"","and c.goods_code IN ('"+goods+"')")}
${if(len(manu)=0,"","and g.MANUFACTURER IN ('"+manu+"')")}
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
and a.vip_no is not null
)a ,dim_cus b ,dim_region c 
where 1=1
and a.area_code=b.area_code 
and a.cus_code=b.cus_code
and a.area_code=c.area_code
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
${if(len(area)=0,"","and a.area_code IN ('"+area+"')")}
${if(len(cus)=0,"","and a.cus_code IN ('"+cus+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(insid)=0,"","and a.INSIDERID IN ('"+insid+"')")}
${if(len(union_area)=0,"","and c.union_area_name IN ('"+union_area+"')")}
group by a.goods_code,c.area_name,c.union_area_name,b.cus_code,
b.cus_name,
a.area_code,
a.INSIDERID,
a.TRAN_NO,
a.sale_date
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
MEMBERNO,
area_code
 from 
dim_vip

)c 
on a.INSIDERID=c.INSIDERID and a.area_code=c.area_code
where 1=1
${if(len(vipno)=0,"","and c.INSIDERCARDNO IN ('"+vipno+"')")}
and
(INSIDERNAME not  like '%公卡%' 
or INSIDERNAME not  like '%工卡%'
or INSIDERNAME not  like '%药店%'
or INSIDERNAME not  like '%药房%')
order by a.area_code,a.goods_code

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

