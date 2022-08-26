with fs_now as (
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
dtp,
cus_code,
gather
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
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),

rk_data as (
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
dtp,
cus_code,
gather
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
COMPOSITION,
MANUFACTURER,
goods_code,
goods_name,
row_number() over(order by sum(tax_amount) desc ) rank
from rk_data
group by CATEGORY,MANUFACTURER,
FUNCTION,
goods_code,
goods_name,
COMPOSITION),

su_now as 
(
select count(distinct cus_code) as cus_cnt,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as tax_amount,
area_code,area_name,
CATEGORY,
FUNCTION,
COMPOSITION,
goods_code,
goods_name,
MANUFACTURER
from fs_now
group by 
area_code,area_name,MANUFACTURER,
CATEGORY,
FUNCTION,
goods_code,
goods_name,
COMPOSITION
),

su_tol as
(
select area_code,count(distinct cus_code) as cus_cnt1
from dim_cus
where attribute='直营'
group by area_code
)

select
su_now.area_code,
su_now.area_name,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.MANUFACTURER,
su_now.cus_cnt,su_now.tax_amount,
su_now.goods_code,
su_now.goods_name,
su_tol.cus_cnt1
from 
rk,su_now left join su_tol
on 
su_now.area_code=su_tol.area_code
where 
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and 
su_now.MANUFACTURER=rk.MANUFACTURER and 
su_now.goods_code=rk.goods_code  and
rank <= '${rank}'
order by su_now.area_code asc,su_now.tax_amount desc

with fs_now as (
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
dtp,
cus_code,
gather
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
${if(len(big_cate)=0,""," and b.BIG_CATE in ('"+big_cate+"')")}
)
where 1=1
${if(len(dtp)=0,""," and dtp in ('"+dtp+"')")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
),


rk as 
(select CATEGORY,
MANUFACTURER,
FUNCTION,
goods_code,
goods_name,
COMPOSITION,area_code,
sum(tax_amount) tax_amount,
row_number() over(partition by area_code order by sum(tax_amount) desc ) rank
from fs_now
group by CATEGORY,MANUFACTURER,area_code,
FUNCTION,
goods_code,
goods_name,
COMPOSITION),

su_now as 
(
select count(distinct cus_code) as cus_cnt,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as tax_amount,
area_code,area_name,
CATEGORY,MANUFACTURER,
FUNCTION,
goods_code,
goods_name,
COMPOSITION
from fs_now
group by 
area_code,area_name,
CATEGORY,MANUFACTURER,
FUNCTION,
goods_code,
goods_name,
COMPOSITION
),

su_tol as
(
select area_code,count(distinct cus_code) as cus_cnt1
from dim_cus
where attribute='直营'
group by area_code
)

select
su_now.area_code,
su_now.area_name,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,su_now.MANUFACTURER,
su_now.cus_cnt,su_now.tax_amount,
su_now.goods_code,
su_now.goods_name,
su_tol.cus_cnt1
from 
rk,su_now left join su_tol
on 
su_now.area_code=su_tol.area_code
where 
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.area_code=rk.area_code and 
su_now.MANUFACTURER=rk.MANUFACTURER and 
su_now.goods_code=rk.goods_code  and
rank <= '${rank}'
order by su_now.area_code asc,su_now.tax_amount desc

with fs_now as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
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
and a.goods_code not like '6%'
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
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
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
and a.goods_code not like '6%'
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
COMPOSITION,REGION,sum(tax_amount) tax_amount,
	 row_number() over(partition by REGION order by sum(tax_amount) desc ) rank
from fs_now
group by CATEGORY,REGION,
FUNCTION,
COMPOSITION),

su_now as 
(
select count(distinct goods_code) as sku1,
area_code,area_name,REGION,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_now
group by 
area_code,area_name,REGION,
CATEGORY,
FUNCTION,
COMPOSITION
),
su_before as 
(
select count(distinct goods_code) as sku2,
area_code,area_name,REGION,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_before
group by 
area_code,area_name,REGION,
CATEGORY,
FUNCTION,
COMPOSITION
)

select
su_now.area_code,
su_now.area_name,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.sku1,
su_before.sku2,rk.tax_amount
from 
rk,su_now left join su_before
on
su_now.CATEGORY=su_before.CATEGORY and
su_now.FUNCTION=su_before.FUNCTION and
su_now.COMPOSITION=su_before.COMPOSITION and
su_now.area_code=su_before.area_code
where 
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.REGION=rk.REGION  and
rank <= '${rank}'
order by su_now.area_code,rk.tax_amount

with fs_now as (
select 
goods_code,
area_code,
CATEGORY,
FUNCTION,
COMPOSITION,
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
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
and a.goods_code not like '6%'
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
area_name,
REGION,
PROVINCE,
tax_amount,
dtp,
gather
from
(
select 
a.goods_code,
a.area_code,
b.CATEGORY,
b.FUNCTION,
b.COMPOSITION,
c.area_name,
c.REGION,
c.PROVINCE,
a.tax_amount,
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
and a.goods_code not like '6%'
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
COMPOSITION,PROVINCE,sum(tax_amount) tax_amount,
	 row_number() over(partition by PROVINCE order by sum(tax_amount) desc ) rank
from fs_now
group by CATEGORY,PROVINCE,
FUNCTION,
COMPOSITION),

su_now as 
(
select count(distinct goods_code) as sku1,
area_code,area_name,PROVINCE,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_now
group by 
area_code,area_name,PROVINCE,
CATEGORY,
FUNCTION,
COMPOSITION
),
su_before as 
(
select count(distinct goods_code) as sku2,
area_code,area_name,PROVINCE,
CATEGORY,
FUNCTION,
COMPOSITION
from fs_before
group by 
area_code,area_name,PROVINCE,
CATEGORY,
FUNCTION,
COMPOSITION
)

select
su_now.area_code,
su_now.area_name,
su_now.CATEGORY,
su_now.FUNCTION,
su_now.COMPOSITION,
su_now.sku1,
su_before.sku2,rk.tax_amount
from 
rk,su_now left join su_before
on
su_now.CATEGORY=su_before.CATEGORY and
su_now.FUNCTION=su_before.FUNCTION and
su_now.COMPOSITION=su_before.COMPOSITION and
su_now.area_code=su_before.area_code
where 
su_now.CATEGORY=rk.CATEGORY and
su_now.FUNCTION=rk.FUNCTION and
su_now.COMPOSITION=rk.COMPOSITION and
su_now.PROVINCE=rk.PROVINCE  and
rank <= '${rank}'
order by su_now.area_code,rk.tax_amount

select distinct
CATEGORY,FUNCTION,COMPOSITION,SUB_CATEGORY,BIG_CATE
from 
dim_goods

