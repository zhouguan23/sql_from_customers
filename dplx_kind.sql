 select c.dpt_sale_id,c.cust_id,cust_short_name,tel,di_name,sls.note 
from cust c,cust_prop cp,z_Cun z,di_where d,slsman sls
where c.cust_id=cp.cust_id and z.z_cun_id=cp.z_cun_id and z.dili=d.di_id and 
c.slsman_id=sls.slsman_id and c.status='02' and 
c.dpt_Sale_id='${dpt}' and dplx in ('${dplx}')

SELECT cust_id,sum(QTY_SOLD) QTY FROM  item_CUST_MONTH${YEARS}   a,item i  
where    a.item_id=i.item_id   and  iss_date='${date1}' and  dpt_sale_id='${dpt}' 
 and qty_sold<>0 and kind in (${kind}) group by cust_id

select distinct cust_id,sum(qty) qtyshang from 
(
SELECT cust_id,sum(QTY_SOLD) QTY FROM  item_CUST_MONTH${YEARS}   a,item i  
where    a.item_id=i.item_id   and  iss_date=(select to_char(add_months(to_date(${date1},'yyyymm'),-1),'yyyymm')  from dual) and  dpt_sale_id='${dpt}' 
 and qty_sold<>0 and kind in (${kind}) group by cust_id
union all
SELECT cust_id,sum(QTY_SOLD) QTY FROM  item_CUST_MONTH${YEARS2}   a,item i  
where    a.item_id=i.item_id   and  iss_date=(select to_char(add_months(to_date(${date1},'yyyymm'),-1),'yyyymm')  from dual) and  dpt_sale_id='${dpt}' 
 and qty_sold<>0 and kind in (${kind}) group by cust_id
) group by cust_id

SELECT cust_id,sum(QTY_SOLD) QTY FROM  item_CUST_MONTH${YEARS2}   a,item i  
where    a.item_id=i.item_id   and  iss_date=(select to_char(add_months(to_date(${date1},'yyyymm'),-12),'yyyymm')  from dual) and  dpt_sale_id='${dpt}' 
 and qty_sold<>0 and kind in (${kind}) group by cust_id

