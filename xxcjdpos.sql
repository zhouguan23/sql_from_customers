select  sc.sale_dept_id,sc.cust_id,sc.cust_name,sc.license_code,sc.cust_seg,bengj,sgj,benqty,sqty,kucun5,kucun12,kucun19
from (select cc.sale_dept_id,cc.cust_id,cc.cust_name,cc.license_code,cc.cust_seg
from  co_cust cc, scm_mic_cust_auto  scm where cc.cust_id=scm.cust_id
and cc.status='02') sc 
left join
(select cust_id,sum(qty_purch) bengj,sum(qty_sold) benqty from rim_cust_item_day 
where crea_date>='${date1}'
and crea_date<='${date2}'
group by cust_id) b on sc.cust_id=b.cust_id
left join 
(select cust_id,sum(qty_purch) sgj,sum(qty_sold) sqty from rim_cust_item_day 
where crea_date>=(select to_char((to_date(${date1},'yyyy-mm-dd')-7),'yyyymmdd') from dual)
and crea_date<='${date1}'
group by cust_id) s on sc.cust_id=s.cust_id
left join 
 (select cust_id,sum(qty) kucun5 from co_cust_store where date1=(select to_char((to_date(${date1},'yyyy-mm-dd')-7),'yyyymmdd') from dual)  group by cust_id)  kc5  on sc.cust_id=kc5.cust_id
left join 
  (select cust_id,sum(qty) kucun12 from co_cust_store where date1='${date1}' group by cust_id)  kc12  on sc.cust_id=kc12.cust_id
left join 
   (select cust_id,sum(qty) kucun19 from co_cust_store where date1=(select to_char((to_date(${date2},'yyyy-mm-dd')+1),'yyyymmdd') from dual) group by cust_id)  kc19 on sc.cust_id=kc19.cust_id


