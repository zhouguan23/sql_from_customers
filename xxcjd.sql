select  cc.sale_dept_id,cc.cust_id,cc.license_code,cc.cust_name,sl.slsman_name,cc.cust_seg,
case cc.cust_type3 
  when '011' then '城区'
  when '012' then '镇区'
  when '013' then '特殊镇区'
  when '023' then '好农'
  when '024' then '差农' end as dili, qty,round(dxz,0)
from co_cust cc,slsman sl,
(select pi.cust_id,sum(pi.qty_sold*pl.t_size)/50000 qty,(sum(pi.amt_sold)*50000)/sum(pi.qty_sold*pl.t_size)  dxz
from pi_cust_item_month  pi,scm_mic_cust_auto sc,plm_item pl,plm_item_com pc
where  sc.cust_id=pi.cust_id
and pl.item_id=pi.item_id
and pc.item_id=pi.item_id
and pi.date1>='${date1}'
and pi.date1<='${date2}'
and pi.qty_sold>0
group by pi.cust_id)  a
where a.cust_id=cc.cust_id
and sl.slsman_id=cc.slsman_id
and cc.status='02'

order by  cc.sale_dept_id

select pi.cust_id,pi.item_id,pl.kind,pc.price_trade,sum(pi.qty_sold*pl.t_size)/50000 qty
from pi_cust_item_month  pi,scm_mic_cust_auto sc,plm_item pl,plm_item_com pc
where  sc.cust_id=pi.cust_id
and pl.item_id=pi.item_id
and pc.item_id=pi.item_id
and pi.date1>='${date1}'
and pi.date1<='${date2}'
and pi.qty_sold>0
group by pi.cust_id,pi.item_id,pl.kind,pc.price_trade

