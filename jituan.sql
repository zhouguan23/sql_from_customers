 select im.item_name,
          ic.short_code,
          sum(cl.qty_ord) a,sum(cl.qty_ord*price) b
     from co_cust ct,co_co co,co_co_line cl,plm_item im,plm_item_com ic
     where co.co_num=cl.co_num and
           co.cust_id=ct.cust_id and
           cl.item_id=im.item_id and
           co.born_date>='${time1}' and
           co.born_date<='${time2}' and
           co.status in ('30','40','50','60') and
           im.item_id=ic.item_id and
           ic.com_id='10371701' and
           ct.sale_dept_id='${dptno}' and
           ct.cust_name like '${cust_name}'
     group by im.item_name,
          ic.short_code  having sum(cl.qty_ord)<>0
     order by ic.short_code

 select  substr(ct.cust_id,5,9) cust_id ,cust_name,im.item_name,
          ic.short_code,
          sum(cl.qty_ord) a,sum(cl.qty_ord*price) b
     from co_cust ct,co_co co,co_co_line cl,plm_item im,plm_item_com ic
     where co.co_num=cl.co_num and
           co.cust_id=ct.cust_id and
           cl.item_id=im.item_id and
           co.born_date>='${time1}' and
           co.born_date<='${time2}' and
           co.status in ('30','40','50','60','09') and
           im.item_id=ic.item_id and
           ic.com_id='10371701' and
           ct.sale_dept_id='${dptno}' and
           ct.cust_name like '${cust_name}'
     group by ct.cust_id,cust_name,im.item_name,
          ic.short_code  having sum(cl.qty_ord)<>0
     order by ct.cust_id, im.item_name 
           

select c.cust_id,cig_lice_id,cust_short_name,busi_addr,tel,
case when cust_type3_root='01' then '食杂店'
when cust_type3_root='02' then '便利店'
when cust_type3_root='03' then '超市'
when cust_type3_root='04' then '商场'
when cust_type3_root='05' then '烟酒店'
when cust_type3_root='06' then '娱乐服务'
when cust_type3_root='07' then '其他'
else '未定义' end as custtype,
case when  status='02' then '有效' when status='03' then '暂停'
 when status='04' then '吊销' when status='05' then '注销' end  as status ,
case when pay_type='03' then '电子结算户' else '非结算户' end as pay_type,
cust_type4, case visit_order when 'HZ001' then  '电话订货' else '网订' end  as domain_name ,sls.note,call_period
 from cust   c,slsman sls where c.slsman_id=sls.slsman_id and  (cig_lice_id in 
(${cust_id}) or cust_id in (${cust_id}))

