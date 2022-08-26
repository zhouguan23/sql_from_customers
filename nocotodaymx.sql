select  c.cust_id,cust_short_name,order_tel,busi_addr,b.position_code slsid,po1.organ_name slsname,po2.organ_name dept
 from co_cust c, csc_cust_orderdate a, pub_organ po1,pub_stru b,pub_organ po2
where  a.cust_id=c.cust_id and po1.organ_id=b.organ_id and b.parent_id=po2.organ_id and c.slsman_id=b.position_code
and a.call_date=(select to_char(sysdate,'yyyymmdd') from dual)
and c.cust_id in    (Select cust_id from co_cust minus
select cust_id  from co_co where born_date=(select to_char(sysdate,'yyyymmdd') from dual)  and status<>'90')
 
and c.status='02'   order by po2.organ_name,b.position_code

