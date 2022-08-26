select * from di_where where isstatefl=1

select sale_dept_id,short_name from dpt_sale 
where dpt_sale_id<>'17010100' 
  and   sale_dept_id='${dptid}' 
 order by dpt_sale_id_new 

select i.item_id,item_name,cc.slsman_id,i.brdowner_id,
sum(a.qty_sold*i.t_size)/50000 qty from  plm_item i ,pi_cust_item_month a  ,cust@orahzbo cc
 where i.item_id=a.item_id    and a.cust_id=cc.cust_id 

 
  and cc.slsman_id in ('${sls}') 
  
and i.item_id in ('${itemid}')

and date1>='${date1}' and date1<='${date2}' 
group by i.item_id,item_name,cc.slsman_id,i.brdowner_id 
order by i.brdowner_id

select i.item_id,item_name,cc.slsman_id,i.brdowner_id,
sum(a.qty_sold*i.t_size)/50000 qtyt from  plm_item i ,pi_cust_item_month a  ,cust@orahzbo cc
 where i.item_id=a.item_id    and a.cust_id=cc.cust_id 
  and cc.slsman_id in ('${sls}') 
 and i.item_id in ('${itemid}')

and date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
 and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm' ) from dual)
group by i.item_id,item_name,cc.slsman_id,i.brdowner_id

select i.item_id,item_name,cc.slsman_id,i.brdowner_id,
sum(a.qty_sold*i.t_size)/50000 qtys from  plm_item i ,pi_cust_item_month a  ,cust@orahzbo cc
 where i.item_id=a.item_id    and a.cust_id=cc.cust_id 
  and cc.slsman_id in ('${sls}') 
 and i.item_id in ('${itemid}')

and date1>=(select to_char( to_date('${date1}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
 and date1<=(select to_char( to_date('${date2}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
group by  i.item_id,item_name,cc.slsman_id,i.brdowner_id

select slsman_id,dp.short_name||'-'||sls.note ,dpt_sale_id_new from   slsman sls,dpt_sale dp
where sls.dpt_sale_id=dp.dpt_sale_id
and dp.sale_dept_id='${dptid}' order by dp.dpt_sale_id_new,slsman_id

select  item_id,item_name from  plm_item i 
where item_id in ('${itemid}')

select ic.item_id,item_name,ic.short_id||'-'||item_name||'-'||pri_wsale  from item_com ic,plm_item i 
where ic.item_id=i.item_id  and ic.is_mrb=1 order by ic.short_id

select slsman_id,note from slsman where slsman_id in ('${sls}')

