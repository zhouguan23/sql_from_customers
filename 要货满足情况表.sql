
 
 
 select
  yy.com_client_id,
  yy.client_name,               --要货单位
  yy.order_source_name,         --订单来源
  yy.web_order_id,              --需求单号
  yy.web_order_lines_id,        --需求明细号
  yy.goods_opcode,              --商品编码
  yy.goods_name,                --商品名称
  yy.goods_desc,                --规格
  yy.factory_name,              --生产厂家
  yy.retail_price,              --零售价
  yy.goods_op_status,           --进销状态
  yy.buss_tips,                 --经营提示 
  yy.web_order_date,            --订单日期
  yy.trans_date,                --开单日期  
  nvl(yy.stkqty,0) - nvl(yy.deptchgqty,0) as deptqty,   --门店当日库存
  nvl(yy.onavailable,0) - nvl(yy.onavailable_chg,0) as factqty,  --批发当日库存
  yy.order_qty,                 --要货数量
  yy.trans_complete_qty ,        --发货数量
  hh.party_name                 --默认进货供应商
from (
  select
    b.com_client_id,                 
    c.party_name as client_name,  
    d.order_source_name,          
    b.web_order_id,               
    b.web_order_lines_id,         
    e.goods_opcode,               
    e.goods_name,                 
    e.goods_desc,   
    e.com_goods_id,              
    f.party_name as factory_name, 
    e.retail_price,               
    decode(g.sale_status,'TRUE','可销','FALSE','不可销','') || 
    decode(g.pur_status,'TRUE','可进','FALSE','不可进','') || 
    decode(g.pur_retn_status,'TRUE','可退','FALSE','不可退','') as goods_op_status, 
    h.buss_tips,                                                         
    a.web_order_date,             
    case
      when nvl(b.trans_complete_qty,0) > 0 then b.trans_date
      else null
    end as trans_date,            
    (
      select sum(t1.stkqty)
      from Tbd_Stkloc t1
      where b.com_client_id = t1.deptid
      and b.com_goods_id = t1.artiid
    ) as stkqty,
    (
      select sum(t2.artiqty)
      from Tbd_Stkchg t2
      where b.com_client_id = t2.deptid
      and b.com_goods_id = t2.artiid
      and t2.chgdate > a.web_order_date
    ) as deptchgqty,
    (
      select sum(t3.onavailable)
      from com_inv_fact t3
      where t3.party_owner_id = b.inv_owner
      and t3.com_goods_id = b.com_goods_id
    ) as onavailable,
    (
      select sum(t5.debit_qty) - sum(t5.loan_qty)
      from ssc_cost_book t4
      inner join ssc_cost_book_lines t5
      on t4.sys_cost_book_id = t5.sys_cost_book_id
      where t4.com_party_id = b.inv_owner
      and t5.com_goods_id = b.com_goods_id
      and t5.account_date > a.web_order_date
    ) as onavailable_chg,
    b.order_qty,
    b.trans_complete_qty
  from ssc_orderlist_interface a
  inner join ssc_oms_order_lines b
  on a.ssc_orderlist_interface_id = b.ssc_orderlist_interface_id
  inner join com_party c
  on b.com_client_id = c.com_party_id
  left join sys_order_source d
  on b.order_source_id = d.order_source_id
  inner join com_goods e
  on b.com_goods_id = e.com_goods_id
  left join com_party f
  on e.factory_id = f.com_party_id
  left join sys_goods_org_mapping g
  on b.inv_owner = g.ou_id
  and b.com_goods_id = g.com_goods_id
  left join ssc_inventory_safe h
  on b.inv_owner = h.inv_party_id
  and b.com_goods_id = h.com_goods_id
  where 1 = 1
  and a.web_order_date >= to_date('${ldt_begin}','yyyy-mm-dd')
  and a.web_order_date < to_date('${ldt_end}','yyyy-mm-dd') + 1
  ${if(len(ls_artiinfo)==0,""," and (e.goods_opcode = '" + ls_artiinfo + "' or e.goods_name like '%" + ls_artiinfo + "%')")}
  ${if(len(ls_reqshtno)==0,""," and b.web_order_id = '" + ls_reqshtno + "'")}
  ${if(len(ls_client)==0,""," and b.com_client_id in(" + ls_client + ")")}
  ${if(len(leid)==0,""," and b.inv_owner = " + leid)}
) yy
left join ( select 
 to_char(wm_concat(k.party_name))party_name,j.com_goods_id   
 from sys_vender_goods_ref j  
 inner join  com_party  k      
   on j.vender_party_id =k. com_party_id    and  j.ou_id=170000        and  j.is_primary='TRUE'
   group by j.com_goods_id   
 )hh
on yy.com_goods_id=hh.com_goods_id
order by yy.client_name,yy.web_order_id,yy.web_order_lines_id


