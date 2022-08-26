select zl.prod_id,
       zl.accnbr,
       zl.prod_spec_name,
       zl.open_date,
       zl.status,
       zl.stop_date,
       zl.sell_num,
       zl.sell_name,
       zl.channel_nbr,
       zl.channel_name,
       zl.group_name,
       zl.zone_name,
       zl.identity_type,
       zl.identity_num,
       zj.shu,
       zl.cust_id,
       zl.cust_name,
       zl.cust_address,
       zl.cust_age,
       zl.cust_sex,
       zl.if_rh,
       zl.pay_mode,
       zl.contact_tel,
       zl.main_offer,
       zl.alr_offer_id,
       zl.alr_offer_name,
       th.acct_month,
       th.zhi
  from dsaus.det_crm_info_now zl,
       (select identity_num, count(*) shu
          from dsaus.det_crm_info_now
         where status_id not in (110000, 110001, 110002, 140001)
           and open_date >=
               to_date('2020/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss')
           and prod_spec_id in
               (378, 17028, 722, 600000173, 2, 600000169, 600000222, 868)
         group by identity_num
        having count(*) >= 3) zj,
       (select acct_month,
               prod_id,
               round(in_cdr_num / out_cdr_num, 2) * 100 zhi
          from dsaus.ods_mobile_all_event_month
         where acct_month >= 202001
           and out_cdr_num <> 0) th
 where zl.status_id not in (110000, 110001, 110002, 140001)
   and zl.open_date >=
       to_date('2020/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss')
   and zl.prod_spec_id in
       (378, 17028, 722, 600000173, 2, 600000169, 600000222, 868)
   and zl.prod_id = th.prod_id(+)
   and zl.identity_num = zj.identity_num

