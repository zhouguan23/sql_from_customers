select xg.xiang_id,trim(xg.xiang_name) xiang_name,xc.x_cun_id,trim(xc.x_cun_name) x_cun_name,zc.z_cun_id,trim(zc.z_cun_name) z_cun_name,
zc.pop_chang,zc.pop_out, zc.pop_in, zc.pop_mok,pop_chang+pop_in-pop_out pop2
from xiang xg,x_cun xc,z_cun zc
where xg.xian_id=${dptno}
and xg.xiang_id=xc.xiang_id
and xc.x_cun_id=zc.x_cun_id

select xiang_id,x_cun_id,z_cun_id,count(c.cust_id) custnum from cust_prop cp,cust c

where cp.cust_id=c.cust_id and cp.xian_id=${dptno} and c.status='02'
group by 
xiang_id,x_cun_id,z_cun_id

select z_cun_id,x_cun_id,xiang_id,sum(qty_sold) qty,sum(amt) amt
from
(select cust_id,qty_sold,amt
from cust_month${years}
where date1=${date1}
and dpt_sale_id=${dptno}) cm,
(select cust_id,z_cun_id,x_cun_id,xiang_id from cust_prop where xian_id=${dptno}) cp
where cm.cust_id=cp.cust_id
group by z_cun_id,x_cun_id,xiang_id

