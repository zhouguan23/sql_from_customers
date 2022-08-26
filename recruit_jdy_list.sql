select * from (
SELECT a.*,source,b.detail_executor,detail_source,detail_id,detail_sendtime,rc_comstate,
substring_index(substring_index(substring_index(substring_index(detail_history,'time',-1),',',1),'"',-2),'"',1)uptime
,f.user_username,f.way,detail_degree,detail_school,detail_major,detail_degree_bachelor,detail_jiangjin,detail_degree_master,
detail_state,rc_department,rc_group,rc_position,k.id,k.moneys,if_two,
(case when detail_status="待处理"or detail_status="尚未联系" then "待处理" 
when detail_status="考核中" then "考核中" 
when detail_status="跟进中简历" or detail_status="待部门面试"then "面试中"
when detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer" then "不合适" 
when detail_status="offer中" or detail_status="等待入职中" THEN"offer中" 
when detail_status="拒绝offer" or detail_status="入职失败" then "入职失败" 
when detail_status="实习中"  then "实习中"
when detail_status="已正式入职"  then "正式入职" 
when detail_status="已离职" then "已离职" 
end )state,
(case when detail_status="待处理"or detail_status="尚未联系" or detail_status="跟进中简历" or detail_status="待部门面试" 
or  detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer"  then "0" 
when detail_status="考核中" or detail_status="offer中" or detail_status="等待入职中" or detail_status="拒绝offer" or detail_status="入职失败" then "200" 
when detail_status="实习中"  then "500"
when detail_status="已正式入职" and source regexp "校招" then "500"
when detail_status="已正式入职" and source ="社招" and rc_comstate="0"  then "1000" 
when detail_status="已正式入职" and source ="社招" and rc_comstate="1"  then "2000"
when detail_status="已离职" and hr_ctr_user is not null and source regexp"校招" then "500"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="0" then "1000"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="1" then "2000"
when detail_status="已离职" and hr_ctr_user is null and source ="社招" then "200"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and detail_exam_ifpass='是' then "500"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and (detail_exam_ifpass='否' or detail_exam_ifpass is null) then "200"
end ) money,
(case when detail_status="待处理"or detail_status="尚未联系" or detail_status="跟进中简历" or detail_status="待部门面试" 
or  detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer"  then "1" 
when detail_status="考核中" or detail_status="offer中" or detail_status="等待入职中" or detail_status="拒绝offer" or detail_status="入职失败" then "10" 
when detail_status="实习中"  then "20"
when detail_status="已正式入职" and source regexp "校招" then "20"
when detail_status="已正式入职" and source ="社招" and rc_comstate="0"  then "30" 
when detail_status="已正式入职" and source ="社招" and rc_comstate="1"  then "50"
when detail_status="已离职" and hr_ctr_user is not null and source regexp"校招" then "20"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="0" then "30"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="1" then "50"
when detail_status="已离职" and hr_ctr_user is null and source ="社招" then "10"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and detail_exam_ifpass='是' then "20"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and (detail_exam_ifpass='否' or detail_exam_ifpass is null) then "10"
end  )jifen
 FROM `fr2020jxz - wlxzys` a
left join(select *,if(year(detail_gradyear)=2020 and comment_time<='2020-07-01' and comment_time is not null,'校招',
if(year(detail_gradyear)=2020 and comment_time>'2020-07-01' and comment_time is not null,'社招',
if(comment_time is null and year(detail_gradyear)=2020,'校招','社招')))source from hr_recruit_detail 
left join hr_recruit_comment h on h.rc_id=detail_id
where comments regexp '面试通过，备注' or comments regexp '面试淘汰' or comments is null)b 

on b.detail_mobile=_widget_1532400624673 AND b.detail_getname=_widget_1532400624642
left join hr_user c on c.user_resumeid=b.detail_id 
left join hr_recruit d on d.rc_id=b.detail_recid
left join hr_contract g on g.hr_ctr_user=c.user_username
left join hr_office_sanfang e on e.office_mobile=_widget_1532400624673 AND e.office_name=_widget_1532400624642
left join hr_recruit_commentnum f on f.commentnum=a._widget_1532400624263
left join recruit_jdy_money k on neitui_person=f.user_username and bei_person=_widget_1532400624642

)aa

where 1=1 


${if(len(tel)=0,""," and _widget_1532400624673='"+tel+"'")}
${if(len(name)=0,""," and _widget_1532400624642 regexp'"+name+"'")}
${if(len(state)=0,""," and state='"+state+"'")}

select * from(
SELECT a.*,source,b.detail_executor,detail_id,detail_source,detail_sendtime,substring_index(substring_index(substring_index(substring_index(detail_history,'time',-1),',',1),'"',-2),'"',1)uptime,rc_comstate,f.user_username,f.way,detail_degree,detail_school,detail_major,detail_degree_bachelor,detail_degree_master,detail_state,detail_jiangjin,rc_department,rc_group,rc_position,k.id,k.moneys,if_two,
(case when detail_status="待处理"or detail_status="尚未联系" then "待处理" 
when detail_status="考核中" then "考核中" 
when detail_status="跟进中简历" or detail_status="待部门面试"then "面试中"
when detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer" then "不合适" 
when detail_status="offer中" or detail_status="等待入职中" THEN"offer中" 
when detail_status="拒绝offer" or detail_status="入职失败" then "入职失败" 
when detail_status="实习中"  then "实习中"
when detail_status="已正式入职"  then "正式入职" 
when detail_status="已离职" then "已离职" 
end )state,
(case when detail_status="待处理"or detail_status="尚未联系" or detail_status="跟进中简历" or detail_status="待部门面试" 
or  detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer"  then "0" 
when detail_status="考核中" or detail_status="offer中" or detail_status="等待入职中" or detail_status="拒绝offer" or detail_status="入职失败" then "200" 
when detail_status="实习中"  then "500"
when detail_status="已正式入职" and source regexp "校招" then "500"
when detail_status="已正式入职" and source ="社招" and rc_comstate="0"  then "1000" 
when detail_status="已正式入职" and source ="社招" and rc_comstate="1"  then "2000"
when detail_status="已离职" and hr_ctr_user is not null and source regexp"校招" then "500"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="0" then "1000"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="1" then "2000"
when detail_status="已离职" and hr_ctr_user is null and source ="社招" then "200"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and detail_exam_ifpass='是' then "500"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and (detail_exam_ifpass='否' or detail_exam_ifpass is null) then "200"
end ) money,
(case when detail_status="待处理"or detail_status="尚未联系" or detail_status="跟进中简历" or detail_status="待部门面试" 
or  detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer"  then "1" 
when detail_status="考核中" or detail_status="offer中" or detail_status="等待入职中" or detail_status="拒绝offer" or detail_status="入职失败" then "10" 
when detail_status="实习中"  then "20"
when detail_status="已正式入职" and source regexp "校招" then "20"
when detail_status="已正式入职" and source ="社招" and rc_comstate="0"  then "30" 
when detail_status="已正式入职" and source ="社招" and rc_comstate="1"  then "50"
when detail_status="已离职" and hr_ctr_user is not null and source regexp"校招" then "20"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="0" then "30"
when detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="1" then "50"
when detail_status="已离职" and hr_ctr_user is null and source ="社招" then "10"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and detail_exam_ifpass='是' then "20"
when detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and (detail_exam_ifpass='否' or detail_exam_ifpass is null) then "10"
end  )jifen
from `gwcx-frsz` a
left join (select *,if(year(detail_gradyear)=2020 and comment_time<='2020-07-01' and comment_time is not null,'校招',
if(year(detail_gradyear)=2020 and comment_time>'2020-07-01' and comment_time is not null,'社招',
if(comment_time is null and year(detail_gradyear)=2020,'校招','社招')))source from hr_recruit_detail 
left join hr_recruit_comment h on h.rc_id=detail_id
where comments regexp '面试通过，备注' or comments regexp '面试淘汰' or comments is null) b 
on b.detail_mobile=a._widget_1532420227103 AND b.detail_getname=a._widget_1532420226988
left join hr_user c on c.user_resumeid=b.detail_id 
left join hr_recruit d on d.rc_id=b.detail_recid
left join hr_contract g on g.hr_ctr_user=c.user_username
left join hr_office_sanfang e on e.office_mobile=a._widget_1532420227103 AND e.office_name=a._widget_1532420226988
left join hr_recruit_commentnum f on f.commentnum=a._widget_1545640907503

left join recruit_jdy_money k on neitui_person=f.user_username and bei_person=a._widget_1532420226988

)aa
where 1=1 


${if(len(tel)=0,""," and _widget_1532420227103='"+tel+"'")}
${if(len(name)=0,""," and _widget_1532420226988 regexp'"+name+"'")}
${if(len(state)=0,""," and state='"+state+"'")}

select _widget_1532400624263,user_username,sum(sum) from(
select _widget_1532400624642,_widget_1532400624263,f.user_username,if_two,
sum(
if(detail_status="待处理"or detail_status="尚未联系"or detail_status="跟进中简历" or detail_status="待部门面试" 
or detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer",1,
if(detail_status="考核中" or detail_status="offer中" or detail_status="等待入职中" or detail_status="拒绝offer" or 
detail_status="入职失败",10,
if(detail_status="实习中" 
or (detail_status="已正式入职" and source regexp "校招" ) or
 (detail_status="已离职" and hr_ctr_user is not null and source regexp"校招")
or (detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and detail_exam_ifpass='是'),20,
if(detail_status="已正式入职" and source ="社招" and rc_comstate="0" ,30,
if(detail_status="已正式入职" and source ="社招" and rc_comstate="1",50,
if(detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="1" ,50,
if(detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="0",30,
if(detail_status="已离职" and hr_ctr_user is null and source ="社招" ,10,
if(detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and (detail_exam_ifpass='否' or detail_exam_ifpass is null)
,10,0))))))))))sum
 FROM `fr2020jxz - wlxzys` a
left join (select *,if(year(detail_gradyear)=2020 and comment_time<='2020-07-01' and comment_time is not null,'校招',
if(year(detail_gradyear)=2020 and comment_time>'2020-07-01' and comment_time is not null,'社招',
if(comment_time is null and year(detail_gradyear)=2020,'校招','社招')))source from hr_recruit_detail 
left join hr_recruit_comment h on h.rc_id=detail_id
where comments regexp '面试通过，备注' or comments regexp '面试淘汰' or comments is null) b 
on b.detail_mobile=_widget_1532400624673 AND b.detail_getname=_widget_1532400624642
left join hr_user c on c.user_resumeid=b.detail_id 
left join hr_recruit d on d.rc_id=b.detail_recid
left join hr_contract g on g.hr_ctr_user=c.user_username
left join hr_office_sanfang e on e.office_mobile=_widget_1532400624673 AND e.office_name=_widget_1532400624642
left join hr_recruit_commentnum f on f.commentnum=a._widget_1532400624263
left join recruit_jdy_money k on neitui_person=f.user_username and bei_person=_widget_1532400624642
where f.user_username is not null and (if_two=0 or if_two is null) and f.user_username='${fr_username}'
group by _widget_1532400624642)b 
group by _widget_1532400624263

select _widget_1545640907503,z.user_username,sum(sum1) 
from (
select _widget_1532420226988,_widget_1545640907503,f.user_username,sum(
if(detail_status="待处理"or detail_status="尚未联系"or detail_status="跟进中简历" or detail_status="待部门面试" 
or detail_status="无效简历" or detail_status="潜在简历" or detail_status="淘汰简历" or detail_status="储备offer",1,
if(detail_status="考核中" or detail_status="offer中" or detail_status="等待入职中" or detail_status="拒绝offer" or 
detail_status="入职失败",10,
if(detail_status="实习中" 
or (detail_status="已正式入职" and source regexp "校招" ) or
 (detail_status="已离职" and hr_ctr_user is not null and source regexp"校招")
or (detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and detail_exam_ifpass='是'),20,
if(detail_status="已正式入职" and source ="社招" and rc_comstate="0" ,30,
if(detail_status="已正式入职" and source ="社招" and rc_comstate="1",50,
if(detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="1" ,50,
if(detail_status="已离职" and hr_ctr_user is not null and source ="社招" and rc_comstate="0",30,
if(detail_status="已离职" and hr_ctr_user is null and source ="社招" ,10,
if(detail_status="已离职" and hr_ctr_user is null and source regexp"校招" and (detail_exam_ifpass='否' or detail_exam_ifpass is null)
,10,0))))))))))sum1
from `gwcx-frsz` a
left join (select *,if(year(detail_gradyear)=2020 and comment_time<='2020-07-01' and comment_time is not null,'校招',
if(year(detail_gradyear)=2020 and comment_time>'2020-07-01' and comment_time is not null,'社招',
if(comment_time is null and year(detail_gradyear)=2020,'校招','社招')))source from hr_recruit_detail 
left join hr_recruit_comment h on h.rc_id=detail_id
where comments regexp '面试通过，备注' or comments regexp '面试淘汰' or comments is null)b on b.detail_mobile=a._widget_1532420227103 AND b.detail_getname=a._widget_1532420226988
left join hr_user c on c.user_resumeid=b.detail_id 
left join hr_recruit d on d.rc_id=b.detail_recid
left join hr_contract g on g.hr_ctr_user=c.user_username
left join hr_office_sanfang e on e.office_mobile=a._widget_1532420227103 AND e.office_name=a._widget_1532420226988
left join hr_recruit_commentnum f on f.commentnum=a._widget_1545640907503
left join recruit_jdy_money k on neitui_person=f.user_username and bei_person=_widget_1532420226988
where f.user_username is not null and (if_two=0 or if_two is null) and f.user_username='${fr_username}'
group by a._widget_1532420226988)z
group by _widget_1545640907503

