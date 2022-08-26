select distinct sls.slsman_id,sls.note ,count(cust_id) qty 
from  slsman sls ,co_cust c
where  sls.com_id='10371701' and c.slsman_id=sls.slsman_id and c.status='02'
 and is_mrb=1
and sls.dpt_sale_id=${dptno}
group by sls.slsman_id,sls.note

select slsman_id,rut_id,rut_name,count(c.cust_id) qty  from co_cust c,ldm_cust a,ldm_dist_rut b
where a.region_id=b.rut_id and c.cust_id=a.cust_id and c.status='02'
and c.sale_DEPT_id='${dptno}'
group by slsman_id,rut_id,rut_name

select dp.dpt_sale_id,dp.short_name,count(distinct slsman_id) slsnum ,count(cust_id) custnum 
from co_cust  c,dpt_sale dp where status='02' and c.sale_dept_id=dp.dpt_sale_id
group by dp.dpt_sale_id, dp.short_name order by dp.dpt_sale_id

