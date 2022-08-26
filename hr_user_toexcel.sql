SELECT *,if(user_team=0,null,user_team)user_team_1,if(user_type='实习生' and user_is_wp_sxs=1,"实习生-外聘",user_type) user_type_2
,IFNULL(user_regularDate,DATE_ADD(v.user_firstConventionDate,INTERVAL 6 month))regularDate,
TIMESTAMPDIFF(MONTH,v.user_firstConventionDate,user_leaveDate) AS duration,
IF(ISNULL(user_leaveDate),
TIMESTAMPDIFF(MONTH,v.user_firstConventionDate ,curdate()),
TIMESTAMPDIFF(MONTH,v.user_firstConventionDate,user_leaveDate)) AS siling,
if(t.tag_industry_id=0,null,t.tag_industry_id)tag_industry_id,if(t.tag_product_id=0,null,t.tag_product_id)tag_product_id,if(t.tag_region_id=0,null,t.tag_region_id)tag_region_id ,dept_id,pc,user_team  as team_name1,concat(detail_getname,"-",left(detail_id,3)) showid 
FROM hr_user left join v_hr_contract v on user_username = hr_ctr_user
left join hr_recruit_detail on user_resumeid=detail_id
LEFT JOIN project_members ON prj_user=user_username
LEFT JOIN hr_user_tags t ON user_username=t.tag_username
LEFT JOIN hr_department on user_department=dept_id or user_department=dept_name
LEFT JOIN hr_department_team  ON prj_team=team_id
left join(SELECT concat(provinces,',',citys)pc,provinces,citys FROM dict_region where priority=2 union 
SELECT provinces,provinces,provinces FROM dict_region where priority=1)cs on SUBSTRING_INDEX(user_native,',',-1)=citys
where  dept_id<>'18' and 1=1
${if(len(dept)=0,"","and user_department in ('"+dept+"')")}
${if(len(keys)=0,""," and (user_username like '%"+keys+"%' or user_name like '%"+keys+"%')")}
${if(len(wei)=0,""," and user_group_weituo in ("+wei+")")}
${if(len(shou)=0,""," and user_group_shoutuo in ("+shou+")")}
${if(len(sex)=0,""," and user_sex in ('"+sex+"')")}
${if(len(province)=0,""," and left(user_cardNo,6) in (select left(idno,6) from dict_idno where province in('"+province+"'))")}
${if(len(city)=0,""," and left(user_cardNo,6) in (select idno from dict_idno where city in ('"+city+"'))")}
${if(len(district)=0,""," and left(user_cardNo,6) in (select idno from dict_idno where district in ('"+district+"'))")}
${if(len(zhanghao)=0,""," and is_leave in ('"+zhanghao+"')")}
${if(len(type)=0,"","and user_type in ('"+type+"')")}
${if(len(state)=0,"","and user_state in ('"+state+"')")}
${if(len(starttime)=0,""," and (user_entrydate >= '"+starttime+"' or user_transform_date >= '"+starttime+"'  )")}
${if(len(endtime)=0,""," and (user_entrydate <= '"+endtime+"' or user_transform_date <= '"+endttime+"'  )")}
union
SELECT *,if(user_team=0,null,user_team)user_team_1,if(user_type='实习生' and user_is_wp_sxs=1,"实习生-外聘",user_type) user_type_2
,IFNULL(user_regularDate,DATE_ADD(v.user_firstConventionDate,INTERVAL 6 month))regularDate,
TIMESTAMPDIFF(MONTH,v.user_firstConventionDate,user_leaveDate) AS duration,
IF(ISNULL(user_leaveDate),
TIMESTAMPDIFF(MONTH,v.user_firstConventionDate ,curdate()),
TIMESTAMPDIFF(MONTH,v.user_firstConventionDate,user_leaveDate)) AS siling,
if(t.tag_industry_id=0,null,t.tag_industry_id)tag_industry_id,if(t.tag_product_id=0,null,t.tag_product_id)tag_product_id,if(t.tag_region_id=0,null,t.tag_region_id)tag_region_id ,dept_id,pc,team_name as team_name1,concat(detail_getname,"-",left(detail_id,3)) showid 
FROM hr_user left join v_hr_contract v on user_username = hr_ctr_user
left join hr_recruit_detail on user_resumeid=detail_id
LEFT JOIN project_members ON prj_user=user_username
LEFT JOIN hr_user_tags t ON user_username=t.tag_username
LEFT JOIN hr_department on user_department=dept_id or user_department=dept_name
LEFT JOIN hr_department_team  ON prj_team=team_id
left join(SELECT concat(provinces,',',citys)pc,provinces,citys FROM dict_region where priority=2 union 
SELECT provinces,provinces,provinces FROM dict_region where priority=1)cs on SUBSTRING_INDEX(user_native,',',-1)=citys
where  dept_id='18' and 1=1
${if(len(dept)=0,"","and user_department in ('"+dept+"')")}
${if(len(keys)=0,""," and (user_username like '%"+keys+"%' or user_name like '%"+keys+"%')")}
${if(len(wei)=0,""," and user_group_weituo in ("+wei+")")}
${if(len(shou)=0,""," and user_group_shoutuo in ("+shou+")")}
${if(len(zhanghao)=0,""," and is_leave in ('"+zhanghao+"')")}
${if(len(province)=0,""," and left(user_cardNo,6) in (select left(idno,6) from dict_idno where province in('"+province+"'))")}
${if(len(city)=0,""," and left(user_cardNo,6) in (select idno from dict_idno where city in ('"+city+"'))")}
${if(len(district)=0,""," and left(user_cardNo,6) in (select idno from dict_idno where district in ('"+district+"'))")}
${if(len(sex)=0,""," and user_sex in ('"+sex+"')")}
${if(len(type)=0,"","and user_type in ('"+type+"')")}
${if(len(state)=0,"","and user_state in ('"+state+"')")}
${if(len(starttime)=0,""," and (user_entrydate >= '"+starttime+"' or user_transform_date >= '"+starttime+"'  )")}
${if(len(endtime)=0,""," and (user_entrydate <= '"+endtime+"' or user_transform_date <= '"+endttime+"'  )")}

select concat(province,',',city,',',ifnull(district,''))origin,idno from dict_idno

select user_name,user_username,user_firstConventionDate,
DATE_ADD(user_firstConventionDate,INTERVAL years+modi-1 year)  startdate,
DATE_ADD(user_firstConventionDate,INTERVAL years+modi year)  enddate,
years+modi cycles,

if(years+modi=1,3,if(years+modi+4>=20,20,years+modi+4))days from (

select user_name,user_username,user_firstConventionDate,date,year(date)-year(user_firstConventionDate) years
,if(DATE_FORMAT(date,'%m%d')>=DATE_FORMAT(user_firstConventionDate,'%m%d'),1,0) modi
from (
	SELECT user_id,user_name,user_username,	v.user_firstConventionDate
	FROM	hr_user JOIN v_hr_contract v ON user_username = hr_ctr_user
)hr_user 
CROSS join (select DATE_ADD(CURDATE(),INTERVAL 0 year) date) d 
where  user_firstConventionDate is not null 

)ud where years+modi>0

select user,'病假' type,sum(if(allow<=0,times,if(allow>=times,0,times-allow)))days from(
		SELECT t.`user`,t.y,t.m
		,cast(t.times/2 as dec(5,1)) times
		,u.user_name,u.user_sex
		,if(user_sex='女',1,0.5)-cast(t.lasttime/2 as dec(5,1))allow 
		from (
				select 
				this.* ,ifnull(lastmonth.times,0)lasttime from
				(
						select `user`,year(DATE_ADD(`day`,INTERVAL 3 day)) y, month(DATE_ADD(`day`,INTERVAL 3 day))m,count(out_type)times  from hr_time 
						where out_type=1 and user='${u}' and `day` BETWEEN '${start}' and  '${end}'	and ifnull(verify,'false')<>'true'
						GROUP BY `user`,y, m
				)this/*当前周期每月病假天数*/
				LEFT JOIN 
				(
						select `user`,year(DATE_ADD(`day`,INTERVAL 3 day)) y, month(DATE_ADD(`day`,INTERVAL 3 day))m,count(out_type)times  from hr_time 
						where out_type=1 and user='${u}' 
						and `day` BETWEEN DATE_ADD(
DATE_ADD('${start}',INTERVAL 3 day),INTERVAL -day(DATE_ADD('${start}',INTERVAL 3 day))-2 day) and  DATE_ADD('${start}',INTERVAL -1 day)
						and ifnull(verify,'false')<>'true'
				)lastmonth /*上个周期最后一个月病假天数*/
				on this.`user`=lastmonth.`user`  and this.y=lastmonth.y and this.m=lastmonth.m
		)t 
		left join hr_user u on t.user=u.user_username
		order by `user`,y,m
)list group by user
union 
select `user`,'事假',cast(count(out_type)/2 as dec(5,1)) times
from hr_time 
where out_type=2
and user='${u}' 
and `day` BETWEEN '${start}' and  '${end}'
GROUP BY `user`

select * from hr_recruit_school

SELECT * FROM `hr_department_team`
 where team_department  ='${D4}'
order by team_verified desc,team_paixu,team_id

select 1 id,'停用' name union select 0,'启用' name

select group_id,group_name from hr_group where group_verified='valid'

SELECT * FROM hr_user_tags_new 

