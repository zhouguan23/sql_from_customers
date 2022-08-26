select  i.item_id, sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt  from pi_dept_item_day a,plm_item i 
 where date1>='${date1}'  and date1<='${date2}'  and a.item_id=i.item_id  
 and qty_sold<>0 group by i.kind,i.item_id 
 

select  i.item_id ,sum(qty_sold*t_size)/50000 qtyt,sum(amt_sold) amtt  from pi_dept_item_day a,plm_item i  
 where date1>=(select to_char(add_months(to_date('${date1}' ,'yyyymmdd'),-12 ),'yyyymmdd')  from dual) 
 and date1<=(select to_char(add_months(to_date('${date2}' ,'yyyymmdd'),-12 ),'yyyymmdd')  from dual)   
 and a.item_id=i.item_id and a.qty_sold<>0   group by  i.item_id 


 select  kind,i.item_id,item_name,price_trade ,i.brdowner_id from plm_item i,plm_item_com ic,
 (
 select distinct item_id from pi_dept_item_day where date1>='${date1}'  and date1<='${date2}' and qty_sold<>0
 union
 select   distinct item_id from pi_dept_item_day where date1>=(select to_char(add_months(to_date('${date1}' ,'yyyymmdd'),-12 ),'yyyymmdd')  from dual) 
 and date1<=(select to_char(add_months(to_date('${date2}' ,'yyyymmdd'),-12 ),'yyyymmdd')  from dual)   and qty_sold<>0
 ) b where i.item_id=b.item_id and i.item_id=ic.item_id  order by kind asc，price_trade desc,brdowner_id

