
 select *,row_number() over (order by defday)xh from 
 (select a.NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')  nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )a
,

(


select convert(varchar(10),dateadd(dd,number,convert(varchar(8),'${qsrq}',112)),112)defday
from master..spt_values 
where type='p' and number <= datediff(dd,convert(varchar(8),'${qsrq}',112),convert(varchar(8),'${jsrq}',112)))c
where 1=1 ${if(len(bm) == 0,   "","and nodecode in ('" + replace(bm,",","','")+"')") }
 
order by 1,3


 select a.NodeCode,a.nodename,a.defday,b.Salesindex,b.Grossprofitindex from 
 (select a.NodeCode,a.nodename,b.defday from 
 (select NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')  nodename   from 
TB部门信息表 a )a
,
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),'${qsrq}',112)),112)defday
from master..spt_values 
where type='p' and number <= datediff(dd,convert(varchar(8),'${qsrq}',112),convert(varchar(8),'${jsrq}',112)))b

where 1=1 ${if(len(bm) == 0,   "","and nodecode in ('" + replace(bm,",","','")+"')") }
)a
 left join 
dbo.每日预算表 b on  a.NodeCode =b.DeptCode and a.defday=b.defday
order by 1,3




select BudgetYM,DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex
,row_number() over (order by BudgetYM)xh
 from dbo.含税分课预算表 a 
 
 where BudgetYM  = convert(varchar(6),'${jsrq}',112) and CategoryItemCode='0000'
 and 1=1 ${if(len(bm) == 0,   "","and deptcode in ('" + replace(bm,",","','")+"')") }
 group by BudgetYM,deptcode



