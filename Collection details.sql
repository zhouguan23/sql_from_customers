--订单
with od as
 (select a.supplier,
         substr(c.supplier_name, 1, instr(c.supplier_name, '-') - 1) supplier_name,
         a.item,
         d.goods_name,
         d.specification,
         d.manufacturer,
         a.order_no,
         a.written_date,
         a.unit_cost,
         a.vat_cost tax_unit_price,
         a.qty_ordered,
         a.qty_ordered * vat_cost order_tax_amt,
         b.tran_date,
         a.qty_received,
         a.qty_received * a.vat_cost real_tax_price,
         b.lot,
         e.produced_date,
         e.end_effective_date
    from cmx_order a,
         (select *
            from cmx_arif_history
           where tran_code = 20
             --and tran_date between date '2019-1-1' and date '2019-11-20'
             and tran_date between date'${start_date}' and date'${end_date}'
             ${if(len(line_item)=0,""," and item in ('"+line_item+"')")}
             ) b,
         dim_supplier c,
         dim_goods d,
         cmx_item_lot e
   where a.item = b.item
     and a.order_no = b.ref_no_1
     and to_char(a.supplier) = c.supplier_code
     ${if(len(supplier_site)=0,""," and a.supplier in ('"+supplier_site+"')")}
        --and order_no = '2730021'
     and a.item = d.goods_code
     and b.item = e.item
     and b.lot = e.lot),
--发票
iv as
 (select f.line_item,
         f.item_lot,
         f.po_rtv_no,
         g.invoice_num,
         h.invoice_amount,
         h.invoice_date,
         h.ap_creation_date,
         h.due_date,
         g.item_qty,
         h.paid_date,
         nvl(h.amount_paid, 0) payment_amt,
         h.invoice_amount - nvl(h.amount_paid, 0) unpaid_amt
    from (select max(crim.invoice_header_id) invoice_header_id,
                 crim.data_id,
                 crim.data_type,
                 crim.sub_data_type,
                 crim.account_date,
                 crim.po_rtv_no,
                 crim.shipment_no,
                 crim.line_item,
                 crim.item_lot,
                 crim.line_seq_no,
                 crim.order_date,
                 crim.tran_date,
                 crim.order_unit_price unit_price,
                 crim.vat_rate,
                 sum(crim.match_qty) match_qty,
                 sum(round(crim.order_unit_price * crim.match_qty, 2)) match_amount
            from cmx_reim_invoice_match crim
           where 1 = 1
            -- and tran_date between date '2019-1-1' and date '2019-11-20'
             and crim.tran_date between date'${start_date}' and date'${end_date}'          
           group by crim.invoice_header_id,
                    crim.data_id,
                    crim.data_type,
                    crim.sub_data_type,
                    crim.account_date,
                    crim.po_rtv_no,
                    crim.shipment_no,
                    crim.line_item,
                    crim.item_lot,
                    crim.line_seq_no,
                    crim.order_date,
                    crim.tran_date,
                    crim.order_unit_price,
                    crim.vat_rate
          having(sum(crim.match_qty) <> 0)) f,
         cmx_reim_invoice_header g,
         cmx_ap_invoices h
   where g.header_id = f.invoice_header_id
     and g.invoice_num = h.invoice_num
     and g.status_code not in ('I', 'S', 'R')
  --and f.po_rtv_no = '2730021'
  )
select od.supplier,
       od.supplier_name,
       od.item,
       od.goods_name,
       od.specification,
       od.manufacturer,
       od.order_no,
       od.written_date,
       od.unit_cost,
       od.tax_unit_price,
       od.qty_ordered,
       od.order_tax_amt,
       od.tran_date,
       od.qty_received,
       od.real_tax_price,
       od.lot,
       od.produced_date,
       od.end_effective_date,
       iv.invoice_num,
       iv.invoice_amount,
       iv.invoice_date,
       iv.ap_creation_date,
       iv.due_date,
       iv.item_qty,
       iv.paid_date,
       iv.payment_amt,
       iv.unpaid_amt
  from od, iv
 where od.item = iv.line_item(+)
   and od.lot = iv.item_lot(+)
   and od.order_no = iv.po_rtv_no(+)
   ${if(len(line_item)=0,""," and iv.line_item in ('"+line_item+"')")}
   ${if(len(start_date1)=0,""," and iv.paid_date >= date'"+start_date1+"'")}
   ${if(len(end_date1)=0,""," and iv.paid_date <= date'"+end_date1+"'")}
   ${if(len(invoice_num)=0,""," and iv.invoice_num in ('"+invoice_num+"')")}
   order by 1,7

select * from dim_supplier
where 1=1
${if(len(supplier_site)=0,""," and a.supplier in ('"+supplier_site+"')")}
order by 1,2,3

