 select D.sale_dept_id,short_name,D.CUST_TYPE3,custb,QTYB,amtb,custs,QTYs,amts,custt,QTYt,amtt FROM 

(
select a.dpt_sale_id sale_dept_id,CUST_TYPE3 custqh,count(distinct a.cust_id) custb, sum(a.qty_sold) qtyb,sum(a.amt) amtb
  from cust_sold a, cust cc
 where a.cust_id=cc.cust_id and  date1='${date1}'  
group by a.dpt_sale_id, cc.CUST_TYPE3 ) a,
(

select a.dpt_sale_id sale_dept_id,CUST_TYPE3 custqh,count(distinct a.cust_id) custs,sum(a.qty_sold) qtys,sum(a.amt) amts
  from cust_sold a, cust cc
 where  a.cust_id=cc.cust_id  and  
date1=(select to_char(add_months(to_date('${date1}','yyyymm'),-1),'yyyymm' ) from dual)
group by a.dpt_sale_id, cc.CUST_TYPE3 ) b,

(
select a.dpt_sale_id sale_dept_id,CUST_TYPE3  custqh,count(distinct a.cust_id) custt,sum(a.qty_sold) qtyt,sum(a.amt) amtt
  from cust_sold a, cust cc
 where    a.cust_id=cc.cust_id and  
date1=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
group by a.dpt_sale_id, cc.CUST_TYPE3
) c,
(

select distinct CUST_TYPE3 , dp.sale_dept_id,dp.short_name   from  cust cc,dpt_sale dp  
where cc.dpt_sale_id= dp.dpt_sale_id   
) D
WHERE A.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND B.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND C.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND A.CUSTQH(+)=D.CUST_TYPE3
AND B.CUSTQH(+)=D.CUST_TYPE3
AND C.CUSTQH(+)=D.CUST_TYPE3

order by sale_dept_id,cust_type3

