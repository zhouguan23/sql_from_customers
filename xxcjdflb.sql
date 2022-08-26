select case pl.kind
when '1' then '一类'
when '2' then '二类'
when '3' then '三类'
when '4' then '四类'
else '无价类' end  as kind
,round(sum(pi.qty_sold*pl.t_size)/50000,2)  qty,round((sum(pi.amt_sold)*50000)/sum(pi.qty_sold*pl.t_size))  dxz
from pi_cust_item_month  pi,scm_mic_cust_auto sc,plm_item pl,plm_item_com pc
where  sc.cust_id=pi.cust_id
and pl.item_id=pi.item_id
and pc.item_id=pi.item_id
and pi.date1>='${date1}'
and pi.date1<='${date2}'
and pi.sale_dept_id in (${dpt})
and pi.qty_sold>0
group by pl.kind
order by pl.kind

select pi.item_id,pc.price_trade,round(sum(pi.qty_sold*pl.t_size)/50000,2) qty,sum(pi.amt_sold)  amt
from pi_cust_item_month  pi,scm_mic_cust_auto sc,plm_item pl,plm_item_com pc
where  sc.cust_id=pi.cust_id
and pl.item_id=pi.item_id
and pc.item_id=pi.item_id
and pi.date1>='${date1}'
and pi.date1<='${date2}'
and pi.sale_dept_id in (${dpt})
and pi.qty_sold>0
group by pi.item_id,pc.price_trade

