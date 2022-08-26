select l.com_goods_id,--商品id
       g.goods_opcode,--商品编码
    g.goods_name,--商品名称
    g.goods_desc,
    p.party_name,
   l.account_date,
    l.balance_qty,--库存数量
    l.balance_amount,--库存余额
    (case when l.source_type='PURCHASE_NORMAL' and l.debit_qty<0
     then '采购退货'
      else t.cost_bill_name
    end)as source_type,--类型
    l.debit_qty,-- 借方数量
    l.debit_price,--借方价格
    l.debit_amount,--借方金额
    l.loan_qty,--贷方数量
    l.loan_price,--贷方价格
    l.loan_amount,--贷方金额
     ba.tax_free_price current_power_price,--库存成本金额
    l.adjust_amount,--调整库存金额
    l.diff_adjust_amount ,--销售成本调整金额
     l.sale_amount,
     l.com_goods_batch_id,
    l.sale_profit_amount,
     case   l.loan_amount when  0
    then 0 
    else
     round(l.sale_profit_amount/l.loan_amount，6) 
     end  as profit,
      t.party_name as vender_name ,
      iv.party_name as inv_owner,
      l.com_goods_batch_id,
      l.from_bill_sc
 from ssc_cost_book_lines l
 inner join ssc_cost_book b on b.sys_cost_book_id=l.sys_cost_book_id
  left  join com_goods_batch ba on ba.com_goods_batch_id = l.com_goods_batch_id
  inner join com_goods g on g.com_goods_id=b.com_goods_id
  left join com_party p on p.com_party_id= g.factory_id
  left join com_party t on t.com_party_id = l.ref_party_id
  left join com_party iv on iv.com_party_id = b.com_party_id
 inner join pf_cost_billtype t on t.class_name=l.source_type
 where b.com_party_id in(130000,170000,190000) 
${if(len(ll_ou)==0,""," and b.com_party_id= " + ll_ou)}

 
${if(len(ldt_begin)==0,"","and   l.account_date>=to_date('"+ldt_begin+"','yyyy-MM-dd')")}
${if(len(ldt_end)==0,"","and   l.account_date<to_date('"+ldt_end+"','yyyy-MM-dd')+1")}
${if(len(ll_goods_opcode)==0,""," and g.goods_opcode= " + ll_goods_opcode)}


order by l.account_date asc,l.sys_cost_book_lines_id asc
 

 select
    sum(QC_QTY)  QC_KC, --期初库存
    sum(QC_AMT)  QC_amt --期初金额
    FROM 
    V_INOUTSTK_BI V ,com_goods g
where v.artiid=g.com_goods_id
  

${if(len(ldt_begin)==0,"","and   pak_view_para.F_set_START_DATE(to_date('"+ldt_begin+"'))=1")}
${if(len(ldt_end)==0,"","and   pak_view_para.F_set_START_DATE(to_date('"+ldt_end+"'))=1")}
${if(len(ll_goods_opcode)==0,""," and g.goods_opcode= " + ll_goods_opcode)}
${if(len(com_party_id)==0,""," and v.deptid= " + com_party_id)}


select com_party_id,party_name from com_party where com_party_id in(
130000,170000,190000
)

