select date1,case when substr(date1,5,1)='0' then substr(date1,6,1)||'月'  else substr(date1,5,2)||'月' end as month,
sum(qty_sold) qty ,round(sum(amt)/sum(qty_sold),1) dxamt from  cust_sold
 where date1>=(select to_char(add_months(sysdate,-7),'yyyymm') from dual)
 and cust_id='${custid}'
 group by date1  

select item_name,qty,amt from 
(
select item_name,sum(qty_sold) qty,sum(amt_sold) amt  from  pi_cust_item_month a,plm_item i 
 where date1>=(select to_char(add_months(sysdate,-7),'yyyymm') from dual)
 and a.item_id=i.item_id  and qty_sold<>0
 and cust_id='${custid}'
 group by item_name   order by sum(qty_sold) desc
 ) where rownum<=15

select  slsman_id,note from slsman where dpt_sale_id='${dptid}'

select cust_id,manager  from  co_cust where status='02' and slsman_id='${slsmanid}'

select cust_name,busi_addr,order_tel,cust_seg from co_cust where cust_id='${custid}'

