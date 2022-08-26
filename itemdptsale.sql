select i.item_id,item_name,ic.short_code,price_trade,price_retail from 
plm_item i,plm_item_com ic
where i.item_id=ic.item_id and ic.com_id='10371701' 
  order by ic.price_trade desc

select i.item_id,sale_dept_id,sum(qty_sold*i.t_size)/50000 qty from pi_dept_item_month a,plm_item i
where a.item_id=i.item_id and a.date1>='${date1}' and a.date1<='${date2}'
group by i.item_id,sale_Dept_id  


select i.item_id,sale_dept_id,sum(qty_sold*i.t_size)/50000 qtyshang from pi_dept_item_month a,plm_item i
where a.item_id=i.item_id and 
a.date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-1),'yyyyMM') from dual)
 and a.date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMM'),-1),'yyyyMM') from dual)
group by i.item_id,sale_Dept_id  

select i.item_id,sale_dept_id,sum(qty_sold*i.t_size)/50000 qtytong from pi_dept_item_month a,plm_item i
where a.item_id=i.item_id and 
a.date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') from dual)
 and a.date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMM'),-12),'yyyyMM') from dual)
group by i.item_id,sale_Dept_id 

