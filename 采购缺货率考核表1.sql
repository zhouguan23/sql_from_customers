 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @jsny='${qsrq}'
set @qsny='${jsrq}'
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where CategoryItemCode =''0000''

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_月度缺货数据' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL='

select ParentCategoryCode,CategoryCode1,a.CategoryCode ,YM month
,isnull(d.可订货次数,0)常规可订货次数,isnull(d.非中央控制,0)常规非中央控制,isnull(d.中央控制,0)常规中央控制
,isnull(c.可订货次数,0)经理可订货次数,isnull(c.非中央控制,0)经理非中央控制,isnull(c.中央控制,0)经理中央控制
,isnull(b.可订货次数,0)可订货次数,isnull(b.非中央控制,0)非中央控制,isnull(b.中央控制,0)中央控制
,isnull(e.可订货次数,0)可订货次数实际,isnull(e.非中央控制缺货次数,0)非中央控制缺货次数,isnull(e.中央控制缺货次数,0)中央控制缺货次数
 from 
(select left(CategoryCode,1)ParentCategoryCode,CategoryCode1,CategoryCode ,YM  from 
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode CategoryCode1,b.CategoryName CategoryName1,c.CategoryCode ,c.CategoryName  from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0002''
left join 
(select ''0002''CategoryItemCode,CategoryCode,CategoryName,case when LEFT(CategoryCode,2) in (31,32) then ''31''
when LEFT(CategoryCode,2) in (''46'',''47'') then ''42''
when LEFT(CategoryCode,2) in (''40'',''41'',''42'',''43'') then ''40''
when LEFT(CategoryCode,2) in (''44'',''45'',''48'',''49'') then ''41''
when LEFT(CategoryCode,1) in (''5'') then ''50'' else LEFT(CategoryCode,2) end ParentCategoryCode ,''2'' CategoryLevel from 
TB商品分类表 
where CategoryLevel=''2'' and LEFT(CategoryCode,1)between ''3'' and ''5'' and CategoryItemCode=''0000'') c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0002''

where a.CategoryItemCode=''0002'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''1%'' and a.CategoryCode not like ''2%'' and a.CategoryCode not like ''6%''
)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,''${qsrq}''+''01''),112) AS YM
FROM master.dbo.spt_values
WHERE type = ''p''
    AND DATEADD(month,number,''${qsrq}''+''01'') <=''${jsrq}''+''01'')b
    )a
    left join 
    dbo.[tb缺货率指标预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and   b.CategoryItemCode =''0002'' and b.DeptCode =''0002''
        left join 
    dbo.[tb缺货率指标预算表]A c on a.CategoryCode1=c.CategoryCode and a.YM=c.BudgetYM and   c.CategoryItemCode =''0002'' and c.DeptCode =''0001''
            left join 
    dbo.[tb缺货率指标预算表]A d on d.CategoryCode=''3'' and a.YM=d.BudgetYM and   d.CategoryItemCode =''0002'' and d.DeptCode =''0000''
    left join 
    (select CategoryCode,LEFT(OccurDate,6)BudgetYM,SUM(可订货次数)可订货次数,SUM(非中央控制缺货次数)非中央控制缺货次数,SUM(中央控制缺货次数)中央控制缺货次数 from 
('+@SQL1+')a left join 
TB部门信息表 b on  a.nodecode=b.nodecode
where datediff(MONTH ,case when datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left(OpenDate,6)+''01'')+1, 0)))>=20 then DATEADD(m, 1, OpenDate) - (DATEPART(day, DATEADD(m, 1, OpenDate)) - 1) else OpenDate end,CONVERT(varchar(8),DATEADD(ms, -3, DATEADD(mm, DATEDIFF(m, 0,LEFT(OccurDate,6)+''01'') + 1, 0)),112))+1>3

group by CategoryCode,LEFT(OccurDate,6)) e on a.CategoryCode=e.CategoryCode and a.YM=e.BudgetYM 
    order by 1,2,3,4

'exec(@sql)



select  * from 
tb分类对照表
where CategoryItemCode='0002' and CategoryLevel<=2


