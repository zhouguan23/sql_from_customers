select sls.slsman_id,sls.note,
sum(ps.qty_sold*t_size)/50000 qtyb,sum(ps.amt_sold) amt from 
pi_slsman_item_day ps,plm_item i,slsman sls 
where ps.item_id=i.item_id and ps.slsman_id=sls.slsman_id and sls.dpt_sale_id='${dptid}'
and ps.date1>='${date1}' and ps.date1<='${date2}'
group by sls.slsman_id,sls.note
having sum(qty_sold)<>0

select sls.slsman_id,sls.note,
sum(ps.qty_sold*t_size)/50000 qtyb,sum(ps.amt_sold) amt from 
pi_slsman_item_day ps,plm_item i,slsman sls 
where ps.item_id=i.item_id and ps.slsman_id=sls.slsman_id and sls.dpt_sale_id='${dptid}'
and ps.date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL) and  
 ps.date1<=(SELECT  TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)
group by sls.slsman_id,sls.note
having sum(qty_sold)<>0

select p.brand_id,brand_name,p.brdowner_id,
sum(qty_need*t_size)/50000 qtyneed,sum(qty_sold*t_size)/50000 ppqtyb  from 
pi_dept_item_day ps,plm_item i,plm_brand p
where ps.item_id=i.item_id  and i.brand_id=p.brand_id
  and sale_dept_id='${dptid}'
and ps.date1>='${date1}' and ps.date1<='${date2}'
group by p.brand_id,brand_name,p.brdowner_id
having sum(qty_sold)<>0 order by p.brdowner_id

select p.brand_id,brand_name,p.brdowner_id,
sum(qty_sold*t_size)/50000 ppqtyt  from 
pi_dept_item_day ps,plm_item i,plm_brand p
where ps.item_id=i.item_id  and i.brand_id=p.brand_id
and sale_dept_id='${dptid}'
and ps.date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)   and   
 ps.date1<=(SELECT  TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)
group by p.brand_id,brand_name,p.brdowner_id
having sum(qty_sold)<>0 order by p.brdowner_id

select slsman_id,note from slsman where dpt_sale_id='${dptid}' and is_mrb=1

select dpt_sale_name from dpt_sale where dpt_sale_id='${dptid}'

select * from plm_brand where brand_id in 
(
select  brand_id
  from pi_dept_item_day ps,plm_item i 
where ps.item_id=i.item_id  
  and sale_dept_id='${dptid}' and qty_sold<>0
and ps.date1>='${date1}' and ps.date1<='${date2}'
union

select  brand_id
  from pi_dept_item_day ps,plm_item i 
where ps.item_id=i.item_id  
  and sale_dept_id='${dptid}' and qty_sold<>0
and ps.date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL) and  
 ps.date1<=(SELECT  TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)

) order by brdowner_id

select sls.slsman_id,sls.note,
sum(ps.qty_sold*t_size)/50000 qtys,sum(ps.amt_sold) amts from 
pi_slsman_item_day ps,plm_item i,slsman sls 
where ps.item_id=i.item_id and ps.slsman_id=sls.slsman_id and sls.dpt_sale_id='${dptid}'
and ps.date1>=(select to_char(to_date('${date1}','yyyymmdd')-(to_date('${date2}','yyyymmdd')-to_date('${date1}','yyyymmdd')+1),'yyyyMMdd') from dual)
 and ps.date1<=(select to_char(to_date('${date2}','yyyymmdd')-(to_date('${date2}','yyyymmdd')-to_date('${date1}','yyyymmdd')+1),'yyyyMMdd') from dual)

group by sls.slsman_id,sls.note
having sum(qty_sold)<>0

