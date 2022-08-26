--基本信息
select g.head_id,
b.rebate_year 返利归属期间,
a.contract_seq 合同索引号,
a.supplier_code 供应商编码,
a.supplier_site_code 供应商地点编码,
nvl(e.supplier_name,a.factory_name) 供应商名称,
b.persons_responsible 采购经理,
f.goods_name 品名,
c.item 商品编码,
f.specification 规格,
a.start_date 合同开始日期,
a.end_date 合同截止日期,
decode(united_flag,'Y','是','N','否')是否统签分采,
(select s.item_text from sys_dict_item s
where s.dict_id =(select id from sys_dict where dict_code = 'invoice_method')
and s.item_value = b.invoice_method) 开票方式,
(select s.item_text from sys_dict_item s
where s.dict_id =(select id from sys_dict where dict_code = 'settle_method')
and s.item_value = b.settle_method) 结算方式,
b.rebate_clause 返利条款,
(select s.item_text from sys_dict_item s
where s.dict_id =(select id from sys_dict where dict_code = 'settle_basis')
and s.item_value = b.settle_basis)结算依据,
b.agreement_payoff_date 协议规定支付时间,
b.related_invoice,
b.reason,
b.expected_date,
b.persons_responsible,
b.comments,
g.tax_rate
from cmx_contract_main a right join cmx_rebate_head b
on  a.id=b.contract_id
left join (select * from (
select id,item, row_number() over(partition by id order by item ) rn 
from CMX_ORDER_GOODS) t where t.rn <2)c
on b.id=c.id
--left join CMX_ORDER_GOODS c
--on b.id=c.id 
left join dim_supplier e
on to_char(a.supplier_site_code)=e.supplier_code
left join zux_region_ou o
on o.region=a.region
left join dim_region r
on o.brancode=r.area_code 
left join dim_goods f
on c.item=f.goods_code
right join (select head_id,year,sum(base_amount),sum(amount),sum(amount_received),nvl(tax_rate,0)tax_rate from CMX_REBATE_LINE
where  year||'-'||month>='${Date1}'
and year||'-'||month<='${Date2}' 
group by  head_id,year,nvl(tax_rate,0)) g
on g.head_id=b.id
where 
 1=1 ${if(len(area)=0,""," and r.area_code  in ('"+area +"')")}
and 1=1 ${if(len(contract)=0,""," and a.contract_number  in ('"+contract +"')")}
and 1=1 ${if(len(contract_seq)=0,""," and a.contract_seq  in ('"+contract_seq +"')")}
and 1=1 ${if(len(supplier_site_code)=0,""," and a.supplier_site_code  in ('"+supplier_site_code +"')")}
and 1=1 ${if(len(supplier_name)=0,""," and nvl(e.supplier_name,a.factory_name)  in ('"+supplier_name +"')")}
and  1=1 ${if(len(paydate)=0,""," and b.agreement_payoff_date  in ('"+paydate  +"')")}
and  1=1 ${if(len(persons)=0,""," and b.persons_responsible  in ('"+persons  +"')")}
and 1=1 ${if(len(create_by)=0,""," and a.create_by  in ('"+create_by +"')")}
and 1=1 ${if(len(create_time)=0,""," and a.create_time in ('"+create_time +"')")}
and 1=1 ${if(len(update_by)=0,""," and a.update_by  in ('"+update_by +"')")}
and 1=1 ${if(len(update_time)=0,""," and a.update_time in ('"+update_time +"')")}
order by 1

select distinct receive_period 实收期间 from cmx_rebate_line
where receive_period is not null
and receive_period>='${Date1}'
and receive_period<='${Date2}'
order by 1

select distinct account_period 入账期间 from cmx_rebate_line
where account_period is not null
and account_period>='${Date1}'
and account_period<='${Date2}'
order by 1

--结算基数、应收返利、实收返利、入账返利
select g.head_id,
g.year,
g.month,
--g.receive_period 实收期间,
sum(g.base_amount) 结算基数,
sum(g.amount) 应收返利,
--g.amount_received/(100+g.tax_rate)*100 实收无税金额,
--g.amount_received 实收含税金额,
g.tax_rate 实收税率
from cmx_contract_main a right join cmx_rebate_head b
on  a.id=b.contract_id
left join cmx_rebate_line g
on g.head_id=b.id
where 
g.year||'-'||g.month>='${Date1}'
and g.year||'-'||g.month<='${Date2}' 
group by g.head_id,
g.year,
g.month,
g.tax_rate
order by 1

 select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

--结算基数、应收返利、实收返利、入账返利
select g.head_id,
g.account_period,
sum(g.amount_received/(100+g.tax_rate)*100) 实收无税金额,
sum(g.amount_received) 实收含税金额,
g.tax_rate
from cmx_contract_main a right join cmx_rebate_head b
on  a.id=b.contract_id
left join cmx_rebate_line g
on g.head_id=b.id
where 
g.account_period>='${Date1}'
and g.account_period<='${Date2}'
group by g.head_id,g.account_period,g.tax_rate
order by 1

--结算基数、应收返利、实收返利、入账返利
select g.head_id,
g.year,
g.month,
--g.receive_period 实收期间,
--g.base_amount 结算基数,
sum(g.amount) 应收返利,
--g.amount_received/(100+g.tax_rate)*100 实收无税金额,
--g.amount_received 实收含税金额,
g.tax_rate 实收税率
from cmx_contract_main a right join cmx_rebate_head b
on  a.id=b.contract_id
left join cmx_rebate_line g
on g.head_id=b.id
where 
g.year||'-'||g.month>='${Date1}'
and g.year||'-'||g.month<='${Date2}' 
group by 
g.head_id,
g.year,
g.month,
g.tax_rate
order by 1

--结算基数、应收返利、实收返利、入账返利
select g.head_id,
g.receive_period,
--g.base_amount 结算基数,
--g.amount 应收返利
sum(g.amount_received/(100+g.tax_rate)*100) 实收无税金额,
sum(g.amount_received) 实收含税金额,
g.tax_rate
from cmx_contract_main a right join cmx_rebate_head b
on  a.id=b.contract_id
left join cmx_rebate_line g
on g.head_id=b.id
where 
g.receive_period>='${Date1}'
and g.receive_period<='${Date2}' 
group by g.head_id,g.receive_period,g.tax_rate
order by 1

select head_id,tax_rate,sum(amount_received)合计实收返利 from cmx_rebate_line
where 
year=substr('${Date2}',0,4)
and year||'-'||month<='${Date2}'
group by head_id,tax_rate

select head_id,sum(amount)-sum(amount_received)未收返利 from cmx_rebate_line
WHERE year=substr('${Date2}',0,4)
and year||'-'||month<='${Date2}'
group by head_id

select area_code,area_name from dim_region
order by area_code

select distinct  a.contract_number
from cmx_contract_main a 
left join zux_region_ou o
on o.region=a.region
left join dim_region r
on o.brancode=r.area_code 
where 
 1=1 ${if(len(area)=0,""," and r.area_code  in ('"+area +"')")}


select distinct a.contract_seq
from cmx_contract_main a
left join zux_region_ou o
on o.region=a.region
left join dim_region r
on o.brancode=r.area_code 
where 
 1=1 ${if(len(area)=0,""," and r.area_code  in ('"+area +"')")}

select distinct  a.supplier_site_code
from cmx_contract_main a 
left join zux_region_ou o
on o.region=a.region
left join dim_region r
on o.brancode=r.area_code 
where 
 1=1 ${if(len(area)=0,""," and r.area_code  in ('"+area +"')")}

select distinct  nvl(e.supplier_name,a.factory_name) 供应商名称  from cmx_contract_main a
left join dim_supplier e
on to_char(a.supplier_site_code)=e.supplier_code

select distinct create_by from cmx_contract_main
order by 1

select distinct create_time from cmx_contract_main
order by 1

select distinct agreement_payoff_date from cmx_rebate_head
order by 1

select distinct persons_responsible from cmx_rebate_head

select distinct update_by from cmx_contract_main
order by 1

select distinct update_time from cmx_contract_main
order by 1

