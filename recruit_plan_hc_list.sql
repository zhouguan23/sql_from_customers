SELECT * FROM hr_group_manage where organize='${organize}'

SELECT * FROM hr_group_manage where organize='${organize}' and group_one='${group_one}'

SELECT * FROM hr_group_manage 
left join hr_department on dept=dept_name
where 1=1
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
${if(len(manager)=0,""," and manager ='"+manager+"' ")}
${if(len(master)=0,""," and master ='"+master+"' ")}
group by organize,group_one,group_two,team,dept_id,position

select dept_id,count(*),team,organize,group_one,group_two,a.user_position,position
from(select *
from(SELECT a.user_username,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user a
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name and user_position=position,
if(dept_id in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position,
if(dept_id='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(dept_id='14',if(c.tag_product_id is not null and c.tag_product_id <>'44' ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(dept_id in('6','7'),group_one='市场' and user_position=position,
if(dept_id='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position ,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position,
"")))))))))
left join hr_user_tags_new j on j.tag_username=a.user_username
where user_state='在职' and user_type <>'兼职' and j.tag_username is null 
order by user_department,user_username)a

union 

select *
from(SELECT a.user_username,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,c.tags_group,k.group_name,team_name,h.*
FROM hr_user a
LEFT JOIN hr_user_tags_new c ON user_username=c.tag_username
LEFT JOIN hr_department d on c.tags_dept=dept_id 
left join hr_department_team e on c.tags_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(c.tags_group in('21','22'),old_group=c.tags_group and h.dept=dept_name and user_position=position,
if(c.tags_dept in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position ,
if(c.tags_dept='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(c.tags_dept='14',if(c.tag_product_id is not null and c.tag_product_id <>'44',FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(c.tags_dept in('6','7'),group_one='市场' and user_position=position,
if(c.tags_dept='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position ,
"")))))))))
where user_state='在职' and user_type <>'兼职' and c.tag_username is not null 
order by user_department,user_username)a 
)a
where 1=1 and organize is not null
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by team,dept_id,group_two,group_one,organize

SELECT distinct provinces FROM dict_region

SELECT citys FROM dict_region
where provinces='${layer1}' and citys<>provinces
order by priority,citys

SELECT user_username FROM hr_user where user_state='在职'

select rc_id,rc_department,rc_position,rc_group_team,rc_number,rc_needdate,rc_organize,rc_group_one,rc_group_two,rc_city,rc_state,rc_source,rc_train,rc_hirmgr,rc_remark,old_group,rc_resumekind,rc_deleted,
rc_isplan,rc_userlevel,rc_group_team,concat(rc_source,'-',left(rc_id,3))show_id,rc_plan_new_state,rc_wp_organize,rc_wp_group_one,rc_wp_group_two,rc_wp_dept,rc_wp_team,rc_inner_plan_status,manager,master,rc_team
from hr_recruit_plan 
left join hr_department on dept_id=rc_department
left join hr_group_manage on rc_organize=organize and rc_group_one=group_one and rc_group_two=group_two and dept_name=dept
where rc_isplan='2' and rc_number > 0 
${if(len(organize)=0,""," and rc_organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and rc_group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and rc_group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
${if(len(manager)=0,""," and manager ='"+manager+"' ")}
${if(len(master)=0,""," and master ='"+master+"' ")}


select count(*),rc_department,team,organize,group_one,group_two,rc_position
from(
select detail_id,detail_getname,detail_source,h.*,rc_id,rc_department,rc_position,dept_name,rc_group,rc_group_tags,rc_group_team,rc_team_name,rc_team_region,rc_sale_region,tags_id
from hr_recruit_detail
left join hr_recruit on detail_recid=rc_id
left join hr_department on dept_id =rc_department
left join hr_tags on tags_name=rc_sale_region
left join hr_group_manage h on ( 
if(rc_department='10',if(detail_source = "社招" and rc_group='21',rc_group=old_group and dept_name=dept,team='研究实验室'),
if(rc_group in('21','22','9','10','40','31'),rc_group=old_group and dept_name=dept ,
if(rc_department in ('14','21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),dept_name=dept and organize<>'简道云'and group_one<>'国际业务',
if(rc_department in('6','7'),group_one='市场'and dept_name=dept and position=rc_position,
if(rc_department='18',FIND_IN_SET(if(detail_team_name is null or LENGTH(detail_team_name)=0,rc_team_name,detail_team_name),re_team) and dept=dept_name,
if(ifnull(detail_product_id,rc_group_tags ) in ('7','8','10','11','33','34','46','30','41','47','24','48','44'), FIND_IN_SET(ifnull(detail_product_id,rc_group_tags ),tags) and dept=dept_name,
if(tags_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),tags_id=tags  and h.dept=dept_name,if(rc_department in('9','10','11','16'),group_two='支撑团队' and dept=dept_name,
"" )))))))))
where detail_status='等待入职中' and dept_verified='valid' 
group by detail_id)z
where 1=1
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
${if(len(rc_position)=0,""," and rc_position ='"+rc_position+"' ")}
group by rc_position,team,rc_department,group_two,group_one,organize

select dept,dept_id,position from hr_group_manage
left join hr_department on dept=dept_name
where 1=1
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}

select sum(rc_number),rc_department,rc_team,sum(if(rc_source='社招',rc_number,0))sz,sum(if(rc_source='校招',rc_number,0))xz,rc_organize,rc_group_one,rc_group_two from hr_recruit_plan
where rc_isplan='2' 
${if(len(organize)=0,""," and rc_organize ='"+organize+"'")}
${if(len(group_one)=0,""," and rc_group_one ='"+group_one+"'")}
${if(len(group_two)=0,""," and rc_group_two ='"+group_two+"'")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
group by rc_organize,rc_group_one,rc_group_two,rc_department,rc_team

SELECT count(*),dept_id,ex_preteam,ex_preorga,ex_pregroup,ex_pregroup_two,ex_preposition FROM `hr_expect_change`
left join hr_department on ex_predept=dept_name
left join hr_user on user_username=ex_username
where 1=1 and user_state='在职'
${if(len(organize)=0,""," and ex_preorga ='"+organize+"'")}
${if(len(group_one)=0,""," and ex_pregroup ='"+group_one+"'")}
${if(len(group_two)=0,""," and ex_pregroup_two ='"+group_two+"'")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by ex_preposition,ex_preteam,dept_id,ex_pregroup_two,ex_pregroup,ex_preorga

SELECT count(*),dept_id,ex_dept,ex_team,ex_orga,ex_group,ex_group_two,ex_position FROM `hr_expect_change`
left join hr_department on ex_dept=dept_name
left join hr_user on user_username=ex_username
where 1=1 and ex_type='转岗'and user_state='在职'
${if(len(organize)=0,""," and ex_orga ='"+organize+"'")}
${if(len(group_one)=0,""," and ex_group ='"+group_one+"'")}
${if(len(group_two)=0,""," and ex_group_two ='"+group_two+"'")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by ex_position,ex_team,dept_id,ex_group_two,ex_group,ex_orga

select dept,dept_id,position from hr_group_manage
left join hr_department on dept=dept_name
where 1=1 and dept_id='${C5}'
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}

select dept,dept_id,position,team from hr_group_manage
left join hr_department on dept=dept_name
where 1=1 and dept_id='${C5}' and position='${D5}'
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}

select organize,group_one,group_two,dept,dept_id,team,sum(if(user_state='在职' and user_type='正式',1,0))在职,
sum(if(((user_entrydate<='2020-12-31' and user_leaveDate is null) or (user_entrydate<='2020-12-31' and user_leaveDate>'2020-12-31'))and user_type='正式',1,0))y20,
sum(if(((user_entrydate<='2019-12-31' and user_leaveDate is null) or (user_entrydate<='2019-12-31' and user_leaveDate>'2019-12-31'))and user_type='正式',1,0))y19,
sum(if(((user_entrydate<='2018-12-31' and user_leaveDate is null) or(user_entrydate<='2018-12-31' and user_leaveDate>'2018-12-31'))and user_type='正式',1,0))y18,
sum(if(((user_entrydate<='2017-12-31' and user_leaveDate is null)or (user_entrydate<='2017-12-31' and user_leaveDate>'2017-12-31'))and user_type='正式',1,0))y17,
sum(if(((user_entrydate<='2016-12-31' and user_leaveDate is null)or (user_entrydate<='2016-12-31' and user_leaveDate>'2016-12-31'))and user_type='正式',1,0))y16

from(SELECT a.user_username,a.user_team,a.user_leaveDate,a.user_entrydate,a.user_state,a.user_type,
c.tag_industry_id,c.tag_product_id,c.tag_region_id,dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user a
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_recruit_detail on detail_id =user_resumeid
left join hr_group_manage h on 
 (if(a.user_username='tiny',re_team='tiny',
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name,
if(dept_id in('14','21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务',
if(dept_id in('6','7'),group_two='市场',
if(dept_id='18',FIND_IN_SET(team_name,re_team)and h.dept=dept_name,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48'), FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags or team_name=h.re_team) and h.dept=dept_name ,
""))))))))
where user_state='在职' and detail_status in ('已正式入职','实习中','考核中') and user_type='正式'
order by user_department,user_username)a
where 1=1 
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}

select organize,group_one,group_two,sum(if(detail_status='等待入职中',1,0))zs,organize,group_one,group_two 
from(
select detail_id,detail_getname,detail_status,detail_source,h.*,rc_id,rc_department,rc_position,dept_name,rc_group,rc_group_tags,rc_group_team,rc_team_name,rc_team_region,rc_sale_region,tags_id
from hr_recruit_detail
left join hr_recruit on detail_recid=rc_id
left join hr_department on dept_id =rc_department
left join hr_tags on tags_name=rc_sale_region
left join hr_group_manage h on ( 
if(rc_department='10',if(detail_source = "社招" and rc_group='21',rc_group=old_group and dept_name=dept,team='研究实验室'),
if(rc_group in('21','22','9','10','40'),rc_group=old_group and dept_name=dept ,
if(rc_department in ('14','21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),dept_name=dept and organize<>'简道云'and group_one<>'国际业务',
if(rc_department in('6','7'),group_one='市场',
if(rc_department='18',FIND_IN_SET(rc_team_name,re_team)and dept=dept_name,
if(ifnull(detail_product_id,rc_group_tags ) in ('7','8','10','11','33','34','46','30','41','47','24','48'), FIND_IN_SET(ifnull(detail_product_id,rc_group_tags ),tags) and dept=dept_name,
if(tags_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),tags_id=tags  and h.dept=dept_name,if(rc_department in('9','10','11','16'),group_two='支撑团队' and dept=dept_name,
"" )))))))))
where detail_status='等待入职中' and dept_verified='valid' 
group by detail_id)z
where 1=1
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}


select sum(rc_number) from hr_recruit_plan where rc_isplan='2' 

${if(len(organize)=0,""," and rc_organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and rc_group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and rc_group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}

select GROUP_CONCAT(rc_id),rc_department,rc_position,rc_organize,rc_group_one,rc_group_two,rc_isplan,concat(rc_source,'-',left(rc_id,3))show_id,rc_plan_new_state,rc_inner_plan_status,rc_city,rc_state,rc_source,rc_userlevel,rc_train,rc_needdate,rc_number,rc_hirmgr,manager,master,rc_team
 from hr_recruit_plan 
left join hr_department on dept_id=rc_department
left join hr_group_manage on rc_organize=organize and rc_group_one=group_one and rc_group_two=group_two and dept_name=dept
where rc_isplan='2' and rc_plan_new_state ='待审核' and rc_number >0
${if(len(organize)=0,""," and rc_organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and rc_group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and rc_group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
${if(len(manager)=0,""," and manager ='"+manager+"' ")}
${if(len(master)=0,""," and master ='"+master+"' ")}
group by rc_organize,rc_group_one,rc_group_two,rc_department,rc_team

select organize,group_one,group_two,dept,dept_id,sum(if(user_state='在职' and user_type='正式',1,0))在职,
sum(if(((user_entrydate<='2020-12-31' and user_leaveDate is null) or (user_entrydate<='2020-12-31' and user_leaveDate>'2020-12-31'))and user_type='正式',1,0))y20,
sum(if(((user_entrydate<='2019-12-31' and user_leaveDate is null) or (user_entrydate<='2019-12-31' and user_leaveDate>'2019-12-31'))and user_type='正式',1,0))y19,
sum(if(((user_entrydate<='2018-12-31' and user_leaveDate is null) or(user_entrydate<='2018-12-31' and user_leaveDate>'2018-12-31'))and user_type='正式',1,0))y18,
sum(if(((user_entrydate<='2017-12-31' and user_leaveDate is null)or (user_entrydate<='2017-12-31' and user_leaveDate>'2017-12-31'))and user_type='正式',1,0))y17,
sum(if(((user_entrydate<='2016-12-31' and user_leaveDate is null)or (user_entrydate<='2016-12-31' and user_leaveDate>'2016-12-31'))and user_type='正式',1,0))y16

from(SELECT a.user_username,a.user_team,a.user_leaveDate,a.user_entrydate,a.user_state,a.user_type,
c.tag_industry_id,c.tag_product_id,c.tag_region_id,dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user a
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_recruit_detail on detail_id =user_resumeid
left join hr_group_manage h on 
 (if(a.user_username='tiny',re_team='tiny',
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name,
if(dept_id in('14','21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务',
if(dept_id in('6','7'),group_two='市场',
if(dept_id='18',FIND_IN_SET(team_name,re_team)and h.dept=dept_name,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48'), FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags or team_name=h.re_team) and h.dept=dept_name ,
""))))))))
where user_state='在职' and detail_status in ('已正式入职','实习中','考核中') and user_type='正式'
order by user_department,user_username)a
where 1=1 
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by organize,group_one,group_two,dept

select organize,group_one,group_two,dept,dept_id,team,sum(if(user_state='在职' and user_type='正式',1,0))在职,
sum(if(((user_entrydate<='2020-12-31' and user_leaveDate is null) or (user_entrydate<='2020-12-31' and user_leaveDate>'2020-12-31'))and user_type='正式',1,0))y20,
sum(if(((user_entrydate<='2019-12-31' and user_leaveDate is null) or (user_entrydate<='2019-12-31' and user_leaveDate>'2019-12-31'))and user_type='正式',1,0))y19,
sum(if(((user_entrydate<='2018-12-31' and user_leaveDate is null) or(user_entrydate<='2018-12-31' and user_leaveDate>'2018-12-31'))and user_type='正式',1,0))y18,
sum(if(((user_entrydate<='2017-12-31' and user_leaveDate is null)or (user_entrydate<='2017-12-31' and user_leaveDate>'2017-12-31'))and user_type='正式',1,0))y17,
sum(if(((user_entrydate<='2016-12-31' and user_leaveDate is null)or (user_entrydate<='2016-12-31' and user_leaveDate>'2016-12-31'))and user_type='正式',1,0))y16

from(SELECT a.user_username,a.user_team,a.user_leaveDate,a.user_entrydate,a.user_state,a.user_type,
c.tag_industry_id,c.tag_product_id,c.tag_region_id,dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user a
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_recruit_detail on detail_id =user_resumeid
left join hr_group_manage h on 
 (if(a.user_username='tiny',re_team='tiny',
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name,
if(dept_id in('14','21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务',
if(dept_id in('6','7'),group_two='市场',
if(dept_id='18',FIND_IN_SET(team_name,re_team)and h.dept=dept_name,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48'), FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags or team_name=h.re_team) and h.dept=dept_name ,
""))))))))
where user_state='在职' and detail_status in ('已正式入职','实习中','考核中') and user_type='正式'
order by user_department,user_username)a
where 1=1 
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by organize,group_one,group_two,dept,team

select sum(rc_number),rc_department,rc_team,sum(if(rc_source='社招',rc_number,0))sz,sum(if(rc_source='校招',rc_number,0))xz,rc_organize,rc_group_one,rc_group_two from hr_recruit_plan
where rc_isplan='2' and rc_plan_new_state='已审核'
${if(len(organize)=0,""," and rc_organize ='"+organize+"'")}
${if(len(group_one)=0,""," and rc_group_one ='"+group_one+"'")}
${if(len(group_two)=0,""," and rc_group_two ='"+group_two+"'")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
group by rc_group_team,rc_department,rc_group_two,rc_group_one,rc_organize

select dept_id,count(*),team,organize,group_one,group_two,a.user_position,position
from(select *
from(SELECT a.user_username,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user a
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name and user_position=position,
if(dept_id in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position,
if(dept_id='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(dept_id='14',if(c.tag_product_id is not null and c.tag_product_id <>'44' ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(dept_id in('6','7'),group_one='市场' and h.dept=dept_name and user_position=position,
if(dept_id='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position ,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position,
"")))))))))
left join hr_user_tags_new j on j.tag_username=a.user_username
where user_state='在职' and user_type <>'兼职' and j.tag_username is null 
order by user_department,user_username)a

union 

select *
from(SELECT a.user_username,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,c.tags_group,k.group_name,team_name,h.*
FROM hr_user a
LEFT JOIN hr_user_tags_new c ON user_username=c.tag_username
LEFT JOIN hr_department d on c.tags_dept=dept_id 
left join hr_department_team e on c.tags_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(c.tags_group in('21','22'),old_group=c.tags_group and h.dept=dept_name and user_position=position,
if(c.tags_dept in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position ,
if(c.tags_dept='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(c.tags_dept='14',if(c.tag_product_id is not null and c.tag_product_id <>'44',FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(c.tags_dept in('6','7'),group_one='市场' and h.dept=dept_name and user_position=position,
if(c.tags_dept='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position ,
"")))))))))
where user_state='在职' and user_type <>'兼职' and c.tag_username is not null 
order by user_department,user_username)a 
)a
where 1=1 and organize is not null
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by position,team,dept_id,group_two,group_one,organize

select * from hr_recruit

select dept_id,count(*),team,organize,group_one,group_two,a.user_position,position
from(select *
from(SELECT a.user_username,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user a
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name and user_position=position,
if(dept_id in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position,
if(dept_id='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(dept_id='14',if(c.tag_product_id is not null and c.tag_product_id <>'44' ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(dept_id in('6','7'),group_one='市场' and user_position=position,
if(dept_id='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position ,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position,
"")))))))))
left join hr_user_tags_new j on j.tag_username=a.user_username
where user_state='在职' and (user_type ='正式' or  user_type ='实习生') and j.tag_username is null 
order by user_department,user_username)a

union 

select *
from(SELECT a.user_username,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,c.tags_group,k.group_name,team_name,h.*
FROM hr_user a
LEFT JOIN hr_user_tags_new c ON user_username=c.tag_username
LEFT JOIN hr_department d on c.tags_dept=dept_id 
left join hr_department_team e on c.tags_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(c.tags_group in('21','22'),old_group=c.tags_group and h.dept=dept_name and user_position=position,
if(c.tags_dept in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position ,
if(c.tags_dept='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(c.tags_dept='14',if(c.tag_product_id is not null and c.tag_product_id <>'44',FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(c.tags_dept in('6','7'),group_one='市场' and user_position=position,
if(c.tags_dept='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position ,
"")))))))))
where user_state='在职' and (user_type ='正式' or  user_type ='实习生') and c.tag_username is not null 
order by user_department,user_username)a 
)a
where 1=1 and organize is not null
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by position,team,dept_id,group_two,group_one,organize

SELECT a.organize,a.group_one,a.group_two,c.fd_remark_amount,b.dept_id,sum(fd_remark_amount)a 
FROM (select organize,group_one,group_two,dept,old_group from hr_group_manage group by dept,group_two,group_one,organize ) a
left join hr_department b on dept=dept_name
left join budget_labor_fudongxingzi c on fd_group = old_group and fd_dept = dept_id
where fd_year=2020
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by dept_id,group_two,group_one,organize


SELECT a.organize,a.group_one,a.group_two,c.raise_amount,b.dept_id,sum(raise_amount)a 
FROM (select organize,group_one,group_two,dept,old_group from hr_group_manage group by dept,group_two,group_one,organize ) a
left join hr_department b on dept=dept_name
left join budget_labor_jiaxin c on raise_group = old_group and raise_dept = dept_name
where raise_year=2020
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by dept_id,group_two,group_one,organize

SELECT a.organize,a.group_one,a.group_two,c.jc_amount,b.dept_id,sum(jc_amount)a 
FROM (select organize,group_one,group_two,dept,old_group from hr_group_manage group by dept,group_two,group_one,organize ) a
left join hr_department b on dept=dept_name
left join budget_labor_jichu c on jc_group = old_group and jc_department = dept_id
where jc_year=2020
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by jc_department,dept_id,group_two,group_one,organize

SELECT a.organize,a.group_one,a.group_two,c.lz_amount,b.dept_id,sum(lz_amount)a 
FROM (select organize,group_one,group_two,dept,old_group from hr_group_manage group by dept,group_two,group_one,organize ) a
left join hr_department b on dept=dept_name
left join budget_labor_lizhibuchang c on lz_group = old_group and lz_dept = dept_id
where lz_year=2020
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by dept_id,group_two,group_one,organize

SELECT a.organize,a.group_one,a.group_two,c.zp_amount,b.dept_id,sum(zp_amount)a 
FROM (select organize,group_one,group_two,dept,old_group from hr_group_manage group by dept,group_two,group_one,organize ) a
left join hr_department b on dept=dept_name
left join budget_labor_zhaopin c on zp_group = old_group and zp_department = dept_id
where zp_year=2020 
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by dept_id,group_two,group_one,organize

SELECT sum(fd_remark_amount) from budget_labor_fudongxingzi where fd_year=2020

SELECT sum(raise_amount) from budget_labor_jiaxin where raise_year=2020

select sum(jc_amount) from budget_labor_jichu where jc_year = 2020

select sum(lz_amount) from budget_labor_lizhibuchang where lz_year=2020

select sum(zp_amount) from budget_labor_zhaopin where zp_year = 2020


SELECT a.organize,a.group_one,a.group_two,c.td_amount,b.dept_id,sum(td_amount)a 
FROM (select organize,group_one,group_two,dept,old_group from hr_group_manage group by dept,group_two,group_one,organize ) a
left join hr_department b on dept=dept_name
left join 2019tuanduigongzi c on td_group = old_group and td_dept = dept_id
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by dept_id,group_two,group_one,organize

SELECT sum(td_amount)a 
FROM  2019tuanduigongzi c 

select count(*),rc_department,team,organize,group_one,group_two,rc_position
from(
select detail_id,detail_getname,detail_source,h.*,rc_id,rc_department,rc_position,dept_name,rc_group,rc_group_tags,rc_group_team,rc_team_name,rc_team_region,rc_sale_region,tags_id
from hr_recruit_detail
left join hr_recruit on detail_recid=rc_id
left join hr_department on dept_id =rc_department
left join hr_tags on tags_name=rc_sale_region
left join hr_group_manage h on ( 
if(rc_department='10',if(detail_source = "社招" and rc_group='21',rc_group=old_group and dept_name=dept,team='研究实验室'),
if(rc_group in('21','22','9','10','40'),rc_group=old_group and dept_name=dept ,
if(rc_department in ('14','21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),dept_name=dept and organize<>'简道云'and group_one<>'国际业务',
if(rc_department in('6','7'),group_one='市场',
if(rc_department='18',FIND_IN_SET(if(detail_team_name is null or LENGTH(detail_team_name)=0,rc_team_name,detail_team_name),re_team) and dept=dept_name,
if(ifnull(detail_product_id,rc_group_tags ) in ('7','8','10','11','33','34','46','30','41','47','24','48'), FIND_IN_SET(ifnull(detail_product_id,rc_group_tags ),tags) and dept=dept_name,
if(tags_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),tags_id=tags  and h.dept=dept_name,if(rc_department in('9','10','11','16'),group_two='支撑团队' and dept=dept_name,
"" )))))))))
where detail_status='等待入职中' and detail_state="正式" and dept_verified='valid' 
group by detail_id)z
where 1=1
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
${if(len(rc_position)=0,""," and rc_position ='"+rc_position+"' ")}
group by rc_position,team,rc_department,group_two,group_one,organize

SELECT count(*),dept_id,ex_dept,ex_team,ex_orga,ex_group,ex_group_two,ex_position FROM `hr_expect_change`
left join hr_department on ex_dept=dept_name
left join hr_user on user_username=ex_username
where 1=1 and ex_type='转岗'and user_state='在职' and (user_type="正式" or user_type="实习生" )
${if(len(organize)=0,""," and ex_orga ='"+organize+"'")}
${if(len(group_one)=0,""," and ex_group ='"+group_one+"'")}
${if(len(group_two)=0,""," and ex_group_two ='"+group_two+"'")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by ex_position,ex_team,dept_id,ex_group_two,ex_group,ex_orga

SELECT count(*),dept_id,ex_preteam,ex_preorga,ex_pregroup,ex_pregroup_two,ex_preposition FROM `hr_expect_change`
left join hr_department on ex_predept=dept_name
left join hr_user on user_username=ex_username
where 1=1 and user_state='在职' and (user_type="正式" or user_type="实习生")
${if(len(organize)=0,""," and ex_preorga ='"+organize+"'")}
${if(len(group_one)=0,""," and ex_pregroup ='"+group_one+"'")}
${if(len(group_two)=0,""," and ex_pregroup_two ='"+group_two+"'")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by ex_preposition,ex_preteam,dept_id,ex_pregroup_two,ex_pregroup,ex_preorga

select sum(rc_number),rc_department,rc_position,rc_group_team,rc_number,rc_needdate,rc_organize,rc_group_one,rc_group_two,rc_city,rc_state,rc_source,rc_train,rc_hirmgr,rc_remark,old_group,rc_resumekind,
rc_isplan,rc_userlevel,rc_group_team,concat(rc_source,'-',left(rc_id,3))show_id,rc_plan_new_state,rc_wp_organize,rc_wp_group_one,rc_wp_group_two,rc_wp_dept,rc_wp_team,rc_inner_plan_status,manager,master,rc_team
from hr_recruit_plan 
left join hr_department on dept_id=rc_department
left join hr_group_manage on rc_organize=organize and rc_group_one=group_one and rc_group_two=group_two and dept_name=dept
where rc_isplan='2' and rc_number > 0 and rc_state="正式"
${if(len(organize)=0,""," and rc_organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and rc_group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and rc_group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and rc_department ='"+depts+"' ")}
${if(len(manager)=0,""," and manager ='"+manager+"' ")}
${if(len(master)=0,""," and master ='"+master+"' ")}
group by position,team,dept_id,group_two,group_one,organize

select dept_id,count(*),team,organize,group_one,group_two,position
from(select *
from(SELECT r.resign_user,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user_resign r
left join hr_user a on r.resign_user = a.user_username
left join hr_expect_change on r.resign_user= ex_username
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name and user_position=position,
if(dept_id in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position,
if(dept_id='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(dept_id='14',if(c.tag_product_id is not null and c.tag_product_id <>'44' ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(dept_id in('6','7'),group_one='市场' and h.dept=dept_name and user_position=position,
if(dept_id='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position ,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position,
"")))))))))
left join hr_user_tags_new j on j.tag_username=a.user_username
where user_state='在职' and user_type <>'兼职' and j.tag_username is null and r.resign_flow <> '1' and (r.resign_type='辞退' or r.resign_type='申请离职')  and user_state='在职' and ex_username is null and r.resign_flow <> '6'
order by user_department,r.resign_user)a

union 

select *
from(SELECT r.resign_user,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,c.tags_group,k.group_name,team_name,h.*
FROM hr_user_resign r
left join hr_user a on r.resign_user = a.user_username
left join hr_expect_change on r.resign_user= ex_username
LEFT JOIN hr_user_tags_new c ON r.resign_user=c.tag_username
LEFT JOIN hr_department d on c.tags_dept=dept_id 
left join hr_department_team e on c.tags_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=r.resign_user
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(c.tags_group in('21','22'),old_group=c.tags_group and h.dept=dept_name and user_position=position,
if(c.tags_dept in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position ,
if(c.tags_dept='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(c.tags_dept='14',if(c.tag_product_id is not null and c.tag_product_id <>'44',FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(c.tags_dept in('6','7'),group_one='市场' and h.dept=dept_name and user_position=position,
if(c.tags_dept='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position ,
"")))))))))
where user_state='在职' and user_type <>'兼职' and c.tag_username is not null and r.resign_flow <> '1' and (r.resign_type='辞退' or r.resign_type='申请离职') and user_state='在职' and ex_username is null and r.resign_flow <> '6'
order by user_department,r.resign_user)a 
)a
where 1=1 and organize is not null
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by position,team,dept_id,group_two,group_one,organize

select dept_id,count(*),team,organize,group_one,group_two,position
from(select *
from(SELECT r.resign_user,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,g.group_id,k.group_name,team_name,h.*
FROM hr_user_resign r
left join hr_user a on r.resign_user = a.user_username
left join hr_expect_change on r.resign_user= ex_username
left join v_hr_contract b on user_username = hr_ctr_user
LEFT JOIN hr_user_tags c ON user_username=c.tag_username
LEFT JOIN hr_department d on user_department=dept_id 
left join hr_department_team e on user_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=a.user_username
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(k.group_id in('21','22'),old_group=k.group_id and h.dept=dept_name and user_position=position,
if(dept_id in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position,
if(dept_id='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(dept_id='14',if(c.tag_product_id is not null and c.tag_product_id <>'44' ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(dept_id in('6','7'),group_one='市场' and h.dept=dept_name and user_position=position,
if(dept_id='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position ,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position,
"")))))))))
left join hr_user_tags_new j on j.tag_username=a.user_username
where user_state='在职' and user_type <>'兼职' and j.tag_username is null and r.resign_flow <> '1' and (r.resign_type='辞退' or r.resign_type='申请离职')  and user_state='在职' and ex_username is null and r.resign_flow <> '6'
order by user_department,r.resign_user)a

union 

select *
from(SELECT r.resign_user,a.user_team,a.user_position,c.tag_industry_id,c.tag_product_id,c.tag_region_id,
dept_id,dept_name,c.tags_group,k.group_name,team_name,h.*
FROM hr_user_resign r
left join hr_user a on r.resign_user = a.user_username
left join hr_expect_change on r.resign_user= ex_username
LEFT JOIN hr_user_tags_new c ON r.resign_user=c.tag_username
LEFT JOIN hr_department d on c.tags_dept=dept_id 
left join hr_department_team e on c.tags_team=team_id
left join dict_idno f on left(user_cardNo,6)=idno
left join hr_user_group g on g.user_username=r.resign_user
left join hr_group k on k.group_id=g.group_id
left join hr_group_manage h on 
 (
if(c.tags_group in('21','22'),old_group=c.tags_group and h.dept=dept_name and user_position=position,
if(c.tags_dept in('21','22','23','24','26','28','29','20','31','38','40','5','3','34','39','8','35','19'),h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position ,
if(c.tags_dept='41' and c.tag_product_id='44',h.dept=dept_name and organize<>'简道云'and group_one<>'国际业务' and user_position=position and tags is null,
if(c.tags_dept='14',if(c.tag_product_id is not null and c.tag_product_id <>'44',FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position,h.dept=dept_name and organize='公共职能线'),
if(c.tags_dept in('6','7'),group_one='市场' and h.dept=dept_name and user_position=position,
if(c.tags_dept='18',FIND_IN_SET(team_name,ifnull(re_team,team))and h.dept=dept_name and user_position=position,
if(c.tag_product_id in ('7','8','10','11','33','34','46','30','41','47','24','48','51','50'), if( team_name is not null ,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position and team_name=team,FIND_IN_SET(tag_product_id,tags) and h.dept=dept_name and user_position=position) ,
if(c.tag_region_id in ('12','20','21','17','15','16','18','13','14','19','31','29'),(c.tag_region_id=tags and if(team_name is null,team is null or LENGTH(team)=0,team_name=ifnull(re_team,team))) and h.dept=dept_name and user_position=position ,
"")))))))))
where user_state='在职' and user_type <>'兼职' and c.tag_username is not null and r.resign_flow <> '1' and (r.resign_type='辞退' or r.resign_type='申请离职') and user_state='在职' and ex_username is null and r.resign_flow <> '6'
order by user_department,r.resign_user)a 
)a
where 1=1 and organize is not null
${if(len(organize)=0,""," and organize ='"+organize+"' ")}
${if(len(group_one)=0,""," and group_one ='"+group_one+"' ")}
${if(len(group_two)=0,""," and group_two ='"+group_two+"' ")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by team,dept_id,group_two,group_one,organize

SELECT count(*),dept_id,ex_preteam,ex_preorga,ex_pregroup,ex_pregroup_two,ex_preposition FROM `hr_expect_change`
left join hr_department on ex_predept=dept_name
left join hr_user on user_username=ex_username
where 1=1 and user_state='在职'
${if(len(organize)=0,""," and ex_preorga ='"+organize+"'")}
${if(len(group_one)=0,""," and ex_pregroup ='"+group_one+"'")}
${if(len(group_two)=0,""," and ex_pregroup_two ='"+group_two+"'")}
${if(len(depts)=0,""," and dept_id ='"+depts+"' ")}
group by ex_preteam,dept_id,ex_pregroup_two,ex_pregroup,ex_preorga

