select   cc.cust_id,cc.cust_name, cc.order_tel,case  cs.periods_id
when 'HZ0701'  then '周一'
when 'HZ0702'  then '周二'
when 'HZ0703'  then '周三'
when 'HZ0704'  then '周四'
when 'HZ0705'  then '周五'  end as periods_id,
  ld.rut_id,lr.rut_name,vc.c_line_id,vl.sl_name,case when cc.status='02' then '有效'
 when cc.status='03' then '暂停' 
 when cc.status='01' then '新增' end as status
 from co_cust cc,ldm_cust  lc,ldm_cust_dist ld,ldm_dist_rut lr,vms_custs@heze  vc,vms_send_lines@heze  vl,csc_cust cs
 where  lc.cust_id=cc.cust_id
 and ld.cust_id=lc.cust_id
 and lr.rut_id=ld.rut_id
 and vc.c_id=cc.cust_id
 and vl.sl_id=vc.c_line_id
 and cs.cust_id=cc.cust_id
 and (cc.status='02'  or status='03'  or status='01')
 and lc.deliver_id='${deliver}'
 order by cc.cust_id
 

select 

