
select c.work_port ,count(cust_id) custn,bensale , tongsale ,benamt ,maol ,mzl*100 mzl from co_cust c,

(
select work_port,sum(a.qty_sold)/250 bensale ,sum(amt) benamt from cust_sold a,co_cust c
where a.cust_id=c.cust_id and a.date1='${date1}' group by work_port ) ben,

(
select work_port,sum(a.qty_sold)/250 tongsale ,sum(amt) tongamt from cust_sold a,co_cust c
where a.cust_id=c.cust_id and 
a.date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') from dual) group by work_port ) tong,

(
select work_port,(sum(amtrtl)-sum(amtpri))*100/sum(amtrtl) maol ,sum(qtys)/sum(req) mzl from co_cust c,
(
select cust_id,sum(a.qty_sold*ic.pri_rtl) amtrtl,sum(a.amt_sold) amtpri ,sum(qty_req) req,sum(qty_sold) qtys
from (select * from item_cust_month2017 where iss_date='${date1}' union
select * from item_cust_month2018 where iss_date='${date1}') a,item_com ic
where a.item_id=ic.item_id   group  by cust_id) cc
where c.cust_id=cc.cust_id group by work_port

) maol

where c.work_port=ben.work_port
and c.work_port=tong.work_port
and c.work_port=maol.work_port
and c.status='02'
group by c.work_port,bensale, tongsale,benamt,maol,mzl

select 
 c.base_type  ,count(cust_id) custn ,bensale , tongsale ,benamt ,maol ,mzl from co_cust c,

(
select base_type,sum(a.qty_sold)/250 bensale ,sum(a.amt) benamt from cust_sold a,co_cust c
where a.cust_id=c.cust_id and a.date1='${date1}' group by base_type ) ben,

(
select base_type,sum(a.qty_sold)/250 tongsale ,sum(a.amt) tongamt from cust_sold a,co_cust 

c
where a.cust_id=c.cust_id and a.date1=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') from dual) group by base_type ) tong,

(
select base_type,(sum(amtrtl)-sum(amtpri))*100/sum(amtrtl) maol,sum(qtys)/sum(req)*100 mzl from co_cust c,
(
select cust_id,sum(qty_sold*ic.pri_rtl) amtrtl,sum(amt_sold) amtpri,sum(qty_req) req,sum(qty_sold) qtys from 
(select * from item_cust_month2017 where iss_date='${date1}'
union select * from  item_cust_month2018 where iss_date='${date1}') 

a,item_com ic
where a.item_id=ic.item_id  group  by cust_id) cc
where c.cust_id=cc.cust_id group by base_type

) maol

where c.base_type=ben.base_type
and c.base_type=tong.base_type
and c.base_type=maol.base_type
and c.status='02'
group by c.base_type,bensale, tongsale,benamt,maol,mzl

 

select DICT_KEY,DICT_VALUE from base_dict where dict_id='ENUM_CO_CUST_BASE_TYPE'


select 
  work_port 

,sum(a.qty_sold)/sum(qty_req)*100 mzl  from 
(select * from cust_month2017 where date1='${date1}' union
select * from cust_month2018 where date1='${date1}') a,co_cust c
where a.cust_id=c.cust_id and a.date1='${date1}' group by work_port

