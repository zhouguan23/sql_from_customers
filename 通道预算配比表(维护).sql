select deptcode,LEFT(CategoryCode,1)CategoryCode1,BudgetYM,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex from 
含税分课预算表 
where (DeptCode like '1%' or DeptCode like '2%')  
and CategoryItemCode in ('0000')
and BudgetYM between '${qsrq}' and '${dqrq}'
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
group by deptcode,LEFT(CategoryCode,1),BudgetYM
order by 1,2,3

select
WhetherNew,AreaCode,FormatCode,NodeCode ,
 CategoryCode1,ParentCategoryCode,CategoryCode,CategoryName,YM
from 

(
select ParentCategoryCode CategoryCode1,CategoryCode ParentCategoryCode ,CategoryCode ,CategoryName from 
TB商品分类表  a
where a.CategoryLevel ='2' and CategoryCode like '1%' and CategoryItemCode='0000' and CategoryCode not  like '19'
union all 
select ParentCategoryCode CategoryCode1,CategoryCode ParentCategoryCode ,CategoryCode ,CategoryName from 
TB商品分类表  a
where a.CategoryLevel ='2' and CategoryCode like '2%' and CategoryItemCode='0000' and CategoryCode not  like '29'
union all 
select LEFT(ParentCategoryCode,1)CategoryCode1,ParentCategoryCode ,CategoryCode ,CategoryName from 
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
dbo.TB采购分类通道配比表

where  1=1 ${if(len(bm) == 0,   "",   "and CategoryItemCode in ('" + replace(bm,",","','")+"')") } and BudgetYM between '${qsrq}' and '${dqrq}'


select deptcode,LEFT(CategoryCode,1)CategoryCode1,BudgetYM,SUM(Salesindex)Salesindex,SUM(Grossprofitindex)Grossprofitindex from 
无税分课预算表
where (DeptCode like '1%' or DeptCode like '2%')  and CategoryCode not like '1%' and CategoryCode not like '2%'
and CategoryItemCode='0000'
and BudgetYM between '${qsrq}' and '${dqrq}'
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
group by deptcode,LEFT(CategoryCode,1),BudgetYM
order by 1,2,3

