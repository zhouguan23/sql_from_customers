select c.cust_id,cust_name,busi_addr,order_tel,je,hzje,skje from yao_cust c,
(
select cust_id,sum(je) je from ddsal where substr(cust_id,1,6)='${dpt}'
and dd_id>'201506300000000000000000000000'  group by cust_id
) a,
(
select cust_id,hzje,skje from dingdansk where substr(cust_id,1,6)='${dpt}' and rq>'20150630'
) b
where a.cust_id=c.license_code
and b.cust_id(+)=c.license_code

select * from dw

