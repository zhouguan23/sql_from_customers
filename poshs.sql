select sale_dept_id,count(cust_id)  n  from co_cust where status='02' group by sale_dept_id

   
   select cc.sale_dept_id,count(cc.cust_id)  pn
   from rim_cust rm,co_cust cc where cc.cust_id=rm.cust_id 
   and  pos_version='1' and cc.status='02' 
   group  by cc.sale_dept_id

  select cc.sale_dept_id,count(sm.cust_id)  xxd
   from co_cust cc,scm_mic_cust_auto  sm 
   where  sm.cust_id=cc.cust_id   and cc.status='02' group by cc.sale_dept_id


   select cc.sale_dept_id,cust_kind10,count(cc.cust_id)  xingh 
   from crm_cust  cr,co_cust cc,rim_cust rc
   where cr.cust_id=cc.cust_id
   and rc.cust_id=cc.cust_id
   and rc.pos_version='1'
   and cust_kind10 is not null
   and cc.status='02' group by cc.sale_dept_id,cust_kind10

