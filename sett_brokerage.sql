SELECT
	ls.channel_cde,--渠道编号
	ls.channel_name,--渠道名称
	ls.old_dealer_cde,--进件商户编号
	ls.old_dealer_name,--进件商户名称
	ls.dealer_cde,--结算商户编号
	ls.dealer_name,--结算商户名称
	ls.loan_no,--借据号
	ls.cust_nam,--客户姓名
	ls.id_no,--证件号码
	ls.loan_actv_dt,--放款日期
	ls.orig_prcp,--放款金额
	ll.loan_typ,--贷款品种
	ls.loan_prom_cde,--营销专案编码
	ls.loan_prom_name,--营销专案名称
	ll.loan_int_rate,--年化利率
	ls.perd_no,--还款期号
	(
		CASE ls.recv_ind
		WHEN 'P' THEN
			'付'
		WHEN 'R' THEN
			'收'
		ELSE
			''
		END
	) AS recv_ind,--收付方向
	(
		CASE ls.recv_ind
		WHEN 'P' THEN
			ls.TRANS_AMT
		WHEN 'R' THEN
			- ls.TRANS_AMT
		ELSE
			0
		END
	) AS sett_amt,--佣金金额
	ls.sett_dt,--处理日期
	lc.fee_rate,--分期手续费率
	lc.disc_fee_rate,--贴息率
	lc.prcp_amt,--还款本金
	lc.norm_int_amt,--正常利息
	lc.od_int_amt,--罚息
	lc.comm_int_amt,--复利
	lc.over_fee,--滞纳金
	lc.loan_fee,--贷款服务费
	lc.stage_fee,--分期手续费
	lc.setl_loan_fee,--贷款服务费(费用结清)
	lc.loan_fee_tnr,--贷款服务费结清期数(费用结清)
	lc.setl_stage_fee,--分期手续费(费用结清)
	lc.stage_fee_tnr,--分期手续费结清期数(费用结清)
	lc.loan_setl_norm_int_amt,--正常利息(贷款结清)
	lc.loan_setl_od_int_amt,--罚息(贷款结清)
	lc.loan_setl_over_fee,--滞纳金(贷款结清)
	lc.loan_setl_loan_fee,--贷款服务费(贷款结清)
	lc.loan_setl_stage_fee,--分期手续费(贷款结清)
	lc.loan_setl_fee_incl_tnr,--贷款结清期数
	lc.ps_setl_fee,--提前还款手续费
	lc.account_fee,--账户管理费
	(
		TO_DATE (ll.last_due_dt, 'YY-MM-DD') - TO_DATE (ll.loan_actv_dt, 'YY-MM-DD')
	) AS loan_days,--贷款总天数(待优化)
	(
		TO_DATE (ll.last_setl_dt, 'YY-MM-DD') - TO_DATE (ll.loan_actv_dt, 'YY-MM-DD')
	) AS loan_setl_days,--贷款实际使用天数(待优化)
	ll.loan_tnr,--贷款期数
	(
		CASE lc.SLL_RPY_TYPE
		WHEN 'NM' THEN
			'非提前结清'
		WHEN 'NF' THEN
			'提前结清'
		ELSE
			''
		END
	) AS SLL_RPY_TYPE,--360还款类型
	lc.SLL_ALL_STAGE_FEE,--360应收分期手续费
	lc.SLL_STAGE_FEE,--360分期手续费
	lc.SLL_OD_INT_AMT,--360罚息
	lc.SLL_OVER_FEE,--360滞纳金
	lc.SLL_ALL_DAY,--360当期天数
	lc.SLL_DAY,--360当期使用天数
	lc.SLL_BREAKSCOST,--360营销减免金额
	lc.SLL_PROFIT_AMT,--360接口传输的晋消分润
	lc.SLL_STAGE_FEE+lc.SLL_OD_INT_AMT+lc.SLL_OVER_FEE-ls.TRANS_AMT as SLL_JCFC_PROFIT_AMT--我方计算的晋消分润
FROM
	setm.lm_sett_dda_log ls
LEFT JOIN setm.lm_loan ll ON ll.loan_no = ls.loan_no
LEFT JOIN setm.lm_commission_dtl lc ON lc.tx_log_seq = ls.tx_log_seq
WHERE
	ls.intr_acc_no = (
		SELECT
			T .intr_acct_no
		FROM
			(
				SELECT
					ld.intr_acct_no
				FROM
					setm.lm_dealer_acct_info ld
				WHERE
					ld.dealer_cde = '${dealer_cde}'
				AND ld.acct_typ = 'COMM'
				ORDER BY
					sett_dt DESC
			) T
		WHERE
			ROWNUM = 1
	)
AND ('${start_dt}' IS NULL OR sett_dt >= '${start_dt}')
AND ('${end_dt}' IS NULL OR sett_dt <= '${end_dt}')
AND ('${loan_no}' IS NULL OR ls.loan_no = '${loan_no}')
AND ls.dealer_cde = '${dealer_cde}'

