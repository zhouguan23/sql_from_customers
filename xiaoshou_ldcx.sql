select f.brdowner_id fact_id,substr(brdowner_name,1,4) fact_name ,i.item_id,item_name,i.kind,i.tar_cont tars, price_puh  pri_puh,price_trade pri_wsale,
  i.yieldly_type is_imported,ic.price_retail pri_rtl,i.brand_id itemgr_id 
from  plm_brandowner f,plm_item i,  plm_item_com ic 
where f.brdowner_id=i.brdowner_id 
and i.item_id=ic.item_id  
and i.item_id in 
(select distinct item_id from 
( select distinct item_id from pi_com_month where date1>=(select  to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyy')||'01'  from dual)
and  date1<=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm')  from dual)  group by item_id having sum(qty_sold)<>0
union all
select  distinct item_id from pi_com_month where date1>=(select to_char(to_date('${date1}','yyyymm'),'yyyy')||'01' from dual)
 and date1<=(select to_char(to_date('${date1}','yyyymm'),'yyyymm') from dual)
group by item_id having sum(qty_sold)<>0
)
)
 
order by f.brdowner_id ,i.brand_id,kind asc,ic.price_trade  desc


select  a.item_id,date1,kind,round(sum(qty_sold*t_size)/50000,2) qty,round(sum(amt_sold),0) amt,round(sum(gross_profit),0) ml
 from pi_com_month a,plm_item i  where  a.item_id=i.item_id and date1>=(select to_char(to_date('${date1}','yyyymm'),'yyyy')||'01' from dual)
and  date1<='${date1}'  group by a.item_id,date1,kind having sum(qty_sold)<>0
 


select  a.item_id,date1,kind,round(sum(qty_sold*t_size)/50000,2) qty,round(sum(amt_sold),0) amt,
round(sum(gross_profit),0) ml
 from pi_com_month a,plm_item i  where a.item_id=i.item_id and 
date1>=(select  to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyy')||'01'  from dual)
and  date1<=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm')  from dual)  group by a.item_id,date1,kind having sum(qty_sold)<>0

select bqrq,tqrq from 
(
select to_char(to_date('${date1}','yyyymm'),'yyyymm') bqrq from dual
) ,
(
select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm') tqrq  from dual
)



