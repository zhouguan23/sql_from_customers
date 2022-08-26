 select D.CUST_TYPE3,custb,QTYB,amtb,custs,QTYs,amts,custt,QTYt,amtt FROM 

(select  NVL(CUST_TYPE3,'024') custqh,count(distinct a.cust_id) custb,sum(a.qty_sold*t_size)/200 qtyb,sum(a.amt_sold) amtb
  from pi_cust_item_month a,plm_item i ,co_cust cc
 where  a.item_id=i.item_id and cc.sale_dept_id= '${dptid}' and a.cust_id=cc.cust_id and  date1='${date1}'   group by  NVL(cc.CUST_TYPE3,'024')) a,
(

select  NVL(CUST_TYPE3,'024') custqh,count(distinct a.cust_id) custs,sum(a.qty_sold*t_size)/200 qtys,sum(a.amt_sold) amts
  from pi_cust_item_month a,plm_item i ,co_cust cc
 where  a.item_id=i.item_id and cc.sale_dept_id= '${dptid}' and a.cust_id=cc.cust_id and  
date1=(select to_char(add_months(to_date('${date1}','yyyymm'),-1),'yyyymm' ) from dual)
group by  NVL(CUST_TYPE3,'024')) b,

(
select  NVL(CUST_TYPE3,'024') custqh,count(distinct a.cust_id) custt,sum(a.qty_sold*t_size)/200 qtyt,sum(a.amt_sold) amtt
  from pi_cust_item_month a,plm_item i ,co_cust cc
 where  a.item_id=i.item_id and cc.sale_dept_id= '${dptid}' and a.cust_id=cc.cust_id and  
date1=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
group by  NVL(CUST_TYPE3,'024')
) c,
(

 select distinct cust_type3 from (
select    
case when CUST_TYPE3 in ('011','11','12','21') then '011'
 when CUST_TYPE3 in ('012','31','32') then '012'
 when cust_type3='013' then '013'
 when CUST_TYPE3 in ('023','41') then '023'
 else   '024'
 end as   CUST_TYPE3 ,count(1)    from co_cust cc  
where   cc.status='02' and sale_dept_id='${dptid}' GROUP BY   CUST_TYPE3 
)
) D
WHERE A.CUSTQH(+)=D.CUST_TYPE3
AND B.CUSTQH(+)=D.CUST_TYPE3
AND C.CUSTQH(+)=D.CUST_TYPE3

order by  cust_type3

