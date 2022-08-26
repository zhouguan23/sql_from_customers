select sale_dept_id,count(distinct c.cust_id) custsl from  
co_cust  c
 
where  c.status='02' 

group by sale_dept_id

select sale_dept_id,count(distinct cust_id) djsl,sum(qty_sold*t_size)/50000 qty  from pi_cust_item_month a,plm_item i 

where a.item_id=i.item_id and date1=(select substr('${date1}',1,6） from dual) group by sale_dept_id

select sale_dept_id,sum(qty_sold*t_size)/50000 qtyt  from pi_cust_item_month a,plm_item i 

where a.item_id=i.item_id 
and date1=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-1),'yyyyMM')  from dual)
 group by sale_dept_id

select sale_dept_id, brand_id,yieldly_type,
case when is_thin=1 then 1 else 0 end isthin,sum(qty_sold*t_size)/50000 qty  from pi_cust_item_bnd_day a,plm_item i 

where a.item_id=i.item_id and date1='${date1}' group by sale_dept_id, brand_id,yieldly_type,is_thin
 


select sale_dept_id, count(distinct cust_id) custthin 
  from pi_cust_item_bnd_day a,plm_item i 

where is_thin=1 and a.item_id=i.item_id and date1='${date1}' group by sale_dept_id  having sum(qty_sold)<>0

select sale_dept_id, count(distinct cust_id) custthint 
  from pi_cust_item_bnd_day a,plm_item i 

where is_thin=1 and a.item_id=i.item_id and date1=(select to_char(to_date('${date1}','yyyyMMdd')-7,'yyyyMMdd') from dual) group by sale_dept_id  having sum(qty_sold)<>0


 select '1137'||substr(cust_id,5,4) sale_dept_id,sum(aa)/count(1) hjkd from (
 select a.cust_id,kd/cs aa from  
 (
select   cust_id,count(1) kd
  from pi_cust_item_bnd_day
where qty_sold<>0 and  
date1>=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'01' from dual) 
and date1<=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'31' from dual)
 group by cust_id) a,
( 
select   cust_id,count(distinct date1)  cs
  from pi_cust_item_bnd_day
where qty_sold<>0 and  
date1>=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'01' from dual) 
and date1<=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'31' from dual)
 group by cust_id
 ) b where a.cust_id=b.cust_id
 
 ) group by '1137'||substr(cust_id,5,4)


 select '1137'||substr(cust_id,5,4) sale_dept_id,sum(aa)/count(1) hjkdt from (
 select a.cust_id,kd/cs aa from  
 (
select   cust_id,count(1) kd
  from pi_cust_item_bnd_day
where qty_sold<>0 and 
date1>=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-1),'yyyyMM')||'01'  from dual
)
and 
date1<=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-1),'yyyyMM')||'31'   from dual)
 group by cust_id) a,
( 
select   cust_id,count(distinct date1)  cs
  from pi_cust_item_bnd_day
where qty_sold<>0 and 
date1>=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-1),'yyyyMM')||'01'  from dual
)
and 
date1<=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-1),'yyyyMM')||'31'   from dual)
 group by cust_id
 ) b where a.cust_id=b.cust_id
 
 ) group by '1137'||substr(cust_id,5,4)

select sale_dept_id, cust_id,count(distinct date1) cs
  from pi_cust_item_bnd_day
where qty_sold<>0 and  
date1>=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'01' from dual)
and 
date1<=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'31' from dual)
 group by sale_dept_id, cust_id

