select c.cust_id,cust_short_name,busi_addr,order_tel tel,trim(dplx_name) dplx_name,di_name,
case c.base_type when 'Z' then '食杂店' when 'B' then 
'便利店' when 'S' then '超市' when 'N' then '商场' when 'Y' then '烟酒商店'
when 'F' then '娱乐服务' when 'Q' then '其他' else '' end as  jyyt_name,
 trim(xiang_name)||trim(x_cun_name)||trim(z_cun_name) weiz,cr.rut_name,sls.note
 from  co_cust c, dplx dplx ,di_where d,ldm_dist_rut@hzyx  cr,ldm_cust_dist@hzyx lc ,slsman sls,v_cant_hz@hzyx xx
where c.cust_type3=d.di_id and c.cust_type7=dplx.dplx_id and  c.slsman_id=sls.slsman_id  
and c.cust_id=lc.cust_id and lc.rut_id=cr.rut_id and c.cant_id=xx.z_cun_id
 and c.status='02'
${if(len(custname)==0,""," and cust_short_name like '%"+custname+"%'")}
   
${if(len(slsmanid)==0,""," and sls.slsman_id='"+slsmanid+"'")}
${if(len(custid)==0,"" ," and c.cust_id in ("+custid+")")}

${if(len(custid)==0&&len(slsmanid)==0&&len(custname)==0," and c.sale_dept_id='11371706' " ,"")}


