select xian_id,sum(pop_chang) popchang from z_cun where dili in 
('${dili}') group by xian_id

select cm.dpt_sale_id,sum(cm.qty_sold) qty,sum(cm.amt) amt
from cust_month${years} cm,cust_prop cp,z_cun zc
where cm.cust_id=cp.cust_id
and cp.z_cun_id=zc.z_cun_id
and zc.dili in ('${dili}')
and cm.date1>=${date1}
and cm.date1<=${date2}
group by cm.dpt_sale_id

select zc.xian_id,count(1) numb
from cust_prop cp,z_cun zc,cust ct
where cp.z_cun_id=zc.z_cun_id
and cp.cust_id=ct.cust_id
and ct.status='02'
and zc.dili in ('${dili}')
group by zc.xian_id

select sold.dpt_sale_id,custnum,sold.qty,sold.amt,pop.pop from
(select cm.dpt_sale_id,sum( qty_sold) qty,sum(amt) amt
from cust_month${years}  cm
where cm.date1>=${date1}
and cm.date1<=${date2}
group by cm.dpt_sale_id) sold,

(select dpt_sale_id, pop
from  pop_xian
 ) pop,
(select dpt_Sale_id,count(1) custnum from cust where status='02' group by dpt_sale_id) c
where sold.dpt_sale_id=pop.dpt_sale_id and sold.dpt_sale_id=c.dpt_sale_id

select add_months(to_date(${date2},'yyyymm'),'1')-to_date(${date1}||'01','yyyymmdd') saledays from dual

select di_name from di_where where di_id in ('${dili}')

