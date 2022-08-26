select ParentCategoryCode,CategoryCode1,a.CategoryCode ,YM month
,isnull(d.非中央控制,0)常规非中央控制,isnull(d.中央控制,0)常规中央控制
,isnull(c.非中央控制,0)经理非中央控制,isnull(c.中央控制,0)经理中央控制
,isnull(b.非中央控制,0)非中央控制,isnull(b.中央控制,0)中央控制
 from 
(select left(CategoryCode,1)ParentCategoryCode,CategoryCode1,CategoryCode ,YM  from 
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode CategoryCode1,b.CategoryName CategoryName1,c.CategoryCode ,c.CategoryName  from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0002'
left join 
(select '0002'CategoryItemCode,CategoryCode,CategoryName,case when LEFT(CategoryCode,2) in (31,32) then '31'
when LEFT(CategoryCode,2) in ('46','47') then '42'
when LEFT(CategoryCode,2) in ('40','41','42','43') then '40'
when LEFT(CategoryCode,2) in ('44','45','48','49') then '41'
when LEFT(CategoryCode,1) in ('5') then '50' else LEFT(CategoryCode,2) end ParentCategoryCode ,'2' CategoryLevel from 
TB商品分类表 
where CategoryLevel='2' and LEFT(CategoryCode,1)between '3' and '5' and CategoryItemCode='0000') c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0002'

where a.CategoryItemCode='0002' and a.CategoryLevel='0' and a.CategoryCode not like '1%' and a.CategoryCode not like '2%' and a.CategoryCode not like '6%'
)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[tb缺货率指标预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and   b.CategoryItemCode ='0002' and b.DeptCode ='0002'
        left join 
    dbo.[tb缺货率指标预算表]A c on a.CategoryCode1=c.CategoryCode and a.YM=c.BudgetYM and   c.CategoryItemCode ='0002' and c.DeptCode ='0001'
            left join 
    dbo.[tb缺货率指标预算表]A d on d.CategoryCode='3' and a.YM=d.BudgetYM and   d.CategoryItemCode ='0002' and d.DeptCode ='0000'
    order by 2,3,5,4,6


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

select ParentCategoryCode,CategoryCode1,a.CategoryCode ,YM month
,isnull(sum(可订货次数),0)可订货次数,isnull(sum(非中央控制缺货次数),0)+isnull(sum(中央控制缺货次数),0)+isnull(sum(门店缺货次数),0)缺货次数
 from 
(select left(CategoryCode,1)ParentCategoryCode,CategoryCode1,CategoryCode ,YM  from 
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode CategoryCode1,b.CategoryName CategoryName1,c.CategoryCode ,c.CategoryName  from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0002'
left join 
(select '0002'CategoryItemCode,CategoryCode,CategoryName,case when LEFT(CategoryCode,2) in (31,32) then '31'
when LEFT(CategoryCode,2) in ('46','47') then '42'
when LEFT(CategoryCode,2) in ('40','41','42','43') then '40'
when LEFT(CategoryCode,2) in ('44','45','48','49') then '41'
when LEFT(CategoryCode,1) in ('5') then '50' else LEFT(CategoryCode,2) end ParentCategoryCode ,'2' CategoryLevel from 
TB商品分类表 
where CategoryLevel='2' and LEFT(CategoryCode,1)between '3' and '5' and CategoryItemCode='0000') c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0002'

where a.CategoryItemCode='0002' and a.CategoryLevel='0' and a.CategoryCode not like '1%' and a.CategoryCode not like '2%' and a.CategoryCode not like '6%'
)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${YM}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${YM}'+'01') <= '${YM}'+'01')b
    )a
    left join 
    TB${YM}_月度缺货数据 b on a.CategoryCode=b.CategoryCode and     b.CategoryItemCode ='0000' 
    group by ParentCategoryCode,CategoryCode1,a.CategoryCode ,YM
    order by 1,2,3

select  * from 
tb分类对照表
where CategoryItemCode='0002' and CategoryLevel<=2


