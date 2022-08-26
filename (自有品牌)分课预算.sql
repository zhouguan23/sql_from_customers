
select ParentCategoryCode,a.CategoryCode ,a.CategoryName,YM month,a.NodeCode DeptCode ,b.Salesindex,b.Grossprofitindex,

isnull(round(case when a.CategoryCode in (11,13,14) then b.Salesindex/1.09 when a.CategoryCode in (10,12) then b.Salesindex/1  when a.CategoryCode in (640) then b.Salesindex/1.06  else b.Salesindex/1.13 end,2) ,0)TaxSalesindex,
isnull(round(case when a.CategoryCode in (11,13,14) then (b.Salesindex/1.09)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 when a.CategoryCode in (10,12) then (b.Salesindex/1.0)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 when a.CategoryCode in (640) then (b.Salesindex/1.06)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) 
 else b.Salesindex/1.13*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) end,2),0) TaxGrossprofitindex from 
(select a.CategoryItemCode,ParentCategoryCode,CategoryCode ,CategoryName,YM,c.NodeCode  from 
(select a.CategoryItemCode,A.CategoryCode ParentCategoryCode,B.CategoryCode,B.CategoryName from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and b.ParentCategoryCode=a.CategoryCode

where a.CategoryItemCode='0007' and a.CategoryLevel='0' 




)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b,hldw.dbo.TB部门信息表 c
    where left(c.nodecode,1) between 1 and 2
    )a
    left join 
    [含税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and b.CategoryItemCode ='0001'
	where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7


select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601) 

select a.CategoryCode,a.CategoryCode+' '+a.CategoryName CategoryName from 
HLCWDW.DBO.TB分类对照表 a 


where a.CategoryItemCode='0007' 

