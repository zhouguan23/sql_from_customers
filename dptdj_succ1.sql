select sale_dept_id,bank_id,count(1) custnum from co_cust c,co_debit_acc a
 where c.status='02' and c.cust_id=a.cust_id  and c.pay_type='20' and a.status=1
group by sale_dept_id,bank_id

select SALE_DEPT_ID dpt_sale_id,count(1) custall from CO_cust  where status='02' 
  group by sale_dept_id

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>=(select   to_char(to_date('${date1}','yyyyMMdd')-1 ,'yyyyMMdd') from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyyMMdd')-1 ,'yyyyMMdd') from dual)
 and  trade_flag=0  
 and bank_id<>'NO'
group  by  '1137'||substr(cust_id,5,4) ,bank_id 


select '1137'||substr(cust_id,5,4) as dpt_sale_id,sum(amt_ar) amtall from 
(select * from ldm_dist_line where  dist_num in 
(Select dist_num from  ldm_dist where  dist_date>='${date1}' 
and dist_date<='${date2}'  and  is_mrb=1 )
)
 group by '1137'||substr(cust_id,5,4)
  

select sale_dept_id,count(1) otherdj from hzdjcust group by sale_dept_id

select c.sale_dept_id,count(distinct c.co_num) otherco,sum(amt_sum)  otheramt from 
co_co c ,hzdjcust b
where   c.cust_id=b.cust_id  and pose_date>='${date1}'
and pose_date<= '${date2}'  and c.status<>'90' 
 group by c.sale_dept_id

select sale_dept_id,count(distinct cust_id) dh from 
(select sale_dept_id,cust_id from co_cust where status='02' and tax_account in ('372901777743705X','372901724812645','91371700056224644Q')
union
select a.sale_dept_id,a.cust_id from hzdjcust a,co_cust c where a.cust_id=c.cust_id and c.status='02'
)
group by sale_dept_id

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>=(select   to_char(to_date('${date1}','yyyyMMdd')-1 ,'yyyyMMdd') from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd') from dual)
 and  trade_flag=0    and  cust_id in 
(
select  cust_id from co_cust where  tax_account in ('372901777743705X','372901724812645')
)
group  by  '1137'||substr(cust_id,5,4) ,bank_id 

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>=(select   to_char(to_date('${date1}','yyyyMMdd')-1 ,'yyyyMMdd') from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd') from dual)
 and  trade_flag=0    and  cust_id in 
(
select  cust_id from co_cust where  tax_account='91371700056224644Q'
)
group  by  '1137'||substr(cust_id,5,4) ,bank_id 

select '1137'||substr(cust_id,5,4) as dpt_Sale_id,bank_id, count(1) custdj,sum(qty_trade) qtytrade from co_trans_flow  where 
trade_date>=(select   to_char(to_date('${date1}','yyyyMMdd')-1 ,'yyyyMMdd') from dual)
and trade_date<=(select   to_char(to_date('${date2}','yyyy-MM-dd')-1 ,'yyyyMMdd') from dual)
 and  trade_flag=0    and  cust_id in 
(
select  cust_id from co_cust where  tax_account='91371700793904535W'
)
group  by  '1137'||substr(cust_id,5,4) ,bank_id 

