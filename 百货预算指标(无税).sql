select BudgetYM,DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex
 from dbo.无税分课预算表 a 
 
 where BudgetYM  between  convert(varchar(6),'${qsrq}',112) and  convert(varchar(6),'${jsrq}',112)
 and 1=1 
 
${if(len(bm) == 0,"","and DeptCode in (" + bm + ")")} 

 group by BudgetYM,deptcode,CategoryCode


declare @date1 varchar(10),
        @date2 varchar(10)
set @date1 = '${qsrq}'+'01'
set @date2 = '${jsrq}'+'01'
 select * from 
 (select a.NodeCode,replace(replace(replace(replace(replace(replace(nodename,'合力' ,''),'中天' ,''),'亿足鞋业' ,'百货') ,'一店' ,'二店') ,'修文店' ,'修文二店'),'百货' ,'') nodename  
   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) = 9
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) )a
,

(select  CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from [000]A .TBGOODSCATEGORY where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641) )b ,
(


select convert(varchar(6),cast(ltrim(year(@date1)) + '-'+ ltrim(number) + '-01' as datetime),112) YM 
from master..spt_values where type = 'p' and number between month(@date1) and month(@date2))c
where 1=1 
 
${if(len(bm) == 0,"","and nodecode in (" + bm + ")")} 

 
order by 1,3,5

select a.NodeCode,replace(replace(replace(replace(replace(replace(nodename,'合力' ,''),'中天' ,''),'亿足鞋业' ,'百货') ,'一店' ,'二店') ,'修文店' ,'修文二店'),'百货' ,'') nodename  
   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) = 9
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)

