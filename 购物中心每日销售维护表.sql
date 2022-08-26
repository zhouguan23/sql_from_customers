 select a.NodeCode,a.nodename,a.CategoryCode ,a.defday,b.Salesindex,b.Grossprofitindex from 
 (select a.NodeCode,a.nodename,a.CategoryCode ,b.defday from 
 (select NodeCode, nodename,'800'CategoryCode   from 
TB部门信息表 a 
where nodecode='5001'
UNION ALL 
select NodeCode, nodename,'805'CategoryCode   from 
TB部门信息表 a 
where nodecode='5001')a
,
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),'${qsrq}',112)),112)defday
from master..spt_values 
where type='p' and number <= datediff(dd,convert(varchar(8),'${qsrq}',112),convert(varchar(8),'${jsrq}',112)))b

)a
 left join 
dbo.购物中心手工进帐日合计 b on  a.NodeCode =b.DeptCode and a.defday=b.defday and a.CategoryCode=b.CategoryCode
order by 1,3,4


