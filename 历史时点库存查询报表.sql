
select 
vv.com_party_id,
(select party_name from com_party where com_party.com_party_id = vv.com_party_id) as party_name,
vv.com_goods_id,
g.goods_opcode,
g.goods_name,
(select party_name from com_party where com_party.com_party_id = g.factory_id) as factory_name,
g.goods_desc,
(select u.unit_name from com_unit u where u.com_unit_id = g.com_unit_id) as unit_name,
g.retail_price,
vv.imamt, --进货
vv.loan_amount, -- 出库
vv.init_amount, --期初金额
vv.init_qty, --期初数量
vv.init_amount+vv.imamt+vv.spill_loss_amt-vv.loan_amount as qmamt,--期末
vv.init_qty+debit_qty-loan_qty as qmqty,--期末数量
vv.loan_qty,--出库数量
vv.debit_qty , --进货数量
vv.spill_loss_amt, --损溢金额
nvl((
select sum(ONAVAILABLE)
from V_INV_DISTRIBUTION
where V_INV_DISTRIBUTION.ONHAND > 0
 and V_INV_DISTRIBUTION.com_goods_id = vv.com_goods_id and V_INV_DISTRIBUTION.inv_owner=vv.com_party_id
),0) as ONAVAILABLE,
nvl((
select sum(onhand)
from V_INV_DISTRIBUTION
where V_INV_DISTRIBUTION.ONHAND > 0
 and V_INV_DISTRIBUTION.com_goods_id = vv.com_goods_id and V_INV_DISTRIBUTION.inv_owner=vv.com_party_id
),0) as onhand ,
case when loan_amount=0 then  '无销售' else 
to_char(round((vv.init_amount+vv.init_amount+vv.imamt+vv.spill_loss_amt-vv.loan_amount)/2/loan_amount*(d('${begin_date}')-d('${end_date}')+1),2))
end as kczz --库存周转天数

from (
select  
        nvl(aa.com_party_id,bb.com_party_id)  com_party_id ,
        nvl(aa.com_goods_id,bb.com_goods_id)  com_goods_id,
        nvl(imamt,0) imamt ,
        nvl(spill_loss_amt,0) as spill_loss_amt,
        nvl(loan_amount,0) loan_amount,
        nvl(init_amount,0) init_amount,
        nvl(init_qty,0) init_qty,
        nvl(debit_qty,0) debit_qty,
        nvl(loan_qty,0) loan_qty
  from (select v.com_party_id,
               v.com_goods_id,
               sum(imamt) + sum(imp_adj_amount)  as imamt, --进货+进货成本调整 =进货金额
               sum(sale_adj_amount) + sum(loan_amount) as loan_amount, --销售成本+销售成本调整=出库金额
               sum(v.debit_qty) as debit_qty,
               sum(v.loan_qty) as loan_qty,
                sum(spill_loss_amt) as spill_loss_amt --损溢
          from v_cost_book_erp v
         where v.account_date >= d('${begin_date}')
           and v.account_date < d('${end_date}') + 1
           and v.com_party_id =  ${leid}
         group by v.com_party_id,
                  v.com_goods_id) aa
  full  join (select com_party_id, com_goods_id, sum(init_amount) init_amount,sum(init_qty) init_qty
               from (select book.com_party_id,
                            book.com_goods_id,
                            sum(init_amount) init_amount,
                            sum(book.init_qty) as init_qty
                       from ssc_cost_book book
                      where book.account_month = '202001'
                        and book.com_party_id =  ${leid}
                        and book.com_party_id in (130000, 170000, 190000)
                      group by book.com_party_id, book.com_goods_id
                     union all
                     select book.com_party_id,
                            book_lines.com_goods_id,
                            sum(book_lines.debit_amount -
                                book_lines.loan_amount -
                                book_lines.adjust_amount) init_amount,
                             sum(book_lines.debit_qty-book_lines.loan_qty) as init_qry
                       from ssc_cost_book book
                      inner join ssc_cost_book_lines book_lines on book.sys_cost_book_id =  book_lines.sys_cost_book_id
                      where 1 = 1
                        and book_lines.account_date >= d('2020-01-01')
                        and book_lines.account_date < d('${begin_date}')
                        and book.com_party_id in (130000, 170000, 190000)
                        and book.com_party_id =  ${leid}
                      group by book.com_party_id, book_lines.com_goods_id)
              group by com_party_id, com_goods_id) bb
               on aa.com_goods_id =bb.com_goods_id and aa.com_party_id = bb.com_party_id
 ) vv,com_goods g 
 where g.com_goods_id= vv.com_goods_id 
${if(len(ll_opcode)>0,"and g.goods_opcode = "+ll_opcode,"")}

