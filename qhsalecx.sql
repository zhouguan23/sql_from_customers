select f.brdowner_id fact_id,substr(brdowner_name,1,4) fact_name ,i.item_id,item_name,i.kind,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars,  pri_puh,  pri_wsale,
  i.yieldly_type is_imported,ic.pri_rtl,i.brand_id itemgr_id,
case pp.is_key_brd when '1' then 1 else 0 end as note ,i.is_thin
from  plm_brandowner  f,plm_item  i,  item_com  ic ,plm_brand  pp

where f.brdowner_id=i.brdowner_id  and pp.brand_id=i.brand_id
and i.item_id=ic.item_id   

and i.item_id in 
( select distinct item_id from qhsale_month where 
date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyy'),1,4)||'01' FROM DUAL) group by item_id having sum(qty_sold)<>0
)
 
order by f.brdowner_id ,i.brand_id,kind asc,ic.pri_wsale  desc


select a.item_id,sum(a.qty_sold*t_size)/50000 qty,round(sum(a.amt_sold),0) amt 
 from  qhsale_month a,plm_item i  
 where   a.qty_sold<>0 and 
 a.item_id=i.item_id and cust_type3 in  (${qh})  and  date1='${date1}' 
  ${if(len(dptid)==0 ,""," and sale_dept_id='"+dptid+"'")} group by a.item_id  


select  a.item_id,i.kind,sum(a.qty_sold*t_size)/50000 qty,round(sum(a.amt_sold),0) amt 
 from qhsale_month  a,plm_item i 
 where  a.item_id=i.item_id  and  cust_type3 in  (${qh})
  ${if(len(dptid)==0 ,""," and sale_dept_id='"+dptid+"'")} 
  and  date1=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') FROM DUAL) 
 group by a.item_id,i.kind having sum(a.qty_sold)<>0

select  a.item_id,sum(a.qty_sold*t_size)/50000 qty,round(sum(a.amt_sold),0) amt 
 from qhsale_month a,plm_item i 
 where a.item_id=i.item_id  and  cust_type3 in (${qh})
 ${if(len(dptid)==0 ,""," and sale_dept_id='"+dptid+"'")}
 and   date1>=(select to_char(to_date('${date1}','yyyymm'),'yyyy')||'01' from dual)
and  date1<='${date1}'  group by a.item_id  

select  a.item_id,i.kind,sum(a.qty_sold*t_size)/50000 qty,round(sum(a.amt_sold),0) amt 
 from  qhsale_month a,plm_item i  where 
   a.item_id=i.item_id  and cust_type3 in (${qh})
    ${if(len(dptid)==0 ,""," and sale_dept_id='"+dptid+"'")} 
 and date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyy')||'01' FROM DUAL) and  date1<=(SELECT  to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') FROM DUAL) 
 group by a.item_id,i.kind  


select di_id,di_name from di_where where isstatefl=1

