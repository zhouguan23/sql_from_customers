select * from TB分类对照表 where CategoryItemCode='0002'


select b.YM,a.CategoryItemCode,a.ParentCategoryCode,a.CategoryCode,case when c.CategoryCode is null then a.CategoryCode else c.CategoryCode end CG_CategoryCode

 from 
TB分类对照表 a

left join 
TB分类对照表 c on a.CategoryItemCode=c.CategoryItemCode and a.CategoryCode=c.ParentCategoryCode
,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p' AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
where a.CategoryItemCode='0002'  and a.CategoryLevel ='1' 
and a.ParentCategoryCode='1'


select BudgetYM,left(b.CategoryCode,1) CategoryCode,isnull(SUM(b.Salesindex),0)kb_TaxSalesindex,
isnull(sum(b.Grossprofitindex),0)kb_TaxGrossprofitindex from 
含税分课预算表 b
where BudgetYM between '${qsrq}' and '${jsrq}' and b.CategoryItemCode in('0000','0002')
and b.deptcode in (select nodecode from TB部门信息表 where WhetherNew='1')
group by BudgetYM,left(b.CategoryCode,1) 

select * from 
tb预算表
where IsTax='1' and BudgetYM between '${qsrq}' and '${jsrq}' 


select BudgetYM,left(b.CategoryCode,1)  CategoryCode,isnull(SUM(b.Salesindex),0)kb_TaxSalesindex,
isnull(sum(b.Grossprofitindex),0)kb_TaxGrossprofitindex from 
含税分课预算表 b
where BudgetYM between '${qsrq}' and '${jsrq}' and b.CategoryItemCode in('0000','0002')
and b.deptcode in (select nodecode from TB部门信息表 where WhetherNew='0')
group by BudgetYM,left(b.CategoryCode,1) 

