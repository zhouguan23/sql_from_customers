select distinct area_region from hr_area where area_id<12

select sales_parent,sales_region,concat(sales_region,'-',sales_parent,'组')p from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade 
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3
${if(len(region)=0,"and 1=2","and sales_region in( '"+region+"') ")}

select *  
from
/*新销售取数*/ 
(select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade 
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3)sales
INNER JOIN
(/*考核标准*/
select parent,type_sales_examine,type_sales_examine_standard  from dict_type a
join (SELECT type_id,type_sales_examine parent  FROM dict_type  WHERE type_id<5)list on list.type_id=type_sales_examine_parent
where a.type_id BETWEEN 5 and 15)standard
where 1=1
${if(len(region)=0,"","and sales_region in( '"+region+"') ")}
${if(len(parent)=0,"","and sales_parent in( '"+parent+"') ")}

select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade 
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3

${if(len(region)=0,"and 1=2","and sales_region in( '"+region+"') ")}
${if(len(parent)=0,"and 1=2","and sales_parent in( '"+parent+"') ")}
order by sales_region,sales_parent

/*a_电话营销*/
select user_username,cont_id,trace_id,valid_trace 
from(
select user_username,enter_area_date,cont_id,trace_id,trace_detail,if(length(trace_detail)>=150,1,0)valid_trace,trace_recdate
from
/*新销售取数*/ 
(select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region,enter_area_date from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade ,enter_area_date
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn,e.enter_area_date
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3)sales
join cust_trace on trace_recorder=user_username and trace_action='电话'   and trace_recdate>=enter_area_date 
and length(trace_detail)>30 and trace_detail not REGEXP('关机'|'错号'|'空号'|'无人接听')/*一个中文是3个字节*/
JOIN cust_contact on cont_id=trace_contact and cont_verified='valid'
order by user_username,cont_id,length(trace_detail) desc
)list 
GROUP BY user_username,cont_id
${if(len(p)=0,"having 1=2","")}

select distinct user_username sales,com_id
from
/*新销售取数*/ 
(select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region,enter_area_date from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade ,enter_area_date
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn,e.enter_area_date
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3)sales
join cust_company on com_salesman=user_username and com_verified='valid'
join sale_opportunity on opp_company=com_id and opp_verified='valid'
order by user_username,com_id

/*新销售跟进客户数*/
select user_username sales,com_id,if(com_follow_level=1,1,0)zd
from
/*新销售取数*/ 
(select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region,enter_area_date from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade ,enter_area_date
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn,e.enter_area_date
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3)sales
join cust_company on com_salesman=user_username and com_verified='valid' AND com_status='跟进' 

SELECT user_username,com_id,if((select count(trace_id) from cust_trace where trace_company=com_id and trace_recdate>=enter_area_date and trace_detail REGEXP "陌拜")>0,1,0)trace
,if(com_status='跟进',1,0)gj
from
/*新销售取数*/ 
(select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region,enter_area_date from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade ,enter_area_date
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn,e.enter_area_date
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3)sales 
join cust_company on com_salesman=user_username and  com_source='自主开发' and com_verified='valid'


/*客户拜访次数：客户视图——商务行为：会议或演示或接待或培训或服务或调研或方案或催款*/
SELECT 
user_username
,IF(trace_action IN("会议","演示","接待","培训","服务","调研","方案","催款"),1,0)bf
,IF(trace_action="演示",1,0)jl
,IF(trace_action in("餐饮","服务"),1,0)fw
from
/*新销售取数*/ 
(select user_username,concat(user_username,'-',user_name)user_name,sales_parent,sales_region,enter_area_date from ( 
select user_username,user_name,ifnull(sales_parent,'其他')sales_parent,sales_region,enter_turn
,case when node = 0 then 0 when sales_region in('日本','海外','英文区') then 0 
when user_duty='大区经理' then 1  when user_duty='区域经理' then 2  when user_duty='客户经理' then 3 else 0 end grade ,enter_area_date
from (
select u.user_username,u.user_name,u.user_type,u.user_duty,a.sales_id,a.sales_name,a.sales_parent,ifnull(a.sales_region,(SELECT intent_value FROM `hr_sales_intent_region`where intent_name=u.user_username))sales_region
,ifnull(e.enter_turn,'否')enter_turn,e.enter_area_date
,d.dist_region ,case when a.sales_name is null then 0 when a.sales_name=c.sales_name then 1 when b.sales_name=c.sales_name then 2 ELSE 3 end node
from hr_user u 
left join hr_salesman a on u.user_username=a.sales_name and a.sales_region in (select area_region from hr_area where area_id<=11)
LEFT JOIN hr_salesman  b on a.sales_parent= b.sales_name and b.sales_region in (select area_region from hr_area where area_id<=11) 
LEFT JOIN hr_salesman  c on b.sales_parent= c.sales_name and c.sales_region in (select area_region from hr_area where area_id<=11)
left join dict_district d on  u.user_username=d.dist_salesman
left join hr_salesman_enter e  on u.user_username=e.enter_user
where user_department='2'  and user_state='在职'  and user_username<>'public' order by  node desc ,user_username)grades
join hr_area on area_region=sales_region and area_id<12
where enter_turn='否' and user_username not in('Bean','kevin','channel')
group by  user_username order by sales_region,user_username asc)a 
where sales_parent<>'其他' and grade=3)sales 
join cust_trace on trace_recorder=user_username and trace_action IN("会议","演示","接待","培训","服务","调研","方案","催款","演示","餐饮","服务") and trace_recdate>=enter_area_date
where 1=1
${if(len(p)=0,"and 1=2","")}

