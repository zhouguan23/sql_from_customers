select v.corporate_name customer_name,
       to_char(t.fillin_date, 'yyyy-mm') fillin_date,
       a.grade_id,
       a.qty,
       a.watt,
       a.amount,
       (case
         when b.trade_type_id = '1' then
          '国内'
         else
          '国外'
       end) trade_type,
       (case
         when b.trade_type_id = '1' then
          '中国'
         else
          b.country
       end) export_country
  from st_module_out t
  left join st_module_out_dtl a
    on t.id = a.main_id
  left join sal_module_delivery_notice b
    on t.consignment_note = b.bill_code
   left join view_com_grp_party v
    on t.customer_id = v.id
 where t.source_table = 'M_ST_SEND_PRE'
   and t.fillin_date between trunc(to_date('${年份}', 'yyyy'), 'year') and
       add_months(trunc(to_date('${年份}', 'yyyy'), 'year'), 12)
union all
select v.corporate_name customer_name,
       to_char(t.fillin_date, 'yyyy-mm') fillin_date,
       a.grade_id,
       a.qty,
       a.watt,
       a.amount,
       (case
         when b.trade_type_id = '1' then
          '国内'
         else
          '国外'
       end) trade_type,
       (case
         when b.trade_type_id = '1' then
          '中国'
         else
          b.country
       end) export_country
  from st_module_out t
  left join st_module_out_dtl a
    on t.id = a.main_id
  left join sal_module_return_apply b
    on t.source_id = b.id
  left join view_com_grp_party v
    on t.customer_id = v.id
 where t.source_table = 'M_SAL_HANDBACK'
   and t.fillin_date between trunc(to_date('${年份}', 'yyyy'), 'year') and
       add_months(trunc(to_date('${年份}', 'yyyy'), 'year'), 12)


select * from SA_DICTIONARYDETAIL t where t.dictionary_id = 'F2EDC16E49EE4A1ABB8F1D7F48AD6DA6'

