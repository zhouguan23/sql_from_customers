
select i.item_id,round(sum(qty_sold*t_size)/50000,2)  qty from  pi_com_month a,plm_item i 
where a.item_id=i.item_id and date1>='${date1}' and date1<='${date2}' group by i.item_id having sum(qty_sold)<>0 



select f.vend_name fact_name,brand_name itemgr_name,item_name,i.item_id,price_trade pri_wsale
 from pi_vend f,plm_item i ,plm_item_com ic,plm_brand im
where f.vend_id=i.brdowner_id and i.item_id=ic.item_id and i.brand_id=im.brand_id and ic.com_id='10371701'
 and i.item_id in 
(
select distinct item_id from 
(select distinct item_id from  pi_com_month where date1>='${date1}' and date1<='${date2}' group by item_id having sum(qty_sold)<>0 
union all
select distinct item_id  from  pi_com_month where
 date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm')  from dual)
and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm')  from dual)
 group by item_id having sum(qty_sold)<>0 
)
) order by f.vend_name 


select i.item_id,round(sum(qty_sold*t_size)/50000,2) qtytong from  pi_com_month a,plm_item i  where
a.item_id=i.item_id and   date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm')  from dual)
and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm')  from dual)
 group by i.item_id having sum(qty_sold)<>0 

