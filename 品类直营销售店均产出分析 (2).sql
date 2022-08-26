with aa as(
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
MANUFACTURER,
goods_name,
area_name,
REGION,
PROVINCE,
tax_amount,
no_tax_amount,
tax_ml,
no_tax_ml,
dtp,
cus_code,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.MANUFACTURER,
b.goods_name,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
a.no_tax_amount,
a.tax_amount-a.TAX_COST as tax_ml,
a.no_tax_amount-a.NO_TAX_COST as no_tax_ml,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
cus.cus_code,
(
	case
	when e.new_attribute is null then
	'地采'
	else
	e.new_attribute
	end
) as gather
from 
dim_cus cus,fact_sale a
left join
dim_goods b on a.goods_code=b.goods_code
left join 
dim_region c on a.area_code=c.area_code
left join 
dim_dtp d 
on to_char(add_months(a.sale_date, -1), 'YYYY-MM') = d.create_month
and a.area_code = d.area_code
and a.goods_code = d.goods_code 
left join dim_net_catalogue_general_all e 
on a.goods_code = e.goods_code
and a.area_code = e.area_code
and to_char(a.sale_date, 'YYYY-MM') = e.create_month
where 
a.sale_date between date'${start_date}' and date'${end_date}'
and a.area_code=cus.area_code and a.cus_code=cus.cus_code and cus.attribute='直营'
and a.goods_code <> '0'
--and a.goods_code not like '6%'
${if(len(goods)=0,""," and a.goods_code not like '6%'")}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.LARGE_CATE in ('"+big_cate+"')")}
--${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
${if(len(comp)=0,""," and b.COMPOSITION in ('"+comp+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

aa_comp as 
(
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
MANUFACTURER,
goods_name,
area_name,
REGION,
PROVINCE,
tax_amount,
no_tax_amount,
tax_ml,
no_tax_ml,
dtp,
cus_code,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.MANUFACTURER,
b.goods_name,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
a.no_tax_amount,
a.tax_amount-a.TAX_COST as tax_ml,
a.no_tax_amount-a.NO_TAX_COST as no_tax_ml,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
cus.cus_code,
(
	case
	when e.new_attribute is null then
	'地采'
	else
	e.new_attribute
	end
) as gather
from 
dim_cus cus,fact_sale a
left join
dim_goods b on a.goods_code=b.goods_code
left join 
dim_region c on a.area_code=c.area_code
left join 
dim_dtp d 
on to_char(add_months(a.sale_date, -1), 'YYYY-MM') = d.create_month
and a.area_code = d.area_code
and a.goods_code = d.goods_code 
left join dim_net_catalogue_general_all e 
on a.goods_code = e.goods_code
and a.area_code = e.area_code
and to_char(a.sale_date, 'YYYY-MM') = e.create_month
where 
a.sale_date between date'${start_date}' and date'${end_date}'
and a.area_code=cus.area_code and a.cus_code=cus.cus_code and cus.attribute='直营'
and a.goods_code <> '0'
--and a.goods_code not like '6%'
${if(len(goods)=0,""," and a.goods_code not like '6%'")}
${if(len(area_comp)=0,""," and a.area_code in ('"+area_comp+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.LARGE_CATE in ('"+big_cate+"')")}
--${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
${if(len(comp)=0,""," and b.COMPOSITION in ('"+comp+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),
amount as
(
select 
ss,
CATEGORY, 
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as tax_amount,
(case when '${Tax}'='无税' then sum(no_tax_ml) else sum(tax_ml) end) as tax_ml,
count(distinct cus_code) cus
from aa
group by ss,CATEGORY 
),
amount_comp as
(
select 
ss,
CATEGORY ,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as tax_amount,
(case when '${Tax}'='无税' then sum(no_tax_ml) else sum(tax_ml) end) as tax_ml,
count(distinct cus_code) cus
from aa_comp
group by ss,CATEGORY 
)


select 
 
amount.ss,
amount.CATEGORY,
amount.tax_amount,
amount.tax_ml,
amount.cus,
amount_comp.tax_amount as tax_amount_comp,
amount_comp.tax_ml as tax_ml_comp,
amount_comp.cus as cus_comp
from amount,amount_comp
where 
amount.ss=amount_comp.ss and 
amount.CATEGORY=amount_comp.CATEGORY 
order by amount.ss desc,amount.CATEGORY 

select 
CATEGORY,
SUB_CATEGORY,
BIG_CATE,
FUNCTION,
COMPOSITION,
COMPOSITION
from dim_goods
order by CATEGORY

select a.sorted,a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
--${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by a.sorted

