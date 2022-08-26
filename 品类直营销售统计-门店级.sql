with fs_now as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE  as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

fs_before as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE  as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
a.sale_date between add_months(date'${start_date}',-12) and add_months(date'${end_date}',-12)
and a.area_code=cus.area_code and a.cus_code=cus.cus_code and cus.attribute='直营'
and a.goods_code <> '0'
--and a.goods_code not like '6%'
${if(len(goods)=0,""," and a.goods_code not like '6%'")}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}

),

rk_data as 
(
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE  as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
--${if(len(area)=0,""," and a.area_code in ('"+area+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

rk as 
(select CATEGORY,
FUNCTION,
COMPOSITION,LARGE_CATE,
	 row_number() over(order by sum(tax_amount) desc nulls last) rank
from rk_data
group by CATEGORY,LARGE_CATE,
FUNCTION,
COMPOSITION),

su_now as 
(
select count(distinct goods_code) as sku1,
area_code,area_name,ss,
CATEGORY,LARGE_CATE,
FUNCTION,
COMPOSITION
from fs_now
group by 
area_code,area_name,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
),
su_before as 
(
select count(distinct goods_code) as sku2,
area_code,area_name,ss,
CATEGORY,LARGE_CATE,
FUNCTION,
COMPOSITION
from fs_before
group by 
area_code,area_name,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
)

select
su_now.area_code,
su_now.area_name,su_now.ss,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.LARGE_CATE,
su_now.sku1,
su_before.sku2
from 
rk,su_now left join su_before
on 
su_now.CATEGORY=su_before.CATEGORY and
su_now.FUNCTION=su_before.FUNCTION and
su_now.COMPOSITION=su_before.COMPOSITION and
su_now.area_code=su_before.area_code and
su_now.ss=su_before.ss and
su_now.LARGE_CATE=su_before.LARGE_CATE
where 
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.LARGE_CATE=rk.LARGE_CATE  and
rank <= '${rank}'
order by su_now.area_code

with fs_now as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE  as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

fs_before as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE  as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
a.sale_date between add_months(date'${start_date}',-12) and add_months(date'${end_date}',-12)
and a.area_code=cus.area_code and a.cus_code=cus.cus_code and cus.attribute='直营'
and a.goods_code <> '0'
--and a.goods_code not like '6%'
${if(len(goods)=0,""," and a.goods_code not like '6%'")}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}

),

rk as 
(select CATEGORY,
FUNCTION,
COMPOSITION,area_code,LARGE_CATE,
row_number() over(partition by area_code order by sum(tax_amount) desc ) rank
from fs_now
group by CATEGORY,area_code,LARGE_CATE,
FUNCTION,
COMPOSITION),

su_now as 
(
select count(distinct goods_code) as sku1,
area_code,area_name,ss,
CATEGORY,LARGE_CATE,
FUNCTION,
COMPOSITION
from fs_now
group by 
area_code,area_name,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
),
su_before as 
(
select count(distinct goods_code) as sku2,
area_code,area_name,ss,
CATEGORY,LARGE_CATE,
FUNCTION,
COMPOSITION
from fs_before
group by 
area_code,area_name,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
)

select
su_now.area_code,
su_now.area_name,su_now.ss,
su_now.LARGE_CATE,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.sku1,
su_before.sku2
from 
rk,su_now left join su_before
on
su_now.LARGE_CATE=su_before.LARGE_CATE and
su_now.CATEGORY=su_before.CATEGORY and
su_now.FUNCTION=su_before.FUNCTION and
su_now.COMPOSITION=su_before.COMPOSITION and
su_now.area_code=su_before.area_code and
su_now.ss=su_before.ss
where 
su_now.LARGE_CATE=rk.LARGE_CATE and
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.area_code=rk.area_code  and
rank <= '${rank}'
order by su_now.area_code

with fs_now as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

fs_before as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
a.sale_date between add_months(date'${start_date}',-12) and add_months(date'${end_date}',-12)
and a.area_code=cus.area_code and a.cus_code=cus.cus_code and cus.attribute='直营'
and a.goods_code <> '0'
--and a.goods_code not like '6%'
${if(len(goods)=0,""," and a.goods_code not like '6%'")}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}

),

rk as 
(select CATEGORY,
FUNCTION,
COMPOSITION,REGION,LARGE_CATE,
	 row_number() over(partition by REGION order by sum(tax_amount) desc ) rank
from fs_now
group by CATEGORY,REGION,LARGE_CATE,
FUNCTION,
COMPOSITION),

su_now as 
(
select count(distinct goods_code) as sku1,
area_code,area_name,REGION,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_now
group by 
area_code,area_name,REGION,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
),
su_before as 
(
select count(distinct goods_code) as sku2,
area_code,area_name,REGION,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_before
group by 
area_code,area_name,REGION,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
)

select
su_now.area_code,
su_now.area_name,su_now.ss,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.LARGE_CATE,
su_now.sku1,
su_before.sku2
from 
rk,su_now left join su_before
on
su_now.CATEGORY=su_before.CATEGORY and
su_now.FUNCTION=su_before.FUNCTION and
su_now.COMPOSITION=su_before.COMPOSITION and
su_now.area_code=su_before.area_code and
su_now.ss=su_before.ss and
su_now.LARGE_CATE=su_before.LARGE_CATE
where 
su_now.LARGE_CATE=rk.LARGE_CATE and
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.REGION=rk.REGION  and
rank <= '${rank}'
order by su_now.area_code

with fs_now as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

fs_before as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
LARGE_CATE,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather,ss
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
b.BIG_CATE as LARGE_CATE,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
case when cus.SHOP_AREA>=0 and cus.SHOP_AREA<80 then 'S'
when cus.SHOP_AREA>=80 and cus.SHOP_AREA<200 then 'M'
when cus.SHOP_AREA>=200  then 'L' end as ss,
decode(d.goods_code, null, '否', '是') as dtp,  
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
a.sale_date between add_months(date'${start_date}',-12) and add_months(date'${end_date}',-12)
and a.area_code=cus.area_code and a.cus_code=cus.cus_code and cus.attribute='直营'
and a.goods_code <> '0'
--and a.goods_code not like '6%'
${if(len(goods)=0,""," and a.goods_code not like '6%'")}
${if(len(area)=0,""," and a.area_code in ('"+area+"')")}

${if(len(cate)=0,""," and b.CATEGORY in ('"+cate+"')")}
${if(len(sub_cate)=0,""," and b.SUB_CATEGORY in ('"+sub_cate+"')")}
${if(len(func)=0,""," and b.FUNCTION in ('"+func+"')")}
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}

),

rk as 
(select CATEGORY,
FUNCTION,
COMPOSITION,PROVINCE,LARGE_CATE,
	 row_number() over(partition by PROVINCE order by sum(tax_amount) desc ) rank
from fs_now
group by CATEGORY,PROVINCE,LARGE_CATE,
FUNCTION,
COMPOSITION),

su_now as 
(
select count(distinct goods_code) as sku1,
area_code,area_name,PROVINCE,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_now
group by 
area_code,area_name,PROVINCE,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
),
su_before as 
(
select count(distinct goods_code) as sku2,
area_code,area_name,PROVINCE,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_before
group by 
area_code,area_name,PROVINCE,ss,LARGE_CATE,
CATEGORY,
FUNCTION,
COMPOSITION
)

select
su_now.area_code,
su_now.area_name,su_now.ss,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.LARGE_CATE,
su_now.sku1,
su_before.sku2
from 
rk,su_now left join su_before
on 
su_now.CATEGORY=su_before.CATEGORY and
su_now.FUNCTION=su_before.FUNCTION and
su_now.COMPOSITION=su_before.COMPOSITION and
su_now.area_code=su_before.area_code and
su_now.ss=su_before.ss and
su_now.LARGE_CATE=su_before.LARGE_CATE
where 
su_now.LARGE_CATE=rk.LARGE_CATE and
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.PROVINCE=rk.PROVINCE  and
rank <= '${rank}'
order by su_now.area_code

select distinct
CATEGORY,FUNCTION,COMPOSITION,SUB_CATEGORY,BIG_CATE
from 
dim_goods

