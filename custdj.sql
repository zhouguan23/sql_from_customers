select c.cust_id,cust_name,order_tel,co_num, cf.trade_date,
case 
when  bank_id='HZ1011'   then '农信'
when  bank_id='HZ1005'   then '邮政'
when  bank_id='HZJSEPAY' then '建行'
when  bank_id='NO'       then '支票'
when  bank_id in ('9558816','HZGHH5' )  then '工行通道'
when  bank_id in ('9558808','HZGHWX')  then '工行微信'
when bank_id in ('epay','HZXY') then '兴业银行'
when bank_id in ('WFT','HZXYWX') then '兴业银行微信'
end  as bank,
 qty_trade  from co_trans_flow cf ,co_cust c
where  cf.cust_id=c.cust_id
and trade_date>='${date1}'
and trade_date<='${date2}'
 and trade_flag='0'
 and c.sale_dept_id='${dpt}'
 order by bank_id,c.cust_id

   select  case a.sale_dept_id
   when '11371710' then'牡丹区'
   when '11371703' then '曹县'  
   when '11371704' then '成武'   
   when '11371705' then '单县'   
   when '11371706' then '定陶'   
   when '11371707' then '东明'   
   when '11371708' then '巨野'   
   when '11371709' then '鄄城'
   when '11371711' then '郓城'       
   end as dept
   ,cs,cj,js,jj from 
(select sale_dept_id,count(co_num)  cs,sum(amt_sum) cj
 from co_co 
 where born_date>='${date1}'
 and  born_date<='${date2}'
 and status='60'  
 group by sale_dept_id) a,
  (select sale_dept_id,count(co_num)  js,sum(qty_trade) jj
 from co_trans_flow
 where trade_date>='${date1}'
 and trade_date<='${date2}'
 and trade_flag='0'
 group by sale_dept_id) b
 where a.sale_dept_id=b.sale_dept_id

