select h.title,
       nvl(sum(t.tax_amount), 0) as tax_amount,
       nvl(sum(t.amount), 0) as amount,
       nvl(sum(t.qty), 0) as qty
  from (select d.qty,
               d.oc_tax_amount,
               d.oc_amount,
               d.tax_amount,
               d.amount,
               d.fn_date,
               t.ORGAN_ID,
               s.storage_attr,
               m.materieltype_id,
               d.materiel_name, d.materiel_id
          from st_mate_in                 t,
               st_mate_in_dtl             d,
               view_com_materiel_all_info m,
               com_materieltype           k,
               st_storage                 s,
               buy_arrival_notice         h,
               buy_arrival_notice_dtl     h1,
               buy_order                  b,
               buy_order                  b1,
               sa_oporg                   g
         where t.id = d.main_id
           and d.materiel_id = m.id
           and t.storage_id = s.id
           and t.source_id = h.id
           and h.buy_order_code = b.bill_code(+)
           and t.procure_order_code = b1.bill_code(+)
           and h.person_member_id = g.id
           and d.source_id = h1.id(+)
           and m.materieltype_id = k.id(+)
           and d.qty is not null
           and length(t.id) = 32
           and t.status >= 1000
        
        union all
        select d.qty,
               d.oc_tax_amount,
               d.oc_amount,
               d.tax_amount,
               d.amount,
               d.fn_date,
               t.ORGAN_ID,
               s.storage_attr,
               m.materieltype_id,
               d.materiel_name, d.materiel_id
          from st_mate_in t,
               st_mate_in_dtl d,
               view_com_materiel_all_info m,
               com_materieltype k,
               st_storage s,
               buy_handback b,
               (select k.id,
                       h.id                 as buyer_id,
                       h.operation_code     as buy_operation_code,
                       k.procure_order_code
                  from buy_handback_dtl k, buy_order h
                 where k.procure_order_code = h.bill_code) f,
               sa_oporg g
         where t.id = d.main_id
           and d.materiel_id = m.id
           and m.materieltype_id = k.id(+)
           and t.storage_id = s.id
           and t.source_id = b.id
           and d.source_id = f.id(+)
           and b.person_member_id = g.id
           and d.qty is not null
           and length(t.id) = 32
           and t.status >= 1000) t,
       (select * from table(solar_scm_buy.f_mate_disc_config)) h
 where t.storage_attr = '1'
   and t.materiel_id = h.materiel_id ${parameter1} -- 公司
 ${parameter2} -- 月份起
 ${parameter3} -- 月份止
 group by h.title

select h.title,
       nvl(sum(t.tax_amount), 0) as tax_amount,
       nvl(sum(t.amount), 0) as amount,
       nvl(sum(t.qty), 0) as qty
  from (select d.qty,
               d.oc_tax_amount,
               d.oc_amount,
               d.tax_amount,
               d.amount,
               d.fn_date,
               t.ORGAN_ID,
               s.storage_attr,
               m.materieltype_id,
               d.materiel_name, d.materiel_id
          from st_mate_in                 t,
               st_mate_in_dtl             d,
               view_com_materiel_all_info m,
               com_materieltype           k,
               st_storage                 s,
               buy_arrival_notice         h,
               buy_arrival_notice_dtl     h1,
               buy_order                  b,
               buy_order                  b1,
               sa_oporg                   g,
               view_vender                v
         where t.id = d.main_id
           and d.materiel_id = m.id
           and t.storage_id = s.id
           and t.source_id = h.id
           and h.buy_order_code = b.bill_code(+)
           and t.procure_order_code = b1.bill_code(+)
           and h.person_member_id = g.id
           and d.source_id = h1.id(+)
           and m.materieltype_id = k.id(+)
           and d.qty is not null
           and length(t.id) = 32
           and t.status >= 1000
           and v.id = t.vender_id
           and v.is_internal = 1 -- 内部公司
        
        union all
        select d.qty,
               d.oc_tax_amount,
               d.oc_amount,
               d.tax_amount,
               d.amount,
               d.fn_date,
               t.ORGAN_ID,
               s.storage_attr,
               m.materieltype_id,
               d.materiel_name, d.materiel_id
          from st_mate_in t,
               st_mate_in_dtl d,
               view_com_materiel_all_info m,
               com_materieltype k,
               st_storage s,
               buy_handback b,
               (select k.id,
                       h.id                 as buyer_id,
                       h.operation_code     as buy_operation_code,
                       k.procure_order_code
                  from buy_handback_dtl k, buy_order h
                 where k.procure_order_code = h.bill_code) f,
               sa_oporg g,
               view_vender v
         where t.id = d.main_id
           and d.materiel_id = m.id
           and m.materieltype_id = k.id(+)
           and t.storage_id = s.id
           and t.source_id = b.id
           and d.source_id = f.id(+)
           and b.person_member_id = g.id
           and d.qty is not null
           and length(t.id) = 32
           and t.status >= 1000
           and v.id = t.vender_id
           and v.is_internal = 1 -- 内部公司
        ) t,
       (select * from table(solar_scm_buy.f_mate_disc_config)) h
 where t.storage_attr = '1'
   and t.materiel_id = h.materiel_id
 ${parameter1} -- 公司
 ${parameter2} -- 月份起
 ${parameter3} -- 月份止
 group by h.title


select t.title, t.measurement_prop, t.valuation_prop, t.average_prop
  from buy_mate_disc_config t
 where t.status = 1
 order by sequence_no


