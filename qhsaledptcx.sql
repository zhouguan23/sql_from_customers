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

 
  select qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt

from plm_item i ,item_com ic,plm_brand pp,qhsale_month qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id
and qh.date1='${date1}'  
and qh.cust_type3 in  (${qh})
group by qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl



  select qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt

from plm_item i ,item_com ic,plm_brand pp,qhsale_month qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id
and qh.date1=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') FROM DUAL)  
and qh.cust_type3 in  (${qh})
group by qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl


 
  select qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt

from plm_item i ,item_com ic,plm_brand pp,qhsale_month qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id and 
 date1>=(select to_char(to_date('${date1}','yyyymm'),'yyyy')||'01' from dual)
and qh.date1<='${date1}'  
and qh.cust_type3 in  (${qh})
group by qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl

   select qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt

from plm_item i ,item_com ic,plm_brand pp,qhsale_month qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id
and qh.date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyy')||'01' FROM DUAL) and  date1<=(SELECT  to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') FROM DUAL) 
and qh.cust_type3 in  (${qh})
group by qh.sale_dept_id, i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl


select di_id,di_name from di_where where isstatefl=1

select distinct is_prm,substr(is_prm,2,16) pricefl from item_com

