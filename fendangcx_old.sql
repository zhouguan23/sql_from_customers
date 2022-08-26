select distinct i.item_id,item_name ,i.brdowner_id from  sgp_custtype_item_limit a,
 plm_item i  where  a.item_id=i.item_id and  type_kind='KHCP'  
order by i.brdowner_id

select cust_type,qty_once_limit from 
(
select cust_type,qty_once_limit  from sgp_custtype_item_limit where item_id='${itemid}'
and type_kind='KHCP'
union 
select distinct    cust_type4   cust_type ,qty_once_limit from sgp_custtype_item_limit a,co_cust c
where c.status='02' and a.type_kind='01' and c.cust_type4   in 
 (select distinct cust_type4 from co_cust where status='02' minus select cust_type from sgp_custtype_item_limit where item_id='${itemid}'
and type_kind='KHCP') and a.item_id='${itemid}'

union 
select distinct case when cust_type4 is null then '00' end  cust_type,qty_once_limit from sgp_custtype_item_limit a,co_cust c
where c.status='02' and a.type_kind='01' and c.cust_type4 is null 
and type_kind='01' and a.item_id='${itemid}'
)  order by cust_type desc

select  case when cs.cust_type4 is null then '00' else cust_type4 end cust_type4  ,count(1) custnum from  csc_cust  cc, co_cust cs 
where cs.cust_id=cc.cust_id and cs.status='02'  and  substr(cc.periods_id,6,1)>=(select to_char(to_date('${date1}','yyyymmdd')-1,'D') from dual )
and substr(cc.periods_id,6,1)<=(select to_char(to_date('${date2}','yyyymmdd')-1,'D') from dual )
 group by cs.cust_type4 order by cust_type4 desc

select distinct case when  cs.cust_type4 is null then '00' else cust_type4 end as cust_type4,sum(a.qty_sold*t_size)/50000 qtysold,sum(a.qty_need*t_size)/50000 qtyneed,count(distinct cs.cust_id) custsl 
from pi_cust_item_bnd_day a,co_cust cs,plm_item i 
where a.cust_id=cs.cust_id and a.item_id=i.item_id 
and a.date1>='${date1}' and a.date1<='${date2}' and i.item_id='${itemid}'
group by cs.cust_type4

select cust_type,custqty from 
 (
 select bb.cust_type,count(cust_id) custqty from 
 (
select  cs.cust_type4 , cs.cust_id,sum(a.qty_sold) qtysold 
from pi_cust_item_bnd_day a,co_cust cs  
where a.cust_id=cs.cust_id   and  a.item_id='${itemid}'  
and a.date1>='${date1}' and a.date1<='${date2}'  
group by cs.cust_type4,cs.cust_id having sum(a.qty_sold)<>0
) aa,
(
select cust_type,qty_once_limit from sgp_custtype_item_limit where item_id='${itemid}' and type_kind='KHCP'
) bb
where aa.cust_type4=bb.cust_type and aa.qtysold=bb.qty_once_limit group by cust_type

union

 select aa.cust_type4 cust_type,count(cust_id)  custqty from 
 (
select    case when  cs.cust_type4 is null then '00' else cust_type4 end cust_type4 , cs.cust_id,sum(a.qty_sold) qtysold 
from pi_cust_item_bnd_day a,co_cust cs  
where a.cust_id=cs.cust_id   and  a.item_id='${itemid}'  
and a.date1>='${date1}' and a.date1<='${date2}'   and cs.cust_type4  in
(select distinct cust_type4 from co_cust minus
 select cust_type from sgp_custtype_item_limit where item_id='${itemid}' and type_kind='KHCP')

group by cs.cust_type4,cs.cust_id having sum(a.qty_sold)<>0
) aa,
(
select cust_type,qty_once_limit from sgp_custtype_item_limit where item_id='${itemid}' and type_kind='01'
) bb
where  aa.qtysold=bb.qty_once_limit group by cust_type4

union

 select cust_type4 cust_type,count(cust_id)  custqty from 
 (
select     '00'  cust_type4 , cs.cust_id,sum(a.qty_sold) qtysold 
from pi_cust_item_bnd_day a,co_cust cs  
where a.cust_id=cs.cust_id   and  a.item_id='${itemid}'  
and a.date1>='${date1}' and a.date1<='${date2}'    and cs.cust_type4 is  null  
group by cs.cust_type4,cs.cust_id having sum(a.qty_sold)<>0
) cc,
(
select cust_type,qty_once_limit from sgp_custtype_item_limit where item_id='${itemid}'  and type_kind='01'
) dd
where  cc.qtysold=dd.qty_once_limit group by cust_type4



)
 

 
  select i.item_id,ic.short_code,item_name,ic.price_trade,sum(qtycust) qtycust,sum(qty)/250 qtytf from plm_item i ,plm_item_com ic,
  (
select item_id, cc.cust_type4,qty_once_limit,count(cust_id) qtycust, qty_once_limit*count(cust_id) qty from sgp_custtype_item_limit aa,
  co_cust cc 
where     cc.cust_type4=aa.cust_type  and  type_kind='KHCP' and item_id='${itemid}'
 and cc.status='02'
group by item_id,aa.cust_type,cc.cust_type4,qty_once_limit
 
 union
  
 select item_id,cust_type4,qty_once_limit, qtycust,qty_once_limit*qtycust qty from 
 ( 
 select  cust_type4, count(1) qtycust  from  co_cust cc
where     cc.status='02' and   cc.cust_type4   in 
(select cust_type4 from co_cust where  cust_type4 is not null  minus 
select cust_type from  sgp_custtype_item_limit where type_kind='KHCP' and item_id='${itemid}')
group by cust_type4),
 (
 select item_id,cust_type,qty_once_limit from sgp_custtype_item_limit a where   a.type_kind='01' and a.item_id='${itemid}' and qty_once_limit>0
 ) 
 
 union
 
 select item_id,cust_type4,qty_once_limit, qtycust,qty_once_limit*qtycust qty from 
 ( 
 select  '00' cust_type4, count(1) qtycust  from  co_cust cc
where     cc.status='02' and    cust_type4 is   null ),
 (
 select item_id,cust_type,qty_once_limit from sgp_custtype_item_limit a where   a.type_kind='01' and a.item_id='${itemid}' and qty_once_limit>0
 ) 
 ) a where i.item_id=ic.item_id and i.item_id=a.item_id and ic.com_id='10371701' group by i.item_id,ic.short_code,item_name,ic.price_trade

select i.item_id,count(distinct cust_id) custnum,sum(qty_need*t_size)/50000 qtyneed,sum(qty_sold*t_size)/50000 qtysold from pi_cust_item_bnd_day a,plm_item i  where a.item_id=i.item_id and i.item_id='${itemid}'
and date1>='${date1}' and date1<='${date2}' group by i.item_id
 

select distinct case when  cs.cust_type4 is null then '00' else cust_type4 end as cust_type4,count(distinct cs.cust_id) custsl 
from pi_cust_item_bnd_day a,co_cust cs
where a.cust_id=cs.cust_id and a.qty_sold<>0
and a.date1>='${date1}' and a.date1<='${date2}' and a.item_id='${itemid}'
group by cs.cust_type4 

