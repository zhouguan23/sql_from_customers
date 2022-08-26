with t1 as -- 今日数据
(select * from f_mkt_data_check  where credate = curdate()
),
t2 as    -- 昨日数据
(select * from f_mkt_data_check  where credate = date_add(curdate(), interval -1 day)
),

t3 as(  -- 今日认购金额都小于昨天的分期
select concat(t1.PROJECTNAME,t2.PERIODNAME) proj, t1.orderamount torderamount, t2.orderamount yorderamount
from t1 left join t2 on t1.periodid = t2.periodid
where t2.orderamount-t1.orderamount >20000000
),

t4 as( -- 今日减少的分期
select concat(t2.PROJECTNAME,t2.PERIODNAME) proj
from t2 left join t1 on t1.periodid = t2.periodid
where t1.periodid is null
) 

select 
(select count(1) from t3)+(select count(1) from t4) num

