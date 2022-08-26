select   count(1) week1  from  cust where status='02' and slsman_id='${slsmanid}'
and  call_period=1

select slsman_id,note from slsman where dpt_sale_id='17080100'

select cust_type3,
case when pay_type='10' then 'xj'
when pay_type='20' then 'dj' else 'qt' end jsfs,
count(1)custjs from co_cust cc   where   status='02' and 
slsman_id='${slsmanid}'
group by cust_type3,pay_type

select cust_type3,dingh,sum(qty) qtys from (
select cust_type3,
case when domain_id='HZ001' then 'dh'
else 'ws' end dingh,
count(1) qty from co_cust cc,csc_cust cd
where cc.cust_id=cd.cust_id and cc.status='02'
and cc.slsman_id='${slsmanid}' group by cust_type3,domain_id
) group by cust_type3,dingh

select dict_key,dict_value from base_dict where dict_id='CO_CUST_CUST_TYPE3_SD'

select   count(1) week2  from  cust where status='02' and slsman_id='${slsmanid}'
and  call_period=2

select   count(1) week3  from  cust where status='02' and slsman_id='${slsmanid}'
and  call_period=3

select   count(1) week4  from  cust where status='02' and slsman_id='${slsmanid}'
and  call_period=4

select   count(1) week5  from  cust where status='02' and slsman_id='${slsmanid}'
and  call_period=5

select distinct  kind from plm_item  order by kind asc


select kind,sum(a.qty_sold*t_size)/50000 qtyb  
from pi_cust_item_month a,plm_item i ,co_cust cc
where a.item_id=i.item_id and a.cust_id=cc.cust_id
and cc.slsman_id='${slsmanid}' and a.date1='${date1}' group by kind

select kind,sum(a.qty_sold*t_size)/50000 qtys 
from pi_cust_item_month a,plm_item i ,co_cust cc
where a.item_id=i.item_id and a.cust_id=cc.cust_id
and cc.slsman_id='${slsmanid}' and 
a.date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual) group by kind

select (qtya-qtyb)/qtyb shizj from (
select sum(qty_sold*t_size)/50000 qtya from pi_com_month a,plm_item i
where a.item_id=i.item_id and date1='${date1}'
),
(
select sum(qty_sold*t_size)/50000 qtyb from pi_com_month a,plm_item i
where a.item_id=i.item_id
 and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual)
)

select (qtya-qtyb)/qtyb xianzj from (
select sum(qty_sold*t_size)/50000 qtya from pi_dept_item_month a,plm_item i
where a.item_id=i.item_id and date1='${date1}'
and sale_dept_id='11371708'
),
(
select sum(qty_sold*t_size)/50000 qtyb from pi_dept_item_month a,plm_item i
where a.item_id=i.item_id
 and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual) and sale_dept_id='11371708'
)

select (qtya-qtyb)/qtyb slszj from (
select sum(a.qty_sold*t_size)/50000 qtya from pi_cust_item_month a,plm_item i,co_cust cc
where a.item_id=i.item_id
 and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') from dual)
and  a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}'
),
(
select sum(a.qty_sold*t_size)/50000 qtyb from pi_cust_item_month a,plm_item i
,co_cust cc
where a.item_id=i.item_id 
 and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-13),'yyyyMM') from dual) and  a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}'
)

select distinct period,substr(period,2,14) fl from  item_com

select period,sum(a.qty_sold*t_size)/50000  qtyb
from plm_item i,item_com ic,pi_cust_item_month@hzyx a,co_cust cc
where i.item_id=ic.item_id and i.item_id=a.item_id
and a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}'
and date1='${date1}'
group by period

select period,sum(a.qty_sold*t_size)/50000  qtys
from plm_item i,item_com ic,pi_cust_item_month@hzyx a,co_cust cc
where i.item_id=ic.item_id and i.item_id=a.item_id
and a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}'
and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual)
group by period

select i.item_id,sum(a.qty_sold*t_size)/50000  qtybs
from plm_item i,pi_cust_item_month@hzyx a,co_cust cc
where  i.item_id=a.item_id
and a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}'
and date1='${date1}' and a.qty_sold<>0
group by i.item_id 

select i.item_id,sum(a.qty_sold*t_size)/50000  qtybs
from plm_item i,pi_cust_item_month@hzyx a,co_cust cc
where  i.item_id=a.item_id
and a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}'
and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual) and a.qty_sold<>0
group by i.item_id 

select distinct i.item_id,item_name,brdowner_id from plm_item i ,pi_cust_item_month a,co_cust cc
where a.item_id=i.item_id  and a.qty_sold<>0 and a.cust_id=cc.cust_id 
and cc.slsman_id='${slsmanid}'
and date1>=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual)
and date1<='${date1}'  and a.sale_dept_id='11371708'  and i.is_mrb=1 order by brdowner_id

select ct.cust_id,cust_name,count(distinct i.item_id) ppkd,sum(a.qty_sold*t_size)/200  qtyb from pi_cust_item_month a
,plm_item i ,co_cust ct where a.item_id=i.item_id and 
ct.slsman_id='${slsmanid}' and a.cust_id=ct.cust_id
 and date1='${date1}' group by ct.cust_id,cust_name having sum(a.qty_sold)<>0


select ct.cust_id,count(distinct i.item_id) ppkd,sum(a.qty_sold*t_size)/200  qtyb from pi_cust_item_month a
,plm_item i ,co_cust ct where a.item_id=i.item_id and 
ct.slsman_id='${slsmanid}' and a.cust_id=ct.cust_id
 and date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual)  group by ct.cust_id having sum(a.qty_sold)<>0



select  ct.cust_id, count(co_num) dhcss from co_co cc,co_cust ct
where cc.born_date like '${date1}%' and  cc.cust_id=ct.cust_id and 
 ct.slsman_id='${slsmanid}'
and cc.status<>'90' group by  ct.cust_id


select  ct.cust_id, count(1) dhcss from co_co cc,co_cust ct
where  cc.cust_id=ct.cust_id and born_date>=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM')||'01' from dual)
 and born_date<=(select to_char(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM')||'31' from dual) and 
ct.slsman_id='${slsmanid}'
and cc.status<>'90' group by  ct.cust_id



select ct.cust_id,count(1) djfail from co_co ccc,co_cust ct where
ccc.cust_id=ct.cust_id  and born_date like '${date1}%'  and ct.slsman_id='${slsmanid}' and ccc.status='90'
 and co_num in (select co_num from co_trans_flow where trade_date like '${date1}%'  and trade_flag=2)
 group by ct.cust_id

