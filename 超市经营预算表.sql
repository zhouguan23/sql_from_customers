
select ParentCategoryCode,a.CategoryCode ,a.CategoryName,LEFT(YM,4) YEAR,
 CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
,YM month,AreaCode,a.NodeCode DeptCode ,b.Salesindex,b.Grossprofitindex,
round(case when a.CategoryCode in (11,13,14) then b.Salesindex/1.1 when a.CategoryCode in (10,12) then b.Salesindex/1  when a.CategoryCode in (640) then b.Salesindex/1.06  else b.Salesindex/1.16 end,2) TaxSalesindex,
round(case when a.CategoryCode in (11,13,14) then (b.Salesindex/1.1)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 when a.CategoryCode in (10,12) then (b.Salesindex/1.0)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 when a.CategoryCode in (640) then (b.Salesindex/1.06)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 else b.Salesindex/1.16*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) end,2) TaxGrossprofitindex from 
(select ParentCategoryCode,CategoryCode ,CategoryName,YM,a.AreaCode,a.NodeCode  from 
(select  b.AreaCode,b.NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and CategoryCode<>29   and CategoryCode<>19 
and left(b.NodeCode,1) between 1 and 2
and 1=1 ${if(lx<>'0001',   "",   "and CategoryCode in (30,40,46,50)") } 
and 1=1 ${if(lx<>'0002',   "",   "and CategoryCode in (20,21,22,23)") } 
union all 

select  b.AreaCode,b.NodeCode ,ParentCategoryCode,CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from dbo.TB商品分类表 a,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641)
and b.NodeCode like '9%'

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[含税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='${lx}'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,'店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流')+case when convert(varchar(8),dateadd(YY,1,OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '(新店)' else '' end   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") } 
and left(nodecode,1) between 1 and 2
union all 
select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,'店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流')+case when convert(varchar(8),dateadd(YY,1,OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '(新店)' else '' end   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'店' ,'百货店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") } 
and left(nodecode,1) =9


select ParentCategoryCode,a.CategoryCode ,a.CategoryName,LEFT(YM,4) YEAR,
 CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
,YM month,AreaCode,a.NodeCode DeptCode ,b.Salesindex,b.Grossprofitindex,
round(case when a.CategoryCode in (11,13,14) then b.Salesindex/1.1 when a.CategoryCode in (10,12) then b.Salesindex/1  when a.CategoryCode in (640) then b.Salesindex/1.06  else b.Salesindex/1.16 end,2) TaxSalesindex,
round(case when a.CategoryCode in (11,13,14) then (b.Salesindex/1.1)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 when a.CategoryCode in (10,12) then (b.Salesindex/1.0)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 when a.CategoryCode in (640) then (b.Salesindex/1.06)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 else b.Salesindex/1.16*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) end,2) TaxGrossprofitindex from 
(select ParentCategoryCode,CategoryCode ,CategoryName,YM,a.AreaCode,a.NodeCode  from 
(select  b.AreaCode,b.NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and CategoryCode<>29   and CategoryCode<>19 
and left(b.NodeCode,1) between 1 and 2
and 1=1 ${if(lx<>'0001',   "",   "and CategoryCode in (30,40,46,50)") } 
and 1=1 ${if(lx<>'0002',   "",   "and CategoryCode in (20,21,22,23)") } 
union all 

select  b.AreaCode,b.NodeCode ,ParentCategoryCode,CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from dbo.TB商品分类表 a,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641)
and b.NodeCode like '9%'

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[无税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='${lx}'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7

