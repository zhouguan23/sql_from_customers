select * from 
TB预算科目
where 
CategoryLevel='3'
order by 2,4,5

select CategoryItemCode,CategoryCode,CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel>='0' and CategoryItemCode in('0000')
order by 1,6,5,cast(CategoryCode as int)

select a.CategoryCode,a.DeptCode,c.BudgetYM,sum(c.Salesindex)Salesindex from 
(select a.CategoryCode,c.DeptCode,b.GoodsCode from 
TB分类对照表 a
left join 
tbCatToGoods b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
left join 
tbCatToDept  c on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode and b.CategoryCode=c.CategoryCode
where  a.CategoryItemCode='0003' and a.CategoryCode ='${bm}')a
left join 
[HLDW]A.[dbo]A.含税分课预算表 c on a.GoodsCode=c.CategoryCode and a.DEPTcode=c.DeptCode and c.CategoryItemCode='0000'  
where c.BudgetYM like '${qsrq}%'
group by  a.CategoryCode ,a.DeptCode,c.BudgetYM


    select a.NodeCode,a.NodeName,a.YM,a.ParentCategoryCode,a.CategoryCode,a.CategoryName,isnull(b.salesindex,0)salesindex from 
    (select c.NodeCode,c.NodeName,b.YM,a.CategoryCode,a.CategoryName,a.ParentCategoryCode  from 
    --获取分类
TB预算科目 a,
--获取年月
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    --获取部门
        ,TB部门信息表 c
        where (left(c.NodeCode,1) between 1 and 2 or left(c.NodeCode,1) =9) 
        and  a.CategoryLevel='2'
        and a.CategoryItemCode='9002'
        and  1=1 ${if(len(bm) == 0,   "",   "and c.NodeCode in ('" + replace(bm,",","','")+"')") } )a
        left join 
           tB营业外收入预算表 b on a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryCode=b.CategoryCode
    order by a.NodeCode,a.YM ,Convert(int,left(a.CategoryCode,charindex('.',a.CategoryCode+'.')-1))+0 ,Convert(int,left(a.parentcategorycode,charindex('.',a.parentcategorycode+'.')-1))+0

${if(js == "1","
select case when rank()  over(order by CategoryLevel)=1 then '' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+' '+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel>=0
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)","
select case when rank()  over(order by CategoryLevel)=1 then '' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+' '+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel>=0 and BuildManCode ='"+gh+"'
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)



")}


select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' 


select * from 
(select '${qsrq}'+'00'YM
union all 
SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201')a
    where 1=1 ${if(len(ym) == 0,   "",   "and a.YM in ('" + replace(ym,",","','")+"')") }  

select * from 
TB部门费用预算表
where deptcode in (select CategoryCode from  TB分类对照表 where CategoryItemCode='0003' and CategoryCode='${bm}') and BudgetYM like '${qsrq}%'

select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryCode='${bm}'

select * from 
TB部门费用预算表
where deptcode='${bm}' and BudgetYM like '${qsrq}%'

select * from 
tb费用调整表
where deptcode in (select CategoryCode from  TB分类对照表 where CategoryItemCode='0003' and CategoryCode='${bm}') and BudgetYM like '${qsrq}%'

select ChargeDeptCode DeptCode,CostCoding,BuildYM,sum(CEMoneyext)CEMoneye from 
TB费用报销单
where BuildDate like '${qsrq}%' and ChargeDeptCode='${bm}'
group by ChargeDeptCode,CostCoding,BuildYM



