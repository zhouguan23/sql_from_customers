
with sale as 
(
select a.CUS_CODE,c.area_code,a.SALE_QTY,to_char(b.insiderid) as insiderid,to_char(TRAN_NO) TRAN_NO,SALE_DATE
,a.goods_code,a.TAX_AMOUNT,a.TAX_COST,f.days
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_goods g,DIM_DRUG_COMPLIANCE f
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and a.goods_code=g.goods_code and c.online_flag='1'
and a.goods_code=f.goods_code
and a.sale_date  between date'2020-01-01' and date'${date2}'
${if(len(area)=0,"","and c.area_code IN ('"+area+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and c.attribute IN ('"+attribute+"')")}
${if(len(cus)=0,"","and a.CUS_CODE IN ('"+cus+"')")}
union all
select trim(a.cus_code) cus_code,trim(a.area_code) area_code,a.SALE_QTY,a.area_code || a.vip_no as insiderid,trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
,SALE_DATE ,a.goods_code,a.TAX_AMOUNT,a.TAX_COST,f.days
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,dim_goods g ,DIM_DRUG_COMPLIANCE f
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code and c.goods_code=g.goods_code
and a.vip_no is not null and a.goods_code=f.goods_code
and a.sale_date  between date'2020-01-01' and date'${date2}'
${if(len(area)=0,"","and a.area_code IN ('"+area+"')")}
${if(len(goods)=0,"","and c.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
${if(len(cus)=0,"","and a.CUS_CODE IN ('"+cus+"')")}
)

select 
a.area_code,
c.area_name,
a.cus_code,
cus.cus_name,
a.TRAN_NUM,
a.TAX_AMOUNT,
a.TAX_ML,
a.SALE_QTY,
a.goods_code,
b.goods_name,
b.SPECIFICATION,
b.MANUFACTURER,
d.INSIDERNAME,
d.IDCARD,
d.MOBILE,
d.INSIDERCARDNO,
d.MEMBERNO ,
to_number(date'${date2}'-date'${date1}')  num,
e.sale_date,
e.SALE_QTY as l_sale_qty,
e.TAX_AMOUNT as l_TAX_AMOUNT,
f.SALE_QTY as total_sale_qty,
f.SALE_QTY*g.days as day_drug
from 
(
select 
a.area_code,
a.insiderid,
a.goods_code,
a.cus_code,
count(distinct TRAN_NO) TRAN_NUM,
sum(TAX_AMOUNT) TAX_AMOUNT,
sum(SALE_QTY) SALE_QTY,
sum(TAX_AMOUNT-TAX_COST) TAX_ML
from sale a 
where a.sale_date  between date'${date1}' and date'${date2}'
group by 
a.area_code,
a.insiderid,a.goods_code,a.cus_code
)a left join dim_goods b on a.goods_code=b.goods_code
left join dim_region c on a.area_code=c.area_code
left join dim_vip d on a.area_code=d.area_code and a.insiderid=d.insiderid
left join dim_cus cus on a.area_code=cus.area_code and a.cus_code=cus.cus_code
left join
(
select area_code,goods_code,insiderid,sale_date,,cus_code,sum(SALE_QTY) SALE_QTY,sum(TAX_AMOUNT) TAX_AMOUNT from
	(
	select area_code,goods_code,insiderid,SALE_QTY,TAX_AMOUNT,sale_date,
	ROW_NUMBER() OVER(partition by AREA_CODE,GOODS_CODE,insiderid,cus_code order by sale_date desc nulls last) rn
	from
	sale 
	) a 
where rn=1
group by area_code,goods_code,insiderid,sale_date,cus_code
)e on a.area_code=a.area_code and a.insiderid=e.insiderid and a.goods_code=e.goods_code and a.cus_code=e.cus_code
left join
(
select 
a.area_code,
a.insiderid,
a.goods_code,
a.cus_code,
sum(SALE_QTY) SALE_QTY 
from sale a 
group by 
a.area_code,
a.insiderid,a.goods_code,a.cus_code
)f on a.area_code=f.area_code and a.insiderid=f.insiderid and a.goods_code=f.goods_code and and a.cus_code=f.cus_code
left join DIM_DRUG_COMPLIANCE g on a.goods_code=g.goods_code
where 1=1
${if(len(vipno)=0,"","and d.INSIDERCARDNO IN ('"+vipno+"')")}
${if(len(union_area)=0,"","and c.union_area_name IN ('"+union_area+"')")}
order by a.area_code,a.goods_code

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
a.area_code,
c.area_name,
a.TRAN_NUM,
a.TAX_AMOUNT,
a.TAX_ML,
a.SALE_QTY,
b.goods_code,
b.goods_name,
b.SPECIFICATION,
b.MANUFACTURER,
d.INSIDERNAME,
d.IDCARD,
d.MOBILE,
d.INSIDERCARDNO,
d.MEMBERNO,
to_number(date'${date2}'-date'${date1}')  num
from 
(
select 
a.area_code,
a.insiderid,
a.goods_code,
count(distinct TRAN_NO) TRAN_NUM,
sum(TAX_AMOUNT) TAX_AMOUNT,
sum(SALE_QTY) SALE_QTY,
sum(TAX_AMOUNT-TAX_COST) TAX_ML
from
(
select a.CUS_CODE,c.area_code,a.SALE_QTY,to_char(b.insiderid) as insiderid,to_char(TRAN_NO) TRAN_NO,SALE_DATE
,a.goods_code,a.TAX_AMOUNT,a.TAX_COST
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_goods g
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and a.goods_code=g.goods_code and c.online_flag='1'
and a.sale_date  between date'${date1}' and date'${date2}'
union all
select trim(a.cus_code) cus_code,trim(a.area_code) area_code,a.SALE_QTY,a.area_code || a.vip_no as insiderid,trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
,SALE_DATE ,a.goods_code,a.TAX_AMOUNT,a.TAX_COST
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,dim_goods g 
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code and c.goods_code=g.goods_code
and a.vip_no is not null
and a.sale_date  between date'${date1}' and date'${date2}'
)a
group by 
a.area_code,
a.insiderid,a.goods_code
)a left join dim_goods b on a.goods_code=b.goods_code
left join dim_region c on a.area_code=c.area_code
left join dim_vip d on a.area_code=d.area_code and a.insiderid=d.insiderid

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

select 
a.sale_qty*b.days as daysn
from
(
select area_code,
insiderid,
goods_code,
sum(SALE_QTY) SALE_QTY
from 
(
select a.CUS_CODE,c.area_code,a.SALE_QTY,to_char(b.insiderid) as insiderid,to_char(TRAN_NO) TRAN_NO,SALE_DATE
,a.goods_code,a.TAX_AMOUNT,a.TAX_COST
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_goods g
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and a.goods_code=g.goods_code and c.online_flag='1'
and a.sale_date  between date'2020-01-01' and date'${date2}'
union all
select trim(a.cus_code) cus_code,trim(a.area_code) area_code,a.SALE_QTY,a.area_code || a.vip_no as insiderid,trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
,SALE_DATE ,a.goods_code,a.TAX_AMOUNT,a.TAX_COST
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,dim_goods g 
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code and c.goods_code=g.goods_code
and a.vip_no is not null
and a.sale_date  between date'2020-01-01' and date'${date2}'
)
group by area_code,
insiderid,
goods_code
) a ,DIM_DRUG_COMPLIANCE b
where a.goods_code=b.goods_code

