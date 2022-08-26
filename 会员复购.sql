
with
his as 
(
select trim(a.cus_code) cus_code,b.cus_name,trim(a.area_code) area_code,c.area_name,c.union_area_name,e.goods_code,e.goods_name,
  a.SALE_DATE,a.tax_amount,a.no_tax_amount,a.tax_cost,a.no_tax_cost,tax_price,no_tax_price,
  a.area_code || a.vip_no as insiderid,
  a.SALE_QTY,
  trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
  from
  offline_ods_sale a ,dim_cus b,dim_region c ,DIM_GOODS_MAPPING d,dim_goods e 
  where trim(a.cus_code)=b.cus_code and trim(a.area_code)=c.area_code 
  and trim(a.area_code)=d.area_code and trim(a.goods_code)=d.AREA_GOODS_CODE
  and d.goods_code=e.goods_code
  and sale_date between date'${date1}' and date'${date2}'
    ${if(len(area)=0,"","and c.area_code IN ('"+area+"')")}
    ${if(len(uarea)=0,"","and c.union_area_name IN ('"+uarea+"')")}
	${if(len(cus)=0,"","and b.cus_code IN ('"+cus+"')")}
	${if(len(goods)=0,"","and e.goods_code IN ('"+goods+"')")}
	${if(len(ATTRIBUTE)=0,"","and b.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}     
	${if(len(cate)=0,"","and e.CATEGORY IN ('"+cate+"')")}
 
  union all

  select a.CUS_CODE,c.cus_name,c.area_code,d.area_name,d.union_area_name,a.goods_code,e.goods_name,
  a.SALE_DATE,a.tax_amount,a.no_tax_amount,a.tax_cost,a.no_tax_cost,tax_price,no_tax_price,
  to_char(b.insiderid) as insiderid,a.SALE_QTY,to_char(TRAN_NO) TRAN_NO
  from 
  ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_region d ,DIM_GOODS e 
  where a.tran_no = b.rsaid(+) and a.cus_code=c.cus_code and c.online_flag='1' 
  and c.area_code=d.area_code and a.goods_code=e.goods_code
  and  sale_date between date'${date1}' and date'${date2}'
	${if(len(area)=0,"","and c.area_code IN ('"+area+"')")}
	${if(len(uarea)=0,"","and d.union_area_name IN ('"+uarea+"')")}
	${if(len(cus)=0,"","and a.cus_code IN ('"+cus+"')")}
	${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
	${if(len(ATTRIBUTE)=0,"","and c.ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
	${if(len(cate)=0,"","and e.CATEGORY IN ('"+cate+"')")}
 
)

SELECT
a.area_code,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name,
a.no_tax_amount,
a.TRAN_NO,
a.no_tax_amount_v,
a.TRAN_NO_v,
a.pop,
b.pop_f
FROM 
(
select 
a.area_code,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name,
sum(no_tax_amount) no_tax_amount,
count(distinct TRAN_NO) TRAN_NO,
sum(case when b.insiderid is not null then  no_tax_amount end) no_tax_amount_v,
count(distinct case when b.insiderid is not null then TRAN_NO end) TRAN_NO_v,
count(distinct b.insiderid) pop
from 
his a ,dim_vip b
where 
a.insiderid=b.insiderid(+)
GROUP BY 
a.area_code,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name
)a
left join 
(
SELECT
a.area_code,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name,
COUNT(DISTINCT insiderid) pop_f
FROM 
(
  select 
  a.area_code,
  a.area_name,
  a.union_area_name,
  a.cus_code,
  a.cus_name,
  a.insiderid,
  count(distinct TRAN_NO) cc
  from 
  his a ,dim_vip b
  where 
  a.insiderid=b.insiderid
  group by 
  a.area_code,
  a.area_name,
  a.union_area_name,
  a.cus_code,
  a.cus_name,
  a.insiderid
  having count(distinct TRAN_NO)>1
)A 
GROUP BY a.area_code,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name
)b on a.area_code=b.area_code and a.cus_code=b.cus_code
order by a.area_code,a.cus_code

select 
area_code,
area_name
from
dim_region
WHERE 
1=1
${if(len(UAREA)=0,""," and UNION_AREA_NAME in ('"+UAREA+"')")}

select distinct
cus_code,
cus_name
from dim_cus
where 1=1
${if(len(area)=0,"","and area_code IN ('"+area+"')")}

select 
goods_code,
goods_name，
goods_code||'|'||goods_name
from dim_goods
order by goods_code

select 
distinct
CATEGORY
from
dim_goods

select 
distinct union_area_name
from
dim_region

