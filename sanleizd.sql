select sale_dept_id,count(cust_id)  n  from co_cust where status='02' group by sale_dept_id

   select cc.sale_dept_id,count(cc.cust_id) nu
   from crm_cust rc,co_cust cc
   where cc.cust_id=rc.cust_id
   and cc.status='02'
   and rc.rim_kind in ('11','12','13','14')
   and cc.base_type in ('F','Q')
   group by  cc.sale_dept_id

  select cc.sale_dept_id,rc.rim_kind,count(cc.cust_id) nu
   from crm_cust rc,co_cust cc
   where cc.cust_id=rc.cust_id
   and cc.status='02'
   group by  cc.sale_dept_id,rc.rim_kind

select   a.sale_dept_id,nus,nu
from 
   (select cc.sale_dept_id,count(cc.cust_id) nus
   from crm_cust rc,co_cust cc
   where cc.cust_id=rc.cust_id
   and cc.status='02'
   and rc.rim_kind in ('11','12','13')
   and cc.base_type in ('Y','B','Z','N','S')
   group by  cc.sale_dept_id) a,
    
   (select cc.sale_dept_id,count(cc.cust_id) nu
   from crm_cust rc,co_cust cc
   where cc.cust_id=rc.cust_id
   and cc.status='02'
   and cc.base_type in ('Y','B','Z','N','S')
   group by  cc.sale_dept_id) b
   where b.sale_dept_id=a.sale_dept_id

  select cc.sale_dept_id,count(cc.cust_id) nu
   from crm_cust rc,co_cust cc
   where cc.cust_id=rc.cust_id
   and cc.status='02'
   and rc.rim_kind in ('11','12','13')
   and cc.base_type in ('F','Q')
   group by  cc.sale_dept_id

