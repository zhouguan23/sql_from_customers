select deptcode,BudgetYM ,SUM(Salesindex)Salesindex from 
含税分课预算表
where CategoryItemCode ='0000' and BudgetYM between '${qsrq}' and '${jsrq}'
and  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } 
group by deptcode,BudgetYM


select case when a.Category1Code in ('14','15','16','17','18') then '不可控费用' else '经营费用' end fyfl,a.Category1Code,a. Category1Name,A.CategoryCode,A.CategoryName,a.YM,a.NodeCode,a.NodeName,isnull(b.Salesindex,0)Salesindex from 
(select a.CategoryItemCode,a.Category1Code, Category1Name,A.CategoryCode,A.CategoryName,B.YM,c.NodeCode,c.NodeName from 
(select a.CategoryItemCode,a.CategoryCode Category1Code,a.CategoryName as Category1Name,b.CategoryCode,b.CategoryName  from 
tb预算科目表 a 
left join 
tb预算科目表 b on b.CategoryLevel='2' and a.CategoryCode=b.ParentCategoryCode
where a.CategoryLevel='1' and a.CategoryItemCode='0000'
)a,

(sELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')B,
    TB部门信息表 c 
    where left(NodeCode,1) in (1,2) and   1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") })a
    left join 
    TB费用预算表 b on a.CategoryCode=A.CategoryCode and a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryItemCode=b.CategoryItemCode
    order by convert(int,a.Category1Code),convert(int,a.CategoryCode)
    



select case when a.Category1Code in ('14','15','16','17','18') then '不可控费用' else '经营费用' end fyfl,a.Category1Code,a. Category1Name,A.CategoryCode,A.CategoryName,a.YM,a.NodeCode,a.NodeName,isnull(b.Salesindex,0)Salesindex from 
(select a.CategoryItemCode,a.Category1Code, Category1Name,A.CategoryCode,A.CategoryName,B.YM,c.NodeCode,c.NodeName from 
(select a.CategoryItemCode,a.CategoryCode Category1Code,a.CategoryName as Category1Name,b.CategoryCode,b.CategoryName  from 
tb预算科目表 a 
left join 
tb预算科目表 b on b.CategoryLevel='2' and a.CategoryCode=b.ParentCategoryCode
where a.CategoryLevel='1' and a.CategoryItemCode='0001'
)a,

(sELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')B,
    TB部门信息表 c 
    where left(NodeCode,1) in (1,2) and   1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") })a
    left join 
    TB费用预算表 b on a.CategoryCode=A.CategoryCode and a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryItemCode=b.CategoryItemCode
    order by convert(int,a.Category1Code),convert(int,a.CategoryCode)
    


