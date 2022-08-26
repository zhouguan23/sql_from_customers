 select D.sale_dept_id,short_name,D.CUST_TYPE3,QTYB,QTYS,QTYT FROM 

(select a.sale_dept_id,a.cust_type3,sum(aa.qty_sold*t_size)/50000 qtyb  from pi_cust_item_day aa,
co_cust a,plm_item i 
 where  aa.item_id=i.item_id  and aa.cust_id=a.cust_id and  date1>='${date1}' and date1<='${date2}' 
group by a.sale_dept_id,a.cust_type3) a,
(

select a.sale_dept_id,a.cust_type3,sum(aa.qty_sold*t_size)/50000 qtys  from pi_cust_item_day aa,
co_cust a,plm_item i 
 where  aa.item_id=i.item_id and   aa.cust_id=a.cust_id and 
date1>=(select to_char(to_date('${date1}','yyyymmdd')-(to_date('${date2}','yyyymmdd')-to_date('${date1}','yyyymmdd')+1),'yyyymmdd') from dual)
and date1<=(select to_char(to_date('${date2}','yyyymmdd')-(to_date('${date2}','yyyymmdd')-to_date('${date1}','yyyymmdd')+1),'yyyymmdd') from dual)
group by a.sale_dept_id,a.cust_type3) b,
(
select a.sale_dept_id,a.cust_type3,sum(aa.qty_sold*t_size)/50000 qtyt  from pi_cust_item_day aa, co_cust a,plm_item i 
 where  aa.item_id=i.item_id and aa.cust_id=a.cust_id and 
date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd' ) from dual)
 and date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd' ) from dual)
group by a.sale_dept_id,a.cust_type3
) c,
(
select sale_dept_id,short_name,cust_type3  from 
(
select   dp.dpt_sale_id sale_dept_id,short_name,
case when CUST_TYPE3 in ('011','11','12','21') then '011'
 when CUST_TYPE3 in ('012','21') then '012'
 when cust_type3='013' then '013'
 when CUST_TYPE3 in ('023','41') then '023'
else '024'
 end as   CUST_TYPE3,COUNT(1)  qty  from co_cust cc,dpt_sale dp  
where cc.sale_dept_id=dp.dpt_sale_id and cc.status='02' GROUP BY dp.dpt_sale_id ,short_name, CUST_TYPE3 
) 
) D
WHERE A.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND B.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND C.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND A.cust_type3(+)=D.CUST_TYPE3
AND B.cust_type3(+)=D.CUST_TYPE3
AND C.cust_type3(+)=D.CUST_TYPE3

order by cust_type3

 select D.sale_dept_id,short_name,D.CUST_TYPE3,QTYB,QTYS,QTYT FROM 

(select sale_dept_id,custqh,sum(qty_sold*t_size)/50000 qtyb  from qhsale a,plm_item i 
 where  a.item_id=i.item_id and  date1>='${date1}' and date1<='${date2}' 
group by sale_dept_id,custqh) a,
(

select sale_dept_id,custqh,sum(qty_sold*t_size)/50000 qtys  from qhsale a,plm_item i 
 where  a.item_id=i.item_id and  
date1>=(select to_char(to_date('${date1}','yyyymmdd')-(to_date('${date2}','yyyymmdd')-to_date('${date1}','yyyymmdd')+1),'yyyymmdd') from dual)
and date1<=(select to_char(to_date('${date2}','yyyymmdd')-(to_date('${date2}','yyyymmdd')-to_date('${date1}','yyyymmdd')+1),'yyyymmdd') from dual)
group by sale_dept_id,custqh) b,
(
select sale_dept_id,custqh,sum(qty_sold*t_size)/50000 qtyt  from qhsale a,plm_item i 
 where  a.item_id=i.item_id and 
date1>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd' ) from dual)
 and date1<=(select to_char(add_months(to_date('${date2}','yyyymmdd'),-12),'yyyymmdd' ) from dual)
group by sale_dept_id,custqh
) c,
(

select '1137'||substr(dp.dpt_sale_id,1,4) sale_dept_id,short_name,NVL(CUST_TYPE3,'51') CUST_TYPE3,COUNT(1)   from co_cust cc,dpt_sale dp  
where cc.sale_dept_id='1137'||substr(dp.dpt_sale_id,1,4) GROUP BY '1137'||substr(dp.dpt_sale_id,1,4) ,short_name,NVL(CUST_TYPE3,'51') 
) D
WHERE A.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND B.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND C.SALE_DEPT_ID(+)=D.SALE_DEPT_ID
AND A.CUSTQH(+)=D.CUST_TYPE3
AND B.CUSTQH(+)=D.CUST_TYPE3
AND C.CUSTQH(+)=D.CUST_TYPE3

order by cust_type3

