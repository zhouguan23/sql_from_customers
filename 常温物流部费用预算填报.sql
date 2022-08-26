select * from 
TB预算科目
where 
CategoryLevel='2'
order by 2,4,5

select * from 
TB预算科目
where 
CategoryLevel='3'
order by 2,4,5


select a.NodeCode,a.NodeName,a.YM,a.ParentCategoryCode,a.CategoryCode,a.CategoryName,isnull(b.salesindex,0)salesindex from 
    (select c.NodeCode,c.NodeName,b.YM,a.CategoryCode,a.CategoryName,a.ParentCategoryCode  from 
    --获取分类
TB商品分类表  a,
--获取年月
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    --获取部门
        ,TB部门信息表 c
        where (left(c.NodeCode,1) between 1 and 2 or left(c.NodeCode,1) =9 ) 
        and  a.CategoryLevel='2'
        and a.CategoryItemCode='0000' and left(a.CategoryCode,1) between 1 and 5 
        and  1=1 ${if(len(dbbm) == 0,   "", "and c.NodeCode in ('" + replace(dbbm,",","','")+"')") } )a
        left join 
           (       select DeptCode ,CategoryCode,Salesindex ,BudgetYM,CategoryItemCode from 
   含税分课预算表 where CategoryItemCode ='0000') b on a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryCode=b.CategoryCode
    order by a.NodeCode,a.YM ,Convert(int,left(a.CategoryCode,charindex('.',a.CategoryCode+'.')-1))+0 ,Convert(int,left(a.parentcategorycode,charindex('.',a.parentcategorycode+'.')-1))+0
    

    select a.NodeCode,a.NodeName,a.YM,case when a.ParentCategoryCode <=13 then '经营费用' when a.ParentCategoryCode in (14,15,16,17,18) then '不可控费用' end ParentCategory,  
    
    a.ParentCategoryCode,a.CategoryCode,a.CategoryName,sum(isnull(b.salesindex,0))salesindex from 
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
        where (left(c.NodeCode,1) between 1 and 2 or left(c.NodeCode,1) =9 ) 
        and  a.CategoryLevel='2'         and  1=1 ${if(len(bm) == 0,   "",   "and c.NodeCode in ('" + replace(bm,",","','")+"')") } 
        and a.CategoryItemCode='9001'
)a
        left join 
        TB费用预算 b on a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryCode=b.CategoryCode
        group by a.NodeCode,a.NodeName,a.YM,case when a.ParentCategoryCode <=13 then '经营费用' when a.ParentCategoryCode in (14,15,16,17,18) then '不可控费用' end, a.ParentCategoryCode,a.CategoryCode,a.CategoryName
    order by a.NodeCode,a.YM ,Convert(int,left(a.CategoryCode,charindex('.',a.CategoryCode+'.')-1))+0 ,Convert(int,left(a.parentcategorycode,charindex('.',a.parentcategorycode+'.')-1))+0






select a.NodeCode,a.NodeName,a.YM,a.ParentCategoryCode,a.CategoryCode,a.CategoryName,isnull(b.salesindex,0)salesindex from 
    (select c.NodeCode,c.NodeName,b.YM,a.CategoryCode,a.CategoryName,a.ParentCategoryCode  from 
    --获取分类
TB商品分类表  a,
--获取年月
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    --获取部门
        ,TB部门信息表 c
        where (left(c.NodeCode,1) between 1 and 2 or left(c.NodeCode,1) =9 ) 
        and  a.CategoryLevel='2'
        and a.CategoryItemCode='0000' and left(a.CategoryCode,1) between 1 and 5 
        and  1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") } )a
        left join 
           (       select DeptCode ,CategoryCode,Salesindex ,BudgetYM,CategoryItemCode from 
   含税分课预算表 where CategoryItemCode ='0000') b on a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryCode=b.CategoryCode
    order by a.NodeCode,a.YM ,Convert(int,left(a.CategoryCode,charindex('.',a.CategoryCode+'.')-1))+0 ,Convert(int,left(a.parentcategorycode,charindex('.',a.parentcategorycode+'.')-1))+0
    


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
        and a.CategoryItemCode='9001'
        and  1=1 ${if(len(dbbm) == 0,   "",   "and c.NodeCode in ('" + replace(dbbm,",","','")+"')") } )a
        left join 
           tB费用跟踪明细表 b on a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryCode=b.CategoryCode
    order by a.NodeCode,a.YM ,Convert(int,left(a.CategoryCode,charindex('.',a.CategoryCode+'.')-1))+0 ,Convert(int,left(a.parentcategorycode,charindex('.',a.parentcategorycode+'.')-1))+0

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

select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店') NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'二'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店') Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where 
exists (select * from  dbo.TB部门信息表 b where (a.AreaCode =b.AreaCode or a.FormatCode =b.FormatCode )
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and b.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}
  )

and a.nodecode='${bm}'

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
        and  1=1 ${if(len(dbbm) == 0,   "",   "and c.NodeCode in ('" + replace(dbbm,",","','")+"')") } )a
        left join 
           tB营业外收入预算表 b on a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryCode=b.CategoryCode
    order by a.NodeCode,a.YM ,Convert(int,left(a.CategoryCode,charindex('.',a.CategoryCode+'.')-1))+0 ,Convert(int,left(a.parentcategorycode,charindex('.',a.parentcategorycode+'.')-1))+0

