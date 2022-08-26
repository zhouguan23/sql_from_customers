
 select kind,sum(qty_sold*t_size)/50000 qtyy from qhsale_month a,plm_item i  where date1>=(select to_char(sysdate,'yyyy')||'01' from dual) and a.item_id=i.item_id
 group by kind

 select kind,sum(qty_sold*t_size)/50000 qtyb from qhsale_month a,plm_item i  where date1>=(select to_char(sysdate,'yyyymm')  from dual) and a.item_id=i.item_id
 group by kind

select distinct  kind from item order by kind

 select kind,sum(qty_sold*t_size)/50000 qtysb from qhsale a,plm_item i  where date1>=(select  to_char(add_months( sysdate, -12) ,'yyyymm')||'01' from dual) 
 and  date1<=(select  to_char(add_months( sysdate, -12) ,'yyyymmdd') from dual)and a.item_id=i.item_id
 group by kind

 select kind,sum(qty_sold*t_size)/50000 qtysb from qhsale a,plm_item i  where date1>=(select  to_char(add_months( sysdate, -12) ,'yyyy')||'0101' from dual)
 and date1<=(select  to_char(add_months( sysdate, -12) ,'yyyymmdd') from dual)
 and a.item_id=i.item_id
 group by kind


  select distinct item_type3,substr(item_type3,2,10) fl from item_com

 select item_type3,sum(qty_sold*t_size)/50000 qtyb from qhsale_month a,plm_item i,item_com ic
 where date1>=(select to_char(sysdate,'yyyymm')  from dual) and a.item_id=i.item_id and i.item_id=ic.item_id
 group by item_type3


 select item_type3,sum(qty_sold*t_size)/50000 qtyy from qhsale_month a,plm_item i,
 item_com ic where date1>=(select to_char(sysdate,'yyyy')||'01' from dual) and a.item_id=i.item_id and i.item_id=ic.item_id
 group by item_type3

 select item_type3,sum(qty_sold*t_size)/50000 qtysb from qhsale a,plm_item i,item_com ic
 where date1>=(select  to_char(add_months( sysdate, -12) ,'yyyymm')||'01' from dual) 
 and  date1<=(select  to_char(add_months( sysdate, -12) ,'yyyymmdd') from dual)and a.item_id=i.item_id and i.item_id=ic.item_id 
 group by item_type3

 select item_type3,sum(qty_sold*t_size)/50000 qtysb from qhsale a,plm_item i ,item_com ic
 where date1>=(select  to_char(add_months( sysdate, -12) ,'yyyy')||'0101' from dual)
 and date1<=(select  to_char(add_months( sysdate, -12) ,'yyyymmdd') from dual)
 and a.item_id=i.item_id and i.item_id=ic.item_id 
 group by item_type3

