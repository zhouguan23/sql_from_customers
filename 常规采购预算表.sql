select
WhetherNew,AreaCode,FormatCode,NodeCode ,
 ParentCategoryCode,CategoryCode1,CONVERT(varchar(255), CategoryCode)CategoryCode,CategoryName,CONVERT(varchar(255),YM)YM,CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
from 

(select ParentCategoryCode ,CategoryCode CategoryCode1 ,CategoryCode,CategoryName  from 
TB商品分类表
where CategoryLevel='2' and ParentCategoryCode  in (1) 
and CategoryItemCode='0000' and CategoryCode not in (29,28,19,23)
union all 
select ParentCategoryCode ,ParentCategoryCode CategoryCode1 ,CategoryCode,CategoryName  from 
TB商品分类表
where CategoryLevel='2' and ParentCategoryCode  in (2) 
and CategoryItemCode='0000' and CategoryCode not in (29,28,19,23)
union all 
select ParentCategoryCode ,CategoryCode CategoryCode1 ,CategoryCode,CategoryName  from 
TB商品分类表
where CategoryLevel='2' and ParentCategoryCode  in (2) 
and CategoryItemCode='0000' and CategoryCode in (23)
union all 
select left(ParentCategoryCode,1)ParentCategoryCode ,ParentCategoryCode CategoryCode1 ,CategoryCode,CategoryName  from 
TB商品分类表
where CategoryLevel='3' and ParentCategoryCode  in (28) 
and CategoryItemCode='0000' and CategoryCode not in (287,288,289)
union all 
select '3' CategoryCode1,ParentCategoryCode ,CategoryCode ,CategoryName from 
TB分类对照表 a
where a.CategoryLevel ='2')a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p' AND DATEADD(month,number,'${qsrq}'+'01') <= '${dqrq}'+'01')b,
(select WhetherNew,AreaCode,FormatCode,NodeCode from 
tb部门信息表
where (nodecode like '1%' or nodecode like '2%') 
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") })c
order by 9,1,2,3,4,5,6,7



select * from 
含税分课预算表

where  CategoryItemCode='0004'
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'
union all 
select DeptCode,case when CategoryCode='20' then '280'  when CategoryCode='21' then '281'  when CategoryCode='22' then '282' else CategoryCode end CategoryCode ,BudgetYM,Salesindex,Grossprofitindex,CategoryItemCode from 
含税分课预算表

where  CategoryItemCode='0002' and left(DeptCode,1) between  1 and 2
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'
union all 
select DeptCode, CategoryCode ,BudgetYM,Salesindex,Grossprofitindex,CategoryItemCode from 
含税分课预算表

where  CategoryItemCode='0000' and left(DeptCode,1) between  1 and 2 and (CategoryCode like '1%' or CategoryCode like '2%')
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'


select CategoryItemCode,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB商品分类表
where CategoryItemCode='0000' and CategoryLevel<3 and (CategoryCode like '1%' or CategoryCode like '2%')
union all 
select CategoryItemCode,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel  from 
TB商品分类表
where CategoryLevel='3' and ParentCategoryCode  in (28) 
and CategoryItemCode='0000' and CategoryCode not in (287,288,289)
union all 
select * from 
TB分类对照表 
order by 2

select * from 
无税分课预算表

where  CategoryItemCode='0004'
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'
union all 
select DeptCode,case when CategoryCode='20' then '280'  when CategoryCode='21' then '281'  when CategoryCode='22' then '282' else CategoryCode end CategoryCode ,BudgetYM,Salesindex,Grossprofitindex,CategoryItemCode from 
无税分课预算表

where  CategoryItemCode='0002' and left(DeptCode,1) between  1 and 2
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'
union all 
select DeptCode, CategoryCode ,BudgetYM,Salesindex,Grossprofitindex,CategoryItemCode from 
无税分课预算表

where  CategoryItemCode='0000' and left(DeptCode,1) between  1 and 2 and (CategoryCode like '1%' or CategoryCode like '2%')
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'

