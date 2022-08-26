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

select cc.cust_id,REGION_id,cust_short_name,busi_addr,order_tel   tel, 
case when pay_type='10' then '现金'
 when pay_type='24' then '支票'
when pay_type='20' then '电子结算'
when pay_type='21' then '网银'
when pay_type='22' then '终端'
when pay_type='23' then 'POS刷卡' 
else '' end as paytype,
case when bank_id='HZ1012' then '工行'
 when bank_id='HZ1511' then '农行'
 when bank_id='HZ1011' then '农信'
 when bank_id='HZ1005' then '邮政'
else ''  end  as frombank

 from ldm_cust c, co_cust cc,CO_DEBIT_ACC CA
where  c.cust_id=cc.cust_id AND CC.STATUS='02'
 AND CA.CUST_ID(+)=CC.CUST_ID
and CC.sale_dept_id=${dptno}

