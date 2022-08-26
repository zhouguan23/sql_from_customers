
select 
a.*,

b.上期采购数量,
b.上期采购金额,
b.上期直营销售数量,
b.上期直营销售含税额,
b.上期直营毛利额,
b.上期直营配送数量,
b.上期直营配送金额,
b.上期加盟销售数量,
b.上期加盟销售含税金额,
b.上期加盟毛利额,
b.上期加盟配送数量,
b.上期加盟配送金额,
b.上期批发配送数量,
b.上期批发配送金额,
d.AREA_NAME,
d.union_area_name,
e.NEW_ATTRIBUTE,
f.SPECIFICATION,
f.MANUFACTURER,
f.SUB_COMPOSITION,
f.DOSAGE_FORM,
f.FINISHING_SPECIFICATION,
f.FINISHING_MANUFACTURER,
f.CONTENT,
f.LOAD,
f.BIG_CATE,
f.CATEGORY,
f.SUB_CATEGORY,
f.COMPOSITION
from 
(
select
a.AREA_CODE,
a.GOODS_CODE,
a.GOODS_NAME,
-- a.date1,
sum(a.CG_QTY) as 采购数量,
sum(a.CG_AMOUNT) as 采购金额,
sum(a.ZYXS_QTY) as 直营销售数量,
sum(a.ZYXS_TAX_AMOUNT) as 直营销售含税额,
sum(a.ZYXS_TAX_AMOUNT-a.ZYXS_TAX_COST) as 直营毛利额,
sum(a.ZYPS_QTY) as 直营配送数量,
sum(a.ZYPS_TAX_AMOUNT) as 直营配送金额,

sum(a.JMXS_QTY) as 加盟销售数量,
sum(a.JMXS_TAX_AMOUNT) as 加盟销售含税金额,
sum(a.JMXS_TAX_AMOUNT-a.JMXS_TAX_COST) as 加盟毛利额,
sum(a.JMPS_QTY) as 加盟配送数量,
sum(a.JMPS_TAX_AMOUNT) as 加盟配送金额,
sum(a.PFPS_QTY) as 批发配送数量,
sum(a.PFPS_TAX_AMOUNT) as 批发配送金额

from
DM_PURCHASE_SALE_STOCK_GOODS a
where date1>='${date}' and date1<='${date1}'
group by a.AREA_CODE,
a.GOODS_CODE,
a.GOODS_NAME
)a 
left join
(
select
a.AREA_CODE,
a.GOODS_CODE,
sum(a.CG_QTY) as 上期采购数量,
sum(a.CG_AMOUNT) as 上期采购金额,
sum(a.ZYXS_QTY) as 上期直营销售数量,
sum(a.ZYXS_TAX_AMOUNT) as 上期直营销售含税额,
sum(a.ZYXS_TAX_AMOUNT-a.ZYXS_TAX_COST) as 上期直营毛利额,
sum(a.ZYPS_QTY) as 上期直营配送数量,
sum(a.ZYPS_TAX_AMOUNT) as 上期直营配送金额,

sum(a.JMXS_QTY) as 上期加盟销售数量,
sum(a.JMXS_TAX_AMOUNT) as 上期加盟销售含税金额,
sum(a.JMXS_TAX_AMOUNT-a.JMXS_TAX_COST) as 上期加盟毛利额,
sum(a.JMPS_QTY) as 上期加盟配送数量,
sum(a.JMPS_TAX_AMOUNT) as 上期加盟配送金额,
sum(a.PFPS_QTY) as 上期批发配送数量,
sum(a.PFPS_TAX_AMOUNT) as 上期批发配送金额

from
DM_PURCHASE_SALE_STOCK_GOODS a
where date1>=to_char(ADD_MONTHS(TO_DATE('${date}','YYYY-MM'),-12),'YYYY-MM') and date1<=to_char(ADD_MONTHS(TO_DATE('${date1}','YYYY-MM'),-12),'YYYY-MM')
group by a.AREA_CODE,
a.GOODS_CODE
)b on a.AREA_CODE=b.AREA_CODE and a.GOODS_CODE=b.GOODS_CODE
left join 
dim_region d on a.area_code=d.area_code
left join 
DIM_NET_CATALOGUE_GENERAL_ALL e on a.area_code=e.area_code and a.goods_code=e.goods_code and e.CREATE_MONTH='${date1}'
left join DIM_GOODS f on a.goods_code=f.goods_code
where 
1=1
${if(len(aname)=0,""," and d.AREA_NAME in ('"+aname+"')")} and
1=1 
${if(len(uname)=0,""," and d.union_area_name in ('"+uname+"')")} and 
1=1
${if(len(subcom)=0,""," and f.SUB_COMPOSITION in ('"+subcom+"')")} and 
1=1
${if(len(form)=0,""," and f.DOSAGE_FORM in ('"+form+"')")} and 
1=1
${if(len(spe)=0,""," and f.SPECIFICATION in ('"+spe+"')")} and 
1=1
${if(len(man)=0,""," and f.MANUFACTURER in ('"+man+"')")} and 
1=1
${if(len(gcode)=0,""," and a.GOODS_CODE in ('"+gcode+"')")} and 
1=1
${if(len(gname)=0,""," and a.GOODS_NAME in ('"+gname+"')")} 
order by a.AREA_CODE,a.GOODS_CODE

select 
distinct
SUB_COMPOSITION,
DOSAGE_FORM,
SPECIFICATION,
MANUFACTURER,
GOODS_CODE,
GOODS_NAME,
GOODS_CODE||'|'||goods_name
from 
dim_goods
order by goods_code

select 
distinct
AREA_NAME,
union_area_name
from
dim_region



with all_good as (
select 
a.area_code,
a.goods_code,
a.attribute,
a.date1,
a.ORDER_QTY,
a.采购含税金额,
a.SALE_QTY,
a.TAX_AMOUNT,
a.含税毛利额,
a.Delivery_QTY,
a.配送金额
from
(
  select a.area_code,goods_code,'直营' as attribute, ORDER_DATE date1,ORDER_QTY,TAX_AMOUNT as 采购含税金额,0 as SALE_QTY,0 as TAX_AMOUNT,0as 含税毛利额,0 as Delivery_QTY,0 as 配送金额 from FACT_PURCHASE a 
  where ORDER_DATE=date'2019-06-01'  
  union all 
  select a.area_code,goods_code,b.attribute,sale_date date1,0 as ORDER_QTY,0 as 采购含税金额,SALE_QTY,TAX_AMOUNT,TAX_AMOUNT-TAX_COST as 含税毛利额,0 as Delivery_QTY,0 as 配送金额 FROM FACT_SALE A
  inner join dim_cus b on a.cus_Code=b.cus_code
  and A.AREA_CODE=B.AREA_CODE
  where SALE_DATE=date'2019-06-01'
  -- and b.attribute='直营'
  union all
  select a.area_code,a.goods_code,b.attribute,sale_date date1,0 as ORDER_QTY,0 as 采购含税金额,0 as SALE_QTY,0 as TAX_AMOUNT,0 as 含税毛利额,Delivery_QTY,TAX_AMOUNT as 配送金额  FROM FACT_delivery a 
  inner join dim_cus b on a.cus_Code=b.cus_code
  and A.AREA_CODE=B.AREA_CODE
  where sale_date=date'2019-06-01'
  -- and b.attribute='直营'

)a
),
all_good_last as 
(
select 
a.area_code,
a.goods_code,
a.attribute,
a.date1,
a.ORDER_QTY,
a.采购含税金额,
a.SALE_QTY,
a.TAX_AMOUNT,
a.含税毛利额,
a.Delivery_QTY,
a.配送金额
from
(
  select a.area_code,goods_code,'直营' as attribute, ORDER_DATE date1,ORDER_QTY,TAX_AMOUNT as 采购含税金额,0 as SALE_QTY,0 as TAX_AMOUNT,0as 含税毛利额,0 as Delivery_QTY,0 as 配送金额 from FACT_PURCHASE a 
  where ORDER_DATE=date'2018-06-01'  
  union all 
  select a.area_code,goods_code,b.attribute,sale_date date1,0 as ORDER_QTY,0 as 采购含税金额,SALE_QTY,TAX_AMOUNT,TAX_AMOUNT-TAX_COST as 含税毛利额,0 as Delivery_QTY,0 as 配送金额 FROM FACT_SALE A
  inner join dim_cus b on a.cus_Code=b.cus_code
  and A.AREA_CODE=B.AREA_CODE
  where SALE_DATE=date'2018-06-01'
  -- and b.attribute='直营'
  union all
  select a.area_code,a.goods_code,b.attribute,sale_date date1,0 as ORDER_QTY,0 as 采购含税金额,0 as SALE_QTY,0 as TAX_AMOUNT,0 as 含税毛利额,Delivery_QTY,TAX_AMOUNT as 配送金额  FROM FACT_delivery a 
  inner join dim_cus b on a.cus_Code=b.cus_code
  and A.AREA_CODE=B.AREA_CODE
  where sale_date=date'2018-06-01'
  -- and b.attribute='直营'

)a
)
select 
a.*,
b.采购数量 as 上期采购数量,
b.采购含税金额 as 上期采购含税金额,
b.销售数量 as 上期销售数量,-- 销售数量
b.含税金额 as 上期含税金额,
b.含税毛利额 as 上期含税毛利额,
b.配送数量 as 上期配送数量,-- 配送数量
b.配送金额 as 上期配送金额,
b.加盟销售数量 as 上期加盟销售数量,-- 销售数量
b.加盟含税金额 as 上期加盟含税金额,
b.加盟含税毛利额 as 上期加盟含税毛利额,
b.加盟配送数量 as 上期加盟配送数量,-- 配送数量
b.加盟配送金额 as 上期加盟配送金额,
d.union_area_name,
e.NEW_ATTRIBUTE
from 
(
  select 
  a.*,
  b.采购数量,
  b.采购含税金额,
  b.销售数量,-- 销售数量
  b.含税金额,
  b.含税毛利额,
  b.配送数量,-- 配送数量
  b.配送金额,
  c.销售数量 as 加盟销售数量,-- 销售数量
  c.含税金额 as 加盟含税金额,
  c.含税毛利额 as 加盟含税毛利额,
  c.配送数量 as 加盟配送数量,-- 配送数量
  c.配送金额 as 加盟配送金额
  from 
  (
  select 
  distinct
  area_code,
  goods_code
  from all_good 
  )a left join 
  (
  select 
  area_code,
  goods_code,
  sum(ORDER_QTY) as 采购数量,
  sum(TAX_AMOUNT) as 采购含税金额,
  sum(SALE_QTY) as  销售数量,-- 销售数量
  sum(TAX_AMOUNT) as 含税金额,
  sum(含税毛利额) as 含税毛利额,
  sum(Delivery_QTY) as 配送数量,-- 配送数量
  sum(配送金额) as 配送金额
  from all_good
  where attribute='直营'
  group by area_code,goods_code
  )b on a.area_code=b.area_code and a.goods_code=b.goods_code
  left join 
  (
  select 
  area_code,
  goods_code,
  sum(SALE_QTY) as  销售数量,-- 销售数量
  sum(TAX_AMOUNT) as 含税金额,
  sum(含税毛利额) as 含税毛利额,
  sum(Delivery_QTY) as 配送数量,-- 配送数量
  sum(配送金额) as 配送金额
  from all_good
  where attribute='加盟'
  group by area_code,goods_code
  )c on a.area_code=c.area_code and a.goods_code=c.goods_code
)a 
left join
(
  select 
  a.*,
  b.采购数量,
  b.采购含税金额,
  b.销售数量,-- 销售数量
  b.含税金额,
  b.含税毛利额,
  b.配送数量,-- 配送数量
  b.配送金额,
  c.销售数量 as 加盟销售数量,-- 销售数量
  c.含税金额 as 加盟含税金额,
  c.含税毛利额 as 加盟含税毛利额,
  c.配送数量 as 加盟配送数量,-- 配送数量
  c.配送金额 as 加盟配送金额
  from 
  (
  select 
  distinct
  area_code,
  goods_code
  from all_good_last 
  )a left join 
  (
  select 
  area_code,
  goods_code,
  sum(ORDER_QTY) as 采购数量,
  sum(TAX_AMOUNT) as 采购含税金额,
  sum(SALE_QTY) as  销售数量,-- 销售数量
  sum(TAX_AMOUNT) as 含税金额,
  sum(含税毛利额) as 含税毛利额,
  sum(Delivery_QTY) as 配送数量,-- 配送数量
  sum(配送金额) as 配送金额
  from all_good_last
  where attribute='直营'
  group by area_code,goods_code
  )b on a.area_code=b.area_code and a.goods_code=b.goods_code
  left join 
  (
  select 
  area_code,
  goods_code,
  sum(SALE_QTY) as  销售数量,-- 销售数量
  sum(TAX_AMOUNT) as 含税金额,
  sum(含税毛利额) as 含税毛利额,
  sum(Delivery_QTY) as 配送数量,-- 配送数量
  sum(配送金额) as 配送金额
  from all_good_last
  where attribute='加盟'
  group by area_code,goods_code
  )c on a.area_code=c.area_code and a.goods_code=c.goods_code   
)b on a.area_code=b.area_code and a.goods_code=b.goods_code
left join 
dim_region d on a.area_code=d.area_code
left join 
DIM_NET_CATALOGUE_GENERAL_ALL e on a.area_code=e.area_code and a.goods_code=e.goods_code

