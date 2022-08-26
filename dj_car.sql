select   car_id,seq, c.cust_id,cust_short_name, order_tel tel,c.pay_type,dd.bank_id from_bank,
  qty_bar  , amt_ar amt ,
case when trade_flag=0 then 0
when trade_flag=2 then 1
when trade_flag  is null then 2
else 3
end trust_flag
from  
(
select car_id,co_num,seq,cust_id,dl.qty_bar ,dl.amt_ar from ldm_dist l,ldm_dist_line dl
 where dist_date='${date1}' and dl.dist_num=l.dist_num and l.is_mrb=1
) dl ,
(select * from co_trans_flow  where trade_date=(select   to_char(to_date(to_char(to_date('${date1}','yyyy-MM-dd')-1 ,'yyyyMMdd'),'yyyyMMdd') ,'yyyyMMdd') from dual)
) a,co_cust c,co_debit_acc dd
where  dl.cust_id=c.cust_id and dd.cust_id(+)=dl.cust_id 
and a.co_num(+)=dl.co_num 
 
and  car_id  like '${carid}%'
 order by seq

