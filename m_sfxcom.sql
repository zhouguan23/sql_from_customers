
select s.com_id,sum(qty_sold*t_size)/50000 qtyday,sum(amt_sold) amtday from s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1=(select to_char(sysdate,'yyyyMMdd') from dual)
group by s.com_id

select s.com_id,sum(qty_sold*t_size)/50000 qtymonth,sum(amt_sold)*50000/sum(qty_sold*t_size) monghdx from s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1>=(select to_char(sysdate,'yyyyMM')||'01' from dual)
group by s.com_id

select s.com_id,kind,sum(qty_sold*t_size)/50000 kindmonth from s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1>=(select to_char(sysdate,'yyyyMM')||'01' from dual)
group by s.com_id,kind

select com_id,com_name,pop from s_com order by note

select distinct kind,kind||'类' from item

select to_date(to_char(sysdate-1,'yyyymmdd'),'yyyymmdd')
- to_date(to_char(to_date(to_char(sysdate-1,'yyyymmdd'),'yyyymmdd'),'yyyymm')||'01','yyyymmdd')+1 daypastyue
 from dual

select sale_dept_id,i.kind,sum(qty_sold*t_size)/50000 kindmonthd 
from  plm_item i, pi_dept_item_day a
where  a.item_id=i.item_id
and date1>=(select to_char(sysdate,'yyyyMM')||'01' from dual)
and date1<=(select to_char(sysdate,'yyyyMMdd') from dual)
group by sale_dept_id,i.kind

select sale_dept_id,sum(qty_sold*t_size)/50000 monthd 
from  plm_item i, pi_dept_item_day a
where  a.item_id=i.item_id
and date1=(select to_char(sysdate,'yyyyMMdd') from dual)
group by sale_dept_id

