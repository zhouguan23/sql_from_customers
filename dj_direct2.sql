select dc.car_id,car_name dspt,'1137'||substr(cust_id,5,4) dptid,sum(dl.qty_bar) qty,sum(dl.amt_ar) amt from ldm_dist_line dl,ldm_dist_car dc ,ldm_dist l
where l.car_id=dc.car_id and dc.car_id like '2%' and dc.com_id='10371701' and dl.dist_num=l.dist_num
 and l.dist_date>='${date1}' and l.dist_date<='${date2}' and l.is_mrb=1
group by dc.car_id,car_name,'1137'||substr(cust_id,5,4)

select  car_id,bank_id,'1137'||substr(dl.cust_id,5,4) dptid,sum(qty_trade) qtydj from 
ldm_dist_line dl,ldm_dist l,

(select * from co_trans_flow  where trade_date>=(select    to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and trade_date<=(select    to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
  and trade_flag=0
) a
where dl.co_num=a.co_num and   dl.dist_num=l.dist_num and   l.car_id like  '2%'   and l.is_mrb=1
group by car_id,bank_id,'1137'||substr(dl.cust_id,5,4)

select distinct car_id,dptid from 
(
select  car_id,'1137'||substr(cust_id,5,4) dptid,sum(l.qty_bar) qty,sum(amt_sum) amt from ldm_dist_line dl ,ldm_dist l
where  car_id like '2%'   and dl.dist_num=l.dist_num
 and dist_date>='${date1}' and dist_date<='${date2}' and l.is_mrb=1
group by  car_id ,'1137'||substr(cust_id,5,4)
) ORDER BY CAR_ID

select a.car_id,a.dptid,amt-qtydj cash from 
(
select  car_id,'1137'||substr(cust_id,5,4) dptid, sum(dl.amt_ar) amt from ldm_dist_line  dl,ldm_dist l
where  car_id like '2%' and dl.dist_num=l.dist_num  and l.is_mrb=1
 and dist_date>='${date1}' and dist_date<='${date2}'group by car_id, '1137'||substr(cust_id,5,4)
) a,
(
select  car_id, sale_dept_id dptid,sum(qty_trade) qtydj from 
ldm_dist_line dl,ldm_dist l,

(
select * from co_trans_flow  where trade_date>=(select    to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
  and trade_flag=0
 ) a
where dl.co_num=a.co_num and   dl.dist_num=l.dist_num and  l.car_id  like '2%'
group by car_id, sale_dept_id
) b
where b.car_id(+)=a.car_id and b.dptid=a.dptid

select  car_id,bank_id,'1137'||substr(dl.cust_id,5,4) dptid,sum(qty_trade) qtydj from 
ldm_dist_line dl,ldm_dist l,

( select * from co_trans_flow  where trade_date>=(select    to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd')  from dual)
  and trade_flag=0
) a
where dl.co_num=a.co_num and   dl.dist_num=l.dist_num and  l.car_id like  '2%'   and l.is_mrb=1
group by car_id,bank_id,'1137'||substr(dl.cust_id,5,4)
 

