select * from(select com_id,com_name,com_province,com_city,com_salesman,com_status,com_priority,com_recdate,com_key,com_tags,
ifnull(bm_guwen,(select area_presales from hr_presales join hr_area on pres_region = area_region where pres_name =com_presales limit 1))guwen,case com_status when '合作'then ifnull(bm_mark,'0') else -1 end mark ,
tags_code,tags_name,trace_recorder,trace_recdate,trace_detail,hangye_comname,task.task_id,task.task_action,task_predate
from (
select * from cust_company where (com_status='合作' or com_tags regexp 'H')and com_verified = 'valid'
${if(len(province)=0,""," and com_province in('"+province+"')")}
${if(len(city)=0,""," and com_city in('"+city+"')")}
${if(len(salesman)=0,""," and com_salesman  in ('"+salesman+"')")}
${if(len(status)=0,""," and com_status in ('"+status+"')")}
${if(len(tag)=0,""," and concat(',',com_tags,',') regexp ',"+tag+",'")}
 )cust_company
LEFT JOIN cust_benchmark on com_id=bm_company 
LEFT JOIN (select * from dict_tags where tags_code like '%H%'
${if(len(tag)=0,""," and tags_code like '%"+tag+"%'")})t on concat(com_tags,',') regexp concat(tags_code,',') 

left join
(select * from(
select trace_company ,trace_recdate,trace_recorder,trace_detail from cust_trace
where trace_recorder in (select user_username from  hr_user LEFT JOIN hr_user_tags on user_username = tag_username left join hr_tags on tag_industry_id =  tags_id LEFT JOIN hr_hangye on user_username=hangye_user left join hangye_tag_code on tag_industry_id=tagid
where user_department =3 and user_state='在职' and ifnull(tags_name,'')<>'')
${if(len(date1)=0,""," and date(trace_recdate)>= ('"+date1+"')")}
${if(len(date2)=0,""," and date(trace_recdate)<= ('"+date2+"')")}
${if(len(action)=0,""," and trace_action in ('"+action+"')")}
order by trace_company,trace_recdate desc)list1

group by trace_company 
)tc on trace_company=com_id 

left join hangye_guanlian AS hg ON crm_comid = com_id
LEFT JOIN hangye_daoru AS hd ON hd.hangye_id = hg.hangye_id
left join (
SELECT * FROM cust_task
where task_predate > CURDATE()
and task_status = '待办'
group by task_company,task_actor
order by task_company,task_actor,task_predate desc)task on task.task_company=com_id and task.task_actor =bm_guwen
where 1=1
/*ifnull(bm_mark,'0')<=0*/
${if(len(weilianluo)>0,"and ifnull(trace_detail,'')=''","and ifnull(trace_detail,'')<>''")}

order by com_id,trace_recdate desc
)ordered
group by com_id
order by trace_recdate desc


select distinct tagcode tags_code,tags_name from  hr_user 
LEFT JOIN hr_user_tags on user_username = tag_username
left join hr_tags on tag_industry_id =  tags_id
LEFT JOIN hr_hangye on user_username=hangye_user
left join hangye_tag_code on tag_industry_id=tagid
where user_department =3 
and user_state='在职'
and ifnull(tags_name,'')<>''
ORDER BY hangye_grade,user_username


select '合作' id,'合作' name union
select '跟进','跟进' union
select '潜在','潜在' union
select '尚未联络','尚未联络'

select distinct dist_province from dict_district

select distinct dist_salesman from dict_district

select distinct dist_city from dict_district where  dist_province in('${province}')

select type_trace from dict_type

