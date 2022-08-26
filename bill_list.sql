select a.*,ctr_project,com_name from finan_bill a
left join sale_contract_info on ctr_id regexp bill_ctr
left join cust_company on com_id=ctr_company
where 1=1
${if(len(salesman)=0,"",if(find("财务",$fr_userposition)>0 || find("crm",$fr_userposition)>0,"and bill_salesman in ('"+salesman+"')","and bill_salesman in ("+"select sales_name from hr_salesman where sales_parent = '"+salesman+"'
union (select sales_name from hr_salesman where sales_name='"+salesman+"')"+")"))}

${if(len(secondparty)=0,"","and bill_com in ('"+secondparty+"')")}
${if(len(com)=0,"","and bill_2ndparty in ('"+com+"')")}
${if(len(ctr)=0,"","and bill_ctr regexp ('"+ctr+"')")}
${if(len(kaipiao_sd)=0,"","and date(bill_startdate)>='"+kaipiao_sd+"'")}
${if(len(kaipiao_ed)=0,"","and date(bill_startdate)<='"+kaipiao_ed+"'")}
${if(len(daoqi_sd)=0,"","and date(bill_enddate)>='"+daoqi_sd+"'")}
${if(len(daoqi_ed)=0,"","and date(bill_enddate)<='"+daoqi_ed+"'")}
${if(len(status)=0,"","and bill_status='"+status+"'")}



SELECT user_username,concat(user_username,'(',user_name,')') FROM hr_salesman
left join hr_user on user_username=sales_name
where (user_state="在职" or (user_state="离职" and ifnull(year(user_leaveDate),2016)>=year(now())))
${if(find("财务",fr_userposition)=0,"and user_username='"+fr_username+"'","")}
	

select distinct ctr_company,com_name,ctr_salesman,com_id from sale_contract_info
left join (select com_id,com_name from cust_company)ss on com_id=ctr_company
where 1=1
${if(len(salesman)=0,"","and ctr_salesman in ('"+salesman+"')")}

select distinct ctr_id,com_name,ctr_salesman,com_id,ifnull(opp_name,role_project)opp_name from sale_contract_info
left join (select com_id,com_name from cust_company)ss on com_id=ctr_company
LEFT JOIN sale_opportunity ON ctr_id=opp_sign or ctr_agreement=opp_sign
LEFT JOIN sale_role ON ctr_role=role_id
where 1=1
${if(len(salesman)=0,"","and ctr_salesman in ('"+salesman+"')")}
${if(len(com)=0,"","and com_id in ('"+com+"')")}

