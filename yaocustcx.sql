select  cust_id,cust_name,busi_addr,order_tel,sls.note from yao_cust c,slsman sls
where sale_dept_id='${dpt}' and c.slsman_id=sls.slsman_id
${if(len(slsmanid)==0,""," and sls.slsman_id='"+slsmanid+"'")}

select slsman_id,note from slsman  where dpt_sale_id='${dpt}'

