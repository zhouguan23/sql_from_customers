select f.brdowner_id fact_id,substr(brdowner_name,1,4) fact_name ,i.item_id,item_name,i.kind,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars,  price_puh pri_puh,  price_trade pri_wsale,
  i.yieldly_type is_imported,ic.price_retail  pri_rtl,i.brand_id itemgr_id,
case pp.is_key_brd when '1' then 1 else 0 end as note ,is_thin
from  plm_brandowner  f,plm_item  i,  plm_item_com  ic ,plm_brand  pp

where f.brdowner_id=i.brdowner_id  and pp.brand_id=i.brand_id 
and i.item_id=ic.item_id and  ic.com_id='10371701' and i.item_id in 
( select distinct item_id from pi_dept_item_day where  date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'yyyyMMdd') FROM DUAL) and  date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'yyyyMMdd') FROM DUAL)  and qty_sold<>0
union 
select distinct   item_id from pi_dept_item_day where  date1>='${date1}' and  date1<='${date2}' 
 and qty_sold<>0 
)
order by f.brdowner_id ,i.brand_id,kind asc,ic.price_trade  desc


select  a.item_id,round(sum(a.qty_sold*t_size)/50000,2) qty,round(sum(a.amt_sold),0) amt,round(sum(a.gross_profit),0) ml
 from pi_dept_item_day a,plm_item i 
 where  a.item_id=i.item_id and sale_dept_id like '${dptid}%' and date1>='${date1}'
and  date1<='${date2}'  group by a.item_id having sum(qty_sold)<>0
 


select  a.item_id,date1,kind,sum(yuce) qty, round(sum(yuce*250*pri_wsale),0) amt,
round(sum(yuce*250*(pri_wsale-pri_puh)),0) ml
 from hztianbao a,plm_item i,item_com ic
  where a.item_id=i.item_id and  a.item_id=ic.item_id
and a.sale_dept_id like '${dptid}%' and date1=(select to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM') from dual)
group  by a.item_id,date1,kind 


select  a.item_id,i.kind,round(sum(a.qty_sold*t_size)/50000,2) qty,round(sum(a.amt_sold),0) amt,round(sum(a.gross_profit),0) ml
 from pi_dept_item_day a,plm_item i  where  a.item_id=i.item_id
and sale_dept_id like '${dptid}%' and date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMMdd'),-12),'yyyyMMdd') FROM DUAL) and  date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMMdd'),-12),'yyyyMMdd') FROM DUAL) 
 group by a.item_id,i.kind having sum(qty_sold)<>0

