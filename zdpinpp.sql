select brand_id,brand_name from  plm_brand where is_key_brd=1

select i.brand_id,sale_dept_id,sum(qty_sold*t_size)/50000 qtyben from 
pi_dept_item_day a,plm_item i,plm_brand p
where a.item_id=i.item_id and i.brand_id=p.brand_id and a.date1>='${date1}' and date1<='${date2}'
and p.is_key_brd=1
group by i.brand_id,sale_dept_id

select i.brand_id,sale_dept_id,sum(qty_sold*t_size)/50000 qtytong from 
pi_dept_item_day a,plm_item i,plm_brand p
where a.item_id=i.item_id and i.brand_id=p.brand_id 
and a.date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL) 
 and date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)
and p.is_key_brd=1
group by i.brand_id,sale_dept_id

