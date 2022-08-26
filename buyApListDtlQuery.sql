select * from 订单

select *
  from (select t.id,
               t.advance_pay_code,
               t.frombillno,
               t.apply_date,
               t.organ_id,
               t.organ_name,
               t.vender_id,
               t.vender_name,
               t.buy_order,
               t.currency_id,
               t.currency_name,
               t.oc_advance_amount,
               d.sourceid,
               nvl(d.oc_write_off_amount,0) as oc_write_off_amount,
               nvl(d.oc_adjust_amount,0) as oc_adjust_amount,
               nvl(d.back_amount,0) as back_amount,
               d.frombillno as dtl_frombillno,
               d.created_date,
               0 as oc_auditing_amount,
               null as is_auditting,
               nvl(solar_fn_apar.fun_get_writing_amount(t.vender_id,
                                                        t.currency_id,
                                                        t.id,
                                                        '0'),
                   0) as oc_writting_off_amount,
               nvl(t.oc_advance_amount, 0) + nvl(t.oc_adjust_amount, 0) -
               nvl(t.oc_write_off_amount, 0) - nvl(t.back_amount, 0) -
               nvl(solar_fn_apar.fun_get_writing_amount(t.vender_id,
                                                        t.currency_id,
                                                        t.id,
                                                        '0'),
                   0) as oc_write_able_amount,
               decode((nvl(t.oc_advance_amount, 0) +
                      nvl(t.oc_adjust_amount, 0) -
                      nvl(t.oc_write_off_amount, 0) - nvl(t.back_amount, 0) -
                      nvl(solar_fn_apar.fun_get_writing_amount(t.vender_id,
                                                                t.currency_id,
                                                                t.id,
                                                                '0'),
                           0)),
                      '0',
                      '1,0',
                      '1') as is_verification
          from buy_ap_list t, buy_ap_listdtl d
         where t.id = d.main_id(+)
        union all
        select t.id,
               t.advance_pay_code,
               t.frombillno,
               t.apply_date,
               t.organ_id,
               t.organ_name,
               t.vender_id,
               t.vender_name,
               t.buy_order,
               t.currency_id,
               t.currency_name,
               t.oc_advance_amount,
               null as sourceid,
               0 as oc_write_off_amount,
               0 as oc_adjust_amount,
               0 as back_amount,
               v.bill_code as dtl_frombillno,
               v.fillin_date as created_date,
               nvl(solar_fn_apar.f_get_auditing_amount(v.ap_id,
                                                       '0',
                                                       v.operation_code,
                                                       v.bill_code),
                   0) as oc_auditing_amount,
               decode(nvl(solar_fn_apar.f_get_auditing_amount(v.ap_id,
                                                              '0',
                                                              v.operation_code,
                                                              v.bill_code),
                          0),
                      '0',
                      '1,0',
                      '1') as is_auditting,
               0 as oc_writting_off_amount,
               0 as oc_write_able_amount,
               null as is_verification
          from buy_ap_list t, view_operation_code v
         where t.id = v.ap_id) t
 where 1 = 1 
   and organ_id like nvl('%${organId}%', organ_id)
   and currency_id = nvl('${currencyId}', currency_id)
   and to_char(apply_date, 'yyyy-mm-dd') >=
       nvl('', to_char(apply_date, 'yyyy-mm-dd'))
   and to_char(apply_date, 'yyyy-mm-dd') <=
       nvl('', to_char(apply_date, 'yyyy-mm-dd'))
   and t.frombillno like nvl('%${frombillno}%', t.frombillno)
   and nvl(t.advance_pay_code, '0') like nvl(t.advance_pay_code, '0')
   and vender_name like nvl('%${venderName}%', vender_name)
   and t.buy_order like nvl('%${buyOrder}%', t.buy_order)
   ${if(len(ocAdvanceAmountBegin)==0,""," and t.oc_advance_amount>="+ocAdvanceAmountBegin)}
   ${if(len(ocAdvanceAmountEnd)==0,""," and t.oc_advance_amount<="+ocAdvanceAmountEnd)}
   ${if(isAuditting=='1'," and is_auditting = '1'","")}
   ${if(isVerification=='1'," and is_verification = '1'","")}
   order by  t.apply_date  desc

