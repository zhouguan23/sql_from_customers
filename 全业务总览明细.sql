select * from (select zl.dept_id,
       zl.dept_name,
       zl.zone_id,
       zl.zone_name,
       zl.group_id,
       zl.group_name,
       zl.prod_id,
       '***' accnbr,
       zl.open_date,
       zl.prod_spec_name,
       ps.prod_type,
       ps.prod_busi,
       decode(zl.if_zb_1,1,'在网',0,'离网') if_zb_1,
       zl.status,
       zl.stop_date,
       zl.close_date,
       zl.cust_name,
       zl.phone_device_id,
       zl.phone_device_name,
       jx.coupon_type,
       jx.coupon_spec,
       reg.coupon_name reg_coupon_name,
       reg.coupon_model reg_coupon_model,
       reg.if_android reg_if_android,
       reg.coupon_type reg_coupon_type,
       zl.exp_offer_name,
       zl.alr_offer_name,
       zl.eff_offer_name,
       zl.sell_num,
       zl.sell_name,
       zl.channel_nbr,
       zl.channel_name,
       zl.standard_addr,
       zl.if_rh,
       zl.rh_type_name,
       zl.rh_offer_nbr,
       zl.rh_offer_name,
       zl.rh_role_name,
       NVL(GRO.TYPE_DESC,'否') IF_GROUP_COME,
       nvl(inc.charge, 0) income_charge,
       nvl(adj.charge, 0) adjust_charge,
       nvl(giv.charge, 0) give_charge,
       nvl(lis.charge, 0) no_list_charge,
       nvl(rec.charge, 0) recovery_charge,
       nvl(roa.charge, 0) roam_charge,
       nvl(coo.charge, 0) coop_charge,
       nvl(aos.charge, 0) aoss_charge,
       nvl(nrl.charge, 0) new_rules,
       nvl(tax.charge, 0) tax_charge,
       nvl(th.cdr_num, 0) cdr_num,
       nvl(th.out_cdr_num, 0) out_cdr_num,
       nvl(th.call_duration_min, 0) call_duration_min,
       nvl(th.out_call_duration, 0) out_call_duration,
       nvl(th.call_sms_num, 0) call_sms_num,
       nvl((th.sum_amount)/1024, 0) data_amount
  FROM ------------用户资料----------------------------
       (SELECT A.GROUP_ID,
               a.group_name,
               a.zone_id,
               a.zone_name,
               a.dept_id,
               a.dept_name,
               A.PROD_ID,
               A.BILL_ID,
               A.ACCNBR,
               A.OPEN_DATE,
               a.prod_spec_id,
               A.PROD_SPEC_NAME,
               A.STATUS,
               A.STOP_DATE,
               A.CLOSE_DATE,
               A.phone_device_id,
               A.phone_device_name,
               a.exp_offer_name,
               a.alr_offer_name,
               a.eff_offer_name,
               A.SELL_NUM,
               A.SELL_NAME,
               A.channel_nbr,
               A.channel_name,
               a.standard_addr,
               a.sell_id,
               a.if_zb_1,
               a.if_rh,
               a.rh_type_name,
               a.rh_offer_nbr,
               a.rh_offer_name,
               a.rh_role_name,
               substr(a.cust_name, 1, 1) ||
               substr('*************************************************',
               1,
               (length(a.cust_name) - 1)) cust_name
          FROM DSAUS.DET_CRM_INFO_HIS A
         WHERE A.ACCT_MONTH = ${date2}
        UNION
       SELECT B.GROUP_ID,
              b.group_name,
              b.zone_id,
              b.zone_name,
              b.dept_id,
              b.dept_name,
              B.PROD_ID,
              B.BILL_ID,
              B.ACCNBR,
              B.OPEN_DATE,
              b.prod_spec_id,
              B.PROD_SPEC_NAME,
              B.STATUS,
              B.STOP_DATE,
              B.CLOSE_DATE,
              B.phone_device_id,
              B.phone_device_name,
              b.exp_offer_name,
              b.alr_offer_name,
              b.eff_offer_name,
              B.SELL_NUM,
              B.SELL_NAME,
              B.channel_nbr,
              B.channel_name,
              b.standard_addr,
              b.sell_id,
              b.if_zb_1,
              b.if_rh,
              b.rh_type_name,
              b.rh_offer_nbr,
              b.rh_offer_name,
              b.rh_role_name,
              substr(b.cust_name, 1, 1) ||
              substr('*************************************************',
                     1,
                     (length(b.cust_name) - 1)) cust_name
         FROM DSAUS.DET_CRM_INFO_DEL B
         WHERE close_date >= to_date('${date3}', 'yyyy/mm/dd') 
           and TO_CHAR(CLOSE_DATE, 'YYYYMM') <= ${date2}) ZL,
         dsaus.prod_spec ps,
         (select * from dsaus.ods_mobile_all_event_month where acct_month = ${date2}) th,
         (select * from dsaus.det_reg_info_his where acct_month = ${date2}) reg,
       ------------机型资料----------------------------    
       (SELECT CI.COUPON_ID,
               CI.COUPON_NAME,
               TY.STATE_NAME  COUPON_TYPE,
               SP.STATE_NAME  COUPON_SPEC
          FROM TDSS.COUPON_INFO CI,
               (SELECT STATE_ID, STATE_NAME
                  FROM TDSS.SYS_STATE
                 WHERE TABLE_NAME = 'COUPON_INFO'
                   AND FIELD_NAME = 'TYPE_ID') TY,
               (SELECT STATE_ID, STATE_NAME
                  FROM TDSS.SYS_STATE
                 WHERE TABLE_NAME = 'COUPON_INFO'
                   AND FIELD_NAME = 'SPEC_ID') SP
         WHERE CI.TYPE_ID = TY.STATE_ID
           AND CI.SPEC_ID = SP.STATE_ID) JX,
       ------------出账收入----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_INCOME_SHARE A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) INC,
       ------------调账费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_ADJUST A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) ADJ, --关联BILL_ID
       ------------赠费费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_GIVE A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) GIV, --关联BILL_ID
       ------------不列收费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_NO_LIST A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) LIS, --关联BILL_ID
       ------------回收费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_RECOVERY A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) REC, --关联BILL_ID
       ------------数据漫游支出----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_C_DATA_ROAM A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) ROA,
       ------------固网合作分成费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_G_COOP_INTO A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) COO,
       ------------一站式结算费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_AOSS A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) AOS,
      ------------新收入减收费用----------------------------
       (select prod_id, sum(charge) charge
          from dsaus.det_charge_newrules a
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         group by prod_id) nrl,
       ------------增值税费用----------------------------
       (SELECT A.PROD_ID, SUM(A.CHARGE) CHARGE
          FROM DSAUS.DET_CHARGE_TAX A
         WHERE A.ACCT_MONTH >= ${date1}
           AND A.ACCT_MONTH <= ${date2}
         GROUP BY A.PROD_ID) TAX,
        ------------增值税费用----------------------------
       (SELECT A.PROD_ID, '是' TYPE_DESC
          FROM DSAUS.DET_CHARGE_INCOME_GROUP A
         WHERE A.ACCT_MONTH = ${date2}) GRO
 where zl.phone_device_id = jx.coupon_id(+)
   and zl.prod_id = inc.prod_id(+)
   and zl.prod_id = adj.prod_id(+)
   and zl.prod_id = giv.prod_id(+)
   and zl.prod_id = lis.prod_id(+)
   and zl.prod_id = rec.prod_id(+)
   and zl.prod_id = roa.prod_id(+)
   and zl.prod_id = coo.prod_id(+)
   and zl.prod_id = aos.prod_id(+)
   and zl.prod_id = nrl.prod_id(+)
   and zl.prod_id = tax.prod_id(+)
   and zl.prod_id = th.prod_id(+)
   and zl.prod_id = GRO.prod_id(+)
   and zl.prod_spec_id = ps.prod_spec_id(+)
   and zl.prod_id = reg.prod_id(+))
 ${switch(sql("dsaus","select class_id from dsaus.sys_role_group where role_name = '"+fr_authority+"'",1,1)
,0,"where 1=0"
,1,"where 1=0"
,2,"where dept_id in (select dept_id from dsaus.sys_role_group where role_name = '"+fr_authority+"')"
,3,"where zone_id in (select zone_id from dsaus.sys_role_group where role_name = '"+fr_authority+"')"
,4,"where group_id ="+fr_username+"")}

