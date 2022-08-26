select f.vend_name fact_name,a.sale_dept_id,sum(benq*i.t_size)/50000 benq,sum(tongq*i.t_size)/50000  tongq
 from pi_vend f,plm_item i ,
 ( select pd.sale_dept_id,pd.item_id,sum(pd.qty_sold) benq
  from pi_dept_item_day  pd
  where pd.qty_sold>0
  and pd.date1>='${date1}'
and pd.date1<='${date2}'
group by pd.sale_dept_id,pd.item_id) a,
 ( select pd.sale_dept_id,pd.item_id,sum(pd.qty_sold) tongq
  from pi_dept_item_day  pd
  where pd.qty_sold>0
  and pd.date1>=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-12),'yyyymmdd')from dual)
and pd.date1<=(select to_char(add_months(to_date('${date2}','yyyyMMdd'),-12),'yyyymmdd')from dual)
group by pd.sale_dept_id,pd.item_id) b
 where f.vend_id=i.brdowner_id 
and a.item_id=i.item_id
and b.item_id=i.item_id 
and a.sale_dept_id=b.sale_dept_id
group by f.vend_name,a.sale_dept_id


select f.vend_name fact_name,a.sale_dept_id,sum(benq*i.t_size)/50000 benq,sum(tongq*i.t_size)/50000  tongq
 from plm_item i  left join  pi_vend f on ( f.vend_id=i.brdowner_id)
 left join
 ( select pd.sale_dept_id,pd.item_id,sum(pd.qty_sold) benq
  from pi_dept_item_day  pd
  where pd.qty_sold>0
  and pd.date1>='20210301'
and pd.date1<='20210331'
group by pd.sale_dept_id,pd.item_id) a on a.item_id=i.item_id
left  join
 ( select pd.sale_dept_id,pd.item_id,sum(pd.qty_sold) tongq
  from pi_dept_item_day  pd
  where pd.qty_sold>0
  and pd.date1>=(select to_char(add_months(to_date('20210301','yyyyMMdd'),-12),'yyyymmdd')from dual)
and pd.date1<=(select to_char(add_months(to_date('20210331','yyyyMMdd'),-12),'yyyymmdd')from dual)
group by pd.sale_dept_id,pd.item_id) b on (b.item_id=i.item_id and  a.sale_dept_id=b.sale_dept_id)
group by f.vend_name,a.sale_dept_id

