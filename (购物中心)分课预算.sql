
select ParentCategoryCode,a.CategoryCode ,a.CategoryName ,YM month,a.NodeCode DeptCode ,b.Salesindex,b.Grossprofitindex
		    from
(select ParentCategoryCode,CategoryCode ,CategoryName,YM,a.NodeCode  from 
(select NodeCode,'8'ParentCategoryCode,'800' CategoryCode,'餐饮' CategoryName  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'8'ParentCategoryCode,'801' CategoryCode,'皮具家居' CategoryName  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'8'ParentCategoryCode,'802' CategoryCode,'男装' CategoryName  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'8'ParentCategoryCode,'803' CategoryCode,'女装' CategoryName  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'8'ParentCategoryCode,'804' CategoryCode,'儿童服饰' CategoryName  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'8'ParentCategoryCode,'805' CategoryCode,'儿童娱乐' CategoryName  from 
TB部门信息表 
where NodeCode ='5001'

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[含税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='5001'
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

