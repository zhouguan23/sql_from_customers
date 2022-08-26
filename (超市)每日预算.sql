
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



select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601) 

