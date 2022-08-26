select m.lot,
       m.price_subtotal,
       m.average_efficiency,
       m.oc_tax_price,
       m.wafer_price,
       m.wafer_qty,
       m.wafer_amount,
       m.convert_wafer_qty,
       m.cost_performance,
       m.data_type,
       d.*
  from scm_wafer_contrast m, scm_wafer_contrast_dtl d
 where m.id = d.main_id
   and m.id = nvl('${compareBillId}', '${billId}')
 order by d.gear

select m.lot,
       m.price_subtotal,
       m.average_efficiency,
       m.oc_tax_price,
       m.wafer_price,
       m.wafer_qty,
       m.wafer_amount,
       m.convert_wafer_qty,
       m.cost_performance,
       m.data_type,
       d.*
  from scm_wafer_contrast m, scm_wafer_contrast_dtl d
 where m.id = d.main_id
    ${if(len(compareBillId)=0," and m.compare_bill_id = '"+billId+"'"," and m.id = '"+billId+"'")}
 order by d.gear

