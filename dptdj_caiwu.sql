select sale_dept_id,bank_id,count(1) custnum from co_cust c,co_debit_acc a
 where c.status='02' and c.cust_id=a.cust_id  and c.pay_type='20'
group by sale_dept_id,bank_id

select SALE_DEPT_ID dpt_sale_id,count(1) custall from CO_cust  where status='02' 
  group by sale_dept_id

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>='${date1}'
and trade_date<='${date2}'
 and  trade_flag=0  
 and bank_id<>'NO'
group  by  '1137'||substr(cust_id,5,4) ,bank_id 


select '1137'||substr(cust_id,5,4) as dpt_sale_id,sum(amt_ar) amtall from 
(select * from ldm_dist_line where  dist_num in 
(Select dist_num from  ldm_dist 
where  dist_date>=(select   to_char(to_date('${date1}','yyyyMMdd')+1 ,'yyyyMMdd') from dual) 
and dist_date<=(select   to_char(to_date('${date2}','yyyyMMdd')+1 ,'yyyyMMdd') from dual)
and  is_mrb=1 )
)
 group by '1137'||substr(cust_id,5,4)
  

select sale_dept_id,count(1) otherdj from hzdjcust group by sale_dept_id

select c.sale_dept_id,count(distinct c.co_num) otherco,sum(amt_sum)  otheramt from 
co_co c ,CO_TRANS_FLOW CF,co_cust cc,hzdjcust b
where   c.cust_id=b.cust_id 
AND C.CO_NUM=CF.CO_NUM 
AND CF.TRADE_FLAG='0' 
and trade_date>='${date1}'
and trade_date<= '${date2}' 
and c.status='60' 
and cc.status='02'
and cf.bank_id='NO'
and cc.cust_id=b.cust_id
 group by c.sale_dept_id

select sale_dept_id,count(distinct cust_id) dh from 
(select sale_dept_id,cust_id from co_cust where status='02' and tax_account in ('372901777743705X','372901724812645','91371700056224644Q')
union
select a.sale_dept_id,a.cust_id from hzdjcust a,co_cust c where a.cust_id=c.cust_id and c.status='02'
)
group by sale_dept_id

select '1137'||substr(c.cust_id,5,4) as dpt_Sale_id,a.bank_id, c.tax_account,count(1) custdj,sum(a.qty_trade) qtytrade from co_trans_flow  a,co_cust c where  a.cust_id=c.cust_id and 
trade_date>='${date1}'
and trade_date<='${date2}'
 and  trade_flag=0    and  c.tax_account in ('372901777743705X','372901724812645','913717000906941567')
 
group  by  '1137'||substr(c.cust_id,5,4) ,a.bank_id ,c.tax_account

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>='${date1}'
and trade_date<='${date2}'
 and  trade_flag=0   and bank_id='NO' and  cust_id in 
(
select  cust_id from co_cust where  tax_account='91370000732603894Y'
)
group  by  '1137'||substr(cust_id,5,4) ,bank_id 

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>='${date1}'
and trade_date<='${date2}'
 and  trade_flag=0    and  cust_id in 
(
select  cust_id from co_cust where  tax_account='91371700793904535W'
)
group  by  '1137'||substr(cust_id,5,4) ,bank_id 

