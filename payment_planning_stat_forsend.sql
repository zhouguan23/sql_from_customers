select sales_parent,xz.sales_region,sum(paid) as paid,sum(planning_value_h)as planning_value_h from (
select pay_salesman,sales_region,sum(paid)paid,ifnull(planning_value_h,planning_value_e*0.80) AS planning_value_h
,sum(paid)/ifnull(planning_value_h,planning_value_e*0.80) as rate,type
from (
/*回款统计*/
select ifnull(dis_salesman,pay_salesman)as pay_salesman,sales_region
,sum(if(year(pay_enddate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(dis_percent,1)*pay_paid*f_amount,0)) paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year,type
from sale_payment 
join v_sale_contract_info_valid on pay_contract=ctr_id
left join /*业绩分配*/
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) 
and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) 
and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id

left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
join cust_company on com_id=ctr_company and com_country="中国"
join  /*全体销售包括离职的*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)salesman on sales_name=ifnull(dis_salesman,pay_salesman)
where  pay_verified = 'valid' 
and length(sales_region)>0 and sales_region  in (select area_region from hr_area where area_id<11)
and ((year(pay_enddate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and pay_enddate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
      )

group by ifnull(dis_salesman,pay_salesman),year

UNION/*外包*/
select  outspay_salesman,sales_region,-paid,year,type  from (
SELECT ifnull(dis_salesman,outspay_salesman)as outspay_salesman
,sum(if(year(outspay_paydate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(dis_percent,1)*outspay_paid,0)) paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
FROM `sale_outsource` a
left join v_sale_contract_info_valid b on outs_contract=ctr_id
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
inner join sale_opportunity c on ctr_id=opp_sign or ctr_agreement=opp_sign
inner join cust_company d on opp_company=com_id
left join sale_outsource_payment e on outs_id=outspay_outsource
left join (select distinct sales_name,sales_region from hr_salesman) f on ctr_salesman=sales_name
where ((year(outspay_paydate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and outspay_paydate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))))
and outs_status!="已作废" and com_country="中国"

group by ifnull(dis_salesman,outspay_salesman),year)a
join 
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on outspay_salesman=sales_name

union/*项目陈本*/
SELECT prj_salesman,sales_region,-sum(prj_cost)as prj_cost,prj_year,type FROM project_rentian
join/*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region
)sales on prj_salesman=sales_name
where prj_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))  and prj_month-month(LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))<=0  
group by prj_year,prj_salesman
)a 
join sale_planning on planning_name=pay_salesman and planning_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))
GROUP BY pay_salesman
ORDER BY paid DESC
)list_gr
JOIN/*小组组长和组员*/
(               /*普通小组*/
select sales_region,if(user_duty='区域经理',sales_name,sales_parent)sales_parent,sales_name 
from hr_salesman 
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name WHERE length(sales_parent)>0 and sales_name in (SELECT distinct dist_salesman a FROM dict_district where dist_country ='中国' union select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外')) 
and((user_duty<>'区域经理' and sales_parent not in (select area_salesman from hr_area where area_id<11)) or user_duty='区域经理')

UNION
               /*大区经理自己负责的小组*/
SELECT sales_region,sales_parent,sales_name
FROM 
( SELECT sales_name,count(sales_parent)cou,sales_parent,sales_region
	FROM `hr_salesman` 
	join hr_area on sales_region=area_region and area_id<11
	GROUP BY sales_name having count(sales_parent)=1)hr_salesman
join hr_area on area_salesman=sales_parent and area_id<11
join hr_user on user_username=sales_name and user_department='2'  and user_state='在职'  and user_username<>'public' and user_duty ='客户经理'

UNION           /*有组内成员的大区经理*/
SELECT area_region,area_salesman,area_salesman
from hr_area 
where area_region
in(SELECT distinct sales_region
FROM 
( SELECT sales_name,count(sales_parent)cou,sales_parent,sales_region
	FROM `hr_salesman` 
	join hr_area on sales_region=area_region and area_id<11
	GROUP BY sales_name having count(sales_parent)=1)hr_salesman
join hr_area on area_salesman=sales_parent and area_id<11
join hr_user on user_username=sales_name and user_department='2'  and user_state='在职'  and user_username<>'public' and user_duty ='客户经理')

ORDER BY sales_region,sales_parent,sales_name

)xz on sales_name=pay_salesman
GROUP BY sales_parent
ORDER BY paid DESC
LIMIT 10

select xz.sales_region,sales_parent,sum(amount) amount,sum(planning_value_e)as planning_value_e  from (
select sales_region,ctr_salesman,sum(amount)amount,planning_value_e ,
sum(amount)/planning_value_e as rate,type
from(


select sales_region,ctr_salesman, amount,type from(
select sales_region,ctr_salesman,sum(amount)amount,type from(
/*销售额*/
select ctr_salesman,sum(amount)amount,year
from(
SELECT ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1),0)) AS amount
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
FROM sale_contract_info
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = paid.pay_contract 
where (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))
group by ifnull(yj_salesman,ctr_salesman),year

union#已作废合同(当年签单当年作废才算是作废)
select ifnull(yj_salesman,ctr_salesman) as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1),0)) as amount
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_contract_info 
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
join cust_company on com_id=ctr_company and com_country='中国'
and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
group by year,ifnull(yj_salesman,ctr_salesman)

union#未作废合同中作废的财务记录
select ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*pay_bill*ifnull(f_amount,1),0)) as bill
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and pay_status in ("记坏账","已作废") 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))
group by year,ifnull(yj_salesman,ctr_salesman)

union#已作废合同中已回款的部分
select  ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*pay_paid*ifnull(f_amount,1),0)) as paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))
group by year,ifnull(yj_salesman,ctr_salesman)
)list group by ctr_salesman
)list
join 
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on ctr_salesman=sales_name
group by ctr_salesman
ORDER BY sales_region,ctr_salesman)new1


union
select  sales_region,outspay_salesman,-paid ,type from (
select ifnull(yj_salesman,ctr_salesman) as outspay_salesman
,sum(if(year(outs_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*outs_amount,0)) paid
,sales_region
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year,type
from sale_outsource
join v_sale_contract_info_valid on outs_contract=ctr_id
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
join  /*全体销售包括离职的*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)salesman on sales_name=ifnull(yj_salesman,ctr_salesman)
where (year(outs_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and outs_recdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
and outs_status!="已作废"
group by ifnull(yj_salesman,ctr_salesman),year
)new2

union
SELECT sales_region ,prj_salesman,prj_cost,type FROM(
SELECT sales_region ,prj_salesman,sum(-prj_cost)as prj_cost,type FROM project_rentian
join/*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region
)sales on prj_salesman=sales_name
where prj_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))  and prj_month-month(LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))<=0  
group by prj_year,prj_salesman)new3
)list
join sale_planning on planning_name=ctr_salesman and planning_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))
group by ctr_salesman
ORDER BY sum(amount) DESC
)gr_xs
JOIN/*小组组长和组员*/
(               /*普通小组*/
select sales_region,if(user_duty='区域经理',sales_name,sales_parent)sales_parent,sales_name 
from hr_salesman 
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name WHERE length(sales_parent)>0 and sales_name in (SELECT distinct dist_salesman a FROM dict_district where dist_country ='中国' union select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外')) 
and((user_duty<>'区域经理' and sales_parent not in (select area_salesman from hr_area where area_id<11)) or user_duty='区域经理')

UNION
               /*大区经理自己负责的小组*/
SELECT sales_region,sales_parent,sales_name
FROM 
( SELECT sales_name,count(sales_parent)cou,sales_parent,sales_region
	FROM `hr_salesman` 
	join hr_area on sales_region=area_region and area_id<11
	GROUP BY sales_name having count(sales_parent)=1)hr_salesman
join hr_area on area_salesman=sales_parent and area_id<11
join hr_user on user_username=sales_name and user_department='2'  and user_state='在职'  and user_username<>'public' and user_duty ='客户经理'

UNION           /*有组内成员的大区经理*/
SELECT area_region,area_salesman,area_salesman
from hr_area 
where area_region
in(SELECT distinct sales_region
FROM 
( SELECT sales_name,count(sales_parent)cou,sales_parent,sales_region
	FROM `hr_salesman` 
	join hr_area on sales_region=area_region and area_id<11
	GROUP BY sales_name having count(sales_parent)=1)hr_salesman
join hr_area on area_salesman=sales_parent and area_id<11
join hr_user on user_username=sales_name and user_department='2'  and user_state='在职'  and user_username<>'public' and user_duty ='客户经理')

ORDER BY sales_region,sales_parent,sales_name
)xz on sales_name=ctr_salesman
GROUP BY sales_parent
ORDER BY amount DESC
limit 10

select sales_region from hr_sales where sales_name='${fr_username}' limit 1

select sum(paid) paid,planning,a.sales_region from (
/*part 1 各区域上月回款*/
select ifnull(sum(paid)/10000,0) paid,sales_region from (
/*回款统计*/
select ifnull(dis_salesman,pay_salesman)as pay_salesman,sales_region
,sum(if(year(pay_enddate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(dis_percent,1)*pay_paid*f_amount,0)) paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment 
join v_sale_contract_info_valid on pay_contract=ctr_id
left join /*业绩分配*/
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) 
and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) 
and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id

left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
join cust_company on com_id=ctr_company and com_country="中国"
join  /*全体销售包括离职的*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)salesman on sales_name=ifnull(dis_salesman,pay_salesman)
where  pay_verified = 'valid' 
and length(sales_region)>0 and sales_region  in (select area_region from hr_area where area_id<11)
and ((year(pay_enddate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and pay_enddate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
      )

group by ifnull(dis_salesman,pay_salesman),year
)new1
group by sales_region

union
/*part 2 各区域上月外包*/
select ifnull(-sum(paid)/10000,0) paid ,sales_region from (
SELECT ifnull(dis_salesman,outspay_salesman)as outspay_salesman
,sum(if(year(outspay_paydate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(dis_percent,1)*outspay_paid,0)) paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
FROM `sale_outsource` a
left join v_sale_contract_info_valid b on outs_contract=ctr_id
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
inner join sale_opportunity c on ctr_id=opp_sign or ctr_agreement=opp_sign
inner join cust_company d on opp_company=com_id
left join sale_outsource_payment e on outs_id=outspay_outsource
left join (select distinct sales_name,sales_region from hr_salesman) f on ctr_salesman=sales_name
where ((year(outspay_paydate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and outspay_paydate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))))
and outs_status!="已作废" and com_country="中国"

group by ifnull(dis_salesman,outspay_salesman),year)a
join 
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on outspay_salesman=sales_name
group by sales_region


union
/*part 3 各区域上月项目实施成本*/
select ifnull(-sum(prj_cost)/10000,0)prj_cost,sales_region from (
SELECT prj_year,prj_salesman,sum(prj_cost)as prj_cost,sales_region FROM project_rentian
join/*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region
)sales on prj_salesman=sales_name
where prj_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))  and prj_month-month(LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))<=0  group by prj_year,prj_salesman
)prj_list
group by sales_region
)a 

join /*各区域回款任务*/
(select sum(planning)planning, sales_region from (
SELECT sum(planning_value_h)/10000 as planning, sales_region FROM sale_planning
join /*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on planning_name=sales_name
WHERE planning_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))
GROUP BY sales_region
UNION/*未分配*/
select planning_weifenpei_h/10000 weifenpei ,planning_region
from sale_planning_of_region where planning_year =YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and planning_weifenpei>0
)list GROUP BY sales_region
)planning on a.sales_region=planning.sales_region
group by a.sales_region
ORDER BY paid DESC

select * from (
/*依照rate排序*/
SELECT
  @rownum:=@rownum+1 AS rownum,gr_rate_order.*
FROM (SELECT
        @rownum:=0) r,

(
select pay_salesman,sales_region,sum(paid)paid,ifnull(planning_value_h,planning_value_e*0.80) AS planning_value_h
,sum(paid)/ifnull(planning_value_h,planning_value_e*0.80) as rate,type
from (
/*回款统计*/
select ifnull(dis_salesman,pay_salesman)as pay_salesman,sales_region
,sum(if(year(pay_enddate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(dis_percent,1)*pay_paid*f_amount,0)) paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year,type
from sale_payment 
join v_sale_contract_info_valid on pay_contract=ctr_id
left join /*业绩分配*/
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) 
and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) 
and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id

left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
join cust_company on com_id=ctr_company and com_country="中国"
join  /*全体销售包括离职的*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)salesman on sales_name=ifnull(dis_salesman,pay_salesman)
where  pay_verified = 'valid' 
and length(sales_region)>0 and sales_region  in (select area_region from hr_area where area_id<11)
and ((year(pay_enddate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and pay_enddate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
      )

group by ifnull(dis_salesman,pay_salesman),year

UNION/*外包*/
select  outspay_salesman,sales_region,-paid,year,type  from (
SELECT ifnull(dis_salesman,outspay_salesman)as outspay_salesman
,sum(if(year(outspay_paydate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(dis_percent,1)*outspay_paid,0)) paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
FROM `sale_outsource` a
left join v_sale_contract_info_valid b on outs_contract=ctr_id
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
inner join sale_opportunity c on ctr_id=opp_sign or ctr_agreement=opp_sign
inner join cust_company d on opp_company=com_id
left join sale_outsource_payment e on outs_id=outspay_outsource
left join (select distinct sales_name,sales_region from hr_salesman) f on ctr_salesman=sales_name
where ((year(outspay_paydate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and outspay_paydate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))))
and outs_status!="已作废" and com_country="中国"

group by ifnull(dis_salesman,outspay_salesman),year)a
join 
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on outspay_salesman=sales_name

union/*项目陈本*/
SELECT prj_salesman,sales_region,-sum(prj_cost)as prj_cost,prj_year,type FROM project_rentian
join/*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region
)sales on prj_salesman=sales_name
where prj_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))  and prj_month-month(LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))<=0  
group by prj_year,prj_salesman
)a 
join sale_planning on planning_name=pay_salesman and planning_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))
GROUP BY pay_salesman
ORDER BY rate DESC
)gr_rate_order

)a ORDER BY paid DESC
${if(len(lim)=0,"","limit "+lim)}

select * from (
/*依照rate排序*/
SELECT
  @rownum:=@rownum+1 AS rownum,list.*
FROM (SELECT
        @rownum:=0) r,

(
select sales_region,ctr_salesman,sum(amount)amount,planning_value_e ,
sum(amount)/planning_value_e as rate,type
from(


select sales_region,ctr_salesman, amount,type from(
select sales_region,ctr_salesman,sum(amount)amount,type from(
/*销售额*/
select ctr_salesman,sum(amount)amount,year
from(
SELECT ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1),0)) AS amount
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
FROM sale_contract_info
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = paid.pay_contract 
where (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))
group by ifnull(yj_salesman,ctr_salesman),year

union#已作废合同(当年签单当年作废才算是作废)
select ifnull(yj_salesman,ctr_salesman) as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1),0)) as amount
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_contract_info 
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
join cust_company on com_id=ctr_company and com_country='中国'
and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
group by year,ifnull(yj_salesman,ctr_salesman)

union#未作废合同中作废的财务记录
select ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*pay_bill*ifnull(f_amount,1),0)) as bill
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and pay_status in ("记坏账","已作废") 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))
group by year,ifnull(yj_salesman,ctr_salesman)

union#已作废合同中已回款的部分
select  ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*pay_paid*ifnull(f_amount,1),0)) as paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))
group by year,ifnull(yj_salesman,ctr_salesman)
)list group by ctr_salesman
)list
join 
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on ctr_salesman=sales_name
group by ctr_salesman
ORDER BY sales_region,ctr_salesman)new1


union
select  sales_region,outspay_salesman,-paid ,type from (
select ifnull(yj_salesman,ctr_salesman) as outspay_salesman
,sum(if(year(outs_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*outs_amount,0)) paid
,sales_region
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year,type
from sale_outsource
join v_sale_contract_info_valid on outs_contract=ctr_id
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
join  /*全体销售包括离职的*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)salesman on sales_name=ifnull(yj_salesman,ctr_salesman)
where (year(outs_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and outs_recdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
and outs_status!="已作废"
group by ifnull(yj_salesman,ctr_salesman),year
)new2

union
SELECT sales_region ,prj_salesman,prj_cost,type FROM(
SELECT sales_region ,prj_salesman,sum(-prj_cost)as prj_cost,type FROM project_rentian
join/*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region
)sales on prj_salesman=sales_name
where prj_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))  and prj_month-month(LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))<=0  
group by prj_year,prj_salesman)new3
)list
join sale_planning on planning_name=ctr_salesman and planning_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))
group by ctr_salesman
ORDER BY sum(amount)/planning_value_e DESC
)list
)order_by_rate
ORDER BY amount DESC
${if(len(lim)=0,"","limit "+lim)}

select list.sales_region,sum(amount)/10000 amount,planning/10000  as planning_value_e 
from(


select sales_region,ctr_salesman, ifnull(amount,0) as amount from(
select sales_region,ctr_salesman,sum(amount)amount from(
/*销售额*/
select ctr_salesman,sum(amount)amount,year
from(
SELECT ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1),0)) AS amount
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
FROM sale_contract_info
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = paid.pay_contract 
where (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))
group by ifnull(yj_salesman,ctr_salesman),year

union#已作废合同(当年签单当年作废才算是作废)
select ifnull(yj_salesman,ctr_salesman) as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1),0)) as amount
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_contract_info 
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
join cust_company on com_id=ctr_company and com_country='中国'
and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
group by year,ifnull(yj_salesman,ctr_salesman)

union#未作废合同中作废的财务记录
select ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*pay_bill*ifnull(f_amount,1),0)) as bill
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and pay_status in ("记坏账","已作废") 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))
group by year,ifnull(yj_salesman,ctr_salesman)

union#已作废合同中已回款的部分
select  ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(if(year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*pay_paid*ifnull(f_amount,1),0)) as paid
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 
and (year(ctr_signdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and ctr_signdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))
group by year,ifnull(yj_salesman,ctr_salesman)
)list group by ctr_salesman
)list
join 
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on ctr_salesman=sales_name
group by ctr_salesman
ORDER BY sales_region,ctr_salesman)new1


union
select  sales_region,outspay_salesman,-paid  from (
select ifnull(yj_salesman,ctr_salesman) as outspay_salesman
,sum(if(year(outs_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)),ifnull(yj_percent,1)*outs_amount,0)) paid
,sales_region
,YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) AS year
from sale_outsource
join v_sale_contract_info_valid on outs_contract=ctr_id
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company and com_country='中国'
join  /*全体销售包括离职的*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)salesman on sales_name=ifnull(yj_salesman,ctr_salesman)
where (year(outs_recdate)=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and outs_recdate<=LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month))) 
and outs_status!="已作废"
group by ifnull(yj_salesman,ctr_salesman),year
)new2

union
SELECT sales_region ,prj_salesman,prj_cost FROM(
SELECT sales_region ,prj_salesman,sum(-prj_cost)as prj_cost FROM project_rentian
join/*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region
)sales on prj_salesman=sales_name
where prj_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))  and prj_month-month(LAST_DAY(DATE_SUB(curdate(),INTERVAL 1 month)))<=0  
group by prj_year,prj_salesman)new3
)list


join /*各区域回款任务*/
(select sum(planning)planning, sales_region from (
SELECT sum(planning_value_e) as planning, sales_region FROM sale_planning
join /*全体销售*/
(select DISTINCT sales_name,sales_region,turn,type from (
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,1 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name and user_state <> '离职'
/**/
union
SELECT DISTINCT sales_name,sales_region,if(enter_turn='是',1,0) AS turn,0 as type FROM hr_salesman
LEFT JOIN hr_salesman_enter ON enter_user = sales_name JOIN hr_user on user_username = sales_name 
WHERE length(sales_parent)>0 and 
sales_name in (select distinct user_username a from hr_user,hr_salesman where sales_name=user_username and user_state="离职" 
and ifnull(year(user_leaveDate),2016)>=YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and sales_region not in('台湾','日本','海外'))
)sales where sales_region not in ("韩国","日本","台湾","英文区")
order by sales_region)sales on planning_name=sales_name
WHERE planning_year=YEAR(DATE_SUB(curdate(),INTERVAL 1 month))
GROUP BY sales_region
UNION/*未分配*/
select planning_weifenpei weifenpei ,planning_region
from sale_planning_of_region where planning_year =YEAR(DATE_SUB(curdate(),INTERVAL 1 month)) and planning_weifenpei>0
)list GROUP BY sales_region
)planning on list.sales_region=planning.sales_region
group by list.sales_region
ORDER BY sum(amount) DESC

