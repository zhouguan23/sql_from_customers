select prj_user,concat(prj_user,'(',prj_name,')') name from project_members
 

select team_id,team_name,team_paixu,TEAM_KIND FROM hr_department_team
WHERE team_department=18 and team_verified ='valid'
union 
select 0 team_id,'成本中心' team_name,0 team_paixu,'2' TEAM_KIND
order by FIELD(TEAM_NAME,'资源池'),TEAM_KIND,team_paixu


SELECT level_name FROM `job_level` where level_order_id =10


select "总部" area
union
select if(area_area="京津区","北京组",replace(area_area,"区","组")) area from hr_area

/************************/
select list.*,team_kind
from 
(select i.*,if(i.team_name  REGEXP "未分配",999,if(i.team_name  REGEXP "考核",998,if(i.team_name  REGEXP "资源池",997,if(i.team_name  REGEXP "生产力",98,if(i.team_name  REGEXP "运维",97,if(i.team_name  REGEXP "外包",99,i.team_paixu))))) ) teampai,
if(i.team_name  REGEXP "项目未分配","成本中心",if(i.team_name  REGEXP "项目" or i.team_name  REGEXP "运维" or i.team_name  REGEXP "生产力","利润中心","成本中心") ) kind,n.pro_num,m.team_region,if(nn.prj_team=i.goal_team&&nn.prj_verified='valid',1,0) user_num
from 
(select g.*,CASE
WHEN @rowtotal2 = ifnull(returnbili,0) THEN  
@r2
WHEN @rowtotal2 := ifnull(returnbili,0) THEN
@r2 :=@r2 + 1
WHEN @rowtotal2 = 0 THEN
@r2:=@r2 + 1 
END AS r2 /*验收比例全排名*/
from 
(select e.*,IF(@p1=goal_team,
    CASE 
       WHEN @s1=ifnull(returnbili,0) THEN @rr1
       WHEN @s1:=ifnull(returnbili,0) THEN @rr1:=@rr1+1
       WHEN @s1=0 THEN @rr1:=@rr1+1
      END,
   @rr1:=1 ) AS rank1,
@p1:=goal_team,
@s1:=ifnull(returnbili,0)
from 
(select c.*,CASE  
WHEN @rowtotal1 = ifnull(huikuanbili,0) THEN 
@r1 
WHEN @rowtotal1 := ifnull(huikuanbili,0) THEN 
@r1 :=@r1 + 1 
WHEN @rowtotal1 = 0 THEN 
@r1:=@r1 + 1
END AS r1/*回款比例全排名*/
from 
(select a.*,IF(@p=goal_team,
    CASE 
       WHEN @s=ifnull(huikuanbili,0) THEN @r
       WHEN @s:=ifnull(huikuanbili,0) THEN @r:=@r+1
       WHEN @s=0 THEN @r:=@r+1
      END,
   @r:=1 ) AS rank,
@p:=goal_team,
@s:=ifnull(huikuanbili,0)
from 
(#正常SQL
select main.team_id goal_team,main.team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,aa.goal_amount prj_payment_goal,aa.goal_returnmoney prj_payment_returnmoney,main.amount,main.sspay_amount,if(ifnull(aa.goal_amount,0)=0,0,main.amount/aa.goal_amount) huikuanbili,if(ifnull(aa.goal_returnmoney,0)=0,0,main.goalamount/aa.goal_returnmoney) returnbili
from 
(select if(main.teamid='0',d.team_id,main.teamid) team_id,if(main.teamid='0',d.team_name,main.team) team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount1+main.amount2 amount,ifnull(main.sspay_amount1,0)+ifnull(main.sspay_amount2,0) sspay_amount
from 
(SELECT
									*
								FROM
									(	SELECT

										IF (
											ifnull(team,b.team_name)  REGEXP "生产力" 
											OR ifnull(team,b.team_name) REGEXP "运维" OR ifnull(team,b.team_name) REGEXP "考核通过",
											97,
                   if(ifnull(team,b.team_name)  REGEXP "未分配",
                      98,
											if(ifnull(team,b.team_name)  REGEXP "成本中心",
                       99,
                   if( ifnull(team,b.team_name)  REGEXP "资源池",96, ifnull(paixu,b.team_paixu)))
                   )
										) team_paixu,
										
										prj_id,
										ifnull(id,team_id) teamid,
									ifnull(team,b.team_name) team,
										prj_user,
										prj_name,
                    ifnull(h_job_level,user_level) user_level,
										rentian xishu,
                           round(ifnull(goalamount,0)/10000,2) goalamount,
									IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										(ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0))
									) prj_payment_goal,
		IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										ifnull(returnmoney, 0)*rentian
									) prj_payment_returnmoney,
      round(ifnull(amount1, 0)/10000,2)  amount1,
									     round(ifnull(amount2, 0)/10000,2) amount2,
											 round(ifnull(huikuan1.sspay_amount, 0)/10000,2)  sspay_amount1,
											 round(ifnull(huikuan2.sspay_amount, 0)/10000,2)  sspay_amount2,
									round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									) rate,
               if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)) rate2,
(round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									)+if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)))/2 ratio,
									user_entrydate,
									user_leavedate,
									prj_verified,
									concat(prj_user, "-", prj_name) NAME
								FROM
									project_members
							LEFT JOIN hr_department_team b ON b.team_id = prj_team
								LEFT JOIN (
select user_username,id,team,team_paixu paixu,sum(rentian) rentian from(
									SELECT
										hr_user.user_username,

									IF (
										 user_type <> "实习生" && user_state = "在职" && a.user_username IS NULL && hr_user.user_department <> 18 && hr_user.user_username NOT IN (
											SELECT
												change_name
											FROM
												hr_dept_tags_change
											WHERE
												change_department = 18
											AND YEAR (change_date) >"${year}"
										),
										0,

									IF (
									user_type <> "实习生" && user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(
													if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),change_date_out),
													concat("${year}", "-12-31")
												),
												IFNULL(
													ifnull(
														change_date_in,
														user_transform_date
													),
													user_entrydate
												)
											)+1) / 365,
											2
										),

									IF (
										user_type <> "实习生" &&  user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												ifnull(
												if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),change_date_out)),
													concat("${year}", "-12-31")
												),
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),concat("${year}", "-01-01"))
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" && 	user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(change_date_out,user_leaveDate),
												IFNULL(
													IFNULL(
														change_date_in,
														user_entrydate
													),
													concat("${year}", "-01-01")
												)
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" &&  user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),user_leaveDate),
												concat("${year}", "-01-01")
											)+1) / 365,
											2
										),

									IF (
										user_type = "实习生" && user_state = "在职",
										0.5,

									IF (
										user_type = "实习生" && user_state = "离职",
										0,
										0
									)
									)
									)
									)
									)
									)
									) rentian,a.id,a.team,a.team_paixu
									FROM project_members
LEFT JOIN hr_user ON prj_user = user_username

LEFT JOIN (
SELECT
		user_username,
		'转入' user_status,
		max(change_date) change_date_in,
		NULL change_date_out,prj_team id,team_name team,team_paixu
	FROM
		hr_dept_tags_change
	JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
	WHERE
		user_department = 18 and change_flag <>'invalid' and   (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
and  (select count(1) as num from  hr_user_growhistory B  where B.user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19' and B.user_grow_name = hr_user.user_username) = 0
	GROUP BY
		user_username
union all
select user_grow_name,'转入' user_status,user_grow_stime change_date_in,user_grow_etime change_date_out,
prj_team id,team_name team,team_paixu
 from (select * from hr_user_growhistory
left join hr_user on user_username=user_grow_name where user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19') ab 
left join project_members on user_grow_name = prj_user 
left join hr_department_team  on prj_team=team_id
where  (select count(1) as num from  project_member_fenpei A where A.user = ab.user_grow_name) = 0
	GROUP BY
		user_grow_name
	union all
		SELECT
			user_username,
			'转出' user_status,
			NULL change_date_in,
			change_date change_date_out,prj_team id,team_name team,team_paixu
		FROM
			hr_dept_tags_change
		JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
		WHERE
			change_department = 18 and change_flag <>'invalid' and  (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
union all 
select a.user user_username,'转入' user_status,a.start_date change_date_in, a.end_date change_date_out,a.team_id id,a.team_name team,team_paixu FROM project_member_fenpei a
left join hr_department_team  b on a.team_id=b.team_id
union all 
select name_id,"转入" user_status,concat("${year}",'-01-01') change_date_in,concat("${year}",'-01-01') change_date_out,if(e.user is not null,0,c.prj_team)  id,
if(e.user is not null,"成本中心",f.team_name) team,if(e.user is not null,"0",f.team_paixu) team_paixu
 from project_payment a 
left join project_opportunity1 c on a.keyid =c.key_id 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1") e on a.name_id = e.`user`
left join hr_department_team f on c.prj_team= f.team_id
 join (select GROUP_CONCAT(team_id) tid,user from project_member_fenpei where verified ='1' group by user)  g on a.name_id = g.user  
WHERE YEAR (f_date) ="${year}"  and FIND_IN_SET(if(e.user is not null,0,c.prj_team),g.tid)=0
and (f_number<0 or d.role_user is null)
) AS a ON prj_user = a.user_username where 1=1 )  dd 
group by user_username,id,team	)				rentian ON user_username = prj_user
       LEFT JOIN hr_user ON hr_user.user_username = prj_user
								LEFT JOIN (
									SELECT
										*
									FROM
										project_payment_goal
									WHERE
										goal_year ="${year}" 
								) g ON goal_user = prj_user and goal_team= ifnull(id,team_id) 
								LEFT JOIN (
select sum(amount1)amount1,sum(ifnull(sspay_amount,0)) sspay_amount,name_id,teamm from(
									SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount ,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
												left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=payID
left join sale_payment dd on payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren1" 
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag/*二开*/
union all
SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id  
left join project_members on name_id =prj_user 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1" ) e on a.name_id = e.`user`

			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=a.payID
left join sale_payment dd on a.payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract

									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0  or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren1"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all /*3*/
select ROUND(sum(amount1),2) amount1,sum(ifnull(sspay_amount,0)) sspay_amount ,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount  amount1,amount,(round(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount
,ah.name_id,teamm,ah.payID from (
select ID,payID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate 
from (SELECT ID,payID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c on a.name_id =c.prj_user 
 join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2') a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=ah.payID
left join sale_payment ee on ah.payID=ee.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=ee.pay_contract
) aa group by name_id,teamm) kk  group by name_id,teamm
								) huikuan1 ON huikuan1.name_id = prj_user and huikuan1.teamm= ifnull(id,team_id) 
	LEFT JOIN (
select sum(amount1)amount2,sum(ifnull(sspay_amount,0)) sspay_amount,name_id,teamm from(
									SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount ,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user
																				left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=payID
left join sale_payment dd on payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract 	
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag/*二开*/
union all
SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`

left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=a.payID
left join sale_payment dd on a.payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract

									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all /*3*/
select ROUND(sum(amount1),2) amount1,sum(ifnull(sspay_amount,0)) sspay_amount ,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount,(round(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount
,ah.name_id,teamm from (
select ID,payID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,payID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=ah.payID
left join sale_payment ee on ah.payID=ee.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=ee.pay_contract

) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan2 ON huikuan2.name_id = prj_user and huikuan2.teamm= ifnull(id,team_id) 
left join (select h_username,h_job_level from hr_user_department_history where h_year="${year}" and h_job_level is not null group by h_username) his on hr_user.user_username = his.h_username 
left join project_position_rank base on ifnull(his.h_job_level,user_level) = base.joblevel and year ="${year}" 
left join (select sum(ifnull(xs.xishu,1)*ifnull(cof.coefficient,1)*ifnull(det_paid,0)) goalamount,projectmanager,ppp.prj_team from (select key_id,projectmanager from project_opportunity1 where prj_status in ('运维阶段','项目关闭')) opp
left join project_members ppp on ppp.prj_user=opp.projectmanager 
 join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=key_id and year(history_time)='${year}'
  left join project_inspection_xishu xs on opp.key_id=xs.key_id
left join (select b.coefficient,a.tags_project from 
(select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)a
left join project_coefficient b on a.tags_names = b.tag_id group  by a.tags_project) cof on  opp.key_id=cof.tags_project  
left  join project_contract_link a on opp.key_id=a.ctrlink_key
left join (
select ifnull(SUM(IFNULL(prj_amount, 0) - IFNULL(sumpay_bill, 0) * IFNULL(prj_amount, 0) / ctr_amount),0)*ifnull( f_amount,1)-sum(ifnull(outsource.waibao_amount,0))  det_paid,ctr_id from sale_contract_of_project
LEFT JOIN v_sale_contract_info_valid ctr ON prj_contract = ctr_id
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) sumpay_bill FROM sale_payment WHERE pay_status IN ('记坏账', '已作废') GROUP BY pay_contract ) pay ON pay.pay_contract = ctr.ctr_id
left join (select ctr_id outs_contract,sum(d_outstype_amount) waibao_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id) outsource on outsource.outs_contract = ctr.ctr_id
group by ctr.ctr_id
 ) b  on a.ctrlink_contract = b.ctr_id  GROUP BY opp.projectmanager
 ) shishi on shishi.projectmanager = prj_user and shishi.prj_team= ifnull(id,team_id) 
		WHERE (datediff(ifnull(user_leavedate,concat("${year}", "-12-31")),ifnull(user_entrydate,"2015-01-01")) > 14
										/*AND ifnull(YEAR (user_leavedate),"${year}") >="${year}"*/
AND prj_user NOT IN (SELECT user_username num FROM	hr_dept_tags_change	JOIN hr_user ON change_name = user_username
WHERE change_department = 18 AND YEAR (change_date) <"${year}" AND user_department <> 18 )) OR prj_user IN ("luren", "luren2")or (ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0 or ifnull(rentian,0)<>0) ) list
where teamid<>'' and (ifnull(xishu,0)<>0 or ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)
group by team_paixu,teamid,prj_user,ratio
								ORDER BY
									team_paixu asc,
									teamid asc,
									ratio DESC)main 
left join project_member_fenpei b on b.team_name='成本中心' and b.end_date is null and b.team_id=main.teamid and b.user=main.prj_user
left join project_members c on c.prj_verified='valid' and  c.prj_user=b.user
left join hr_department_team d on d.team_department='18' and  d.team_id=c.prj_team
where if(main.teamid='0',d.team_id,main.teamid) <>''
)main /*系数，职级，净回款，验收实际*/
left join project_payment_goal  aa on aa.goal_year='${year}' and goal_user=main.prj_user  and aa.goal_team=main.team_id

)a,

(SELECT @p:=NULL,@s:=NULL,@r:=0)r
order by goal_team,huikuanbili desc ) c ,(SELECT @r1:=0 ,@rowtotal1 := NULL )d 
order by huikuanbili desc )e,(SELECT @p1:=NULL,@s1:=NULL,@rr1:=0)f
order by goal_team,returnbili desc )g,(SELECT @r2:=0 ,@rowtotal2 := NULL ) h
order by returnbili desc ) i
left join prj_profit_target_team n on i.goal_team=n.pro_team
left join hr_department_team m on m.team_id=i.goal_team
left join project_members nn on nn.prj_user=i.prj_user  
where 1=1
${if(len(team)=0,"","and goal_team in ('"+team+"')")}
${if(len(area)=0,"","and m.team_region in ('"+area+"')")}
${if(len(user)=0,"","and i.prj_user in ('"+user+"')")}
${if((fr_username <>"Maggie" && fr_username <>"tiny"&&fr_username <>"Vivi")||len(level)=0,"","and user_level in ('"+level+"')")}
group by i.prj_user,goal_team
ORDER BY
teampai,xishu desc,user_level desc,i.prj_user)list
left join hr_department_team on team_id=list.goal_team
order by field(list.team_name,'hrbp','服务外包与运营','学习与发展','PMO','财务BP','资源池','项目未分配','考核通过') ,teampai,team_paixu,xishu desc,user_level desc ,prj_user

select date_year from dict_date where date_year between 2020 and year(curdate())+1

select prj_user,
										ifnull(id,team_id) teamid,
									ifnull(team,b.team_name) team,rentian xishu
FROM
									project_members
							LEFT JOIN hr_department_team b ON b.team_id = prj_team
								LEFT JOIN (
select user_username,id,team,team_paixu paixu,sum(rentian) rentian from(
									SELECT
										hr_user.user_username,

									IF (
										 user_type <> "实习生" && user_state = "在职" && a.user_username IS NULL && hr_user.user_department <> 18 && hr_user.user_username NOT IN (
											SELECT
												change_name
											FROM
												hr_dept_tags_change
											WHERE
												change_department = 18
											AND YEAR (change_date) >"${year}"
										),
										0,

									IF (
									user_type <> "实习生" && user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(
													if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),change_date_out),
													concat("${year}", "-12-31")
												),
												IFNULL(
													ifnull(
														change_date_in,
														user_transform_date
													),
													user_entrydate
												)
											)+1) / 365,
											2
										),

									IF (
										user_type <> "实习生" &&  user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												ifnull(
												if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),change_date_out)),
													concat("${year}", "-12-31")
												),
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),concat("${year}", "-01-01"))
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" && 	user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(change_date_out,user_leaveDate),
												IFNULL(
													IFNULL(
														change_date_in,
														user_entrydate
													),
													concat("${year}", "-01-01")
												)
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" &&  user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),user_leaveDate),
												concat("${year}", "-01-01")
											)+1) / 365,
											2
										),

									IF (
										user_type = "实习生" && user_state = "在职",
										0.5,

									IF (
										user_type = "实习生" && user_state = "离职",
										0,
										0
									)
									)
									)
									)
									)
									)
									) rentian,a.id,a.team,a.team_paixu
									FROM project_members
LEFT JOIN hr_user ON prj_user = user_username

LEFT JOIN (
SELECT
		user_username,
		'转入' user_status,
		max(change_date) change_date_in,
		NULL change_date_out,prj_team id,team_name team,team_paixu
	FROM
		hr_dept_tags_change
	JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
	WHERE
		user_department = 18 and change_flag <>'invalid' and   (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
and  (select count(1) as num from  hr_user_growhistory B  where B.user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19' and B.user_grow_name = hr_user.user_username) = 0
	GROUP BY
		user_username
union all
select user_grow_name,'转入' user_status,user_grow_stime change_date_in,user_grow_etime change_date_out,
prj_team id,team_name team,team_paixu
 from (select * from hr_user_growhistory
left join hr_user on user_username=user_grow_name where user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19') ab 
left join project_members on user_grow_name = prj_user 
left join hr_department_team  on prj_team=team_id
where  (select count(1) as num from  project_member_fenpei A where A.user = ab.user_grow_name) = 0
	GROUP BY
		user_grow_name
	union all
		SELECT
			user_username,
			'转出' user_status,
			NULL change_date_in,
			change_date change_date_out,prj_team id,team_name team,team_paixu
		FROM
			hr_dept_tags_change
		JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
		WHERE
			change_department = 18 and change_flag <>'invalid' and  (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
union all 
select a.user user_username,'转入' user_status,a.start_date change_date_in, a.end_date change_date_out,if(a.team_id ='0',c.prj_team,a.team_id)id,if(a.team_name='成本中心',cc.team_name,a.team_name) team,b.team_paixu FROM project_member_fenpei a
left join hr_department_team  b on a.team_id=b.team_id
left join project_members c on c.prj_user=a.user
left join hr_department_team  cc on cc.team_id=c.prj_team
union all 
select name_id,"转入" user_status,concat("${year}",'-01-01') change_date_in,concat("${year}",'-01-01') change_date_out,if(e.user is not null,0,c.prj_team)  id,
if(e.user is not null,"成本中心",f.team_name) team,if(e.user is not null,"0",f.team_paixu) team_paixu
 from project_payment a 
left join project_opportunity1 c on a.keyid =c.key_id 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1") e on a.name_id = e.`user`
left join hr_department_team f on c.prj_team= f.team_id
 join (select GROUP_CONCAT(team_id) tid,user from project_member_fenpei where verified ='1' group by user)  g on a.name_id = g.user  
WHERE YEAR (f_date) ="${year}"  and FIND_IN_SET(if(e.user is not null,0,c.prj_team),g.tid)=0
and (f_number<0 or d.role_user is null)
) AS a ON prj_user = a.user_username where 1=1 )  dd 
group by user_username,id,team	)				rentian ON user_username = prj_user

/************************/
select m.*,n.pro_num
from 
(select i.*,CASE
  
WHEN @rowtotal5 = ifnull(profit,0) THEN
  
@r5
  
WHEN @rowtotal5 := ifnull(profit,0) THEN
  
@r5 :=@r5 + 1
  
WHEN @rowtotal5 = 0 THEN
  
@r5:=@r5 + 1
  
END AS r5
from 
(select e.*,CASE
  
WHEN @rowtotal3 = ifnull(return_bili,0) THEN
  
@r3
  
WHEN @rowtotal3 := ifnull(return_bili,0) THEN
  
@r3 :=@r3 + 1
  
WHEN @rowtotal3 = 0 THEN
  
@r3:=@r3 + 1
  
END AS r3 /*验收比例全排名*/
from 
(select a.*,CASE
  
WHEN @rowtotal1 = ifnull(goal_bili,0) THEN
  
@r1
  
WHEN @rowtotal1 := ifnull(goal_bili,0) THEN
  
@r1 :=@r1 + 1
  
WHEN @rowtotal1 = 0 THEN
  
@r1:=@r1 + 1
  
END AS r1 /*回款比例全排名*/
from 
(
select goal_team,sum(ifnull(f_numer1,0))/sum(ifnull(ssf_num,0)) profit,sum(ifnull(ssf_num,0))/sum(ifnull(goal_amount,0)) goal_bili,sum(ifnull(returnmoney,0))/sum(ifnull(goal_returnmoney,0)) return_bili
from 
(select o.prj_user,ifnull(t.goal_user,o.prj_user) goal_user,o.prj_name,
IFNULL(t.goal_team,O.PRJ_TEAM) GOAL_TEAM,
r.user_level goal_joblevel,num.f_numer1/10000 f_numer1,
ifnull(TT.team_name,s.team_name) team_name,num.ssf_num/10000 ssf_num,t.goal_amount,t.goal_returnmoney,t.goal_coefficient,ifnull(num.user_num,if(t.goal_team=o.prj_team||(o.prj_team in ('1','2','17','29','30','35','40','42','8') and o.prj_verified='valid'),1,0)) user_num,num.returnmoney/10000 returnmoney,ifnull(tt.team_kind,s.team_kind) team_kind,ifnull(tt.team_paixu,s.team_paixu) team_paixu,ifnull(q.team_region,s.team_region) team_region,
IF(IFNULL(num.ssf_num,0)=0,0,num.f_numer1/num.ssf_num) prj_profit,
if(IFNULL(t.goal_returnmoney,0)=0,0,num.returnmoney/10000/t.goal_returnmoney) returnbili,
if(IFNULL(t.goal_amount,0)=0,0,num.ssf_num/10000/t.goal_amount) huikuanbili,o.prj_verified
from 
project_members o 
left join project_payment_goal t on  t.goal_year='${year}' and o.prj_user=t.goal_user  and t.goal_coefficient<>0
left join hr_department_team TT on TT.team_id=T.GOAL_TEAM
left join hr_user r on r.user_username=t.goal_user
left join hr_department_team s on s.team_id=o.prj_team
left join 
(select key_id,e.ctrlink_contract,sum(ifnull(main.pay_paid,0)) pay_paid,sum(ifnull(b.f_numall,0)) f_numall/*分配金额-到人*/,sum(ifnull(c.f_numer1,0)) f_numer1/*分配金额占比（小组）*/,c.name_id/*英文名*/,c.prj_name,d.team_id,d.team_name /*小组*/,sum(round(main.pay_paid*IF(IFNULL(b.f_numall,0)=0,0,c.f_numer1/b.f_numall),2)) ssf_num,f.goal_amount,f.goal_returnmoney,f.goal_coefficient/*人效系数*/,if(c.team_id=g.prj_team,1,0) user_num,
sum(if(prj_status in ("运维阶段","项目关闭"),ifnull(main.ssamount,0)-ifnull(main.prj_amount2,0),0)*IF(IFNULL(f_numall,0)=0,0,c.f_numer1/f_numall)) returnmoney
from 
project_opportunity1 a left  join 
project_contract_link e on e.ctrlink_key=a.key_id left join 
/*1项目-n合同-实施回款-实施金额-实施外包*/
(select ctrlink_key,a.ctrlink_contract,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount,g.prj_amount2,h.pay_paid*sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0))/ctr_amount pay_paid
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM sale_contract_of_project a 
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract/*实施金额*/
left join (SELECT outs_contract,
SUM(IF(d_outs_type = '实施',d_outstype_amount,0)) prj_amount2
FROM  project_contract_link join v_outsource_detail a on  ctrlink_contract = a.d_outs_contract
LEFT JOIN sale_outsource b ON a.d_outs_id = outs_id  
where outs_status!="已作废"
GROUP BY outs_contract ) g on b.ctr_id = g.outs_contract 
left join (select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract  
FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
where year(pay_enddate)='${year}' 
group by pay_contract) h on b.ctr_id = h.pay_contract 
group by a.ctrlink_contract/*,b.ctr_project,a.ctrlink_type*/
) main on main.ctrlink_key=a.key_id

left join (/*每个人分的钱，如果中间转组，按照在两个小组的签到占比计算*/
select a.payID,a.name_id,sum(if(ifnull(c.day_all,0)=0,0,a.f_number*ifnull(b.day_num,0)/c.day_all)) f_numall/*每个人分配的钱*在不同小组签到的天数之比，分到对应的小组*/,a.keyid,b.team_id,b.day_num,c.day_all,a.f_number,d.pay_contract
from 
project_payment a left join 
project_members member on member.prj_user=a.name_id left join 
/*每个人在项目，小组的签到总数*/
(select payID,name_id,f_number,xishu,keyid,c.team_id,count(e.day)*0.5 day_num
from 
project_payment a
left join project_members b on a.name_id =b.prj_user
left join project_member_fenpei c on c.user=a.name_id and (c.end_date>=CONCAT(year(curdate()),'-01','-01') ) and c.verified="1"
left join prj_qiandao_time e on e.user=c.user and e.project=a.keyid and if(c.end_date is null, e.day >= c.start_date,e.day between c.start_date and c.end_date)
 where payID<>'' and f_number<>0 and YEAR (a.f_date)='${year}'/*回款时间是筛选年份*/
 group by payID,name_id,c.team_id
 order by payID
) b on b.payID=a.payID and a.name_id=b.name_id and b.keyid=a.keyid
/*每个人在项目上的签到总数*/
left join (select day_all,key_id projectkey,nameid nameidd
from (select project,count(day)*0.5 day_all,user as nameid from prj_qiandao_time where user_type='1' and `status`='0' and project<>'' group by project,user)c left join project_opportunity1 on c.project=key_id or c.project=prj_number where prj_status<>'无效' group by key_id,nameid) c on c.nameidd=a.name_id and c.projectkey=a.keyid 
/*left join project_opportunity1 opp on opp.key_id=a.keyid*/
left join sale_payment d on a.payID=d.pay_id
WHERE YEAR (a.f_date)='${year}' and  a.name_id in (select user from  project_member_fenpei c where  (c.end_date>=CONCAT(year(curdate()),'-01','-01') ) and c.verified="1")   
group by a.keyid,d.pay_id
union all 
select a.payID,a.name_id,sum(ifnull(a.f_number,0)) f_numall/*每个人分配的钱*在不同小组签到的天数之比，分到对应的小组*/,a.keyid,b.team_id,b.day_num,c.day_all,a.f_number,d.pay_contract
from 
project_payment a left join 
project_members member on member.prj_user=a.name_id left join 
/*每个人在项目，小组的签到总数*/
(select payID,name_id,f_number,xishu,keyid,c.team_id,count(e.day)*0.5 day_num
from 
project_payment a
left join project_members b on a.name_id =b.prj_user
left join project_member_fenpei c on c.user=a.name_id and (c.end_date
  is null ) and c.verified="1"
left join prj_qiandao_time e on e.user=c.user and e.project=a.keyid and if(c.end_date is null, e.day >= c.start_date,e.day between c.start_date and c.end_date)
 where payID<>'' and f_number<>0 and YEAR (a.f_date)='${year}'/*回款时间是筛选年份*/
 group by payID,name_id,c.team_id
 order by payID
) b on b.payID=a.payID and a.name_id=b.name_id and b.keyid=a.keyid
/*每个人在项目上的签到总数*/
left join (select day_all,key_id projectkey,nameid nameidd
from (select project,count(day)*0.5 day_all,user as nameid from prj_qiandao_time where user_type='1' and `status`='0' and project<>'' group by project,user)c left join project_opportunity1 on c.project=key_id or c.project=prj_number where prj_status<>'无效' group by key_id,nameid) c on c.nameidd=a.name_id and c.projectkey=a.keyid 
/*left join project_opportunity1 opp on opp.key_id=a.keyid*/
left join sale_payment d on a.payID=d.pay_id
WHERE YEAR (a.f_date)='${year}' and  a.name_id in (select user from  project_member_fenpei c where (c.end_date is null ) and c.verified="1") and  a.name_id not in (select user from  project_member_fenpei c where  (c.end_date>=CONCAT(year(curdate()),'-01','-01') ) and c.verified="1") 
group by a.keyid,d.pay_id) b on b.pay_contract=main.ctrlink_contract
left join 
(/*小组分配到人，人员属于几组，分配的钱分到几组*/
/*每个人分的钱，如果中间转组，按照在两个小组的签到占比计算*/
select a.payID,a.name_id,if(ifnull(c.day_all,0)=0,0,a.f_number*ifnull(b.day_num,0)/c.day_all) f_numer1/*每个人分配的钱*在不同小组签到的天数之比，分到对应的小组*/,a.keyid,b.team_id,b.day_num,c.day_all,a.f_number,d.pay_contract,member.prj_name
from 
project_payment a left join 
/*每个人在项目，小组的签到总数*/
project_members member on member.prj_user=a.name_id left join 
(select payID,name_id,f_number,xishu,keyid,c.team_id,count(e.day)*0.5 day_num
from 
project_payment a
left join project_members b on a.name_id =b.prj_user
left join project_member_fenpei c on c.user=a.name_id and (c.end_date>=CONCAT(year(curdate()),'-01','-01') ) and c.verified="1"
left join prj_qiandao_time e on e.user=c.user and e.project=a.keyid and if(c.end_date is null, e.day >= c.start_date,e.day between c.start_date and c.end_date)
 where payID<>'' and f_number<>0 and YEAR (a.f_date)='${year}' and b.prj_team !='2'/*回款时间是筛选年份*/
 group by payID,name_id,c.team_id
 order by payID
) b on b.payID=a.payID and a.name_id=b.name_id and b.keyid=a.keyid
/*每个人在项目上的签到总数*/
left join (select day_all,key_id projectkey,nameid nameidd
from (select project,count(day)*0.5 day_all,user as nameid from prj_qiandao_time where user_type='1' and `status`='0' and project<>'' group by project,user)c left join project_opportunity1 on c.project=key_id or c.project=prj_number where prj_status<>'无效' group by key_id,nameid) c on c.nameidd=a.name_id and c.projectkey=a.keyid 
/*left join project_opportunity1 opp on opp.key_id=a.keyid*/
left join sale_payment d on a.payID=d.pay_id
WHERE YEAR (a.f_date)='${year}'  and a.f_number<>0 and a.f_number<>'' and member.prj_team !='2' and a.name_id in (select user from  project_member_fenpei c where  (c.end_date>=CONCAT(year(curdate()),'-01','-01') ) and c.verified="1") 
group by a.name_id,b.team_id,payID
union all 
/*小组分配到人，人员属于几组，分配的钱分到几组*/
/*每个人分的钱，如果中间转组，按照在两个小组的签到占比计算*/
select a.payID,a.name_id,a.f_number f_numer1/*每个人分配的钱*在不同小组签到的天数之比，分到对应的小组*/,a.keyid,b.team_id,b.day_num,c.day_all,a.f_number,d.pay_contract,member.prj_name
from 
project_payment a left join 
/*每个人在项目，小组的签到总数*/
project_members member on member.prj_user=a.name_id left join 
(select payID,name_id,f_number,xishu,keyid,c.team_id,count(e.day)*0.5 day_num
from 
project_payment a
left join project_members b on a.name_id =b.prj_user
left join project_member_fenpei c on c.user=a.name_id and (c.end_date
  is null ) and c.verified="1"
left join prj_qiandao_time e on e.user=c.user and e.project=a.keyid and if(c.end_date is null, e.day >= c.start_date,e.day between c.start_date and c.end_date)
 where payID<>'' and f_number<>0 and YEAR (a.f_date)='${year}' and b.prj_team !='2'/*回款时间是筛选年份*/
 group by payID,name_id,c.team_id
 order by payID
) b on b.payID=a.payID and a.name_id=b.name_id and b.keyid=a.keyid
/*每个人在项目上的签到总数*/
left join (select day_all,key_id projectkey,nameid nameidd
from (select project,count(day)*0.5 day_all,user as nameid from prj_qiandao_time where user_type='1' and `status`='0' and project<>'' group by project,user)c left join project_opportunity1 on c.project=key_id or c.project=prj_number where prj_status<>'无效' group by key_id,nameid) c on c.nameidd=a.name_id and c.projectkey=a.keyid 
/*left join project_opportunity1 opp on opp.key_id=a.keyid*/
left join sale_payment d on a.payID=d.pay_id
WHERE YEAR (a.f_date)='${year}'  and a.f_number<>0 and a.f_number<>'' and member.prj_team !='2' and a.name_id in (select user from  project_member_fenpei c where  (c.end_date is null ) and c.verified="1") and  a.name_id not in (select user from  project_member_fenpei c where  (c.end_date>=CONCAT(year(curdate()),'-01','-01') ) and c.verified="1")
group by a.name_id,b.team_id,payID
)c on  c.payID=b.payID
left join project_members g on g.prj_user=c.name_id
left join hr_department_team d on d.team_id=c.team_id
left join project_payment_goal f on f.goal_user=c.name_id and f.goal_team=c.team_id and f.goal_year='${year}'
where f_numall<>0
group by c.name_id,d.team_id
) num on t.goal_user =num.name_id and t.goal_team=num.team_id
left join hr_department_team q on q.team_id=num.team_id 
where ifnull(q.team_verified,s.team_verified)='valid'
order by goal_team,huikuanbili desc
)aaaaa
group by goal_team
order by return_bili desc
)a,(SELECT @r1:=0,@rowtotal1 := NULL ) d  
order by goal_bili desc )e,(SELECT @r3:=0,@rowtotal3 := NULL ) h
order by return_bili desc ) i,(SELECT @r5:=0 ,@rowtotal5 := NULL)l
order by profit desc)m
left join prj_profit_target_team n on m.goal_team=n.pro_team
group by goal_team

select a.*,CASE
  
WHEN @rowtotal1 = ifnull(profit,0) THEN
  
@r1
  
WHEN @rowtotal1 := ifnull(profit,0) THEN
  
@r1 :=@r1 + 1
  
WHEN @rowtotal1 = 0 THEN
  
@r1:=@r1 + 1
  
END AS r1 
from 
(select prj_fenlei,prj_name,num as profit,mubiaonum as '目标值',fenzi,fenmu,team_kind 
from
(select prj_fenlei,prj_name,ifnull(num,0) num,ifnull(fenzi,0) fenzi,ifnull(fenmu,0) fenmu,a.pro_num as mubiaonum,team_kind
from
(select a.prj_team prj_fenlei,
g.team_name prj_name,g.team_kind,
sum((ifnull(sspayback,0)-ifnull(ssoutspaid,0)-ifnull(chengben,0)-ifnull(pro_day_outspay,0)-ifnull(amount,0)))/sum((ifnull(sspayback,0)-ifnull(amount,0))) num,
sum((ifnull(sspayback,0)-ifnull(ssoutspaid,0)-ifnull(chengben,0)-ifnull(pro_day_outspay,0)-ifnull(amount,0))) fenzi,sum((ifnull(sspayback,0)-ifnull(amount,0))) fenmu
from project_opportunity1 a 
left join cust_company b on a.customer_id = b.com_id
left join hr_department_team g on a.prj_team = g.team_id
left join project_region_unitprice m on m.price_year =year(now()) and m.price_jidu =QUARTER(curdate()) and m.price_province=prj_province
left join (select pro_project,sum(ifnull(pro_day_outspay,0)) pro_day_outspay  from project_sln_info left join fr_t_system1 on pro_key=jira_keys  where pro_project<>'' and year(accept_time)=year(curdate()) group by pro_project
) sln  on pro_project=key_id /*二开成本取当年*/
left join (select a.*,ifnull(dayamount,0) chengben/*人天*人天单价*回款率*/,cc.key_id as keyidd
from 
project_opportunity1 cc left join 
(select ctrlink_key,prj_status2,prj_finishdate2,prj_province,sum(amount) amount,sum(ctramount) ctramount,sum(ssamount) ssamount,sum(sspayback) sspayback,sum(outs_amount) outs_amount, sum(prj_amount2) prj_amount2, sum(pay_paid) pay_paid,sum(outspaid) outspaid,sum(ssoutspaid) ssoutspaid
from
(select ctrlink_key,prj_status prj_status2,prj_finishdate prj_finishdate2,a.ctrlink_contract,(ifnull(finan.amount,0)*(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0))/((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1))) amount,/*商务费用按合同*/prj_province,
((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)) ctramount,/*合同金额*/ 
(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)) ssamount,/*实施金额*/
ifnull(h.pay_paid,0)*(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0))/((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)) sspayback,/*实施回款*/
ifnull(outs_amount,0) outs_amount,/*外包金额*/
ifnull(g.prj_amount2,0) prj_amount2,/*实施外包*/
ifnull(h.pay_paid,0) pay_paid,/*回款*/
ifnull(outspaid,0) outspaid/*外包付款*/,
ifnull(outspaid,0)*ifnull(g.prj_amount2,0)/ifnull(outs_amount,0) ssoutspaid/*实施外包付款*//*成本原价*/
from project_opportunity1 left join 
project_contract_link a on a.ctrlink_key=key_id

left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select ctr_id ctrid,sum(ifnull(amount,0)) amount  from finan_expense a
join finan_outsource_payment b on pay_expense=a.id
join sale_contract_info on ctr_project=pay_contract where year(happenday)= year(now()) group by ctr_id) finan on ctrid=b.ctr_id
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废')  
and year(pay_enddate)=year(curdate())
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract 
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract

left join (
SELECT ctrlink_key c_key,sum(ctr_amount)-sum(ifnull(sumpay_bill,0)) sum_paid
from v_sale_contract_info_valid
join project_contract_link on ctr_id=ctrlink_contract
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment where pay_status in('记坏账','已作废') and year(pay_enddate)=year(curdate())   group by pay_contract)pay /*签单额=合同金额-记坏账-已作废*/
on pay.pay_contract=ctr_id 
GROUP BY ctrlink_key
)sum_pay on c_key=key_id
left join (select sum(ifnull(outspay_amount,0)) outs_amount,outs_contract FROM  project_contract_link 
join sale_outsource on ctrlink_contract = outs_contract 
join sale_outsource_payment on outs_id = outspay_outsource 
where outspay_status not like '%作废'
 group by outs_contract
) e on b.ctr_id =e.outs_contract
left join (SELECT outs_contract,
SUM(IF(d_outs_type = '实施',d_outstype_amount,0)) prj_amount2,
SUM(ifnull(outspay_paid,0)) outspaid
FROM  project_contract_link join v_outsource_detail a on  ctrlink_contract = a.d_outs_contract
LEFT JOIN sale_outsource b ON a.d_outs_id = outs_id  
LEFT JOIN (select SUM(ifnull(outspay_paid,0)) outspay_paid,outspay_outsource from sale_outsource_payment 
where 1=1  and year(outspay_paydate)=year(curdate())
group by outspay_outsource) e ON b.outs_id=e.outspay_outsource 
where outs_status!="已作废"
GROUP BY outs_contract ) g on b.ctr_id = g.outs_contract 
left join (select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract  
FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
where 1=1  and year(pay_enddate)=year(curdate()) 
group by pay_contract) h on b.ctr_id = h.pay_contract 
where prj_status<>'无效' 
group by a.ctrlink_contract
/*having  (prj_finishdate2 is null or prj_finishdate2>='2020-01-01') or (ctramount-pay_paid>0 and prj_finishdate2 is not null)*/
) aa 
group by ctrlink_key )a on a.ctrlink_key=cc.key_id
left join (select a.project,sum(ifnull(a.days,0)*m.price_amount) dayamount
from 
(select sum(if(`day` between c_startdate and c_enddate,0.5*c_value,0.5)) days,a.key_id as project,a.prj_province,year(day) yy,QUARTER(day) qq
from project_opportunity1 a 
join prj_qiandao_time c on (a.key_id = c.project or a.prj_number=c.project) and user_type='1' and status ='0' and (out_type = 0 or out_type = 16 ) 
and year(day)=year(curdate())
left join project_out_coefficient on c_username=c.`user`
group by a.key_id,year(day),QUARTER(day)
 )a
left join project_region_unitprice m on m.price_year =a.yy and m.price_jidu =a.qq and m.price_province=a.prj_province
group by project)p on p.project=cc.key_id) amount on amount.keyidd=key_id
where prj_status<>'无效' /*and ((prj_finishdate is null or prj_finishdate>='2020-01-01') or (ctramount-ifnull(pay_paid,0)>0 and prj_finishdate is not null))*/
group by a.prj_team
order by a.prj_team )main 
left join prj_profit_target_team a on a.pro_team=main.prj_fenlei
left join prj_profit_target_area b on b.profit_area=main.prj_fenlei
where  prj_fenlei <>'英文区' and prj_fenlei <>'台湾' and prj_fenlei <>'日本' and prj_fenlei <>'韩国' and prj_fenlei<>'2'
order by num desc
)a
where team_kind='1'
order  by num desc)a,(SELECT @r1:=0,@rowtotal1 := NULL ) d 
order by profit desc

/************************/
select e.*,CASE
WHEN @ss = ifnull(returnbili,0) THEN  
@s
WHEN @ss := ifnull(returnbili,0) THEN
@s :=@s + 1
WHEN @ss = 0 THEN
@s:=@s + 1 
END AS s
from 
(select a.*,CASE
WHEN @row = ifnull(huikuanbili,0) THEN  
@rr
WHEN @row := ifnull(huikuanbili,0) THEN
@rr :=@rr + 1
WHEN @row = 0 THEN
@rr:=@rr + 1 
END AS rr
from 
(select goal_team,sum(ifnull(goalamount,0)) goalamount,sum(ifnull(i.prj_payment_goal,0)) prj_payment_goal ,sum(ifnull(prj_payment_returnmoney,0)) prj_payment_returnmoney,sum(ifnull(amount,0)) amount,
if(sum(ifnull(i.prj_payment_goal,0))=0,0,sum(ifnull(amount,0))/sum(ifnull(i.prj_payment_goal,0))) huikuanbili,
if(sum(ifnull(prj_payment_returnmoney,0))=0,0,sum(ifnull(goalamount,0))/sum(ifnull(prj_payment_returnmoney,0))) returnbili
from 
(select g.*,CASE
WHEN @rowtotal2 = ifnull(returnbili,0) THEN  
@r2
WHEN @rowtotal2 := ifnull(returnbili,0) THEN
@r2 :=@r2 + 1
WHEN @rowtotal2 = 0 THEN
@r2:=@r2 + 1 
END AS r2 /*验收比例全排名*/
from 
(select e.*,IF(@p1=goal_team,
    CASE 
       WHEN @s1=ifnull(returnbili,0) THEN @rr1
       WHEN @s1:=ifnull(returnbili,0) THEN @rr1:=@rr1+1
       WHEN @s1=0 THEN @rr1:=@rr1+1
      END,
   @rr1:=1 ) AS rank1,
@p1:=goal_team,
@s1:=ifnull(returnbili,0)
from 
(select c.*,CASE  
WHEN @rowtotal1 = ifnull(huikuanbili,0) THEN 
@r1 
WHEN @rowtotal1 := ifnull(huikuanbili,0) THEN 
@r1 :=@r1 + 1 
WHEN @rowtotal1 = 0 THEN 
@r1:=@r1 + 1
END AS r1/*回款比例全排名*/
from 
(select a.*,IF(@p=goal_team,
    CASE 
       WHEN @s=ifnull(huikuanbili,0) THEN @r
       WHEN @s:=ifnull(huikuanbili,0) THEN @r:=@r+1
       WHEN @s=0 THEN @r:=@r+1
      END,
   @r:=1 ) AS rank,
@p:=goal_team,
@s:=ifnull(huikuanbili,0)
from 
(#正常SQL
select main.team_id goal_team,main.team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount,if(ifnull(main.prj_payment_goal,0)=0,0,main.amount/main.prj_payment_goal) huikuanbili,if(ifnull(main.prj_payment_returnmoney,0)=0,0,main.goalamount/main.prj_payment_returnmoney) returnbili
from 
(select if(main.teamid='0',d.team_id,main.teamid) team_id,if(main.teamid='0',d.team_name,main.team) team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount1+main.amount2 amount
from 
(SELECT
									*
								FROM
									(	SELECT

										IF (
											ifnull(team,b.team_name)  REGEXP "生产力" 
											OR ifnull(team,b.team_name) REGEXP "运维" OR ifnull(team,b.team_name) REGEXP "考核通过",
											97,
                   if(ifnull(team,b.team_name)  REGEXP "未分配",
                      98,
											if(ifnull(team,b.team_name)  REGEXP "成本中心",
                       99,
                     ifnull(paixu,b.team_paixu))
                   )
										) team_paixu,
										
										prj_id,
										ifnull(id,team_id) teamid,
									ifnull(team,b.team_name) team,
										prj_user,
										prj_name,
                    ifnull(h_job_level,user_level) user_level,
										rentian xishu,
                           round(ifnull(goalamount,0)*rentian/10000,2) goalamount,
									IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										(ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0))
									) prj_payment_goal,
		IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										ifnull(returnmoney, 0)*rentian
									) prj_payment_returnmoney,
      round(ifnull(amount1, 0)/10000,2)  amount1,
									     round(ifnull(amount2, 0)/10000,2) amount2,round(ifnull(amount3, 0)/10000,2)  amount3,
									round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									) rate,
               if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)) rate2,
(round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									)+if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)))/2 ratio,
									user_entrydate,
									user_leavedate,
									prj_verified,
									concat(prj_user, "-", prj_name) NAME
								FROM
									project_members
							LEFT JOIN hr_department_team b ON b.team_id = prj_team
								LEFT JOIN (
select user_username,id,team,team_paixu paixu,sum(rentian) rentian from(
									SELECT
										hr_user.user_username,

									IF (
										 user_type <> "实习生" && user_state = "在职" && a.user_username IS NULL && hr_user.user_department <> 18 && hr_user.user_username NOT IN (
											SELECT
												change_name
											FROM
												hr_dept_tags_change
											WHERE
												change_department = 18
											AND YEAR (change_date) >"${year}"
										),
										0,

									IF (
									user_type <> "实习生" && user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(
													if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),change_date_out),
													concat("${year}", "-12-31")
												),
												IFNULL(
													ifnull(
														change_date_in,
														user_transform_date
													),
													user_entrydate
												)
											)+1) / 365,
											2
										),

									IF (
										user_type <> "实习生" &&  user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												ifnull(
												if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),change_date_out)),
													concat("${year}", "-12-31")
												),
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),concat("${year}", "-01-01"))
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" && 	user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(change_date_out,user_leaveDate),
												IFNULL(
													IFNULL(
														change_date_in,
														user_entrydate
													),
													concat("${year}", "-01-01")
												)
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" &&  user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),user_leaveDate),
												concat("${year}", "-01-01")
											)+1) / 365,
											2
										),

									IF (
										user_type = "实习生" && user_state = "在职",
										0.5,

									IF (
										user_type = "实习生" && user_state = "离职",
										0,
										0
									)
									)
									)
									)
									)
									)
									) rentian,a.id,a.team,a.team_paixu
									FROM project_members
LEFT JOIN hr_user ON prj_user = user_username

LEFT JOIN (
SELECT
		user_username,
		'转入' user_status,
		max(change_date) change_date_in,
		NULL change_date_out,prj_team id,team_name team,team_paixu
	FROM
		hr_dept_tags_change
	JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
	WHERE
		user_department = 18 and change_flag <>'invalid' and   (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
and  (select count(1) as num from  hr_user_growhistory B  where B.user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19' and B.user_grow_name = hr_user.user_username) = 0
	GROUP BY
		user_username
union all
select user_grow_name,'转入' user_status,user_grow_stime change_date_in,user_grow_etime change_date_out,
prj_team id,team_name team,team_paixu
 from (select * from hr_user_growhistory
left join hr_user on user_username=user_grow_name where user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19') ab 
left join project_members on user_grow_name = prj_user 
left join hr_department_team  on prj_team=team_id
where  (select count(1) as num from  project_member_fenpei A where A.user = ab.user_grow_name) = 0
	GROUP BY
		user_grow_name
	union all
		SELECT
			user_username,
			'转出' user_status,
			NULL change_date_in,
			change_date change_date_out,prj_team id,team_name team,team_paixu
		FROM
			hr_dept_tags_change
		JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
		WHERE
			change_department = 18 and change_flag <>'invalid' and  (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
union all 
select a.user user_username,'转入' user_status,a.start_date change_date_in, a.end_date change_date_out,a.team_id id,a.team_name team,team_paixu FROM project_member_fenpei a
left join hr_department_team  b on a.team_id=b.team_id
union all 
select name_id,"转入" user_status,concat("${year}",'-01-01') change_date_in,concat("${year}",'-01-01') change_date_out,if(e.user is not null,0,c.prj_team)  id,
if(e.user is not null,"成本中心",f.team_name) team,if(e.user is not null,"0",f.team_paixu) team_paixu
 from project_payment a 
left join project_opportunity1 c on a.keyid =c.key_id 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1") e on a.name_id = e.`user`
left join hr_department_team f on c.prj_team= f.team_id
 join (select GROUP_CONCAT(team_id) tid,user from project_member_fenpei where verified ='1' group by user)  g on a.name_id = g.user  
WHERE YEAR (f_date) ="${year}"  and FIND_IN_SET(if(e.user is not null,0,c.prj_team),g.tid)=0
and (f_number<0 or d.role_user is null)
) AS a ON prj_user = a.user_username where 1=1 )  dd 
group by user_username,id,team	)				rentian ON user_username = prj_user
       LEFT JOIN hr_user ON hr_user.user_username = prj_user
								LEFT JOIN (
									SELECT
										*
									FROM
										project_payment_goal
									WHERE
										goal_year ="${year}" 
								) g ON goal_user = prj_user and goal_team= ifnull(id,team_id) 
								LEFT JOIN (
select sum(amount1)amount1,name_id,teamm from(
									SELECT
										sum(f_number) amount1,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren1" 
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag
union all
SELECT
										sum(f_number) amount1,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id  
left join project_members on name_id =prj_user 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1" ) e on a.name_id = e.`user`
									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0  or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren1"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all 
select ROUND(sum(amount1),2) amount1,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount  amount1,amount
,ah.name_id,teamm from (
select ID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
 join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2') a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
) aa group by name_id,teamm) kk  group by name_id,teamm
								) huikuan1 ON huikuan1.name_id = prj_user and huikuan1.teamm= ifnull(id,team_id) 
	LEFT JOIN (
select sum(amount1)amount2,name_id,teamm from(
									SELECT
										sum(f_number) amount1,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag
union all
SELECT
										sum(f_number) amount1,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`
									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all 
select ROUND(sum(amount1),2) amount1,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount
,ah.name_id,teamm from (
select ID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan2 ON huikuan2.name_id = prj_user and huikuan2.teamm= ifnull(id,team_id) 
LEFT JOIN (
select sum(amount1)amount3,name_id,teamm from(
									SELECT
										sum(f_number) amount1,
										name_id,prj_team teamm
									FROM
									(select * from project_payment where keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y') ) project_payment
                  left join project_members on name_id =prj_user 
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag
union all
SELECT
										sum(f_number) amount1,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
									(select * from project_payment where keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y') ) a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`
									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all 
select ROUND(sum(amount1),2) amount1,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount
,ah.name_id,teamm from (
select ID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' and keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y')) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2'  and keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y')) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan3 ON huikuan3.name_id = prj_user and huikuan3.teamm= ifnull(id,team_id) 

left join (select h_username,h_job_level from hr_user_department_history where h_year="${year}" and h_job_level is not null group by h_username) his on hr_user.user_username = his.h_username 
left join project_position_rank base on ifnull(his.h_job_level,user_level) = base.joblevel and year ="${year}" 
left join (select sum(ifnull(xs.xishu,1)*ifnull(cof.coefficient,1)*ifnull(det_paid,0)) goalamount,projectmanager from (select key_id,projectmanager from project_opportunity1 where prj_status in ('运维阶段','项目关闭')) opp
 join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=key_id and year(history_time)='${year}'
  left join project_inspection_xishu xs on opp.key_id=xs.key_id
left join (select b.coefficient,a.tags_project from 
(select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)a
left join project_coefficient b on a.tags_names = b.tag_id group  by a.tags_project) cof on  opp.key_id=cof.tags_project  
left  join project_contract_link a on opp.key_id=a.ctrlink_key
left join (
select ifnull(SUM(IFNULL(prj_amount, 0) - IFNULL(sumpay_bill, 0) * IFNULL(prj_amount, 0) / ctr_amount),0)*ifnull( f_amount,1)-sum(ifnull(outsource.waibao_amount,0))  det_paid,ctr_id from sale_contract_of_project
LEFT JOIN v_sale_contract_info_valid ctr ON prj_contract = ctr_id
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) sumpay_bill FROM sale_payment WHERE pay_status IN ('记坏账', '已作废') GROUP BY pay_contract ) pay ON pay.pay_contract = ctr.ctr_id
left join (select ctr_id outs_contract,sum(d_outstype_amount) waibao_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id) outsource on outsource.outs_contract = ctr.ctr_id
group by ctr.ctr_id
 ) b  on a.ctrlink_contract = b.ctr_id  GROUP BY opp.projectmanager
 ) shishi on shishi.projectmanager = prj_user
								WHERE
									(
										 datediff(
											ifnull(
												user_leavedate,
												concat("${year}", "-12-31")
											),
											ifnull(
												user_entrydate,
												"2015-01-01"
											)
										) > 14
										/*AND ifnull(
											YEAR (user_leavedate),
											"${year}"
										) >="${year}"*/
										AND prj_user NOT IN (
											SELECT
												user_username num
											FROM
												hr_dept_tags_change
											JOIN hr_user ON change_name = user_username
											WHERE
												change_department = 18
											AND YEAR (change_date) <"${year}"
											AND user_department <> 18
										)
									)
								OR prj_user IN ("luren", "luren2")
									) list
                                   where teamid<>'' and (ifnull(xishu,0)<>0 or ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)
group by team_paixu,teamid,prj_user,ratio
								ORDER BY
									team_paixu asc,
									teamid asc,
									ratio DESC)main 
left join project_member_fenpei b on b.team_name='成本中心' and b.end_date is null and b.team_id=main.teamid and b.user=main.prj_user
left join project_members c on c.prj_verified='valid' and  c.prj_user=b.user
left join hr_department_team d on d.team_department='18' and  d.team_id=c.prj_team
where if(main.teamid='0',d.team_id,main.teamid) <>''
)main /*系数，职级，净回款，验收实际*/


)a,

(SELECT @p:=NULL,@s:=NULL,@r:=0)r
order by goal_team,huikuanbili desc ) c ,(SELECT @r1:=0 ,@rowtotal1 := NULL )d 
order by huikuanbili desc )e,(SELECT @p1:=NULL,@s1:=NULL,@rr1:=0)f
order by goal_team,returnbili desc )g,(SELECT @r2:=0 ,@rowtotal2 := NULL ) h
order by returnbili desc ) i
left join prj_profit_target_team n on i.goal_team=n.pro_team
left join hr_department_team m on m.team_id=i.goal_team
left join project_members nn on nn.prj_user=i.prj_user  

group by goal_team
)a,(SELECT @rr:=0 ,@row := NULL )d order by huikuanbili desc )e,(SELECT @s:=0 ,@ss := NULL )f order by returnbili desc

select profit_num from  prj_profit_target_area b where profit_area='sumall' and profit_year='${year}'

select team_id,team_name,if(i.team_name  REGEXP "项目未分配","成本中心",if(i.team_name  REGEXP "项目" or i.team_name  REGEXP "运维" or i.team_name  REGEXP "生产力","利润中心","成本中心") ) kind
from hr_department_team i where team_department='18' and team_verified='valid'
order by team_kind,team_paixu

/************************/
select i.*
from 
(select e.*,CASE
WHEN @rowtotal2 = ifnull(returnbili,0) THEN  
@r2
WHEN @rowtotal2 := ifnull(returnbili,0) THEN
@r2 :=@r2 + 1
WHEN @rowtotal2 = 0 THEN
@r2:=@r2 + 1 
END AS r2 /*验收比例全排名*/
from 
(select a.*,CASE  
WHEN @rowtotal1 = ifnull(huikuanbili,0) THEN 
@r1 
WHEN @rowtotal1 := ifnull(huikuanbili,0) THEN 
@r1 :=@r1 + 1 
WHEN @rowtotal1 = 0 THEN 
@r1:=@r1 + 1
END AS r1/*回款比例全排名*/
from 
(#正常SQL
select main.prj_user,
if(sum(ifnull(aa.goal_amount,0))=0,0,sum(ifnull(main.amount,0))/sum(ifnull(aa.goal_amount,0))) huikuanbili,
if(sum(ifnull(aa.goal_returnmoney,0))=0,0,sum(ifnull(main.goalamount,0))/sum(ifnull(aa.goal_returnmoney,0))) returnbili
from 
(select if(main.teamid='0',d.team_id,main.teamid) team_id,if(main.teamid='0',d.team_name,main.team) team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount1+main.amount2 amount,ifnull(main.sspay_amount1,0)+ifnull(main.sspay_amount2,0) sspay_amount
from 
(SELECT
									*
								FROM
									(	SELECT

										IF (
											ifnull(team,b.team_name)  REGEXP "生产力" 
											OR ifnull(team,b.team_name) REGEXP "运维" OR ifnull(team,b.team_name) REGEXP "考核通过",
											97,
                   if(ifnull(team,b.team_name)  REGEXP "未分配",
                      98,
											if(ifnull(team,b.team_name)  REGEXP "成本中心",
                       99,
                   if( ifnull(team,b.team_name)  REGEXP "资源池",96, ifnull(paixu,b.team_paixu)))
                   )
										) team_paixu,
										
										prj_id,
										ifnull(id,team_id) teamid,
									ifnull(team,b.team_name) team,
										prj_user,
										prj_name,
                    ifnull(h_job_level,user_level) user_level,
										rentian xishu,
                           round(ifnull(goalamount,0)/10000,2) goalamount,
									IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										(ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0))
									) prj_payment_goal,
		IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										ifnull(returnmoney, 0)*rentian
									) prj_payment_returnmoney,
      round(ifnull(amount1, 0)/10000,2)  amount1,
									     round(ifnull(amount2, 0)/10000,2) amount2,
											 round(ifnull(huikuan1.sspay_amount, 0)/10000,2)  sspay_amount1,
											 round(ifnull(huikuan2.sspay_amount, 0)/10000,2)  sspay_amount2,
									round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									) rate,
               if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)) rate2,
(round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									)+if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)))/2 ratio,
									user_entrydate,
									user_leavedate,
									prj_verified,
									concat(prj_user, "-", prj_name) NAME
								FROM
									project_members
							LEFT JOIN hr_department_team b ON b.team_id = prj_team
								LEFT JOIN (
select user_username,id,team,team_paixu paixu,sum(rentian) rentian from(
									SELECT
										hr_user.user_username,

									IF (
										 user_type <> "实习生" && user_state = "在职" && a.user_username IS NULL && hr_user.user_department <> 18 && hr_user.user_username NOT IN (
											SELECT
												change_name
											FROM
												hr_dept_tags_change
											WHERE
												change_department = 18
											AND YEAR (change_date) >"${year}"
										),
										0,

									IF (
									user_type <> "实习生" && user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(
													if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),change_date_out),
													concat("${year}", "-12-31")
												),
												IFNULL(
													ifnull(
														change_date_in,
														user_transform_date
													),
													user_entrydate
												)
											)+1) / 365,
											2
										),

									IF (
										user_type <> "实习生" &&  user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												ifnull(
												if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),change_date_out)),
													concat("${year}", "-12-31")
												),
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),concat("${year}", "-01-01"))
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" && 	user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(change_date_out,user_leaveDate),
												IFNULL(
													IFNULL(
														change_date_in,
														user_entrydate
													),
													concat("${year}", "-01-01")
												)
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" &&  user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),user_leaveDate),
												concat("${year}", "-01-01")
											)+1) / 365,
											2
										),

									IF (
										user_type = "实习生" && user_state = "在职",
										0.5,

									IF (
										user_type = "实习生" && user_state = "离职",
										0,
										0
									)
									)
									)
									)
									)
									)
									) rentian,a.id,a.team,a.team_paixu
									FROM project_members
LEFT JOIN hr_user ON prj_user = user_username

LEFT JOIN (
SELECT
		user_username,
		'转入' user_status,
		max(change_date) change_date_in,
		NULL change_date_out,prj_team id,team_name team,team_paixu
	FROM
		hr_dept_tags_change
	JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
	WHERE
		user_department = 18 and change_flag <>'invalid' and   (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
and  (select count(1) as num from  hr_user_growhistory B  where B.user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19' and B.user_grow_name = hr_user.user_username) = 0
	GROUP BY
		user_username
union all
select user_grow_name,'转入' user_status,user_grow_stime change_date_in,user_grow_etime change_date_out,
prj_team id,team_name team,team_paixu
 from (select * from hr_user_growhistory
left join hr_user on user_username=user_grow_name where user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19') ab 
left join project_members on user_grow_name = prj_user 
left join hr_department_team  on prj_team=team_id
where  (select count(1) as num from  project_member_fenpei A where A.user = ab.user_grow_name) = 0
	GROUP BY
		user_grow_name
	union all
		SELECT
			user_username,
			'转出' user_status,
			NULL change_date_in,
			change_date change_date_out,prj_team id,team_name team,team_paixu
		FROM
			hr_dept_tags_change
		JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
		WHERE
			change_department = 18 and change_flag <>'invalid' and  (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
union all 
select a.user user_username,'转入' user_status,a.start_date change_date_in, a.end_date change_date_out,a.team_id id,a.team_name team,team_paixu FROM project_member_fenpei a
left join hr_department_team  b on a.team_id=b.team_id
union all 
select name_id,"转入" user_status,concat("${year}",'-01-01') change_date_in,concat("${year}",'-01-01') change_date_out,if(e.user is not null,0,c.prj_team)  id,
if(e.user is not null,"成本中心",f.team_name) team,if(e.user is not null,"0",f.team_paixu) team_paixu
 from project_payment a 
left join project_opportunity1 c on a.keyid =c.key_id 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1") e on a.name_id = e.`user`
left join hr_department_team f on c.prj_team= f.team_id
 join (select GROUP_CONCAT(team_id) tid,user from project_member_fenpei where verified ='1' group by user)  g on a.name_id = g.user  
WHERE YEAR (f_date) ="${year}"  and FIND_IN_SET(if(e.user is not null,0,c.prj_team),g.tid)=0
and (f_number<0 or d.role_user is null)
) AS a ON prj_user = a.user_username where 1=1 )  dd 
group by user_username,id,team	)				rentian ON user_username = prj_user
       LEFT JOIN hr_user ON hr_user.user_username = prj_user
								LEFT JOIN (
									SELECT
										*
									FROM
										project_payment_goal
									WHERE
										goal_year ="${year}" 
								) g ON goal_user = prj_user and goal_team= ifnull(id,team_id) 
								LEFT JOIN (
select sum(amount1)amount1,sum(ifnull(sspay_amount,0)) sspay_amount,name_id,teamm from(
									SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount ,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
												left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=payID
left join sale_payment dd on payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren1" 
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag/*二开*/
union all
SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id  
left join project_members on name_id =prj_user 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1" ) e on a.name_id = e.`user`

			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=a.payID
left join sale_payment dd on a.payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract

									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0  or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren1"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all /*3*/
select ROUND(sum(amount1),2) amount1,sum(ifnull(sspay_amount,0)) sspay_amount ,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount  amount1,amount,(round(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount
,ah.name_id,teamm,ah.payID from (
select ID,payID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate 
from (SELECT ID,payID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c on a.name_id =c.prj_user 
 join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2') a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=ah.payID
left join sale_payment ee on ah.payID=ee.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=ee.pay_contract
) aa group by name_id,teamm) kk  group by name_id,teamm
								) huikuan1 ON huikuan1.name_id = prj_user and huikuan1.teamm= ifnull(id,team_id) 
	LEFT JOIN (
select sum(amount1)amount2,sum(ifnull(sspay_amount,0)) sspay_amount,name_id,teamm from(
									SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount ,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user
																				left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=payID
left join sale_payment dd on payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract 	
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag/*二开*/
union all
SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`

left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=a.payID
left join sale_payment dd on a.payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract

									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all /*3*/
select ROUND(sum(amount1),2) amount1,sum(ifnull(sspay_amount,0)) sspay_amount ,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount,(round(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount
,ah.name_id,teamm from (
select ID,payID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,payID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=ah.payID
left join sale_payment ee on ah.payID=ee.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=ee.pay_contract

) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan2 ON huikuan2.name_id = prj_user and huikuan2.teamm= ifnull(id,team_id) 
left join (select h_username,h_job_level from hr_user_department_history where h_year="${year}" and h_job_level is not null group by h_username) his on hr_user.user_username = his.h_username 
left join project_position_rank base on ifnull(his.h_job_level,user_level) = base.joblevel and year ="${year}" 
left join (select sum(ifnull(xs.xishu,1)*ifnull(cof.coefficient,1)*ifnull(det_paid,0)) goalamount,projectmanager from (select key_id,projectmanager from project_opportunity1 where prj_status in ('运维阶段','项目关闭')) opp
 join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=key_id and year(history_time)='${year}'
  left join project_inspection_xishu xs on opp.key_id=xs.key_id
left join (select b.coefficient,a.tags_project from 
(select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)a
left join project_coefficient b on a.tags_names = b.tag_id group  by a.tags_project) cof on  opp.key_id=cof.tags_project  
left  join project_contract_link a on opp.key_id=a.ctrlink_key
left join (
select ifnull(SUM(IFNULL(prj_amount, 0) - IFNULL(sumpay_bill, 0) * IFNULL(prj_amount, 0) / ctr_amount),0)*ifnull( f_amount,1)-sum(ifnull(outsource.waibao_amount,0))  det_paid,ctr_id from sale_contract_of_project
LEFT JOIN v_sale_contract_info_valid ctr ON prj_contract = ctr_id
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) sumpay_bill FROM sale_payment WHERE pay_status IN ('记坏账', '已作废') GROUP BY pay_contract ) pay ON pay.pay_contract = ctr.ctr_id
left join (select ctr_id outs_contract,sum(d_outstype_amount) waibao_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id) outsource on outsource.outs_contract = ctr.ctr_id
group by ctr.ctr_id
 ) b  on a.ctrlink_contract = b.ctr_id  GROUP BY opp.projectmanager
 ) shishi on shishi.projectmanager = prj_user
								WHERE
									(
										 datediff(
											ifnull(
												user_leavedate,
												concat("${year}", "-12-31")
											),
											ifnull(
												user_entrydate,
												"2015-01-01"
											)
										) > 14
										/*AND ifnull(
											YEAR (user_leavedate),
											"${year}"
										) >="${year}"*/
										AND prj_user NOT IN (
											SELECT
												user_username num
											FROM
												hr_dept_tags_change
											JOIN hr_user ON change_name = user_username
											WHERE
												change_department = 18
											AND YEAR (change_date) <"${year}"
											AND user_department <> 18
										)
									)
								OR prj_user IN ("luren", "luren2")
									or (ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)) list
                                   where teamid<>'' and (ifnull(xishu,0)<>0 or ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)
group by team_paixu,teamid,prj_user,ratio
								ORDER BY
									team_paixu asc,
									teamid asc,
									ratio DESC)main 
left join project_member_fenpei b on b.team_name='成本中心' and b.end_date is null and b.team_id=main.teamid and b.user=main.prj_user
left join project_members c on c.prj_verified='valid' and  c.prj_user=b.user
left join hr_department_team d on d.team_department='18' and  d.team_id=c.prj_team
where if(main.teamid='0',d.team_id,main.teamid) <>''
)main /*系数，职级，净回款，验收实际*/
left join project_payment_goal  aa on aa.goal_year='${year}' and goal_user=main.prj_user  and aa.goal_team=main.team_id
group by prj_user
)a,(SELECT @r1:=0 ,@rowtotal1 := NULL )d 
order by huikuanbili desc )e,(SELECT @r2:=0 ,@rowtotal2 := NULL ) h
order by returnbili desc ) i
group by i.prj_user


/************************/
select i.*
from 
(select a.*,CASE  
WHEN @rowtotal1 = ifnull(huikuanbili,0) THEN 
@r1 
WHEN @rowtotal1 := ifnull(huikuanbili,0) THEN 
@r1 :=@r1 + 1 
WHEN @rowtotal1 = 0 THEN 
@r1:=@r1 + 1
END AS r1/*回款比例全排名*/
from 
(#正常SQL
select main.prj_user,
if(sum(ifnull(aa.goal_amount,0))=0,0,sum(ifnull(main.amount,0))/sum(ifnull(aa.goal_amount,0)))*'${xishu1}'+
if(sum(ifnull(aa.goal_returnmoney,0))=0,0,sum(ifnull(main.goalamount,0))/sum(ifnull(aa.goal_returnmoney,0)))*'${xishu3}' huikuanbili
from 
(select if(main.teamid='0',d.team_id,main.teamid) team_id,if(main.teamid='0',d.team_name,main.team) team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount1+main.amount2 amount,ifnull(main.sspay_amount1,0)+ifnull(main.sspay_amount2,0) sspay_amount
from 
(SELECT
									*
								FROM
									(	SELECT

										IF (
											ifnull(team,b.team_name)  REGEXP "生产力" 
											OR ifnull(team,b.team_name) REGEXP "运维" OR ifnull(team,b.team_name) REGEXP "考核通过",
											97,
                   if(ifnull(team,b.team_name)  REGEXP "未分配",
                      98,
											if(ifnull(team,b.team_name)  REGEXP "成本中心",
                       99,
                   if( ifnull(team,b.team_name)  REGEXP "资源池",96, ifnull(paixu,b.team_paixu)))
                   )
										) team_paixu,
										
										prj_id,
										ifnull(id,team_id) teamid,
									ifnull(team,b.team_name) team,
										prj_user,
										prj_name,
                    ifnull(h_job_level,user_level) user_level,
										rentian xishu,
                           round(ifnull(goalamount,0)/10000,2) goalamount,
									IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										(ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0))
									) prj_payment_goal,
		IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										ifnull(returnmoney, 0)*rentian
									) prj_payment_returnmoney,
      round(ifnull(amount1, 0)/10000,2)  amount1,
									     round(ifnull(amount2, 0)/10000,2) amount2,
											 round(ifnull(huikuan1.sspay_amount, 0)/10000,2)  sspay_amount1,
											 round(ifnull(huikuan2.sspay_amount, 0)/10000,2)  sspay_amount2,
									round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									) rate,
               if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)) rate2,
(round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									)+if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)))/2 ratio,
									user_entrydate,
									user_leavedate,
									prj_verified,
									concat(prj_user, "-", prj_name) NAME
								FROM
									project_members
							LEFT JOIN hr_department_team b ON b.team_id = prj_team
								LEFT JOIN (
select user_username,id,team,team_paixu paixu,sum(rentian) rentian from(
									SELECT
										hr_user.user_username,

									IF (
										 user_type <> "实习生" && user_state = "在职" && a.user_username IS NULL && hr_user.user_department <> 18 && hr_user.user_username NOT IN (
											SELECT
												change_name
											FROM
												hr_dept_tags_change
											WHERE
												change_department = 18
											AND YEAR (change_date) >"${year}"
										),
										0,

									IF (
									user_type <> "实习生" && user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(
													if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),change_date_out),
													concat("${year}", "-12-31")
												),
												IFNULL(
													ifnull(
														change_date_in,
														user_transform_date
													),
													user_entrydate
												)
											)+1) / 365,
											2
										),

									IF (
										user_type <> "实习生" &&  user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												ifnull(
												if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),change_date_out)),
													concat("${year}", "-12-31")
												),
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),concat("${year}", "-01-01"))
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" && 	user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(change_date_out,user_leaveDate),
												IFNULL(
													IFNULL(
														change_date_in,
														user_entrydate
													),
													concat("${year}", "-01-01")
												)
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" &&  user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),user_leaveDate),
												concat("${year}", "-01-01")
											)+1) / 365,
											2
										),

									IF (
										user_type = "实习生" && user_state = "在职",
										0.5,

									IF (
										user_type = "实习生" && user_state = "离职",
										0,
										0
									)
									)
									)
									)
									)
									)
									) rentian,a.id,a.team,a.team_paixu
									FROM project_members
LEFT JOIN hr_user ON prj_user = user_username

LEFT JOIN (
SELECT
		user_username,
		'转入' user_status,
		max(change_date) change_date_in,
		NULL change_date_out,prj_team id,team_name team,team_paixu
	FROM
		hr_dept_tags_change
	JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
	WHERE
		user_department = 18 and change_flag <>'invalid' and   (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
and  (select count(1) as num from  hr_user_growhistory B  where B.user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19' and B.user_grow_name = hr_user.user_username) = 0
	GROUP BY
		user_username
union all
select user_grow_name,'转入' user_status,user_grow_stime change_date_in,user_grow_etime change_date_out,
prj_team id,team_name team,team_paixu
 from (select * from hr_user_growhistory
left join hr_user on user_username=user_grow_name where user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19') ab 
left join project_members on user_grow_name = prj_user 
left join hr_department_team  on prj_team=team_id
where  (select count(1) as num from  project_member_fenpei A where A.user = ab.user_grow_name) = 0
	GROUP BY
		user_grow_name
	union all
		SELECT
			user_username,
			'转出' user_status,
			NULL change_date_in,
			change_date change_date_out,prj_team id,team_name team,team_paixu
		FROM
			hr_dept_tags_change
		JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
		WHERE
			change_department = 18 and change_flag <>'invalid' and  (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
union all 
select a.user user_username,'转入' user_status,a.start_date change_date_in, a.end_date change_date_out,a.team_id id,a.team_name team,team_paixu FROM project_member_fenpei a
left join hr_department_team  b on a.team_id=b.team_id
union all 
select name_id,"转入" user_status,concat("${year}",'-01-01') change_date_in,concat("${year}",'-01-01') change_date_out,if(e.user is not null,0,c.prj_team)  id,
if(e.user is not null,"成本中心",f.team_name) team,if(e.user is not null,"0",f.team_paixu) team_paixu
 from project_payment a 
left join project_opportunity1 c on a.keyid =c.key_id 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1") e on a.name_id = e.`user`
left join hr_department_team f on c.prj_team= f.team_id
 join (select GROUP_CONCAT(team_id) tid,user from project_member_fenpei where verified ='1' group by user)  g on a.name_id = g.user  
WHERE YEAR (f_date) ="${year}"  and FIND_IN_SET(if(e.user is not null,0,c.prj_team),g.tid)=0
and (f_number<0 or d.role_user is null)
) AS a ON prj_user = a.user_username where 1=1 )  dd 
group by user_username,id,team	)				rentian ON user_username = prj_user
       LEFT JOIN hr_user ON hr_user.user_username = prj_user
								LEFT JOIN (
									SELECT
										*
									FROM
										project_payment_goal
									WHERE
										goal_year ="${year}" 
								) g ON goal_user = prj_user and goal_team= ifnull(id,team_id) 
								LEFT JOIN (
select sum(amount1)amount1,sum(ifnull(sspay_amount,0)) sspay_amount,name_id,teamm from(
									SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount ,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
												left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=payID
left join sale_payment dd on payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren1" 
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag/*二开*/
union all
SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id  
left join project_members on name_id =prj_user 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1" ) e on a.name_id = e.`user`

			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=a.payID
left join sale_payment dd on a.payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract

									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0  or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren1"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all /*3*/
select ROUND(sum(amount1),2) amount1,sum(ifnull(sspay_amount,0)) sspay_amount ,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount  amount1,amount,(round(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount
,ah.name_id,teamm,ah.payID from (
select ID,payID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate 
from (SELECT ID,payID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c on a.name_id =c.prj_user 
 join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2') a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=ah.payID
left join sale_payment ee on ah.payID=ee.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=ee.pay_contract
) aa group by name_id,teamm) kk  group by name_id,teamm
								) huikuan1 ON huikuan1.name_id = prj_user and huikuan1.teamm= ifnull(id,team_id) 
	LEFT JOIN (
select sum(amount1)amount2,sum(ifnull(sspay_amount,0)) sspay_amount,name_id,teamm from(
									SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount ,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user
																				left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=payID
left join sale_payment dd on payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract 	
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag/*二开*/
union all
SELECT
										sum(f_number) amount1,sum(round(f_number/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`

left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=a.payID
left join sale_payment dd on a.payID=dd.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=dd.pay_contract

									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all /*3*/
select ROUND(sum(amount1),2) amount1,sum(ifnull(sspay_amount,0)) sspay_amount ,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount,(round(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount/number*ssamount/ctramount*ifnull(pay_paid,0),2)) sspay_amount
,ah.name_id,teamm from (
select ID,payID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,payID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
			left join (select payID as payall,sum(ifnull(f_number,0)) number from project_payment group by payID) bb on bb.payall=ah.payID
left join sale_payment ee on ah.payID=ee.pay_id
left join (select a.ctrlink_contract,b.ctr_id,
round(sum((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)),2) ctramount,
round(sum(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)),2) ssamount
from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废') 
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract
group by ctrlink_contract) cc on cc.ctrlink_contract=ee.pay_contract

) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan2 ON huikuan2.name_id = prj_user and huikuan2.teamm= ifnull(id,team_id) 
left join (select h_username,h_job_level from hr_user_department_history where h_year="${year}" and h_job_level is not null group by h_username) his on hr_user.user_username = his.h_username 
left join project_position_rank base on ifnull(his.h_job_level,user_level) = base.joblevel and year ="${year}" 
left join (select sum(ifnull(xs.xishu,1)*ifnull(cof.coefficient,1)*ifnull(det_paid,0)) goalamount,projectmanager from (select key_id,projectmanager from project_opportunity1 where prj_status in ('运维阶段','项目关闭')) opp
 join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=key_id and year(history_time)='${year}'
  left join project_inspection_xishu xs on opp.key_id=xs.key_id
left join (select b.coefficient,a.tags_project from 
(select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)a
left join project_coefficient b on a.tags_names = b.tag_id group  by a.tags_project) cof on  opp.key_id=cof.tags_project  
left  join project_contract_link a on opp.key_id=a.ctrlink_key
left join (
select ifnull(SUM(IFNULL(prj_amount, 0) - IFNULL(sumpay_bill, 0) * IFNULL(prj_amount, 0) / ctr_amount),0)*ifnull( f_amount,1)-sum(ifnull(outsource.waibao_amount,0))  det_paid,ctr_id from sale_contract_of_project
LEFT JOIN v_sale_contract_info_valid ctr ON prj_contract = ctr_id
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) sumpay_bill FROM sale_payment WHERE pay_status IN ('记坏账', '已作废') GROUP BY pay_contract ) pay ON pay.pay_contract = ctr.ctr_id
left join (select ctr_id outs_contract,sum(d_outstype_amount) waibao_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id) outsource on outsource.outs_contract = ctr.ctr_id
group by ctr.ctr_id
 ) b  on a.ctrlink_contract = b.ctr_id  GROUP BY opp.projectmanager
 ) shishi on shishi.projectmanager = prj_user
								WHERE
									(
										 datediff(
											ifnull(
												user_leavedate,
												concat("${year}", "-12-31")
											),
											ifnull(
												user_entrydate,
												"2015-01-01"
											)
										) > 14
										/*AND ifnull(
											YEAR (user_leavedate),
											"${year}"
										) >="${year}"*/
										AND prj_user NOT IN (
											SELECT
												user_username num
											FROM
												hr_dept_tags_change
											JOIN hr_user ON change_name = user_username
											WHERE
												change_department = 18
											AND YEAR (change_date) <"${year}"
											AND user_department <> 18
										)
									)
								OR prj_user IN ("luren", "luren2")
									or (ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)) list
                                   where teamid<>'' and (ifnull(xishu,0)<>0 or ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)
group by team_paixu,teamid,prj_user,ratio
								ORDER BY
									team_paixu asc,
									teamid asc,
									ratio DESC)main 
left join project_member_fenpei b on b.team_name='成本中心' and b.end_date is null and b.team_id=main.teamid and b.user=main.prj_user
left join project_members c on c.prj_verified='valid' and  c.prj_user=b.user
left join hr_department_team d on d.team_department='18' and  d.team_id=c.prj_team
where if(main.teamid='0',d.team_id,main.teamid) <>''
)main /*系数，职级，净回款，验收实际*/
left join project_payment_goal  aa on aa.goal_year='${year}' and goal_user=main.prj_user  and aa.goal_team=main.team_id
group by prj_user
)a,(SELECT @r1:=0 ,@rowtotal1 := NULL )d 
order by huikuanbili desc )i
group by i.prj_user


/************************/
select c.*,CASE
WHEN @row= ifnull(returnbili,0) THEN  
@rr
WHEN @row := ifnull(returnbili,0) THEN
@rr :=@rr + 1
WHEN @row = 0 THEN
@rr:=@rr + 1 
END AS r
from 
(select a.goal_team,b.profit,ifnull(a.huikuanbili,0)*'${xishu1}'+ifnull(a.returnbili,0)*'${xishu3}'+ifnull(b.profit,0)*'${xishu2}' returnbili
from 
(select goal_team,sum(ifnull(goalamount,0)) goalamount,sum(ifnull(i.prj_payment_goal,0)) prj_payment_goal ,sum(ifnull(prj_payment_returnmoney,0)) prj_payment_returnmoney,sum(ifnull(amount,0)) amount,
if(sum(ifnull(i.prj_payment_goal,0))=0,0,sum(ifnull(amount,0))/sum(ifnull(i.prj_payment_goal,0))) huikuanbili,
if(sum(ifnull(prj_payment_returnmoney,0))=0,0,sum(ifnull(goalamount,0))/sum(ifnull(prj_payment_returnmoney,0))) returnbili
from 
(select g.*,CASE
WHEN @rowtotal2 = ifnull(returnbili,0) THEN  
@r2
WHEN @rowtotal2 := ifnull(returnbili,0) THEN
@r2 :=@r2 + 1
WHEN @rowtotal2 = 0 THEN
@r2:=@r2 + 1 
END AS r2 /*验收比例全排名*/
from 
(select e.*,IF(@p1=goal_team,
    CASE 
       WHEN @s1=ifnull(returnbili,0) THEN @rr1
       WHEN @s1:=ifnull(returnbili,0) THEN @rr1:=@rr1+1
       WHEN @s1=0 THEN @rr1:=@rr1+1
      END,
   @rr1:=1 ) AS rank1,
@p1:=goal_team,
@s1:=ifnull(returnbili,0)
from 
(select c.*,CASE  
WHEN @rowtotal1 = ifnull(huikuanbili,0) THEN 
@r1 
WHEN @rowtotal1 := ifnull(huikuanbili,0) THEN 
@r1 :=@r1 + 1 
WHEN @rowtotal1 = 0 THEN 
@r1:=@r1 + 1
END AS r1/*回款比例全排名*/
from 
(select a.*,IF(@p=goal_team,
    CASE 
       WHEN @s=ifnull(huikuanbili,0) THEN @r
       WHEN @s:=ifnull(huikuanbili,0) THEN @r:=@r+1
       WHEN @s=0 THEN @r:=@r+1
      END,
   @r:=1 ) AS rank,
@p:=goal_team,
@s:=ifnull(huikuanbili,0)
from 
(#正常SQL
select main.team_id goal_team,main.team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount,if(ifnull(main.prj_payment_goal,0)=0,0,main.amount/main.prj_payment_goal) huikuanbili,if(ifnull(main.prj_payment_returnmoney,0)=0,0,main.goalamount/main.prj_payment_returnmoney) returnbili
from 
(select if(main.teamid='0',d.team_id,main.teamid) team_id,if(main.teamid='0',d.team_name,main.team) team_name,main.team_paixu,main.prj_user,main.prj_name,main.user_level,main.xishu,main.goalamount,main.prj_payment_goal,main.prj_payment_returnmoney,main.amount1+main.amount2 amount
from 
(SELECT
									*
								FROM
									(	SELECT

										IF (
											ifnull(team,b.team_name)  REGEXP "生产力" 
											OR ifnull(team,b.team_name) REGEXP "运维" OR ifnull(team,b.team_name) REGEXP "考核通过",
											97,
                   if(ifnull(team,b.team_name)  REGEXP "未分配",
                      98,
											if(ifnull(team,b.team_name)  REGEXP "成本中心",
                       99,
                     ifnull(paixu,b.team_paixu))
                   )
										) team_paixu,
										
										prj_id,
										ifnull(id,team_id) teamid,
									ifnull(team,b.team_name) team,
										prj_user,
										prj_name,
                    ifnull(h_job_level,user_level) user_level,
										rentian xishu,
                           round(ifnull(goalamount,0)/10000,2) goalamount,
									IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										(ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0))
									) prj_payment_goal,
		IF (
										ifnull(team,b.team_name) NOT REGEXP "项目"
										OR ifnull(team,b.team_name) NOT REGEXP "组",
										0,
										ifnull(returnmoney, 0)*rentian
									) prj_payment_returnmoney,
      round(ifnull(amount1, 0)/10000,2)  amount1,
									     round(ifnull(amount2, 0)/10000,2) amount2,round(ifnull(amount3, 0)/10000,2)  amount3,
									round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									) rate,
               if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)) rate2,
(round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									  (ifnull(amount1, 0)+ifnull(amount2, 0)) 
										) / (ifnull(base.payment, 0)*rentian+ifnull(goal_adjust, 0)) / 10000,
										4
									)+if(isnull(returnmoney),"",round(

										IF (
											ifnull(team,b.team_name) NOT REGEXP "项目"
											OR ifnull(team,b.team_name) NOT REGEXP "组",
											0,
									   ifnull(goalamount, 0) 
										) / (returnmoney) / 10000,
										4
									)))/2 ratio,
									user_entrydate,
									user_leavedate,
									prj_verified,
									concat(prj_user, "-", prj_name) NAME
								FROM
									project_members
							LEFT JOIN hr_department_team b ON b.team_id = prj_team
								LEFT JOIN (
select user_username,id,team,team_paixu paixu,sum(rentian) rentian from(
									SELECT
										hr_user.user_username,

									IF (
										 user_type <> "实习生" && user_state = "在职" && a.user_username IS NULL && hr_user.user_department <> 18 && hr_user.user_username NOT IN (
											SELECT
												change_name
											FROM
												hr_dept_tags_change
											WHERE
												change_department = 18
											AND YEAR (change_date) >"${year}"
										),
										0,

									IF (
									user_type <> "实习生" && user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(
													if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),change_date_out),
													concat("${year}", "-12-31")
												),
												IFNULL(
													ifnull(
														change_date_in,
														user_transform_date
													),
													user_entrydate
												)
											)+1) / 365,
											2
										),

									IF (
										user_type <> "实习生" &&  user_state = "在职" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												ifnull(
												if(year(change_date_out)>"${year}",concat("${year}", "-12-31"),if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),change_date_out)),
													concat("${year}", "-12-31")
												),
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),concat("${year}", "-01-01"))
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" && 	user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) ="${year}",
										round(
											(DATEDIFF(
												ifnull(change_date_out,user_leaveDate),
												IFNULL(
													IFNULL(
														change_date_in,
														user_entrydate
													),
													concat("${year}", "-01-01")
												)
											)+1) / 365,
											2
										),

									IF (
									user_type <> "实习生" &&  user_state = "离职" && YEAR (user_leaveDate) ="${year}" && YEAR (
											IFNULL(
												ifnull(
													change_date_in,
													user_transform_date
												),
												user_entrydate
											)
										) <"${year}",
										round(
											(DATEDIFF(
												if(year(change_date_out)<"${year}",concat("${year}", "-01-01"),user_leaveDate),
												concat("${year}", "-01-01")
											)+1) / 365,
											2
										),

									IF (
										user_type = "实习生" && user_state = "在职",
										0.5,

									IF (
										user_type = "实习生" && user_state = "离职",
										0,
										0
									)
									)
									)
									)
									)
									)
									) rentian,a.id,a.team,a.team_paixu
									FROM project_members
LEFT JOIN hr_user ON prj_user = user_username

LEFT JOIN (
SELECT
		user_username,
		'转入' user_status,
		max(change_date) change_date_in,
		NULL change_date_out,prj_team id,team_name team,team_paixu
	FROM
		hr_dept_tags_change
	JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
	WHERE
		user_department = 18 and change_flag <>'invalid' and   (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
and  (select count(1) as num from  hr_user_growhistory B  where B.user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19' and B.user_grow_name = hr_user.user_username) = 0
	GROUP BY
		user_username
union all
select user_grow_name,'转入' user_status,user_grow_stime change_date_in,user_grow_etime change_date_out,
prj_team id,team_name team,team_paixu
 from (select * from hr_user_growhistory
left join hr_user on user_username=user_grow_name where user_grow_kind  in ('定向','非定向')
and user_group_shoutuo='19') ab 
left join project_members on user_grow_name = prj_user 
left join hr_department_team  on prj_team=team_id
where  (select count(1) as num from  project_member_fenpei A where A.user = ab.user_grow_name) = 0
	GROUP BY
		user_grow_name
	union all
		SELECT
			user_username,
			'转出' user_status,
			NULL change_date_in,
			change_date change_date_out,prj_team id,team_name team,team_paixu
		FROM
			hr_dept_tags_change
		JOIN hr_user ON change_name = user_username
left join project_members on change_name = prj_user 
left join hr_department_team  on prj_team=team_id
		WHERE
			change_department = 18 and change_flag <>'invalid' and  (select count(1) as num from  project_member_fenpei A where A.user = hr_user.user_username) = 0
union all 
select a.user user_username,'转入' user_status,a.start_date change_date_in, a.end_date change_date_out,a.team_id id,a.team_name team,team_paixu FROM project_member_fenpei a
left join hr_department_team  b on a.team_id=b.team_id
union all 
select name_id,"转入" user_status,concat("${year}",'-01-01') change_date_in,concat("${year}",'-01-01') change_date_out,if(e.user is not null,0,c.prj_team)  id,
if(e.user is not null,"成本中心",f.team_name) team,if(e.user is not null,"0",f.team_paixu) team_paixu
 from project_payment a 
left join project_opportunity1 c on a.keyid =c.key_id 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1") e on a.name_id = e.`user`
left join hr_department_team f on c.prj_team= f.team_id
 join (select GROUP_CONCAT(team_id) tid,user from project_member_fenpei where verified ='1' group by user)  g on a.name_id = g.user  
WHERE YEAR (f_date) ="${year}"  and FIND_IN_SET(if(e.user is not null,0,c.prj_team),g.tid)=0
and (f_number<0 or d.role_user is null)
) AS a ON prj_user = a.user_username where 1=1 )  dd 
group by user_username,id,team	)				rentian ON user_username = prj_user
       LEFT JOIN hr_user ON hr_user.user_username = prj_user
								LEFT JOIN (
									SELECT
										*
									FROM
										project_payment_goal
									WHERE
										goal_year ="${year}" 
								) g ON goal_user = prj_user and goal_team= ifnull(id,team_id) 
								LEFT JOIN (
select sum(amount1)amount1,name_id,teamm from(
									SELECT
										sum(f_number) amount1,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren1" 
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag
union all
SELECT
										sum(f_number) amount1,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id  
left join project_members on name_id =prj_user 
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1" ) e on a.name_id = e.`user`
									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0  or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren1"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all 
select ROUND(sum(amount1),2) amount1,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount  amount1,amount
,ah.name_id,teamm from (
select ID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
 join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren1" and f_number>0 and prj_team !='2') a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
) aa group by name_id,teamm) kk  group by name_id,teamm
								) huikuan1 ON huikuan1.name_id = prj_user and huikuan1.teamm= ifnull(id,team_id) 
	LEFT JOIN (
select sum(amount1)amount2,name_id,teamm from(
									SELECT
										sum(f_number) amount1,
										name_id,prj_team teamm
									FROM
										project_payment 
                  left join project_members on name_id =prj_user 
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag
union all
SELECT
										sum(f_number) amount1,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
										project_payment a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`
									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all 
select ROUND(sum(amount1),2) amount1,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount
,ah.name_id,teamm from (
select ID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' ) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan2 ON huikuan2.name_id = prj_user and huikuan2.teamm= ifnull(id,team_id) 
LEFT JOIN (
select sum(amount1)amount3,name_id,teamm from(
									SELECT
										sum(f_number) amount1,
										name_id,prj_team teamm
									FROM
									(select * from project_payment where keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y') ) project_payment
                  left join project_members on name_id =prj_user 
									WHERE
										YEAR (f_date) ="${year}" and f_number<>0
									AND tag = "luren2"  
									AND  ((select count(1) as num from  project_member_fenpei A where A.user = project_payment.name_id and A.verified="1"  ) = 0 || (payID LIKE 'SLN%' and prj_team ='2'))
									GROUP BY
										name_id,prj_team,
										YEAR (f_date),
										tag
union all
SELECT
										sum(f_number) amount1,
										name_id,if(e.user is not null,"0",c.prj_team)  teamm
									FROM
									(select * from project_payment where keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y') ) a
                  left join project_opportunity1 c on a.keyid =c.key_id 
left join project_members on name_id =prj_user
left join (SELECT project,user role_user  FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id
left join (select DISTINCT user from project_member_fenpei where team_id="0" and verified="1"  ) e on a.name_id = e.`user`
									WHERE
										YEAR (f_date) ="${year}"  and name_id in (select user from project_member_fenpei where verified="1"  ) 
and (f_number<0 or d.role_user is null)  and project_members.prj_team !='2' 
									AND tag = "luren2"  
									GROUP BY
										name_id,teamm,
										YEAR (f_date),
										tag
                 union all 
select ROUND(sum(amount1),2) amount1,name_id,teamm from (
select  start_date,ifnull(end_date,f_enddate),f_startdate,f_enddate,if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))/dd.total*amount amount1,amount
,ah.name_id,teamm from (
select ID,amount,name_id,ifnull(b.team_id,c.prj_team) teamm,b.start_date,b.end_date,f_startdate,f_enddate from (SELECT ID,f_number amount,name_id,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2' and keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y')) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user`
left join project_members c
on a.name_id =c.prj_user 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) d on d.project = a.keyid and d.`role_user` = a.name_id ) ah
 left join (
select name_id,a.ID,SUM(if(ifnull(end_date,f_enddate)<=f_enddate && start_date<=f_startdate && ifnull(end_date,f_enddate)>start_date&&f_startdate<=ifnull(end_date,f_enddate),if(ifnull(end_date,f_enddate)=f_startdate,1,DATEDIFF(ifnull(end_date,f_enddate),f_startdate))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)<=f_enddate&& ifnull(end_date,f_enddate)>start_date,if(ifnull(end_date,f_enddate)=start_date,1,DATEDIFF( ifnull(end_date,f_enddate),start_date))
,if(start_date>=f_startdate && ifnull(end_date,f_enddate)>=f_enddate && start_date <= f_enddate&& ifnull(end_date,f_enddate)>start_date,if(f_enddate=start_date,1,DATEDIFF( f_enddate,start_date))
,if( ifnull(end_date,f_enddate)>=f_enddate &&start_date<=f_startdate&& ifnull(end_date,f_enddate)>start_date,if(end_date=start_date,1,DATEDIFF( end_date,start_date)),0 ) )))) total
 from (SELECT name_id,ID,keyid FROM project_payment
left join project_members on name_id =prj_user
WHERE YEAR (f_date) ="${year}" AND tag = "luren2" and f_number>0  and prj_team !='2'  and keyid in (select distinct app_project from sale_outsource_apply where app_performance ='Y')) a
 join (select * from project_member_fenpei where verified="1"  ) b
on a.name_id =b.`user` 
join (SELECT project,user role_user,min(day) f_startdate,max(day) f_enddate FROM prj_qiandao_time
group by project,user) c on c.project = a.keyid and c.`role_user` = a.name_id 
group by name_id,ID) dd on dd.name_id =ah.name_id and dd.ID =ah.ID 
) aa group by name_id,teamm) kk 
group by name_id,teamm
								) huikuan3 ON huikuan3.name_id = prj_user and huikuan3.teamm= ifnull(id,team_id) 

left join (select h_username,h_job_level from hr_user_department_history where h_year="${year}" and h_job_level is not null group by h_username) his on hr_user.user_username = his.h_username 
left join project_position_rank base on ifnull(his.h_job_level,user_level) = base.joblevel and year ="${year}" 
left join (select sum(ifnull(xs.xishu,1)*ifnull(cof.coefficient,1)*ifnull(det_paid,0)) goalamount,projectmanager from (select key_id,projectmanager from project_opportunity1 where prj_status in ('运维阶段','项目关闭')) opp
 join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=key_id and year(history_time)='${year}'
  left join project_inspection_xishu xs on opp.key_id=xs.key_id
left join (select b.coefficient,a.tags_project from 
(select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)a
left join project_coefficient b on a.tags_names = b.tag_id group  by a.tags_project) cof on  opp.key_id=cof.tags_project  
left  join project_contract_link a on opp.key_id=a.ctrlink_key
left join (
select ifnull(SUM(IFNULL(prj_amount, 0) - IFNULL(sumpay_bill, 0) * IFNULL(prj_amount, 0) / ctr_amount),0)*ifnull( f_amount,1)-sum(ifnull(outsource.waibao_amount,0))  det_paid,ctr_id from sale_contract_of_project
LEFT JOIN v_sale_contract_info_valid ctr ON prj_contract = ctr_id
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) sumpay_bill FROM sale_payment WHERE pay_status IN ('记坏账', '已作废') GROUP BY pay_contract ) pay ON pay.pay_contract = ctr.ctr_id
left join (select ctr_id outs_contract,sum(d_outstype_amount) waibao_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id) outsource on outsource.outs_contract = ctr.ctr_id
group by ctr.ctr_id
 ) b  on a.ctrlink_contract = b.ctr_id  GROUP BY opp.projectmanager
 ) shishi on shishi.projectmanager = prj_user
								WHERE
									(
										 datediff(
											ifnull(
												user_leavedate,
												concat("${year}", "-12-31")
											),
											ifnull(
												user_entrydate,
												"2015-01-01"
											)
										) > 14
										/*AND ifnull(
											YEAR (user_leavedate),
											"${year}"
										) >="${year}"*/
										AND prj_user NOT IN (
											SELECT
												user_username num
											FROM
												hr_dept_tags_change
											JOIN hr_user ON change_name = user_username
											WHERE
												change_department = 18
											AND YEAR (change_date) <"${year}"
											AND user_department <> 18
										)
									)
								OR prj_user IN ("luren", "luren2")
									) list
                                   where teamid<>'' and (ifnull(xishu,0)<>0 or ifnull(amount1,0)<>0 or ifnull(amount2,0)<>0 or ifnull(goalamount,0)<>0)
group by team_paixu,teamid,prj_user,ratio
								ORDER BY
									team_paixu asc,
									teamid asc,
									ratio DESC)main 
left join project_member_fenpei b on b.team_name='成本中心' and b.end_date is null and b.team_id=main.teamid and b.user=main.prj_user
left join project_members c on c.prj_verified='valid' and  c.prj_user=b.user
left join hr_department_team d on d.team_department='18' and  d.team_id=c.prj_team
where if(main.teamid='0',d.team_id,main.teamid) <>''
)main /*系数，职级，净回款，验收实际*/


)a,

(SELECT @p:=NULL,@s:=NULL,@r:=0)r
order by goal_team,huikuanbili desc ) c ,(SELECT @r1:=0 ,@rowtotal1 := NULL )d 
order by huikuanbili desc )e,(SELECT @p1:=NULL,@s1:=NULL,@rr1:=0)f
order by goal_team,returnbili desc )g,(SELECT @r2:=0 ,@rowtotal2 := NULL ) h
order by returnbili desc ) i
left join prj_profit_target_team n on i.goal_team=n.pro_team
left join hr_department_team m on m.team_id=i.goal_team
left join project_members nn on nn.prj_user=i.prj_user  

group by goal_team
)a
left join (select prj_fenlei,ifnull(num,0) as profit,region,A.PRO_NUM
from
(select a.prj_team prj_fenlei,
sum((ifnull(sspayback,0)-ifnull(ssoutspaid,0)-ifnull(chengben,0)-ifnull(pro_day_outspay,0)-ifnull(amount,0)))/sum((ifnull(sspayback,0)-ifnull(amount,0))) num,sale.region
from project_opportunity1 a 
left join (SELECT distinct sales_name,if(sales_name='aaron','上海组',if(area_area="京津区","北京组",replace(area_area,"区","组"))) region FROM `hr_salesman` left join hr_area on sales_region=area_region) sale on sale.sales_name=a.prj_salesman
left join cust_company b on a.customer_id = b.com_id
left join hr_department_team g on a.prj_team = g.team_id
left join project_region_unitprice m on m.price_year =year(now()) and m.price_jidu =QUARTER(curdate()) and m.price_province=prj_province
left join (select pro_project,sum(ifnull(pro_day_outspay,0)) pro_day_outspay  from project_sln_info left join fr_t_system1 on pro_key=jira_keys  where pro_project<>'' and year(accept_time)='${year}' group by pro_project
) sln  on pro_project=key_id /*二开成本取当年*/
left join (select a.*,ifnull(dayamount,0) chengben/*人天*人天单价*回款率*/,cc.key_id as keyidd
from 
project_opportunity1 cc left join 
(select ctrlink_key,prj_status2,prj_finishdate2,prj_province,sum(amount) amount,sum(ctramount) ctramount,sum(ssamount) ssamount,sum(sspayback) sspayback,sum(outs_amount) outs_amount, sum(prj_amount2) prj_amount2, sum(pay_paid) pay_paid,sum(outspaid) outspaid,sum(ssoutspaid) ssoutspaid
from
(select ctrlink_key,prj_status prj_status2,prj_finishdate prj_finishdate2,a.ctrlink_contract,(ifnull(finan.amount,0)*(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0))/((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1))) amount,/*商务费用按合同*/prj_province,
((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)) ctramount,/*合同金额*/ 
(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0)) ssamount,/*实施金额*/
ifnull(h.pay_paid,0)*(ifnull(IFNULL(d1.prj_amount,0)*ifnull(f_amount,1)-IFNULL(sumpay_bill,0)*ifnull(f_amount,1)*IFNULL(prj_amount,0)/b.ctr_amount,0))/((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0))*ifnull(f_amount,1)) sspayback,/*实施回款*/
ifnull(outs_amount,0) outs_amount,/*外包金额*/
ifnull(g.prj_amount2,0) prj_amount2,/*实施外包*/
ifnull(h.pay_paid,0) pay_paid,/*回款*/
ifnull(outspaid,0) outspaid/*外包付款*/,
ifnull(outspaid,0)*ifnull(g.prj_amount2,0)/ifnull(outs_amount,0) ssoutspaid/*实施外包付款*//*成本原价*/
from project_opportunity1 left join 
project_contract_link a on a.ctrlink_key=key_id

left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and b.ctr_verified ='valid'  
left join finan_other_statistics c on c.f_remark='CNY' and c.f_type=b.ctr_currency
left join (select ctr_id ctrid,sum(ifnull(amount,0)) amount  from finan_expense a
join finan_outsource_payment b on pay_expense=a.id
join sale_contract_info on ctr_project=pay_contract where year(happenday)= year(now()) group by ctr_id) finan on ctrid=b.ctr_id
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract where pay_status in('记坏账','已作废')  
and year(pay_enddate)='${year}'
group by pay_contract)pay on pay.pay_contract=b.ctr_id 
left join (select sum(a.prj_amount)prj_amount,a.prj_contract FROM  project_contract_link join sale_contract_of_project a on ctrlink_contract =prj_contract 
 group by a.prj_contract) d1 on ctrlink_contract =d1.prj_contract

left join (
SELECT ctrlink_key c_key,sum(ctr_amount)-sum(ifnull(sumpay_bill,0)) sum_paid
from v_sale_contract_info_valid
join project_contract_link on ctr_id=ctrlink_contract
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment where pay_status in('记坏账','已作废') and year(pay_enddate)='${year}'   group by pay_contract)pay /*签单额=合同金额-记坏账-已作废*/
on pay.pay_contract=ctr_id 
GROUP BY ctrlink_key
)sum_pay on c_key=key_id
left join (select sum(ifnull(outspay_amount,0)) outs_amount,outs_contract FROM  project_contract_link 
join sale_outsource on ctrlink_contract = outs_contract 
join sale_outsource_payment on outs_id = outspay_outsource 
where outspay_status not like '%作废'
 group by outs_contract
) e on b.ctr_id =e.outs_contract
left join (SELECT outs_contract,
SUM(IF(d_outs_type = '实施',d_outstype_amount,0)) prj_amount2,
SUM(ifnull(outspay_paid,0)) outspaid
FROM  project_contract_link join v_outsource_detail a on  ctrlink_contract = a.d_outs_contract
LEFT JOIN sale_outsource b ON a.d_outs_id = outs_id  
LEFT JOIN (select SUM(ifnull(outspay_paid,0)) outspay_paid,outspay_outsource from sale_outsource_payment 
where 1=1  and year(outspay_paydate)='${year}'
group by outspay_outsource) e ON b.outs_id=e.outspay_outsource 
where outs_status!="已作废"
GROUP BY outs_contract ) g on b.ctr_id = g.outs_contract 
left join (select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract  
FROM  project_contract_link join sale_payment on  ctrlink_contract = pay_contract
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
where 1=1  and year(pay_enddate)='${year}' 
group by pay_contract) h on b.ctr_id = h.pay_contract 
where prj_status<>'无效' 
group by a.ctrlink_contract
/*having  (prj_finishdate2 is null or prj_finishdate2>='2020-01-01') or (ctramount-pay_paid>0 and prj_finishdate2 is not null)*/
) aa 
group by ctrlink_key )a on a.ctrlink_key=cc.key_id
left join (select a.project,sum(ifnull(a.days,0)*m.price_amount) dayamount
from 
(select sum(if(`day` between c_startdate and c_enddate,0.5*c_value,0.5)) days,a.key_id as project,a.prj_province,year(day) yy,QUARTER(day) qq
from project_opportunity1 a 
join prj_qiandao_time c on (a.key_id = c.project or a.prj_number=c.project) and user_type='1' and status ='0' and (out_type = 0 or out_type = 16 ) 
and year(day)='${year}'
left join project_out_coefficient on c_username=c.`user`
group by a.key_id,year(day),QUARTER(day)
 )a
left join project_region_unitprice m on m.price_year =a.yy and m.price_jidu =a.qq and m.price_province=a.prj_province
group by project)p on p.project=cc.key_id) amount on amount.keyidd=key_id
where prj_status<>'无效' /*and ((prj_finishdate is null or prj_finishdate>='2020-01-01') or (ctramount-ifnull(pay_paid,0)>0 and prj_finishdate is not null))*/
group by a.prj_team/*,sale.region*/
order by a.prj_team/*,sale.region*/ )main 
left join prj_profit_target_team a on A.PRO_YEAR='${year}'  And a.pro_team=main.prj_fenlei
where  prj_fenlei<>'2'
order by num desc
) b on b.prj_fenlei=a.goal_team
LEFT JOIN HR_DEPARTMENT_TEAM ON TEAM_ID=A.GOAL_TEAM
WHERE TEAM_KIND='1'
)c,(SELECT @rr:=0 ,@row := NULL )d order by returnbili desc 

