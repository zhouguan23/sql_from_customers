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
and a.ParentCategoryCode='3'


select BudgetYM,case 
when  b.CategoryCode in(31,32) then '31' 
when  b.CategoryCode in(30,39) then '30'
when  b.CategoryCode in(40,41,42,43) then '40'
when  b.CategoryCode in(44,45,48,49) then '41'
when  b.CategoryCode in(46,47) then '42'
when  b.CategoryCode in(50,51,52) then '50'
when  b.CategoryCode in(610,611,612,620,621) then '61'
when  b.CategoryCode in(622,623,624,613,614,615,616,617,618) then '62'
when  b.CategoryCode in(640,641,642) then '64'
else  b.CategoryCode end CategoryCode,isnull(SUM(b.Salesindex),0)kb_TaxSalesindex,
isnull(sum(b.Grossprofitindex),0)kb_TaxGrossprofitindex from 
含税分课预算表 b
where BudgetYM between '${qsrq}' and '${jsrq}' and b.CategoryItemCode in('0000','0002')
and b.deptcode in (select nodecode from TB部门信息表 where WhetherNew='1')
group by BudgetYM,case when  b.CategoryCode in(31,32) then '31' 
when  b.CategoryCode in(30,39) then '30'
when  b.CategoryCode in(40,41,42,43) then '40'
when  b.CategoryCode in(44,45,48,49) then '41'
when  b.CategoryCode in(46,47) then '42'
when  b.CategoryCode in(50,51,52) then '50'
when  b.CategoryCode in(610,611,612,620,621) then '61'
when  b.CategoryCode in(622,623,624,613,614,615,616,617,618) then '62'
when  b.CategoryCode in(640,641,642) then '64'
else  b.CategoryCode end

select * from 
tb预算表
where IsTax='1' and BudgetYM between '${qsrq}' and '${jsrq}' 


select BudgetYM,case 
when  b.CategoryCode in(31,32) then '31' 
when  b.CategoryCode in(30,39) then '30'
when  b.CategoryCode in(40,41,42,43) then '40'
when  b.CategoryCode in(44,45,48,49) then '41'
when  b.CategoryCode in(46,47) then '42'
when  b.CategoryCode in(50,51,52) then '50'
when  b.CategoryCode in(610,611,612,620,621) then '61'
when  b.CategoryCode in(622,623,624,613,614,615,616,617,618) then '62'
when  b.CategoryCode in(640,641,642) then '64'
else  b.CategoryCode end CategoryCode,isnull(SUM(b.Salesindex),0)kb_TaxSalesindex,
isnull(sum(b.Grossprofitindex),0)kb_TaxGrossprofitindex from 
含税分课预算表 b
where BudgetYM between '${qsrq}' and '${jsrq}' and b.CategoryItemCode in('0000','0002')
and b.deptcode in (select nodecode from TB部门信息表 where WhetherNew='0')
group by BudgetYM,case when  b.CategoryCode in(31,32) then '31' 
when  b.CategoryCode in(30,39) then '30'
when  b.CategoryCode in(40,41,42,43) then '40'
when  b.CategoryCode in(44,45,48,49) then '41'
when  b.CategoryCode in(46,47) then '42'
when  b.CategoryCode in(50,51,52) then '50'
when  b.CategoryCode in(610,611,612,620,621) then '61'
when  b.CategoryCode in(622,623,624,613,614,615,616,617,618) then '62'
when  b.CategoryCode in(640,641,642) then '64'
else  b.CategoryCode end

