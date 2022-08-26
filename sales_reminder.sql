SELECT count(com_id) unqualified FROM cust_company
where com_verified = 'valid' 
and com_status = '尚未联络'
and com_salesman = '${fr_username}'
and com_id not in (
select inq_comid from hotline_400_inquiry
where ifnull(inq_comid,'')<>''
and inq_status='未处理' 
and inq_verified='valid')

SELECT 
	A.REQ_ID,
	A.CUST_ID,
	B.com_name,
	CUST_OPPO_ID,
	EVA_PRO_NAME,
	CASE WHEN A.EVA_STATUS LIKE "%评审中" THEN "评审中"
			 ELSE A.EVA_STATUS
	END 
	STATUS,
	A.EVA_STATUS,
	A.PERSON_SALES,
	PERSON_PRESALE,
	D.team_name,
	A.EVA_PERSON,
	CONCAT(A.SUBMIT_RESULT,"/",a.SUBMIT_VERSION) AS RESULTSTATUS,
	CASE WHEN F.connum IS NULL THEN null
		   ELSE "√"
	END 
	constatus,
	CASE WHEN A.IS_OUTSOURCE=1 THEN "√"
			 ELSE NULL
	END
	PROJECTTYPE,
	A.REQ_INPUT_DATE,
	CASE WHEN A.EVA_STATUS="待评估" THEN TIMESTAMPDIFF(HOUR,A.REQ_INPUT_DATE,NOW())
		   ELSE TIMESTAMPDIFF(HOUR,A.REQ_INPUT_DATE,REQ_EVALUATE_TIME)
	END 
	evaluatehour,
	A.REQ_EVALUATE_TIME,
	CASE WHEN A.EVA_STATUS="待评估" THEN NULL
			 WHEN A.EVA_STATUS="转项目关闭" THEN TIMESTAMPDIFF(HOUR,REQ_EVALUATE_TIME,A.EVA_CLOSE_TIME)
			 WHEN A.EVA_STATUS="转无效关闭" THEN TIMESTAMPDIFF(HOUR,REQ_EVALUATE_TIME,A.EVA_CLOSE_TIME)
			 ELSE TIMESTAMPDIFF(HOUR,REQ_EVALUATE_TIME,NOW())
	END 	tingliu,
	CASE WHEN A.EVA_STATUS="待评估" THEN NULL
			 WHEN A.EVA_STATUS="转项目关闭" THEN TIMESTAMPDIFF(HOUR,H.lasttime,A.EVA_CLOSE_TIME)
			 WHEN A.EVA_STATUS="转无效关闭" THEN TIMESTAMPDIFF(HOUR,H.lasttime,A.EVA_CLOSE_TIME)
			 ELSE TIMESTAMPDIFF(HOUR,H.lasttime,NOW())
	END 	tingzhi,
	A.EVA_CLOSE_TIME,
	key_id,
	CASE WHEN A.EVA_STATUS LIKE "%评审中" THEN IFNULL(M.PINGSHEN,3)
		ELSE NULL
	END  PINGSHEN,
	CONCAT(IFNULL(M.PINGSHEN,3),A.REQ_ID) AS paixu
FROM PROJECT_F_REQUIREMENT_INFO A
LEFT JOIN cust_company B ON A.CUST_ID=B.com_id
LEFT JOIN sale_opportunity C ON A.CUST_OPPO_ID=C.opp_id
LEFT JOIN hr_department_team D ON A.EVA_GROUP=D.team_id
LEFT JOIN (SELECT REQ_ID, count(*) connum from project_f_contract_info GROUP BY REQ_ID) F ON A.REQ_ID=F.REQ_ID
LEFT JOIN (select REQ_ID,max(INPUT_DATE) lasttime from project_f_history GROUP BY REQ_ID) H ON A.REQ_ID=H.REQ_ID #最近更新时间
LEFT JOIN (SELECT key_id,prj_number from project_opportunity1)li on a.req_id=prj_number
LEFT JOIN (SELECT req_id,MAX(CASE verify_kind WHEN '组长评审' THEN 1 WHEN 'PMO评审' THEN 2 ELSE 0 END) PINGSHEN FROM prj_req_verify GROUP BY req_id) M ON A.REQ_ID=M.req_id
LEFT JOIN (SELECT tag_id,tag_name FROM prj_tag WHERE tag_type=2) N ON A.EVA_PROJECT_TYPE=N.tag_id
where A.req_id not in ('20161700149','20161700131','20161700050','20161700044','20161700034') 
and (PERSON_SALES  in (SELECT distinct sales_name  FROM hr_salesman where sales_parent = '${fr_username}' or sales_name = '${fr_username}' )
or person_presale in (SELECT distinct sales_name  FROM hr_salesman where sales_parent = '${fr_username}' or sales_name = '${fr_username}' ))

ORDER BY
	CASE WHEN STATUS='待评估' THEN 1
			 WHEN STATUS='评估中' THEN 2
			 WHEN STATUS='搁置中' THEN 3
			 WHEN STATUS='转项目关闭' THEN 4
			 WHEN STATUS='转无产出关闭' THEN 5	
			 WHEN STATUS='评审中' THEN 6
	END,
paixu desc

select (sum(ifnull(pay_bill,0))/10000)unpaid
from (
SELECT pay_bill*ctr_sta.f_amount pay_bill
/*取数结束*/

FROM sale_payment
left join (select pay_contract pay_contract_plus,sum(if(pay_paid<=0 and ifnull(pay_payable,0)=0,0,1))state from sale_payment group by pay_contract)zz on zz.pay_contract_plus=pay_contract 

left join payment_apply_link on al_payid=pay_id
left join payment_apply_info on a_id=al_apply
left join payment_apply_history on ahis_applyid=a_id and ahis_type="申请作废"
JOIN  v_sale_contract_info_valid ON pay_contract = ctr_id
join(select det_contract,GROUP_CONCAT(DISTINCT det_type)det_type from v_contract_detail where 1=1 
    GROUP BY det_contract )det on ctr_id = det_contract
LEFT JOIN finan_other_statistics pay_sta ON pay_sta.f_remark="CNY" AND  pay_sta.f_type=if(ifnull(pay_payable,0)+ifnull(pay_paid,0)=0,ctr_currency,pay_currency)
LEFT JOIN finan_other_statistics ctr_sta ON ctr_sta.f_remark="CNY" AND ctr_sta.f_type=ctr_currency
LEFT JOIN (
  SELECT opp_sign,opp_id,opp_company FROM sale_opportunity WHERE opp_sign IS NOT NULL
) opp ON opp_sign=sign_id
LEFT JOIN sale_role_valid ON ctr_role=role_id
LEFT JOIN cust_company ON ifnull(opp_company,ctr_company)=com_id
left join (select sales_name p_salesname,sales_parent parent from (select sales_name,sales_parent from hr_salesman)a join hr_user on user_username=sales_parent and user_duty='大区经理')parent on p_salesname=com_salesman
LEFT JOIN project_contract_link ON ctrlink_contract=ctr_id
LEFT JOIN project_opportunity1 a ON key_id=ctrlink_key
left join sale_contract_audit_project q on q.prj_contract=ctr_id
left join PROJECT_F_REQUIREMENT_INFO on REQ_ID=prj_num
left join sale_contract_of_project w on w.prj_contract=ctr_id
LEFT JOIN hr_department_team zhenshi ON a.prj_team = zhenshi.team_id
LEFT JOIN hr_department_team tibu ON EVA_GROUP = tibu.team_id  
LEFT JOIN project_members b ON b.prj_team=zhenshi.team_id AND prj_is_leader=1
LEFT JOIN cust_contact_valid ON pay_contact=cont_id
LEFT JOIN hr_salesman ON ctr_salesman=sales_name AND (sales_name<>"aaron" OR sales_name='aaron' AND sales_region="上海")
left join hr_user_tags on tag_username=ctr_salesman
left join hr_tags on tags_id=tag_region_id
left join (select count(urge_id)edit_num,urge_contract edit_pay from sale_payment_urge
group by edit_pay)edit_num on edit_pay=ctr_id
LEFT JOIN (
  SELECT urge_contract,urge_recorder,concat(date(urge_recdate),":",urge_remarks)urge_remark,urge_remarks FROM sale_payment_urge
join (select urge_contract m_ctr,max(urge_recdate) m_rec,if(urge_recorder="里程碑","里程碑","其他")m_tag from sale_payment_urge
group by urge_contract,if(urge_recorder="里程碑","里程碑","其他"))m on urge_contract=m_ctr and urge_recdate=m_rec and if(urge_recorder="里程碑","里程碑","其他")=m_tag 
) AS urge ON sale_payment.pay_contract=urge_contract
/*取表结束*/

where pay_verified = 'valid' and ifnull(pay_paid,0)<=0 and pay_status not in ("已作废","记坏账") and pay_bill>0
and ifnull(pay_payable,0)<>0
and com_salesman in(SELECT distinct sales_name  FROM hr_salesman where sales_parent = '${fr_username}' or sales_name = '${fr_username}' )
and pay_status in("待收款","已到期")
and sales_region=(select distinct sales_region from(
select 
case when sales_name='aaron' then"上海"
else  sales_region end as sales_region
from hr_salesman where sales_name='${fr_username}')a)
group by pay_id
)a


select ifnull(sum(amount)/10000,0) as jine from(select distinct opp_name,amount from (
SELECT sale_contract_info.*,opp_id,ifnull(opp_name,role_project)opp_name,com_id,com_name,com_type,com_salesman,com_recdate,sumpay_unpayable,
role_project,role_enduser,sumpay_unpaid,sumpay_paid,ctr_amount amount,version
,dec_line,det_type,(det_amount)det_amount,if(ctr_status in ('待审核','待录入','不合格'),'待审核合同',
if(ctr_status='已作废' and sumpay_paid<=0 and sumpay_unpaid<=0,'作废合同',
if((ctr_status='已作废' and (sumpay_paid>0 or sumpay_unpaid>0)) or (ctr_status<>'已作废' and sumpay_bill>0),'坏账合同',
if(ctr_status not in ('已收回','已存档','待审核','待录入','不合格','已作废') and sumpay_paid<=0,'待收回合同','已收回合同')))) ctr_sta
FROM sale_contract_info
 join(select det_contract,GROUP_CONCAT(DISTINCT if(det_productline ='FineBI','BI','报表'))dec_line
	,GROUP_CONCAT(DISTINCT det_type)det_type,sum(det_amount)det_amount from v_contract_detail 
	where 1=1 ${if(len(line)=0,""," and det_productline in ('"+line+"')")} 
	${if(len(type)=0,""," and det_type in ('"+type+"')")}
	GROUP BY det_contract )det on ctr_id = det_contract
LEFT JOIN sale_opportunity ON ctr_id=opp_sign or ctr_agreement=opp_sign
LEFT JOIN cust_partnership ON partnership_contract = ctr_id
LEFT JOIN cust_company ON partnership_company = com_id
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN hr_salesman ON sales_name = ctr_salesman
LEFT JOIN (select pay_contract,sum(IFNULL(pay_unpaid,0))sumpay_unpaid,sum(IFNULL(pay_paid,0))sumpay_paid,sum(ifnull(pay_bill,0)-ifnull(pay_payable,0)+if(pay_unpaid<0&&pay_status="已回款",pay_unpaid,0))sumpay_unpayable from sale_payment where pay_status not in('记坏账','已作废')group by pay_contract)unpaid  ON ctr_id = pay_contract 
left join 
(select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment where pay_status in('记坏账','已作废')group by pay_contract)pay 
on pay.pay_contract=ctr_id 
left join (select  pro_contract,GROUP_CONCAT(distinct pro_edition)version from 
`sale_contract_of_product` GROUP BY pro_contract
)`sale_contract_of_product` on pro_contract=ctr_id
where ctr_verified = 'valid'  and ifnull(ctr_noneed,'')<>'true'
and role_verified = 'valid' and com_country="中国"
and ctr_salesman in (SELECT distinct sales_name  FROM hr_salesman where sales_parent = '${fr_username}' or sales_name = '${fr_username}' )

${if(len(year)=0,"","and year(ctr_signdate) = '"+year+"'")}
${if(len(month)=0,""," and month(ctr_signdate) in ("+month+")")}
${if(len(year_c)=0,"","and year(ctr_signdate_first) = '"+year_c+"'")}
${if(len(month_c)=0,""," and month(ctr_signdate_first) in ("+month_c+")")}
${if(len(opportunity)=0,""," and opp_id = '"+opportunity+"'")}
${if(len(company)=0,""," and com_id = '"+company+"'")}
${if(len(comtype)=0,""," and com_type = '"+comtype+"'")}
${if(len(secondparty)=0,""," and ctr_2ndparty = '"+secondparty+"'")}
${if(len(amount_down)=0,""," and ctr_amount >= '"+amount_down+"'")}
${if(len(object)=0,""," and version regexp'"+object+"'")}
${if(len(currency)=0," and 1=2"," and ctr_currency ='"+currency+"'")}
${if(len(ctr_status)=0,"","and if(ctr_status in ('待审核','待录入','不合格'),'待审核合同',
if(ctr_status='已作废' and sumpay_paid<=0 and sumpay_unpaid<=0,'作废合同',
if((ctr_status='已作废' and (sumpay_paid>0 or sumpay_unpaid>0)) or (ctr_status<>'已作废' and sumpay_bill>0),'坏账合同',
if(ctr_status not in ('已收回','已存档','待审核','待录入','不合格','已作废','订单已处理') and sumpay_paid<=0,'草案合同','正式合同')))) in ('"+ctr_status+"')")}
${if(len(dist)=0,""," and sales_region in ('"+dist+"')")}
${if(len(radio)=0,"",if(radio=0,"and ctr_status not in ('待审核','待录入','不合格')",
"and (ctr_status in ('已收回','已存档','订单已处理') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))"))}
union
SELECT sale_contract_info.*,opp_id,ifnull(opp_name,role_project)opp_name,com_id,com_name,com_type,com_salesman,com_recdate,sumpay_unpayable,
role_project,role_enduser,sumpay_unpaid,sumpay_paid,IFNULL(-sumpay_bill,0)amount,version
,dec_line,det_type,-(det_amount*IFNULL(sumpay_bill,0)/ctr_amount)det_amount,
if(ctr_status='已作废' and sumpay_paid<=0 and sumpay_unpaid<=0,'作废合同',
if((ctr_status='已作废' and (sumpay_paid>0 or sumpay_unpaid>0)) or (ctr_status<>'已作废' and sumpay_bill>0),'坏账合同',
if(ctr_status not in ('已收回','已存档','待审核','待录入','不合格','已作废') and sumpay_paid<=0,'待收回合同','已收回合同'))) ctr_sta
FROM sale_contract_info
 join(select det_contract,GROUP_CONCAT(DISTINCT if(det_productline ='FineBI','BI','报表'))dec_line
	,GROUP_CONCAT(DISTINCT det_type)det_type,sum(det_amount)det_amount from v_contract_detail 
	where 1=1 ${if(len(line)=0,""," and det_productline in ('"+line+"')")} 
	${if(len(type)=0,""," and det_type in ('"+type+"')")}
	GROUP BY det_contract )det on ctr_id = det_contract
LEFT JOIN sale_opportunity ON ctr_id=opp_sign or ctr_agreement=opp_sign
LEFT JOIN cust_partnership ON partnership_contract = ctr_id
LEFT JOIN cust_company ON partnership_company = com_id
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN hr_salesman ON sales_name = ctr_salesman
LEFT JOIN (select pay_contract,sum(IFNULL(pay_unpaid,0))sumpay_unpaid,sum(IFNULL(pay_paid,0))sumpay_paid,sum(ifnull(pay_bill,0)-ifnull(pay_payable,0)+if(pay_unpaid<0&&pay_status="已回款",pay_unpaid,0))sumpay_unpayable from sale_payment where pay_status not in('记坏账','已作废')group by pay_contract)unpaid  ON ctr_id = pay_contract 
inner join 
(select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment 
left join sale_contract_info on pay_contract=ctr_id
where ((pay_status not in("已回款") and ctr_status="已作废" and year(ctr_signdate)="${year}" and year(ifnull(ctr_voiddate,ctr_signdate))="${year}" and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate)
${if(len(month)=0,""," and month(ifnull(ctr_voiddate,ctr_signdate_first)) ="+month+"")}
${if(len(year)=0,""," and year(ifnull(ctr_voiddate,ctr_signdate_first)) ="+year+"")})  or (ctr_status<>"已作废" and pay_status in('记坏账','已作废') and year(ifnull(pay_voiddate,ctr_signdate_first))=year(ctr_signdate)))
and year(ctr_signdate)="${year}" and year(ifnull(ctr_voiddate,ctr_signdate))="${year}"
${if(len(year)=0,""," and year(ifnull(pay_voiddate,ctr_signdate))='"+year+"'")}
${if(len(month)=0,""," and month(ifnull(pay_voiddate,ctr_signdate))='"+month+"'")} group by pay_contract)pay 
on pay.pay_contract=ctr_id 
left join (select  pro_contract,GROUP_CONCAT(distinct pro_edition)version from 
`sale_contract_of_product` GROUP BY pro_contract
)`sale_contract_of_product` on pro_contract=ctr_id
where ctr_verified = 'valid'  
and ifnull(ctr_noneed,'')<>'true'
and role_verified = 'valid' and com_country="中国"
and ctr_salesman in (SELECT distinct sales_name  FROM hr_salesman where sales_parent = '${fr_username}' or sales_name = '${fr_username}' )

${if(len(opportunity)=0,""," and opp_id = '"+opportunity+"'")}
${if(len(company)=0,""," and com_id = '"+company+"'")}
${if(len(comtype)=0,""," and com_type = '"+comtype+"'")}
${if(len(secondparty)=0,""," and ctr_2ndparty = '"+secondparty+"'")}
${if(len(amount_down)=0,""," and ctr_amount >= '"+amount_down+"'")}
${if(len(object)=0,""," and version regexp'"+object+"'")}
${if(len(currency)=0," and 1=2"," and ctr_currency ='"+currency+"'")}
${if(len(dist)=0,""," and sales_region in ('"+dist+"')")}

order by ctr_signdate_first desc,com_recdate asc)allt)allt_a


SELECT count(*)as jccount FROM(
  SELECT *,
  (
    SELECT trace_id FROM cust_trace WHERE trace_contact = cont_id AND trace_recorder<>'system' AND trace_detail NOT REGEXP "被转移的客户|发送了短信"
    ORDER BY trace_recdate DESC,trace_rectime DESC limit 1
  ) AS traceid
  FROM (
    SELECT com_id,com_name,com_province,com_city,com_status,com_salesman,cont_id,cont_name,com_country,com_source
    FROM cust_company JOIN cust_contact ON com_id=cont_company
    WHERE com_verified='valid' AND cont_verified='valid'
    AND cont_tags REGEXP 'H37'
   and com_salesman ='${fr_username}'
  ) AS a
) AS b JOIN cust_trace ON trace_id = traceid
WHERE trace_detail REGEXP '【决策菁英】'
and trace_action='其它'


select count(*)as inq_count 
from
hotline_400_inquiry
join cust_contact on inq_contid=cont_id
join cust_company on com_id=cont_company
where 
ifnull(inq_comid,'')<>''
and inq_status='未处理' 
and inq_verified='valid'
and com_salesman='${fr_username}'


select count(*)as ambcount from(
SELECT *,
  (
    SELECT trace_id FROM cust_trace WHERE trace_contact = cont_id AND trace_recorder<>'system' AND trace_detail NOT REGEXP "被转移的客户|发送了短信"
    ORDER BY trace_recdate DESC,trace_rectime DESC limit 1
  ) AS traceid
	from(
SELECT com_id,com_name,com_province,com_city,com_status,com_salesman,cont_id,cont_name,com_country,com_source
    FROM cust_company JOIN cust_contact ON com_id=cont_company
    WHERE com_verified='valid' AND cont_verified='valid'
    AND cont_tags REGEXP 'T3'
and com_salesman ='${fr_username}'
)a
)b JOIN cust_trace ON trace_id = traceid
WHERE trace_detail REGEXP '【阿米巴】'
and trace_action='其它'


select group_concat(concat('<a href="',re_link,'" target="_blank">',re_content,'</a>') separator '<br/><br/>') texts from sales_release_list



select sum(pay_paid)/10000 as  pay_paid
from sale_payment 
join sale_contract_info on pay_contract=ctr_id 
left join cust_company on com_id=ctr_company
where  pay_verified = 'valid' and year(pay_enddate)=year(curdate()) and month(pay_enddate) =month(curdate()) and com_country="中国"
and IFNULL(pay_currency,ctr_currency)='CNY'
 and pay_salesman in (SELECT distinct sales_name  FROM hr_salesman where sales_parent = '${fr_username}' or sales_name = '${fr_username}')

SELECT 
count(distinct sDis_id)c1
FROM sale_distribute_report
where ifnull(sDis_status,'未审核') in ('未审核')
and sDis_salesman_2nd='${fr_username}' 
union all
SELECT 
count( distinct pre_id)c2
 FROM sale_preparation_apply
left join sale_preparation_company  on com_pre_apply=pre_id
where ifnull(com_status,'未审核') in ('未审核')
and com_pre_salesman ='${fr_username}'


select sum(if(app_type=1,1,0))as product_c
,sum(if(app_type=0,1,0))as outsource_c
from dict_waibao_audit 
join sale_outsource_apply on app_id=s_id
where user='${fr_username}'
and status=0
and app_audit='审核中'

select count(*)c from finan_pay_apply where payapply_status='待审核' and payapply_auditor='${fr_username}'


select count(*)num from hardware_outsource_apply
left join sale_contract_info on ctr_id=h_contract
left join sale_supplier_hardware on sup_id=h_supplier
left join cust_company on com_id=ctr_company
where h_status="待大区经理审核" and h_applier in (select sales_name from hr_salesman where sales_parent='${fine_username}')


select sum(if(c.app_type=1,1,0))as pro_c
,sum(if(c.app_type=0,1,0))as prj_c
from sale_outsource_payment_audit a 
left join sale_outsource_payment_apply b on a.audit_pay =b.app_outspay_id
left join sale_outsource_payment af on af.outspay_id = a.audit_pay
left join sale_outsource ad on b.app_outsource = ad.outs_id 
left join sale_outsource_apply c on  c.app_id = ad.outs_appid
where af.outspay_status<>'已作废'
and b.app_status not regexp '作废'
and a.audit_status regexp '销售|大区'
and a.audit_salesman='${fr_username}'

