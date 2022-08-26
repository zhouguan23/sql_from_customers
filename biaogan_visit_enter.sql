select "10.0" banben
union
select "9.0" banben
union
select "8.0" banben
union
select "8.0之前" banben
union
select "无" banben


select *,greatest(if(due_date="" or due_date is null,"0000-01-01",due_date),if(opp_predate="" or opp_predate is null,"0000-01-01",opp_predate),
if(overdue_enddate="" or overdue_enddate is null,"0000-01-01",overdue_enddate),if(OPERATIONENDDATE="" or OPERATIONENDDATE is null,"0000-01-01",OPERATIONENDDATE)) as f_date,if(com_salesman="public",com_sales_region,sales_region) as region
from cust_company c
left join v_support_service_due on due_company=com_id
left join (select opp_id,opp_company,max(opp_predate) opp_predate from sale_opportunity where opp_verified="valid" group by opp_company order by opp_predate desc)o on opp_company=com_id
left join (select overdue_id,overdue_comid,max(overdue_enddate) overdue_enddate from support_overdue_service group by overdue_comid order by overdue_enddate desc)ov on overdue_comid=com_id
 left join (select CUSID, OPERATIONENDDATE from (select * from OPR_F_OPERATIONMANAGE order by OPERATIONENDDATE desc)opr1 group by CUSID)opr on CUSID=com_id
left join (select sales_region, sales_name from hr_salesman group by sales_name) hs on sales_name = com_salesman
where  com_id='${com_id}'
group by com_id



select * from
(select *,case when version like "8.%" then "8.0" 
when version like "9.%" then "9.0" 
when version like "10.%" then "10.0" 
when (version is not null and version<>"") and version not like "8.%" and version not like "9.%" and version not like "10.%" then "8.0之前"
else  "无" end as final_version from
(select * from
(SELECT 
 reg_id,ctr_company,partnership_company,reg_contract,reg_terms,reg_recdate,reg_version,reg_product,concat(ifnull(reg_version,'')," ",ifnull(reg_product,'')) as version,convert(reg_version,decimal) as order_v

 FROM sale_registration
 left join sale_contract_info on reg_contract=ctr_id
 INNER JOIN cust_partnership ON partnership_contract = ctr_id
where  reg_contract <> '' and reg_terms=0 and (reg_product regexp "FineReport" or reg_product is null or reg_product="")
and reg_version not regexp "v" and reg_version not regexp "f" and reg_version not regexp "r" and reg_version not regexp "变"
order by ctr_company,order_v desc
)A
group by partnership_company
order by order_v desc)B
)C


select * from
(select *,case when version like "8.%" then "8.0" 
when version like "9.%" then "9.0" 
when version like "10.%" then "10.0" 
when (version is not null and version<>"") and version not like "8.%" and version not like "9.%" and version not like "10.%" then "8.0之前"
else  "无" end as final_version from
(select * from
(SELECT 
 reg_id,ctr_company,partnership_company,reg_contract,reg_terms,reg_recdate,reg_version,reg_product,concat(ifnull(reg_version,'')," ",ifnull(reg_product,'')) as version,convert(reg_version,decimal) as order_v

 FROM sale_registration
 left join sale_contract_info on reg_contract=ctr_id
 INNER JOIN cust_partnership ON partnership_contract = ctr_id
where  reg_contract <> '' and reg_terms=0 and (reg_product regexp "FineReport" or reg_product is null or reg_product="")
and reg_version not regexp "v" and reg_version not regexp "f" and reg_version not regexp "r" and reg_version not regexp "变"
order by ctr_company,order_v desc
)A
group by partnership_company
order by order_v desc)B
)C


select * from cust_user_biaogan_visit 
where type='手动录入' and com_id='${com_id}'

select * from cust_user_biaogan_visit_file 

