select * from di_where where isstatefl=1

select sale_dept_id,short_name from dpt_sale 
where dpt_sale_id<>'17010100' 
${if(len(dptid)==0,""," and   sale_dept_id in 
   ('"+dptid+"')")} 
 order by dpt_sale_id_new 

select ic.item_type3  kind,a.sale_dept_id,
sum(a.qty_sold*i.t_size)/50000 qty from  plm_item i ,qhsale_month a ,item_com ic
 where i.item_id=a.item_id   
and i.item_id=ic.item_id  
${if(len(dili)==0,""," and a.cust_type3 in ('"+dili+"')")}
 
${if(len(dptid)==0,""," and   a.sale_dept_id in 
   ('"+dptid+"')")} 
and date1>='${date1}' and date1<='${date2}' 
group by ic.item_type3,a.sale_dept_id

select ic.item_type3 period ,a.sale_dept_id,
sum(a.qty_sold*i.t_size)/50000 qtyt from  plm_item i ,qhsale_month a,item_com ic
 where i.item_id=a.item_id and i.item_id=ic.item_id
${if(len(dili)==0,""," and  cust_type3 in ('"+dili+"')")}
 
${if(len(dptid)==0,""," and    sale_dept_id in 
   ('"+dptid+"')")} 
and date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
 and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm' ) from dual)
group by ic.item_type3, sale_dept_id

select ic.item_type3 kind,a.sale_dept_id sale_dept_id,
sum(a.qty_sold*i.t_size)/50000 qtys from  plm_item i ,qhsale_month a, item_com ic
 where i.item_id=a.item_id   and i.item_id=ic.item_id 
${if(len(dili)==0,""," and a.cust_type3 in ('"+dili+"')")}
 
${if(len(dptid)==0,""," and   a.sale_dept_id in 
   ('"+dptid+"')")} 
and date1>=(select to_char( to_date('${date1}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
 and date1<=(select to_char( to_date('${date2}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
group by ic.item_type3,a.sale_dept_id

select slsman_id,dp.short_name||'-'||sls.note ,dpt_sale_id_new from   slsman sls,dpt_sale dp
where sls.dpt_sale_id=dp.dpt_sale_id order by dp.dpt_sale_id_new,slsman_id

select distinct item_type3 period,substr(item_type3,2,10) kind from item_com order by period asc

