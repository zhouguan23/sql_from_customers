SELECT
pres_region,pres_name,sales_name,pres_order
,c_hezuo,c_genjin,c_qita,c_xz,o_qianyue,o_genjin,o_liebian,o_xz
,q_lastctr_fr,q_thisctr_fr,q_lastctr_bi,q_thisctr_bi,q_lastctr_prj,q_thisctr_prj
,dsh_amount
,amount_last_all
,amount_this_all
,(amount_this_all-ifnull(wb_amount,0))jin_amount
,q_lastopp,q_thisopp,q_lastctr,q_thisctr
,p_lastpay_1,p_thispay_1,p_thispay_2,p_next1pay_2,p_next2pay_2,p_next3pay_2,p_prj_year,p_outs_year,(ifnull(p_erci_year,0)+ifnull(p_plu_year,0)+ifnull(p_sup_year,0)) AS p_qita_year,p_yearpay,(ifnull(p_prj_year,0)+ifnull(p_outs_year,0)+ifnull(p_erci_year,0)+ifnull(p_plu_year,0)+ifnull(p_sup_year,0)) AS p_kouchu
,o_quagenjin,o_next1genjin,o_next2genjin,o_next3genjin
FROM (
/*直接用售前和销售表会漏掉机会里的销售*/
		SELECT DISTINCT pres_region,pres_name,sales_name,SUM(IF(pres_name = pres_parent,1,0)) AS pres_order FROM hr_presales hp
    JOIN (select pres_name as opp_pres,sales_name
		FROM hr_presales h
    LEFT JOIN hr_salesman hs ON h.pres_region = hs.sales_region
		left join hr_user on user_username=pres_name
		where year(user_entrydate)<=${year} 
		union
		select opp_presales,opp_salesman
		from sale_opportunity
		where year(opp_recdate)<=${year}
		group by opp_presales,opp_salesman)sale on hp.pres_name=sale.opp_pres
    WHERE pres_region NOT IN ('日本','台湾','海外')
	 ${if(len(region)=0,"","and pres_region in ('"+region+"')")}
    GROUP BY pres_name,sales_name
		order by pres_region,pres_order desc,pres_name
) AS userlist
LEFT JOIN (
    SELECT com_presales,com_salesman,SUM(if(com_status='合作' && calctype=1,1,0)) AS c_hezuo,SUM(if(com_status='跟进' && calctype=1,1,0)) AS c_genjin,
      SUM(if(com_status IN ('合作','跟进') && calctype=1,0,1)) AS c_qita,SUM(if((YEAR(com_recdate)='${year}' && calctype=1) || (calctype=2),1,0)) AS c_xz
    FROM (
        SELECT com_id,com_salesman,com_presales,com_status,com_recdate,1 AS calctype FROM cust_company WHERE com_verified = 'valid' AND length(com_salesman)>0 AND length(com_presales)>0 AND com_salesman<>'public'
        UNION
        SELECT * FROM (
            SELECT com_id,com_salesman,c_pre_new,com_status,com_recdate,2 AS calctype FROM com_presales_change JOIN cust_company ON c_pre_company = com_id
            WHERE com_verified = 'valid' AND length(com_salesman)>0 AND length(com_presales)>0 AND com_salesman<>'public' AND YEAR(c_pre_recdate) = '${year}' AND YEAR(com_recdate) <> '${year}'
            ORDER BY com_id,c_pre_recdate DESC
        ) AS com_p_c GROUP BY com_id
    ) AS custcompany
    GROUP BY com_presales,com_salesman 
) AS ccom ON ccom.com_salesman = userlist.sales_name AND ccom.com_presales = userlist.pres_name
LEFT JOIN (
    SELECT opp_salesman,opp_presales,SUM(if(opp_status IN ('合同签约','协议签约','变更签约') && calctype=1 && length(ctr_id)>0,1,0)) AS o_qianyue,
        SUM(if(opp_status IN ('初期沟通','售前演示','商务谈判','客户选定') && calctype=1,1,0)) AS o_genjin,
        SUM(if(opp_status IN ('跟进失败') && calctype=1,1,0)) AS o_liebian,SUM(if((YEAR(opp_predate)='${year}' && calctype=1) || (calctype=2),1,0)) AS o_xz,
        SUM(if(YEAR(opp_enddate)='${year}' && opp_status IN ('合同签约','协议签约','变更签约') && calctype=1 && length(ctr_id)>0,opp_budget,0)) AS q_thisopp,SUM(if(YEAR(opp_enddate)='${year}'-1 && opp_status IN ('合同签约','协议签约','变更签约') && calctype=1 && length(ctr_id)>0,opp_budget,0)) AS q_lastopp,
        SUM(if(YEAR(opp_predate)='${year}' && QUARTER(opp_predate)=QUARTER(curdate()) AND opp_status IN ('初期沟通','售前演示','商务谈判','客户选定'),opp_amount,0)) AS o_quagenjin,
        SUM(if(YEAR(opp_predate)=YEAR(DATE_ADD(curdate(),interval 1 QUARTER)) && QUARTER(opp_predate)=QUARTER(DATE_ADD(curdate(),interval 1 QUARTER)) AND opp_status IN ('初期沟通','售前演示','商务谈判','客户选定') && calctype=1,opp_amount,0)) AS o_next1genjin,
        SUM(if(YEAR(opp_predate)=YEAR(DATE_ADD(curdate(),interval 2 QUARTER)) && QUARTER(opp_predate)=QUARTER(DATE_ADD(curdate(),interval 2 QUARTER)) AND opp_status IN ('初期沟通','售前演示','商务谈判','客户选定') && calctype=1,opp_amount,0)) AS o_next2genjin,
        SUM(if(YEAR(opp_predate)=YEAR(DATE_ADD(curdate(),interval 3 QUARTER)) && QUARTER(opp_predate)=QUARTER(DATE_ADD(curdate(),interval 3 QUARTER)) AND opp_status IN ('初期沟通','售前演示','商务谈判','客户选定') && calctype=1,opp_amount,0)) AS o_next3genjin
    FROM (
        SELECT opp_id,opp_salesman,opp_presales,opp_predate,opp_enddate,opp_status,opp_amount,opp_budget,ctr_id,1 AS calctype FROM sale_opportunity 
				LEFT JOIN sale_role ON role_opportunity =opp_id
        LEFT join sale_contract_info on  ctr_role=role_id
        WHERE opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND length(opp_status)>1
        UNION
        SELECT * FROM (
            SELECT opp_id,opp_salesman,o_pre_new,opp_predate,opp_enddate,opp_status,opp_amount,opp_budget,ctr_id,2 AS calctype FROM opp_presales_change JOIN sale_opportunity ON o_pre_opportunity = opp_id
						LEFT JOIN sale_role ON role_opportunity =opp_id
            LEFT join sale_contract_info on  ctr_role=role_id
            WHERE opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND length(opp_status)>1 AND YEAR(o_pre_recdate) = '${year}' AND YEAR(opp_predate) <> '${year}'
            ORDER BY opp_id,o_pre_recdate DESC
        ) AS opp_p_c GROUP BY opp_id
    ) AS saleopportunity
    GROUP BY opp_presales,opp_salesman
) AS opp ON opp.opp_salesman = userlist.sales_name AND opp.opp_presales = userlist.pres_name 
/*机会签单*/
LEFT JOIN (
    SELECT opp_presales,opp_salesman,
    SUM(if(YEAR(opp_enddate)='${year}',ctr_amount*f_amount,0)) AS q_thisctr,SUM(if(YEAR(opp_enddate)='${year}'-1,ctr_amount*f_amount,0)) AS q_lastctr
		from sale_contract_info 
		left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
    JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity ON role_opportunity =opp_id
    WHERE opp_verified = 'valid' and opp_status in ('合同签约','协议签约','变更签约') AND length(opp_salesman)>0 AND length(opp_presales)>0
    GROUP BY opp_presales,opp_salesman
) AS ctr ON ctr.opp_salesman = userlist.sales_name AND ctr.opp_presales = userlist.pres_name
/*回款*/
LEFT JOIN (
    SELECT opp_salesman,opp_presales,
    SUM(IF(YEAR(pay_enddate)=YEAR(DATE_ADD(curdate(),interval -1 QUARTER)) && QUARTER(pay_enddate)=QUARTER(DATE_ADD(curdate(),interval -1 QUARTER)) AND pay_paid>0,pay_bill,0)) AS p_lastpay_1,
    SUM(IF(YEAR(pay_enddate)='${year}' && QUARTER(pay_enddate)=QUARTER(curdate()) AND pay_paid>0,pay_bill,0)) AS p_thispay_1,
    SUM(IF(YEAR(pay_predate)='${year}' && QUARTER(pay_predate)=QUARTER(curdate()) AND (ifnull(pay_paid,0)+0)=0,pay_bill,0)) AS p_thispay_2,
    SUM(IF(YEAR(pay_predate)=YEAR(DATE_ADD(curdate(),interval 1 QUARTER)) && QUARTER(pay_predate)=QUARTER(DATE_ADD(curdate(),interval 1 QUARTER)) AND (ifnull(pay_paid,0)+0)=0,pay_bill,0)) AS p_next1pay_2,
    SUM(IF(YEAR(pay_predate)=YEAR(DATE_ADD(curdate(),interval 2 QUARTER)) && QUARTER(pay_predate)=QUARTER(DATE_ADD(curdate(),interval 2 QUARTER)) AND (ifnull(pay_paid,0)+0)=0,pay_bill,0)) AS p_next2pay_2,
    SUM(IF(YEAR(pay_predate)=YEAR(DATE_ADD(curdate(),interval 3 QUARTER)) && QUARTER(pay_predate)=QUARTER(DATE_ADD(curdate(),interval 3 QUARTER)) AND (ifnull(pay_paid,0)+0)=0,pay_bill,0)) AS p_next3pay_2,
    SUM(IF(YEAR(pay_enddate)='${year}',pay_bill,0)) AS p_yearpay
    FROM (select pay_id,pay_contract,pay_contact,(pay_bill*ifnull(f_amount,1))pay_bill,pay_signer,pay_predate,pay_payable,pay_drawer,pay_recdate,(pay_paid*ifnull(f_amount,1))pay_paid,pay_enddate,pay_unpaid,pay_status,pay_remarks,pay_salesman,pay_presales,pay_verified,pay_verifier,pay_verdate,pay_num,pay_voiddate,pay_voidreason,pay_lastrecorder,pay_lastrecdate,pay_file,pay_filename,pay_currency,pay_bank,pay_method from sale_payment
left join(select f_type,f_amount from finan_other_statistics where f_remark='CNY')money on f_type=pay_currency)sale_payment
    JOIN sale_contract_info ON ctr_id = pay_contract
		JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity  ON role_opportunity =opp_id
    WHERE pay_verified = 'valid' AND ctr_verified = 'valid' AND opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0
    GROUP BY opp_presales,opp_salesman
) AS pay ON pay.opp_salesman = userlist.sales_name AND pay.opp_presales = userlist.pres_name
/*扣除*/
LEFT JOIN (
    SELECT opp_presales,opp_salesman,
    SUM(IF(YEAR(outspay_paydate)='${year}',outspay_paid,0)) AS p_outs_year,
    SUM(IF(YEAR(outspay_paydate)='${year}' && QUARTER(outspay_paydate)=QUARTER(curdate()),outspay_paid,0)) AS p_outs_qua
    FROM sale_outsource LEFT JOIN sale_outsource_payment ON outs_id = outspay_outsource
    JOIN sale_contract_info ON ctr_id = outs_contract
		JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity  ON role_opportunity =opp_id
    WHERE outs_status <> '已作废' AND ctr_verified = 'valid' AND opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND ctr_status NOT IN ('待审核','待录入','不合格','已作废')
    GROUP BY opp_presales,opp_salesman
) AS outs_kj ON outs_kj.opp_salesman = userlist.sales_name AND outs_kj.opp_presales = userlist.pres_name
LEFT JOIN (
    SELECT opp_presales,opp_salesman,
    SUM(IF(prj_year = '${year}',prj_adjust,0)) AS p_prj_year,
    SUM(IF(prj_year = '${year}' && prj_season = QUARTER(curdate()),prj_adjust,0)) AS p_prj_qua
    FROM project_cost
    JOIN sale_contract_info ON ctr_id = prj_contract
		JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity  ON role_opportunity =opp_id
    WHERE ctr_verified = 'valid' AND opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND ctr_status NOT IN ('待审核','待录入','不合格','已作废')
    GROUP BY opp_presales,opp_salesman
) AS prj_kj ON prj_kj.opp_salesman = userlist.sales_name AND prj_kj.opp_presales = userlist.pres_name
LEFT JOIN (
    SELECT opp_presales,opp_salesman,
    SUM(IF(scd_year = '${year}',scd_cost,0)) AS p_erci_year,
    SUM(IF(scd_year = '${year}' && scd_season = QUARTER(curdate()),scd_cost,0)) AS p_erci_qua
    FROM finan_second_cost
    JOIN sale_contract_info ON ctr_id = scd_contract
		JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity  ON role_opportunity =opp_id
    WHERE ctr_verified = 'valid' AND opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND ctr_status NOT IN ('待审核','待录入','不合格','已作废')
    GROUP BY opp_presales,opp_salesman
) AS qita_erci_kj ON qita_erci_kj.opp_salesman = userlist.sales_name AND qita_erci_kj.opp_presales = userlist.pres_name
LEFT JOIN (
    SELECT opp_presales,opp_salesman,
    SUM(IF(YEAR(plugpay_happenday) = '${year}',plugpay_price,0)) AS p_plu_year,
    SUM(IF(YEAR(plugpay_happenday) = '${year}' && QUARTER(plugpay_happenday) = QUARTER(curdate()),plugpay_price,0)) AS p_plu_qua
    FROM product_forumplug_pay
    JOIN sale_contract_info ON ctr_id = plugpay_contract
		JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity  ON role_opportunity =opp_id
    WHERE ctr_verified = 'valid' AND opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND ctr_status NOT IN ('待审核','待录入','不合格','已作废')
    GROUP BY opp_presales,opp_salesman
) AS qita_plu_kj ON qita_plu_kj.opp_salesman = userlist.sales_name AND qita_plu_kj.opp_presales = userlist.pres_name
LEFT JOIN (
    SELECT opp_presales,opp_salesman,
    SUM(IF(YEAR(expense_happenday) = '${year}',expense_amount,0)) AS p_sup_year,
    SUM(IF(YEAR(expense_happenday) = '${year}' && QUARTER(expense_happenday) = QUARTER(curdate()),expense_amount,0)) AS p_sup_qua
    FROM support_expense 
    JOIN sale_contract_info ON ctr_id = expense_contract
		JOIN sale_role ON ctr_role=role_id
    JOIN sale_opportunity  ON role_opportunity =opp_id
    WHERE ctr_verified = 'valid' AND opp_verified = 'valid' AND length(opp_salesman)>0 AND length(opp_presales)>0 AND ctr_status NOT IN ('待审核','待录入','不合格','已作废')
    GROUP BY opp_presales,opp_salesman
) AS qita_sup_kj ON qita_sup_kj.opp_salesman = userlist.sales_name AND qita_sup_kj.opp_presales = userlist.pres_name
/*待收回合同额*/
left join(
SELECT opp_presales,opp_salesman,sum(ctr_amount*f_amount) as dsh_amount
FROM sale_contract_info
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
join cust_company on com_id=ctr_company and com_country='中国' 
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(ctr_currency,'CNY') 
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract 
where year(ctr_recdate)<='${year}' 
and ctr_status not in ('待审核','待录入','不合格','已作废')
and (ctr_status NOT in ('已收回','已存档','订单已处理') AND (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and IFNULL(sumpay_paid,0)<=0) and ifnull(ctr_noneed,"false")<>"true") 
and (ctr_signdate is null  or year(ctr_signdate)<'${year}' )
GROUP BY opp_presales,opp_salesman
)dsh ON dsh.opp_salesman = userlist.sales_name AND dsh.opp_presales = userlist.pres_name
/*签单额*/
left join (

select opp_presales,opp_salesman,sum(q_thisctr_fr)q_thisctr_fr,sum(q_lastctr_fr)q_lastctr_fr,sum(q_lastctr_bi)q_lastctr_bi,sum(q_thisctr_bi)q_thisctr_bi,sum(q_thisctr_prj)q_thisctr_prj,sum(q_lastctr_prj)q_lastctr_prj,sum(amount_this_all)amount_this_all,sum(amount_last_all)amount_last_all
from(select opp_presales,opp_salesman,type
,SUM(if(YEAR(ctr_signdate)='${year}' AND type='FR',amount,0)) AS q_thisctr_fr,
SUM(if(YEAR(ctr_signdate)='${year}'-1 AND type='FR',amount,0)) AS q_lastctr_fr,
SUM(if(YEAR(ctr_signdate)='${year}' AND type='FBI',amount,0)) AS q_thisctr_bi,
SUM(if(YEAR(ctr_signdate)='${year}'-1 AND type='FBI',amount,0)) AS q_lastctr_bi,
SUM(if(YEAR(ctr_signdate)='${year}' AND type='实施',amount,0)) AS q_thisctr_prj,
SUM(if(YEAR(ctr_signdate)='${year}'-1 AND type='实施',amount,0)) AS q_lastctr_prj
,SUM(if(YEAR(ctr_signdate)='${year}',amount,0))as amount_this_all
,SUM(if(YEAR(ctr_signdate)='${year}'-1,amount,0))as amount_last_all
from
(SELECT 
distinct ctr_id,ctr_signdate,opp_presales,opp_salesman,if(det_type in('实施','服务','咨询'),det_type,if(det_type='产品',if(det_productline='FineBI','FBI','FR'),'其他'))type
,sum(det_amount*f_amount) as amount 
from (select ctr_id,sum(det_amount)det_amount,ctr_currency,det_productline,det_type,ctr_company,ctr_role,ctr_signdate
FROM (
SELECT ctr_id,sum(ifnull(det_amount,0))det_amount,ctr_currency,det_productline,det_type,ctr_company,ctr_role,ctr_signdate
FROM v_contract_detail
left join sale_contract_info on ctr_id=det_contract
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract
where year(ctr_signdate) in ('${year}',${year}-1)
and ((year(ctr_signdate)<=2017 and ctr_status not in ('待审核','待录入','不合格')) or (year(ctr_signdate)>2017 and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))))
group by ctr_id,det_type,det_productline
union#已作废合同
select ctr_id,-sum(ifnull(det_amount,0))amount,ctr_currency,det_productline,det_type,ctr_company,ctr_role,ifnull(ctr_voiddate,ctr_signdate)
FROM v_contract_detail
left join sale_contract_info on ctr_id=det_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" 
and year(ctr_signdate) in ('${year}',${year}-1)
group by ctr_id,det_type,det_productline
union#未作废合同中作废的回款
select ctr_id,-sum(ifnull(pay_bill,0)*IFNULL(det_amount,0)/ctr_amount) amount,ctr_currency,det_productline,det_type,ctr_company,ctr_role,ifnull(pay_voiddate,ctr_signdate)
from sale_payment
left join v_contract_detail on pay_contract=det_contract
left join sale_contract_info on ctr_id=det_contract
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and pay_status in ("记坏账","已作废") 
and year(ctr_signdate) in ('${year}',${year}-1)
group by ctr_id,det_type,det_productline
union#已作废合同中已回款的部分
select ctr_id,sum(ifnull(pay_paid,0)*IFNULL(det_amount,0)/ctr_amount) amount,ctr_currency,det_productline,det_type,ctr_company,ctr_role,ifnull(ctr_voiddate,ctr_signdate)
from sale_payment
left join v_contract_detail on pay_contract=det_contract
left join sale_contract_info on ctr_id=pay_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 
and year(ctr_signdate) in ('${year}',${year}-1)
group by ctr_id,det_type,det_productline
)l
group by ctr_id,det_type,det_productline)ctr
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
join cust_company on com_country='中国' and com_id=ctr_company
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(ctr_currency,'CNY') 
group by ctr_id,type
)list1
group by opp_presales,opp_salesman,type
)list2 
group by opp_presales,opp_salesman
)ctr_type_qd ON ctr_type_qd.opp_salesman = userlist.sales_name AND ctr_type_qd.opp_presales = userlist.pres_name
/*外包金额*/
LEFT JOIN(select opp_presales,opp_salesman,sum(outs_amount)wb_amount
from sale_outsource
join v_sale_contract_info_valid on outs_contract=ctr_id
left join cust_company on com_id=ctr_company 
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
where year(outs_recdate) = '${year}'
and com_country="中国"
and outs_status!="已作废"
group by opp_presales,opp_salesman
)wb ON wb.opp_salesman = userlist.sales_name AND wb.opp_presales = userlist.pres_name

select pres_name,-ifnull(paid_dis,0)+ifnull(paid_dised,0) dis_amount from 
(select distinct pres_name,pres_region from hr_presales where pres_region not in ('海外','台湾','日本'))sales
/*回款分配额*/
left join (select dis_presales,sum(pay_paid*f_amount*dis_percent_2nd) paid_dis,month(pay_enddate) month3 from pres_distribute_apply
inner join sale_payment on pay_contract=dis_contract
inner join sale_contract_info on ctr_id=dis_contract
left join(select f_type,f_amount from finan_other_statistics where f_remark='CNY')money on f_type=pay_currency 
where year(pay_enddate)=${year}
group by dis_presales
)distribute on dis_presales=pres_name
/*回款被分配额*/
left join (
select sum(pay_paid*f_amount*dis_percent_2nd) paid_dised,month(pay_enddate) month4,dis_presales_2nd dised_presales from pres_distribute_apply
inner join sale_payment on pay_contract=dis_contract
inner join sale_contract_info on ctr_id=dis_contract
left join(select f_type,f_amount from finan_other_statistics where f_remark='CNY')money on f_type=pay_currency 
where year(pay_enddate)=${year}
group by dised_presales
)distributed on dised_presales=pres_name 

select pres_name,-ifnull(paid_dis,0)+ifnull(paid_dised,0) dis_amount from 
(select distinct pres_name,pres_region from hr_presales where pres_region not in ('海外','台湾','日本'))sales
/*回款分配额*/
left join (select dis_presales,sum(ctr_amount*f_amount*dis_percent_2nd) paid_dis from pres_distribute_apply
inner join sale_contract_info on ctr_id=dis_contract
left join(select f_type,f_amount from finan_other_statistics where f_remark='CNY')money on f_type=ctr_currency 
where year(ctr_signdate)=${year} and ctr_verified='valid'
group by dis_presales
)distribute on dis_presales=pres_name
/*回款被分配额*/
left join (
select sum(ctr_amount*f_amount*dis_percent_2nd) paid_dised,dis_presales_2nd dised_presales from pres_distribute_apply
inner join sale_contract_info on ctr_id=dis_contract
left join(select f_type,f_amount from finan_other_statistics where f_remark='CNY')money on f_type=ctr_currency 
where year(ctr_signdate)=${year} and ctr_verified='valid'
group by dised_presales
)distributed on dised_presales=pres_name 

select area_region from hr_area where area_id<11

