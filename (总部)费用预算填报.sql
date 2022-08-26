
select NodeCode,BudgetYM ,SUM(a.Salesindex)Salesindex  from 


(
--管理部门
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and  ((CategoryItemCode in ('0000') and (DeptCode like '9%' or DeptCode like '5%' or DeptCode like '1%' or DeptCode like '2%')) or (CategoryItemCode in ('0002') and CategoryCode like '23' and (DeptCode like '1%' or DeptCode like '2%')))
and  b.NodeCode in( '000100','000101','010101','010102','000109','000121','000108','000114','000115','000119','000120','000110','011001','000112','011301','011302','011303','010201')
group by b.NodeCode,BudgetYM
union all 
--生鲜采购部、生鲜运营部
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and CategoryItemCode ='0000' and (DeptCode like '1%' or DeptCode like '2%')and CategoryCode like '1%'
and  b.NodeCode in( '010601','010602')
group by b.NodeCode,BudgetYM
union all 
--营运部、营销部
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and  ((CategoryItemCode in ('0000') and (DeptCode like '1%' or DeptCode like '2%')) or (CategoryItemCode in ('0002') and CategoryCode like '23' and (DeptCode like '1%' or DeptCode like '2%')))
and  b.NodeCode in( '000102','000111','010202')
group by b.NodeCode,BudgetYM
union all 
--加工业务部
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and ((CategoryItemCode in ('0000') and CategoryCode like '2%' and (DeptCode like '1%' or DeptCode like '2%')) or (CategoryItemCode in ('0002') and CategoryCode like '23' and (DeptCode like '1%' or DeptCode like '2%'))) 
and  b.NodeCode in( '000107')
group by b.NodeCode,BudgetYM
union all 
--常规业务部、金沙回沙酒促销员
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and CategoryItemCode ='0000' and (DeptCode like '1%' or DeptCode like '2%') and (CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%') 
and  b.NodeCode in( '000103','010301')
group by b.NodeCode,BudgetYM
union all 
--自有品牌业务部、自有品牌业务部促销员
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and  CategoryItemCode ='0001' and (DeptCode like '1%' or DeptCode like '2%')
and  b.NodeCode in( '000104','010401')
group by b.NodeCode,BudgetYM
union all 
--百货业务部
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and  CategoryItemCode ='0000' and (DeptCode like '9%' or DeptCode like '5%')
and  b.NodeCode in( '000105')
group by b.NodeCode,BudgetYM
union all 
--营运大区
select b.NodeCode,a.BudgetYM ,SUM(a.Salesindex)Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b,dbo.TB部门信息表 c
where BudgetYM between '${qsrq}' and '${jsrq}' and b.NodeName=c.AreaName and a.DeptCode =c.NodeCode
and   ((CategoryItemCode in ('0000') and (DeptCode like '1%' or DeptCode like '2%')) or (CategoryItemCode in ('0002') and CategoryCode like '23' and (DeptCode like '1%' or DeptCode like '2%')))
group by b.NodeCode,BudgetYM
union all 
--常温物流部
select b.NodeCode,a.BudgetYM ,(SUM(a.Salesindex)-SUM(a.Grossprofitindex))*0.85 Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and CategoryItemCode ='0000' and (DeptCode like '1%' or DeptCode like '2%') and (CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%') 
and  b.NodeCode in( '006666')
group by b.NodeCode,BudgetYM
union all 
--常温物流部
select b.NodeCode,a.BudgetYM ,(SUM(a.Salesindex)-SUM(a.Grossprofitindex))*0.65 Salesindex from 
含税分课预算表 a,dbo.TB总部部门信息表 b
where BudgetYM between '${qsrq}' and '${jsrq}'
and CategoryItemCode ='0000' and (DeptCode like '1%' or DeptCode like '2%') and (CategoryCode like '1%') 
and  b.NodeCode in( '008888','888801')
group by b.NodeCode,BudgetYM
union all 


sELECT '888802'NodeCode,CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM,'500'
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01'


)a
where 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") } 
group by NodeCode,BudgetYM

order by 1,2


select case when a.Category1Code in ('14','15','16','17','18') then '不可控费用' else '经营费用' end fyfl,a.Category1Code,a. Category1Name,A.CategoryCode,A.CategoryName,a.YM,a.NodeCode,a.NodeName,isnull(b.Salesindex,0)Salesindex from 
(select a.CategoryItemCode,a.Category1Code, Category1Name,A.CategoryCode,A.CategoryName,B.YM,c.NodeCode,c.NodeName from 
(select a.CategoryItemCode,a.CategoryCode Category1Code,a.CategoryName as Category1Name,b.CategoryCode,b.CategoryName  from 
tb预算科目表 a 
left join 
tb预算科目表 b on b.CategoryLevel='2' and a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'
where a.CategoryLevel='1' and a.CategoryItemCode='0000'
)a,

(sELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')B,
    tb总部部门信息表 c 
    where  1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") })a
    left join 
    TB费用预算表 b on a.CategoryCode=b.CategoryCode and a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryItemCode=b.CategoryItemCode
    order by convert(int,a.Category1Code),convert(int,a.CategoryCode)


select case when a.Category1Code in ('14','15','16','17','18') then '不可控费用' else '经营费用' end fyfl,a.Category1Code,a. Category1Name,A.CategoryCode,A.CategoryName,a.YM,a.NodeCode,a.NodeName,isnull(b.Salesindex,0)Salesindex from 
(select a.CategoryItemCode,a.Category1Code, Category1Name,A.CategoryCode,A.CategoryName,B.YM,c.NodeCode,c.NodeName from 
(select a.CategoryItemCode,a.CategoryCode Category1Code,a.CategoryName as Category1Name,b.CategoryCode,b.CategoryName  from 
tb预算科目表 a 
left join 
tb预算科目表 b on b.CategoryLevel='2' and a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0001'
where a.CategoryLevel='1' and a.CategoryItemCode='0001'
)a,

(sELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')B,
    tb总部部门信息表 c 
    where   1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") })a
    left join 
    TB费用预算表 b on a.CategoryCode=A.CategoryCode and a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryItemCode=b.CategoryItemCode
    order by convert(int,a.Category1Code),convert(int,a.CategoryCode)
    


select a.NodeCode,a.NodeCode+' '+a.Nodename Nodename,a.OpenDate,a.WhetherNew,a.AreaCode,a.AreaName,a.FormatCode,a.FormatName from 
dbo.TB总部部门信息表  a

--where  a.NodeCode in (SELECT ManagingCode FROM TB职员分管信息 b where b. CategoryItemCode='0000' and b. ManagingType='0002' and b. EmployeeCode='${yh}')
order by 3

SELECT ManagingCode FROM TB职员分管信息 b on b. CategoryItemCode='0000' and b. ManagingType='0002' and b. EmployeeCode='${yh}'

