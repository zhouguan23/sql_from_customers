select sale_dept_id,cust_seg,count(1) custfdb from crm_cust_segment_month a,co_cust cc
where a.cust_id=cc.cust_id and cc.status='02' and a.date1=(select max(date1) from crm_cust_segment_month)
and sale_dept_id in ('${dptid}') group by sale_dept_id,cust_seg
order by sale_dept_id,cust_seg desc

select sale_dept_id,cust_seg,count(1) custfds from crm_cust_segment_month a,co_cust cc
where a.cust_id=cc.cust_id and cc.status='02' and 
a.date1=(select to_char(add_months(to_date(max(date1),'yyyyMM'),-3),'yyyymm') from crm_cust_segment_month)
and sale_dept_id in ('${dptid}') group by sale_dept_id,cust_seg
order by sale_dept_id,cust_seg desc

select sale_dept_id,short_name from dpt_sale 
where dpt_sale_id<>'17010100'  and 
   sale_dept_id in 
   ('${dptid}') 
 order by dpt_sale_id_new 

select distinct cust_seg from co_cust
where cust_seg>='01' and cust_seg<='30' order by cust_seg desc

select sale_dept_id,cust_seg,count(1) custfdt from crm_cust_segment_month a,co_cust cc
where a.cust_id=cc.cust_id and cc.status='02' and 
a.date1=(select to_char(add_months(to_date(max(date1),'yyyyMM'),-12),'yyyymm') from crm_cust_segment_month)
and sale_dept_id in ('${dptid}') group by sale_dept_id,cust_seg
order by sale_dept_id,cust_seg desc

