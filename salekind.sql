select sale_Dept_id,i.kind,
sum(qty_sold*t_size)/50000 qtyb,sum(amt_sold) amt from 
pi_dept_item_day ps,plm_item i
where ps.item_id=i.item_id 
and ps.date1>='${date1}' and ps.date1<='${date2}'
group by sale_Dept_id, i.kind
having sum(qty_sold)<>0

select sale_Dept_id,i.kind,
sum(qty_sold*t_size)/50000 qtyt,sum(amt_sold) amtt from 
pi_dept_item_day ps,plm_item i 
where ps.item_id=i.item_id  
and ps.date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL) and   ps.date1<=(SELECT  TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)
group by sale_Dept_id ,i.kind 
having sum(qty_sold)<>0

select distinct kind from plm_item order by kind

select p.brand_id,brand_name,p.brdowner_id,
sum(qty_need*t_size)/50000 qtyneed,sum(qty_sold*t_size)/50000 ppqtyb  from 
pi_dept_item_day ps,plm_item i,plm_brand p
where ps.item_id=i.item_id  and i.brand_id=p.brand_id
${if(len(dptid)==0,""," and sale_dept_id in ('"+dptid+ "')")}
and ps.date1>='${date1}' and ps.date1<='${date2}'
group by p.brand_id,brand_name,p.brdowner_id
having sum(qty_sold)<>0 order by p.brdowner_id

select p.brand_id,brand_name,p.brdowner_id,
sum(qty_sold*t_size)/50000 ppqtyt  from 
pi_dept_item_day ps,plm_item i,plm_brand p
where ps.item_id=i.item_id  and i.brand_id=p.brand_id
${if(len(dptid)==0,""," and sale_dept_id in ('"+dptid+ "')")}
and ps.date1>=(SELECT  TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)   and   
 ps.date1<=(SELECT  TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'YYYYMMdd') FROM DUAL)
group by p.brand_id,brand_name,p.brdowner_id
having sum(qty_sold)<>0 order by p.brdowner_id

