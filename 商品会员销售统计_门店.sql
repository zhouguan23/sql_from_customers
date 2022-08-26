
    
select r.union_area_name,
a.CUS_CODE,a.area_code,
count(distinct a.insiderid) pop,
sum(SALE_QTY) qty,
count(distinct TRAN_NO) cnt
from
(
select a.CUS_CODE,c.area_code,a.SALE_QTY,to_char(b.insiderid) as insiderid,to_char(TRAN_NO) TRAN_NO,SALE_DATE
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and c.online_flag='1'
and SALE_DATE between date'${date1}' and date'${date2}' 
${if(len(cus)=0,"","and a.cus_code IN ('"+cus+"')")}
 ${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
  ${if(len(attribute)=0,"","and c.attribute IN ('"+attribute+"')")}
  ${if(len(area)=0,"","and c.area_code IN ('"+area+"')")}
union all
select trim(a.cus_code) cus_code,trim(a.area_code) area_code,a.SALE_QTY,a.area_code || a.vip_no as insiderid,trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
,SALE_DATE 
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c
where trim(a.cus_code)=b.cus_code
and trim(a.area_code)=b.area_code
and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code
and SALE_DATE between date'${date1}' and date'${date2}' 
${if(len(cus)=0,"","and b.cus_code IN ('"+cus+"')")}
${if(len(goods)=0,"","and c.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
${if(len(area)=0,"","and trim(a.area_code) IN ('"+area+"')")}
)a     
left join dim_region r
on a.area_code=r.area_code
left join (select * from USER_AUTHORITY) c
on (r.UNION_AREA_NAME=c.UNION_AREA_NAME or c.UNION_AREA_NAME='ALL')
where 1=1
and ${"c.user_id='"+$fr_username+"'"}
${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")}
and a.area_code is not null
group by r.union_area_name,r.sorted,
a.CUS_CODE,a.area_code
order by r.sorted


    
select
a.CUS_CODE,a.area_code,
count(distinct a.insiderid) pop,
sum(SALE_QTY) qty,
count(distinct TRAN_NO) cnt
from
(
select a.CUS_CODE,c.area_code,a.SALE_QTY,to_char(b.insiderid) as insiderid,to_char(TRAN_NO) TRAN_NO,SALE_DATE
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_region r
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and c.online_flag='1'
and c.area_code=r.area_code
and SALE_DATE between  date'${date1_before}' and date'${date2_before}'
${if(len(cus)=0,"","and a.cus_code IN ('"+cus+"')")} 
${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and c.attribute IN ('"+attribute+"')")}
union all
select trim(a.cus_code) cus_code,trim(a.area_code) area_code,a.SALE_QTY,a.area_code || a.vip_no as insiderid,trim(case when tran_no like '%|%' then substr(tran_no, 1, instr(tran_no, '|') - 1) else TRAN_NO END) TRAN_NO
,SALE_DATE 
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,dim_region r
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code
and b.area_code=r.area_code
and SALE_DATE between date'${date1_before}' and date'${date2_before}'
${if(len(cus)=0,"","and trim(a.cus_code) IN ('"+cus+"')")}
${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")}
${if(len(goods)=0,"","and c.goods_code IN ('"+goods+"')")} 
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
)a     
group by 
a.CUS_CODE,a.area_code


select
count(*) fg_pop
,a.CUS_CODE,a.area_code
from
(
select distinct to_char(b.insiderid) as insiderid,c.CUS_CODE,c.area_code
from 
ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_region r
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and c.online_flag='1'
and c.area_code=r.area_code
and SALE_DATE between date'${date1_before}' and date'${date2_before}' 
${if(len(cus)=0,"","and c.cus_code IN ('"+cus+"')")}
${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and c.attribute IN ('"+attribute+"')")}
union all
select distinct a.area_code || a.vip_no as insiderid,trim(a.cus_code) cus_code,trim(a.area_code) area_code
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,
dim_region r
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code 
and b.area_code=r.area_code
and SALE_DATE between date'${date1_before}' and date'${date2_before}'
${if(len(cus)=0,"","and trim(a.cus_code) IN ('"+cus+"')")} 
${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")}
${if(len(goods)=0,"","and c.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
)a,
(
select distinct to_char(b.insiderid) as insiderid,c.cus_code,c.area_code
from 
v_ods_sale_online a , gresa_sa_doc b ,dim_cus c,dim_region r
where a.tran_no = b.rsaid and a.cus_code=c.cus_code and c.online_flag='1'
and c.area_code=r.area_code
and SALE_DATE between date'${date1}' and date'${date2}'  ${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")}
${if(len(cus)=0,"","and c.cus_code IN ('"+cus+"')")}
${if(len(goods)=0,"","and a.goods_code IN ('"+goods+"')")}
${if(len(attribute)=0,"","and c.attribute IN ('"+attribute+"')")}
union all
select distinct a.area_code || a.vip_no as insiderid,trim(a.cus_code) cus_code,trim(a.area_code) area_code
from
offline_ods_sale a ,dim_cus b,DIM_GOODS_MAPPING c,dim_region r
where trim(a.cus_code)=b.cus_code and trim(a.goods_code)=c.AREA_GOODS_CODE 
and trim(a.area_code)=c.area_code
and b.area_code=r.area_code
and SALE_DATE between date'${date1}' and date'${date2}'${if(len(union_area)=0,"","and r.union_area_name IN ('"+union_area+"')")} 
${if(len(cus)=0,"","and trim(a.cus_code) IN ('"+cus+"')")}
${if(len(goods)=0,"","and c.goods_code IN ('"+goods+"')")} 
${if(len(attribute)=0,"","and b.attribute IN ('"+attribute+"')")}
)b where 
a.insiderid=b.insiderid
and a.cus_code=b.cus_code 
and a.area_code=b.area_code
group by a.CUS_CODE,a.area_code

select distinct 
goods_code,
goods_code||'|'||goods_name||'|'||MANUFACTURER as goods_name
from dim_goods
order by goods_code

select 
distinct
MANUFACTURER
from 
dim_goods

select distinct
a.area_code,
b.area_name,
b.UNION_AREA_NAME,
cus_code,
cus_name,
cus_code||'|'||cus_name
from dim_cus a,dim_region b,(select * from USER_AUTHORITY) c
where 1=1 and a.area_code=b.area_code
and (b.UNION_AREA_NAME=c.UNION_AREA_NAME or c.UNION_AREA_NAME='ALL')
and ${"c.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,""," and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
order by area_code,cus_code


select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
and 1=1
${if(len(union_area)=0,"","and a.union_area_name IN ('"+union_area+"')")}




select date'${date1}'-1 date1_before,
date'${date1}'-1-(date'${date2}'-date'${date1}') date2_before
from dual

