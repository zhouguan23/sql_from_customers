select ''ParentCategoryCode,'' CategoryCode ,'' CategoryName,YM month,a.AreaCode,a.NodeCode DeptCode ,b.非中央控制,b.中央控制,b.门店缺货
 from 
(select YM,a.AreaCode,a.NodeCode  from 
(select  b.AreaCode ,b.NodeCode
from dbo.TB部门信息表 b 
where left(b.NodeCode,1) between 1 and 2
and b.NodeCode not LIKE '1047' 

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[tb缺货率指标预算表]A b on  a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='0000'
        where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,5,6

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

select nodecode,sum(可订货次数)可订货次数,sum(非中央控制缺货次数)+sum(中央控制缺货次数)+sum(门店缺货次数)缺货次数,
sum(非中央控制缺货次数)非中央控制缺货次数,sum(中央控制缺货次数)中央控制缺货次数,sum(门店缺货次数)门店缺货次数 from  
TB${YM}_月度缺货数据 a 
GROUP BY nodecode
order by  1


