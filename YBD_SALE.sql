select c.union_area_name,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 累计剔除DTP总销售,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0) else  nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0)end) as 累计剔除DTP总毛利
from dm_sale_tmp a,dim_cus_ybd b,dim_region c,dim_cus d
where a.cus_code=b.cus_code
and a.area_code=b.area_code
and b.area_code=c.area_code
and a.cus_code=d.cus_code
and a.area_code=d.area_code
and  to_char( a.sale_date,'YYYY-MM')>=to_char( d.open_date,'YYYY-MM')
and a.dtp='否'
and 1=1
${if(len(area)=0, "", " and c.union_area_name in ('" + area + "')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
               to_date('${end_date}', 'yyyy-mm-dd')
group by c.union_area_name

select c.union_area_name,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 累计总销售,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0) else  nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end)  as 累计总毛利
from dm_sale_tmp a,dim_cus_ybd b,dim_region c,dim_cus d
where a.cus_code=b.cus_code
and a.area_code=b.area_code
and b.area_code=c.area_code
and b.cus_code=d.cus_code
and b.area_code=d.area_code
and  to_char( a.sale_date,'YYYY-MM')>=to_char( d.open_date,'YYYY-MM')
and 1=1
${if(len(area)=0, "", " and c.union_area_name in ('" + area + "')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
               to_date('${end_date}', 'yyyy-mm-dd')

group by c.union_area_name

select c.union_area_name,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 累计同期销售,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0) else  nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end)  as 累计同期毛利
from dm_sale_tmp a,dim_cus_ybd b,dim_region c,dim_cus d
where a.cus_code=b.cus_code
and a.area_code=b.area_code
and b.area_code=c.area_code
and b.cus_code=d.cus_code
and b.area_code=d.area_code
and  to_char( a.sale_date,'YYYY-MM')>=to_char( d.open_date,'YYYY-MM')
and 1=1
${if(len(area)=0, "", " and c.union_area_name in ('" + area + "')")}
and a.sale_date between add_months(to_date('${start_date}','yyyy-mm-dd'), -12)
and  add_months(to_date('${end_date}','yyyy-mm-dd'), -12)
group by c.union_area_name



select c.union_area_name,
(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as  累计剔除DTP同期销售,
(case when '${Tax}'='无税' then nvl(sum(no_tax_amount),0)-nvl(sum(no_tax_cost),0) else  nvl(sum(tax_amount),0)-nvl(sum(tax_cost),0) end)  as 累计剔除DTP同期毛利
from dm_sale_tmp a,dim_cus_ybd b,dim_region c,dim_cus d
where a.cus_code=b.cus_code
and a.area_code=b.area_code
and b.area_code=c.area_code
and b.cus_code=d.cus_code
and b.area_code=d.area_code
and  to_char( a.sale_date,'YYYY-MM')>=to_char( d.open_date,'YYYY-MM')
and a.dtp='否'
and 1=1
${if(len(area)=0, "", " and c.union_area_name in ('" + area + "')")}
and a.sale_date between add_months(to_date('${start_date}','yyyy-mm-dd'), -12)
and  add_months(to_date('${end_date}','yyyy-mm-dd'), -12)
group by c.union_area_name

select distinct c.union_area_name
from dim_region c


