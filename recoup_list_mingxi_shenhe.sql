SELECT *,concat(id,"-",left(detail,30)) p
FROM `finan_dict_rule`

SELECT id,name,parent FROM `finan_dict_subject`

${if(find("区域经理",fr_userposition)>0,
"select sales_name user_username,sales_name name from hr_salesman
where sales_parent ='"+fr_username+"'",
"SELECT user_username,concat(user_username,'(',user_name,')') name
FROM `hr_user`
where user_state='在职'
or user_leaveDate >=DATE_ADD(curdate(),INTERVAL -2 month)
order by user_username")}


SELECT key_id,opportunity_name FROM `project_opportunity1`

SELECT key_id,opportunity_name FROM `project_opportunity1`
where customer_id = '${AL9}'

SELECT a.*,c.com_name,opportunity_name,pid,sid,dayofweek(happenday) weekday, concat(
if(isnull(title_1)||isnull(remark_1),"",CONCAT(title_1,':',remark_1,',')),
if(isnull(title_2)||isnull(remark_2),"",CONCAT(title_2,':',remark_2,',')),
if(isnull(title_3)||isnull(remark_3),"",CONCAT(title_3,':',remark_3,',')),
if(isnull(title_4)||isnull(remark_4),"",CONCAT(title_4,':',remark_4,',')),
if(isnull(title_5)||isnull(remark_5),"",CONCAT(title_5,':',remark_5,',')),
if(isnull(remark_0),"",remark_0)) haha
FROM `finan_recoup` a
inner join finan_dict_subject b on a.subject=b.id
left join cust_company c on a.company_id=c.com_id
left join project_opportunity1 on key_id=project_id
join 
(select id aid,sid,pid from(
select a.id,if(b.parent is null,a.id,b.id)sid,ifnull(IFNULL(b.parent,b.id),a.id)pid from finan_dict_subject a 
left join finan_dict_subject b on a.parent=b.id)s
)sub on subject=sub.aid 
where 1=1
${if(len(status)=0," and 1=2","and a.status ='"+status+"'")}
${if(len(project)=0,"","and a.project_id ='"+project+"'")}
${if(len(subject)=0,"","and a.subject in ('"+subject+"')")}
${if(len(recorder)=0,"","and a.recorder in ('"+recorder+"')")}
${if(len(company)=0,"","and c.com_name like'%"+company+"%'")}
${if(len(years)=0,"","and year(a.happenday) ='"+years+"'")}
${if(len(months)=0,"","and month(a.happenday) ='"+months+"'")}
${if(len(startdate)=0,"","and a.happenday >='"+startdate+"'")}
${if(len(enddate)=0,"","and a.happenday <='"+enddate+"'")}
${if(len(c_startdate)=0,"","and a.checkdate >='"+c_startdate+"' and (a.status='已审核' or a.status='已报销')")}
${if(len(c_enddate)=0,"","and a.checkdate <='"+c_enddate+"' and (a.status='已审核' or a.status='已报销')")}
${if(len(r_startdate)=0,"","and a.recoupdate >='"+r_startdate+"' and a.status='已报销'")}
${if(len(r_enddate)=0,"","and a.recoupdate <='"+r_enddate+"' and a.status='已报销'")}
${if(len(verifier)=0,"","and verifier in ('"+verifier+"')")}
${if(len(invoice)=0,"",if(invoice='y',"and a.amount_invoice>0","and a.amount_invoice=0"))}
${if(len(daifa)=0,"",if(daifa=1," and (a.amount_invoice>=a.amount_cost or (a.amount_invoice<a.amount_cost and amount_invoice = amount_recoup))"," and a.amount_invoice < a.amount_cost and amount_invoice <> amount_recoup"))}
${if(len(type)=0,"",if(type=1,"and (subject not in (257,258,259) or (subject in(257,258,259) and remark_1<>'财务录入'))",if(type=0,"and subject in (257,258,259) and remark_1='财务录入'","")))}
order by a.recorder,a.happenday desc

select act_recoup from finan_activities

select pre_causer,sum(pre_amount) from finan_prepay group by pre_causer

SELECT s.id,s.name,s.parent,sid,pid,concat(pid,"-",sid,"-",name) name FROM `finan_dict_subject` s
join 
(select id aid,sid,pid from(
select a.id,if(b.name is null,a.name,b.name)sid,ifnull(IFNULL(c.name,b.name),a.name)pid from finan_dict_subject a 
left join finan_dict_subject b on a.parent=b.id
left join finan_dict_subject c on b.parent=c.id)s
)sub on s.id=sub.aid 
inner join (select subject from finan_recoup where (status="待审核" OR status="已初审") and recorder='${recorder}')c on c.subject=s.id
GROUP BY S.ID

select * from finan_recoup_invoice
where invadd_causer ='${recorder}' and invadd_status="待审核"

SELECT user_username,if(day(ifnull(change_date,user_entrydate))<=15,concat(year(ifnull(change_date,user_entrydate)),"-",month(ifnull(change_date,user_entrydate)),"-01"),concat(year(date_sub(ifnull(change_date,user_entrydate),interval -1 month)),"-",month(date_sub(ifnull(change_date,user_entrydate),interval -1 month)),"-01"))p_date FROM hr_user
left JOIN hr_dept_tags_change ON change_name = user_username
WHERE (change_department_new = 18 or user_department=18 and change_department_new is null) and user_username="${recorder}"
	

select *,GROUP_CONCAT(hu_user) hu_member,if(house_is_sales=1,"销售","项目组")h_type,concat(house_num,"-",house_type,"-",ifnull(GROUP_CONCAT(hu_user),"无"))name from house_rent_info
left join house_rent_user on house_id=hu_house and date_add(concat(ifnull(hu_enddate,"2999-01"),"-01"),interval 1 month)>curdate()
where ((house_type="办公" and house_region in (select sales_region from hr_salesman where sales_name in ("${C9}","${Z9}") union select pres_region from hr_presales where pres_name IN ("${C9}","${Z9}"))) or (house_type="住房" and house_id in (select hu_house from  house_rent_user where house_id=hu_house and date_add(concat(ifnull(hu_enddate,"2999-01"),"-01"),interval 1 month)>curdate() and hu_user IN ("${C9}","${Z9}")))) and house_status<>"过期"
group by house_id
order by  house_region,h_type,house_type,house_num asc

select sum(amount_recoup-amount_invoice) num,recorder from finan_recoup where recoupdate>="2017-06-01" and status="已报销" and subject not in (277,226,257,258,259,292,304,141)  group by recorder
union 
select -sum(invadd_amount) num,invadd_causer recorder from finan_recoup_invoice
where 1=1 group by invadd_causer

select frsc_id,frsc_name from finan_recoup_subject_category

