#yuwh.CRM-1261.2017.04.25
SELECT country,sales_region,user_name,com_salesman AS pay_salesman,unpaid1,unpaid2,unpaid3,unpaid_l_d,unpaid_l_w,pay_unpaid,unpaid_l_k,unpaid_l_q,
if(length(${ord1})>0,if(sales_region = @reg,if(${ord1}<>@rownum,@rank:=@rank+1,@rank),@rank:=1),"无") AS rank,@reg:=sales_region,@rownum:=${ord1}
FROM
(SELECT country,sales_region,user_name,com_salesman,SUM(unpaid1) AS unpaid1,SUM(unpaid2) AS unpaid2,SUM(unpaid3) AS unpaid3,SUM(unpaid_l_d) AS unpaid_l_d,SUM(unpaid_l_w) AS unpaid_l_w,SUM(pay_unpaid) AS pay_unpaid,SUM(unpaid_l_k) AS unpaid_l_k,SUM(unpaid_l_q) AS unpaid_l_q
FROM
(SELECT *,
CASE WHEN pay_status in ('已到期','待收款','未开票') and pay_predate <curdate() THEN pay_unpaid ELSE 0 END AS unpaid1,
CASE WHEN pay_status in ('待收款','已到期') THEN pay_unpaid ELSE 0 END AS unpaid2,
CASE WHEN pay_status = '未开票' THEN pay_unpaid ELSE 0 END AS unpaid3,
CASE WHEN pay_status = '已到期' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_d, 
CASE WHEN pay_status = '未开票' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_w,
CASE WHEN pay_status in ('已到期','待收款') and pay_recdate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -3 month) THEN pay_unpaid ELSE 0 END AS unpaid_l_k,
case when pay_status in ('未开票') and ctr_signdate<date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -182 day) and ctr_id in 
(select ctr_id from (select sum(pay_bill) pay_bill,pay_contract from sale_payment where pay_status not in ('记坏账','已作废','已回款','已到期','待收款') and ifnull(pay_paid,0)=0 group by pay_contract)s
inner join v_sale_contract_info_valid on ctr_id=pay_contract
where ctr_amount=pay_bill) and pay_predate=min_predate THEN pay_unpaid ELSE 0 END AS unpaid_l_q
FROM
(select sales_name com_salesman,user_name,sales_region,
CASE WHEN pay_status = '未开票' THEN (ifnull(pay_bill,0)-(ifnull(pay_payable,0)-ifnull(pay_unpaid,0)))*ifnull(f_amount,1) ELSE ifnull(pay_unpaid,0)*ifnull(f_amount,1) END AS pay_unpaid,
ctr_currency,pay_status,pay_predate,pay_recdate,ctr_signdate,ctr_id,min_predate,if(com_country="中国","国内","海外")country
FROM sale_payment
LEFT JOIN  v_sale_contract_info_valid ON pay_contract = ctr_id
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN sale_role_valid ON ctr_role=role_id
LEFT JOIN cust_company_valid ON opp_company=com_id
left join (SELECT DISTINCT sales_name,if(sales_name="aaron","上海",sales_region)sales_region FROM hr_salesman) AS s on ifnull(com_salesman,ctr_salesman) = sales_name
left join (select min(pay_predate)min_predate,pay_contract min_contract from sale_payment group by pay_contract)min on min_contract=pay_contract
left join finan_other_statistics on f_type=ctr_currency and f_remark="CNY"
JOIN hr_user ON user_username = sales_name
where pay_verified = 'valid' and (pay_status in ("已到期",'未开票') OR (pay_status = '待收款')) and length(sales_region)>0
${if(len(currency)=0,""," and ctr_currency ='"+currency+"'")}
${if(len(sales)=0," and 1=1"," and sales_name in ('"+sales+"')")}
${if(len(region)=0," and 1=1"," and sales_region in ('"+region+"')")}
${if(len(country)=0,"","and if(com_country='中国','国内','海外')='"+country+"'")}
) AS new1) AS new2
WHERE pay_unpaid>=0
GROUP BY com_salesman
order BY sales_region,${ord1} DESC) A,(SELECT @rownum:=0 , @reg:= null ,@rank:=0) B

select * from mar_currency

SELECT DISTINCT sales_name,concat(sales_name,'-',user_name) as sale FROM hr_salesman
left join hr_user on user_username = sales_name
WHERE sales_region in ('${region}')
order by sales_name

SELECT sales_region,user_name,com_salesman,SUM(unpaid1) AS unpaid1,SUM(unpaid2) AS unpaid2,SUM(unpaid3) AS unpaid3,SUM(unpaid_l_d) AS unpaid_l_d,SUM(unpaid_l_w) AS unpaid_l_w,SUM(pay_unpaid) AS pay_unpaid,SUM(unpaid_l_k) AS unpaid_l_k
FROM
(SELECT *,
CASE WHEN pay_status = '已到期' THEN pay_unpaid ELSE 0 END AS unpaid1,
CASE WHEN pay_status = '待收款' and pay_predate >=curdate() THEN pay_unpaid ELSE 0 END AS unpaid2,
CASE WHEN pay_status = '未开票' THEN pay_unpaid ELSE 0 END AS unpaid3,
CASE WHEN pay_status = '已到期' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_d, 
CASE WHEN pay_status = '未开票' and pay_predate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -1 year) THEN pay_unpaid ELSE 0 END AS unpaid_l_w,
CASE WHEN pay_status in ('已到期','待收款') and pay_recdate < date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -3 month) THEN pay_unpaid ELSE 0 END AS unpaid_l_k,
case when pay_status in ('未开票') and ctr_signdate<date_add(${if(len(setdate)>0,"'"+setdate+"'","curdate()")},interval -6 month) and ctr_id in 
(select ctr_id from (select sum(pay_bill) pay_bill,pay_contract from sale_payment where pay_status not in ('记坏账','已作废','已回款','已到期','待收款') and ifnull(pay_paid,0)=0 group by pay_contract)s
inner join v_sale_contract_info_valid on ctr_id=pay_contract
where ctr_amount=pay_bill) THEN pay_unpaid ELSE 0 END AS unpaid_l_q
FROM
(select com_salesman,user_name,sales_region,
CASE WHEN pay_status = '未开票' THEN ifnull(pay_bill,0)-(ifnull(pay_payable,0)-ifnull(pay_unpaid,0)) ELSE ifnull(pay_unpaid,0) END AS pay_unpaid,
ctr_currency,pay_status,pay_predate,pay_recdate,ctr_signdate,ctr_id
FROM sale_payment
LEFT JOIN  v_sale_contract_info_valid ON pay_contract = ctr_id
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN sale_role_valid ON ctr_role=role_id
LEFT JOIN cust_company_valid ON opp_company=com_id
left join (SELECT DISTINCT sales_name,sales_region FROM hr_salesman) AS s on com_salesman = sales_name
JOIN hr_user ON user_username = sales_name
where pay_verified = 'valid' and (pay_status in ("已到期",'未开票') OR (pay_status = '待收款' /*and pay_predate >=curdate()*/)) and length(sales_region)>0
${if(len(currency)=0," and 1=2"," and ctr_currency ='"+currency+"'")}
${if(len(sales)=0," and 1=1"," and com_salesman in ('"+sales+"')")}
${if(len(region)=0," and 1=1"," and sales_region in ('"+region+"')")}
) AS new1) AS new2
WHERE pay_unpaid>=0
GROUP BY com_salesman


select ctr_id,com_salesman,if(com_country="中国","国内","海外")country,sales_region,ctr_project,com_name
from (select sum(pay_bill) pay_bill,pay_contract from sale_payment where pay_status="未开票" and ifnull(pay_paid,0)=0 and pay_verified="valid" group by pay_contract)s
inner join v_sale_contract_info_valid on ctr_id=pay_contract
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid ON ifnull(opp_company,ctr_company)=com_id
left join (SELECT DISTINCT sales_name,sales_region FROM hr_salesman)a on com_salesman = sales_name
where ctr_amount=pay_bill and date_add(ctr_signdate,interval 182 day)<curdate()

