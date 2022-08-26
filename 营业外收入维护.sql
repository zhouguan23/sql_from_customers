select * from 
TB预算科目
where 
CategoryLevel='3'
order by 2,4,5

select CategoryItemCode,CategoryCode,CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel>='0' and CategoryItemCode ='0001'
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


select case when ParentCategoryCode='0003' then '' else ParentCategoryCode end F_ID,CategoryCode ID,CategoryCode,case when left(CategoryCode,2) in ('10','20','90','50') and len(CategoryCode)!=2 then CategoryCode+' '+CategoryName else CategoryName  end CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel >=0
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)

select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' 


select '${qsrq}'+'00'YM
union all 
SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'

select * from 
TB营业外收入表
where deptcode ='${bm}' and CategoryItemCode='0003' and BudgetYM like '${qsrq}%'

select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryCode='${bm}'

select * from 
TB部门费用预算表
where deptcode='${bm}' and BudgetYM like '${qsrq}%'

