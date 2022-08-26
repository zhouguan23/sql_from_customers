select * from mar_currency

SELECT DISTINCT sales_name FROM hr_salesman WHERE sales_region in ('${region}') and length(sales_parent)>0

#yuwh.CRM-1261.2017.04.25
SELECT *,if(length(${ord})>0,if(${ord}<>@rownum_o,@rank_o:=@rank_o+1,@rank_o),"无") AS rank_oo,@rownum_o:=${ord} FROM(
SELECT * FROM(
SELECT *
,if(length(${ord})>0,if(sales_region = @reg,if(${ord}<>@rownum,@rank:=@rank+1,@rank),@rank:=1),"无") AS rank,@reg:=sales_region,@rownum:=${ord}
FROM(
SELECT * FROM(
SELECT s.sales_region,s.turn,new1.s.sales_name,ifnull(new1.amount,0)-ifnull(new2.amount,0)-ifnull(new7.amount,0) AS amount,(ifnull(new1.amount,0)-ifnull(new2.amount,0)-ifnull(new7.amount,0))/ifnull(new3.planning_value_e,0) AS rate,ifnull(new3.planning_value_e,0) AS planning_value_e,new1.year,
ifnull(new4.paid,0)-ifnull(new5.paid,0) AS amount_1,((ifnull(new4.paid_this,0)-ifnull(new5.paid_this,0))-(ifnull(new4.paid_last,0)-ifnull(new5.paid_last,0)))/(ifnull(new4.paid_last,0)-ifnull(new5.paid_last,0)) AS this_last,ifnull(new4.paid_this,0)-ifnull(new5.paid_this,0) AS amount_1_this,ifnull(new4.paid_last,0)-ifnull(new5.paid_last,0) AS amount_1_last,(ifnull(new4.paid,0)-ifnull(new5.paid,0))/ifnull(new3.planning_value_h,ifnull(new3.planning_value_e,0)*0.80) AS rate_1,ifnull(new3.planning_value_h,ifnull(new3.planning_value_e,0)*0.80) AS planning_value_h,if(length(planning_value_h)>0,1,0) AS isset
FROM
(SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name WHERE length(sales_parent)>0 and sales_name in (SELECT distinct dist_salesman a FROM dict_district where dist_country ='中国' union select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" and ifnull(year(user_leaveDate),2016)>='${year}' and sales_region not in('台湾','日本','海外')) 
#and user_state <> '离职'
) AS s 
LEFT JOIN(
SELECT ctr_salesman,sum(ctr_amount)-sum(IFNULL(sumpay_bill,0))amount,year(ctr_signdate) year
FROM (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid left join 
(select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment where pay_status in('记坏账','已作废')group by pay_contract)pay
on pay.pay_contract=ctr_id 
where year(ctr_signdate)='${year}' and ctr_verified='valid' and ctr_status!="已作废"

group by ctr_salesman,year(ctr_signdate)) AS new1 on new1.ctr_salesman = s.sales_name
LEFT JOIN(
select ctr_salesman,sum(outs_amount) amount,year(outs_recdate) year
from sale_outsource
left join (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid on outs_contract=ctr_id
where year(outs_recdate)='${year}'
and outs_status!="已作废"

group by ctr_salesman,year(outs_recdate)) AS new2
ON new1.ctr_salesman = new2.ctr_salesman and new1.year = new2.year 
LEFT JOIN(
SELECT * FROM (select planning_id,planning_name,planning_year,(planning_value_e*f_amount)planning_value_e,planning_type,planning_currency,planning_value_h from sale_planning,finan_other_statistics where f_remark='CNY' and f_type=planning_currency)sale_planning WHERE planning_year='${year}'

) AS new3 ON s.sales_name = new3.planning_name LEFT JOIN
(select pay_salesman,sum(if(year(pay_enddate)='${year}',pay_paid,0)) paid,sum(if(year(pay_enddate)='${year}' AND pay_enddate<=curdate(),pay_paid,0)) paid_this,sum(if(year(pay_enddate)='${year}',0,pay_paid)) paid_last,'${year}' AS year
from sale_payment 
join (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid on pay_contract=ctr_id
where  pay_verified = 'valid' and (year(pay_enddate)='${year}' OR ${if(year=year(today()),"(year(pay_enddate)='"+(year-1)+"' AND pay_enddate<='"+YEARDELTA(today(),-1)+"')","(year(pay_enddate)='"+(year-1)+"')")})

group by pay_salesman,year) AS new4 ON new4.pay_salesman = s.sales_name
left join
(
SELECT com_salesman,SUM(unpaid1) AS unpaid1,SUM(unpaid2) AS unpaid2,SUM(unpaid3) AS unpaid3,SUM(unpaid_l_d) AS unpaid_l_d,SUM(unpaid_l_w) AS amount,SUM(pay_unpaid) AS pay_unpaid
FROM
(SELECT *,
CASE WHEN pay_status = '已到期' THEN pay_unpaid ELSE 0 END AS unpaid1,
CASE WHEN pay_status = '待收款' and pay_predate >=curdate() THEN pay_unpaid ELSE 0 END AS unpaid2,
CASE WHEN pay_status = '未开票' THEN pay_unpaid ELSE 0 END AS unpaid3,
CASE WHEN pay_status = '已到期' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_d, 
CASE WHEN pay_status = '未开票' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_w
FROM
(select com_salesman,sales_region,
CASE WHEN pay_status = '未开票' THEN ifnull(pay_bill,0)-(ifnull(pay_payable,0)-ifnull(pay_unpaid,0)) ELSE ifnull(pay_unpaid,0) END AS pay_unpaid,
ctr_currency,pay_status,pay_predate
FROM sale_payment
LEFT JOIN  (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid ON pay_contract = ctr_id
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN sale_role_valid ON ctr_role=role_id
LEFT JOIN cust_company_valid ON opp_company=com_id
left join (SELECT DISTINCT sales_name,sales_region FROM hr_salesman) AS s on com_salesman = sales_name
where pay_verified = 'valid' and (pay_status in ("已到期",'未开票') OR (pay_status = '待收款' /*and pay_predate >=curdate()*/)) and length(sales_region)>0

) AS new5) AS new6
WHERE pay_unpaid>=0
GROUP BY com_salesman)as new7 on com_salesman=new1.ctr_salesman
LEFT JOIN(
SELECT ctr_salesman,sum(if(year(outspay_paydate)='${year}',outspay_paid,0)) paid,sum(if(year(outspay_paydate)='${year}' AND outspay_paydate<=curdate(),outspay_paid,0)) AS paid_this,sum(if(year(outspay_paydate)='${year}',0,outspay_paid)) paid_last,'${year}' AS year FROM `sale_outsource` a
left join (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency) b on outs_contract=ctr_id
inner join sale_opportunity c on ctr_id=opp_sign or ctr_agreement=opp_sign
inner join cust_company d on opp_company=com_id
left join sale_outsource_payment e on outs_id=outspay_outsource
left join (select distinct sales_name,sales_region from hr_salesman) f on ctr_salesman=sales_name
where (year(outspay_paydate)='${year}' OR ${if(year=year(today()),"(year(outspay_paydate)='"+(year-1)+"' AND outspay_paydate<='"+YEARDELTA(today(),-1)+"')","(year(outspay_paydate)='"+(year-1)+"')")})
and outs_status!="已作废"

group by ctr_salesman,year
) AS new5 ON new5.ctr_salesman = s.sales_name
WHERE length(sales_region)>0 and sales_region  in (select area_region from hr_area where area_id<11)
${if(len(sales)=0," and 1=1"," and new1.ctr_salesman in ('"+sales+"')")}
${if(len(region)=0," and 1=1"," and sales_region in ('"+region+"')")}) AS list
order BY sales_region,${ord} DESC) A,(SELECT @rownum:=0 , @reg:= null ,@rank:=0) B
) AS C ORDER BY ${ord} DESC) AS main,(SELECT @rownum_o:=0 ,@rank_o:=0) AS sub

SELECT type_region FROM dict_type WHERE type_region not in ("台湾","日本")

select *,round(planning_weifenpei*0.80/10000,2)weifenpei from sale_planning_of_region where planning_year ='${year}' and planning_weifenpei>0


SELECT * FROM(
SELECT s.sales_region,s.turn,new1.s.sales_name,ifnull(new1.amount,0)-ifnull(new2.amount,0)-ifnull(new7.amount,0) AS amount,(ifnull(new1.amount,0)-ifnull(new2.amount,0)-ifnull(new7.amount,0))/ifnull(new3.planning_value_e,0) AS rate,ifnull(new3.planning_value_e,0) AS planning_value_e,new1.year,
ifnull(new4.paid,0)-ifnull(new5.paid,0) AS amount_1,((ifnull(new4.paid_this,0)-ifnull(new5.paid_this,0))-(ifnull(new4.paid_last,0)-ifnull(new5.paid_last,0)))/(ifnull(new4.paid_last,0)-ifnull(new5.paid_last,0)) AS this_last,ifnull(new4.paid_this,0)-ifnull(new5.paid_this,0) AS amount_1_this,ifnull(new4.paid_last,0)-ifnull(new5.paid_last,0) AS amount_1_last,(ifnull(new4.paid,0)-ifnull(new5.paid,0))/ifnull(new3.planning_value_h,ifnull(new3.planning_value_e,0)*0.80) AS rate_1,ifnull(new3.planning_value_h,ifnull(new3.planning_value_e,0)*0.80) AS planning_value_h,if(length(planning_value_h)>0,1,0) AS isset
FROM
(SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name WHERE length(sales_parent)>0 and sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" and ifnull(year(user_leaveDate),2016)>='${year}' and sales_region not in('台湾','日本','海外')) 
#and user_state <> '离职'
) AS s 
LEFT JOIN(
SELECT ctr_salesman,sum(ctr_amount)-sum(IFNULL(sumpay_bill,0))amount,year(ctr_signdate) year
FROM (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid left join 
(select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment where pay_status in('记坏账','已作废')group by pay_contract)pay
on pay.pay_contract=ctr_id 
where year(ctr_signdate)='${year}' and ctr_verified='valid' and ctr_status!="已作废"

group by ctr_salesman,year(ctr_signdate)) AS new1 on new1.ctr_salesman = s.sales_name
LEFT JOIN(
select ctr_salesman,sum(outs_amount) amount,year(outs_recdate) year
from sale_outsource
left join (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid on outs_contract=ctr_id
where year(outs_recdate)='${year}'
and outs_status!="已作废"

group by ctr_salesman,year(outs_recdate)) AS new2
ON new1.ctr_salesman = new2.ctr_salesman and new1.year = new2.year 
LEFT JOIN(
SELECT * FROM (select planning_id,planning_name,planning_year,(planning_value_e*f_amount)planning_value_e,planning_type,planning_currency,planning_value_h from sale_planning,finan_other_statistics where f_remark='CNY' and f_type=planning_currency)sale_planning WHERE planning_year='${year}'

) AS new3 ON s.sales_name = new3.planning_name LEFT JOIN
(select pay_salesman,sum(if(year(pay_enddate)='${year}',pay_paid,0)) paid,sum(if(year(pay_enddate)='${year}' AND pay_enddate<=curdate(),pay_paid,0)) paid_this,sum(if(year(pay_enddate)='${year}',0,pay_paid)) paid_last,'${year}' AS year
from sale_payment 
join (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid on pay_contract=ctr_id
where  pay_verified = 'valid' and (year(pay_enddate)='${year}' OR ${if(year=year(today()),"(year(pay_enddate)='"+(year-1)+"' AND pay_enddate<='"+YEARDELTA(today(),-1)+"')","(year(pay_enddate)='"+(year-1)+"')")})

group by pay_salesman,year) AS new4 ON new4.pay_salesman = s.sales_name
left join
(
SELECT com_salesman,SUM(unpaid1) AS unpaid1,SUM(unpaid2) AS unpaid2,SUM(unpaid3) AS unpaid3,SUM(unpaid_l_d) AS unpaid_l_d,SUM(unpaid_l_w) AS amount,SUM(pay_unpaid) AS pay_unpaid
FROM
(SELECT *,
CASE WHEN pay_status = '已到期' THEN pay_unpaid ELSE 0 END AS unpaid1,
CASE WHEN pay_status = '待收款' and pay_predate >=curdate() THEN pay_unpaid ELSE 0 END AS unpaid2,
CASE WHEN pay_status = '未开票' THEN pay_unpaid ELSE 0 END AS unpaid3,
CASE WHEN pay_status = '已到期' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_d, 
CASE WHEN pay_status = '未开票' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_w
FROM
(select com_salesman,sales_region,
CASE WHEN pay_status = '未开票' THEN ifnull(pay_bill,0)-(ifnull(pay_payable,0)-ifnull(pay_unpaid,0)) ELSE ifnull(pay_unpaid,0) END AS pay_unpaid,
ctr_currency,pay_status,pay_predate
FROM sale_payment
LEFT JOIN  (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency)v_sale_contract_info_valid ON pay_contract = ctr_id
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN sale_role_valid ON ctr_role=role_id
LEFT JOIN cust_company_valid ON opp_company=com_id
left join (SELECT DISTINCT sales_name,sales_region FROM hr_salesman) AS s on com_salesman = sales_name
where pay_verified = 'valid' and (pay_status in ("已到期",'未开票') OR (pay_status = '待收款' /*and pay_predate >=curdate()*/)) and length(sales_region)>0

) AS new5) AS new6
WHERE pay_unpaid>=0
GROUP BY com_salesman)as new7 on com_salesman=new1.ctr_salesman
LEFT JOIN(
SELECT ctr_salesman,sum(if(year(outspay_paydate)='${year}',outspay_paid,0)) paid,sum(if(year(outspay_paydate)='${year}' AND outspay_paydate<=curdate(),outspay_paid,0)) AS paid_this,sum(if(year(outspay_paydate)='${year}',0,outspay_paid)) paid_last,'${year}' AS year FROM `sale_outsource` a
left join (select ctr_id,ctr_company,ctr_role,ctr_agreement,ctr_currency,(ctr_amount*f_amount)ctr_amount,ctr_invoice_type,ctr_prints,ctr_remarks,ctr_regemail,ctr_regs,ctr_2ndparty,ctr_salesman,ctr_presales,ctr_project,ctr_file_name,ctr_file_path,ctr_file_number,ctr_file_remarks,ctr_signdate,ctr_startdate,ctr_enddate,ctr_cont_name,ctr_cont_mobile,ctr_cont_address,ctr_invoice_title,ctr_openbank,ctr_account,ctr_taxnum,ctr_regtelephone,ctr_regaddress,ctr_receiver,ctr_receive_date,ctr_final_file,ctr_status,ctr_recdate,ctr_verifier,ctr_verdate,ctr_verified,ctr_is_add,sign_id from v_sale_contract_info_valid, finan_other_statistics where f_remark='CNY' and f_type=ctr_currency) b on outs_contract=ctr_id
inner join sale_opportunity c on ctr_id=opp_sign or ctr_agreement=opp_sign
inner join cust_company d on opp_company=com_id
left join sale_outsource_payment e on outs_id=outspay_outsource
left join (select distinct sales_name,sales_region from hr_salesman) f on ctr_salesman=sales_name
where (year(outspay_paydate)='${year}' OR ${if(year=year(today()),"(year(outspay_paydate)='"+(year-1)+"' AND outspay_paydate<='"+YEARDELTA(today(),-1)+"')","(year(outspay_paydate)='"+(year-1)+"')")})
and outs_status!="已作废"

group by ctr_salesman,year
) AS new5 ON new5.ctr_salesman = s.sales_name
WHERE length(sales_region)>0 and sales_region in (select area_region from hr_area where area_id<11)
${if(len(sales)=0," and 1=1"," and new1.ctr_salesman in ('"+sales+"')")}
${if(len(region)=0," and 1=1"," and sales_region in ('"+region+"')")}) AS list


