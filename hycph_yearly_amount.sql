select com_id,com_name,sum(amount_j)amount from (
SELECT com_id,com_name,ctr_id,ctr_signdate,prj_amount,opp_id,opp_name,amount,sum(outs_amount) outs_amount ,(amount-sum(outs_amount))amount_j from (

SELECT 
com_id,com_name,ctr_id,(prj_amount/10000) as prj_amount,opp_id,opp_name,((ctr_amount)/10000)amount,outs_id
,(IFNULL(outs_amount,0)/10000 )as outs_amount,ctr_signdate
/*ctr_id
,com_id as ctr_company
,ctr_signdate
,ctr_salesman
,opp_id
,opp_name
,com_id
,com_name
,com_salesman
,com_recdate
,com_presales
,role_project
,role_enduser
,(sumpay_unpaid/10000)sumpay_unpaid
,((ctr_amount)/10000)amount
,(prj_amount/10000) as prj_amount
,(prod_amount/10000) as prod_amount
,(else_amount/10000) as else_amount
,if((select count(*)c from cust_partnership where partnership_company=com_id )>1,'是','否')as buy_again
,outs_id
,(IFNULL(outs_amount,0)/10000 )as outs_amount
,version
,(select group_concat(tags_name)name  from dict_tags where tags_code regexp 'H' and concat(ctr_tags,',') regexp concat(tags_code,','))com_tags
,ifnull(bm_guwen,com_presales) as guwen*/
FROM
(select ctr_id,(ctr_amount*f_amount) as ctr_amount,ctr_currency,partnership_company,com_id,com_name,com_salesman,com_recdate,com_presales,com_tags,ctr_salesman,ctr_signdate,ctr_agreement,ctr_role,ctr_tags
from 

(select ctr_id,ctr_amount,ctr_currency,partnership_company,ctr_salesman,ctr_signdate,ctr_agreement,ctr_role,if(ctr_company=partnership_company,1,0)g ,ctr_tags
from(select ctr_id,ctr_signdate,sum(ctr_amount)as ctr_amount,ctr_currency,ctr_company,ctr_agreement,ctr_role,ctr_salesman,ctr_tags
from (SELECT ctr_id,ctr_signdate,ctr_amount,ctr_currency,ctr_company,ctr_agreement,ctr_role,ctr_salesman,ctr_tags
FROM sale_contract_info
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract 
where year(ctr_signdate)=${y} 
${if(y<=2017,"and ctr_status not in ('待审核','待录入','不合格')",
"and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))")}


union#已作废合同
select ctr_id,ifnull(ctr_voiddate,ctr_signdate),-ctr_amount,ctr_currency,ctr_company,ctr_agreement,ctr_role,ctr_salesman,ctr_tags
from sale_contract_info
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ifnull(ctr_voiddate,ctr_signdate))=${y} and year(ctr_signdate)=${y}


union#未作废合同中作废的财务记录
select ctr_id, ifnull(pay_voiddate,ctr_signdate),-ifnull(pay_bill,0),ifnull(pay_currency,ctr_currency) ctr_currency,ctr_company,ctr_agreement,ctr_role,ctr_salesman,ctr_tags
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and year(ifnull(pay_voiddate,ctr_signdate))=${y} and pay_status in ("记坏账","已作废") and year(ctr_signdate)=${y}


union#已作废合同中已回款的部分
select ctr_id, ifnull(ctr_voiddate,ctr_signdate),ifnull(pay_paid,0),ifnull(pay_currency,ctr_currency) ctr_currency,ctr_company,ctr_agreement,ctr_role,ctr_salesman,ctr_tags
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ifnull(ctr_voiddate,ctr_signdate))=${y} and ifnull(pay_paid,0)>0 and year(ctr_signdate)=${y}

) as c
group by ctr_id
)listtt
left join cust_partnership ON partnership_contract = ctr_id
order by partnership_company,g
)l
join finan_other_statistics on f_type=ctr_currency and f_remark="CNY"
JOIN cust_company on com_id=partnership_company and com_type ='最终用户' 
where ifnull(ctr_tags,'')<>''
${if(len(tags)=0,"","and (concat(ctr_tags,',') regexp concat(replace('"+tags+"',',',',|'),','))")}
group by ctr_id
)ctr
LEFT JOIN
(select pay_contract,if(pay_status not in('记坏账','已作废'),sum(IFNULL(pay_unpaid*f_amount,0)),0)sumpay_unpaid,if(pay_status in('记坏账','已作废'),sum(IFNULL(pay_bill*f_amount,0)),0)sumpay_bill from sale_payment join finan_other_statistics on f_type=pay_currency and f_remark="CNY" group by pay_contract)unpaid ON ctr_id = pay_contract 
LEFT JOIN sale_outsource ON outs_contract=ctr_id and outs_status <> '已作废'
LEFT JOIN sale_opportunity ON ifnull(ctr_agreement,ctr_id)=opp_sign
LEFT JOIN cust_benchmark on com_id=bm_company 
LEFT JOIN sale_role ON ctr_role=role_id
left join
(select  pro_contract,GROUP_CONCAT(distinct name)version from `sale_contract_of_product`
join (select  0 id ,'基本版' name union 
select  1 id ,'开发版' name union 
select  2 id ,'标准版' name union 
select  3 id ,'专业版' name union 
select  4 id ,'企业版' name union 
select  5 id ,'轻量级BI' name union 
select  6 id ,'BI' name union 
select  7 id ,'定制版' name  )version on  pro_edition=id
GROUP BY pro_contract)sale_contract_of_product on pro_contract=ctr_id
left join (select det_contract,sum(if(det_type='实施',det_amount,0))as prj_amount,sum(if(det_type='产品',det_amount,0))as prod_amount,sum(if(det_type not in ('产品','实施'),det_amount,0))as else_amount
from v_contract_detail 
group by det_contract)type_ctr on det_contract =ctr_id
where 1=1
having amount>0
ORDER BY com_id,ctr_id,outs_id

)lista
group by ctr_id
order by com_id
)listb 
group by com_id 
having amount>12
order by com_id

select tagcode as tags_code,concat(tags_name,'_',group_concat(user_username))as tags_name
from  hr_user 
JOIN hr_user_tags on user_username = tag_username
join hr_tags on tag_industry_id =  tags_id
JOIN hr_hangye on user_username=hangye_user
join hangye_tag_code on tag_industry_id=tagid
where user_department =3 and user_state='在职' and user_username<>'ming'
group by tagcode
union
select 'H315','保险_charless'


