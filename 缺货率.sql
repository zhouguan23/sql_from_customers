select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' a where a.OccurDate between '+@qsrq+' and '+@dqrq+' 
and (a.NodeCode  like  ''1%'' or a.NodeCode like  ''2%'')
and 1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in (''" + replace(bm,",","'',''")+"'')") } 
and 1=1 ${if(len(fl2) == 0,   "",   "and LEFT(a.CategoryCode,2) in (''" + replace(fl2,",","'',''")+"'')") } 
and  1=1 ${if(sx == "0000",   "",   "and  CategoryItemCode=''sx''") }

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%月度缺货数据' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='



select a.AreaCode,a.AreaName,a.FormatName,left(a.YM,6) 年月,a.YM 日期,a.NodeCode,''0000'' CategoryItemCode,a.ParentCategoryCode 大分类,a.CategoryCode 课分类
,isnull(e.可订货次数,0)可订货SKU
,isnull(e.非中央控制缺货次数+e.门店缺货次数+e.中央控制缺货次数,0)缺货SKU
,isnull(e.非中央控制缺货次数,0)非中央控制缺货SKU
,isnull(e.中央控制缺货次数,0)中央控制缺货SKU
,isnull(e.门店缺货次数,0)门店职责缺货SKU
 from 
(select left(CategoryCode,1)ParentCategoryCode,CategoryCode1,CategoryCode ,YM ,AreaCode,AreaName,FormatName,NodeCode  from 
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
(SELECT CONVERT(varchar(8),DATEADD(day,number,''${qsrq}''),112) AS YM
FROM master.dbo.spt_values
WHERE type = ''p''
    AND DATEADD(day,number,''${qsrq}'') <=''${dqrq}'')b
    ,
    TB部门信息表 c 
    where 

    LEFT(NodeCode ,1) between 1 and 2
    and 1=1 ${if(len(bm) == 0,   "",   "and c.NodeCode in (''" + replace(bm,",","'',''")+"'')") } 
    and 1=1 ${if(len(fl2) == 0,   "",   "and LEFT(a.CategoryCode,2) in (''" + replace(fl2,",","'',''")+"'')") } 
    and len(AreaCode)!=0
    )a
    left join 
    (select a.NodeCode,a.CategoryCode,OccurDate BudgetYM,
    SUM(可订货次数)可订货次数,SUM(非中央控制缺货次数)非中央控制缺货次数,SUM(中央控制缺货次数)中央控制缺货次数,SUM(门店缺货次数)门店缺货次数 from 
 ('+@SQL1+')  a 
where  1=1 ${if(sx == "0000",   "",   "and a.CategoryItemCode in (''" + replace(sx,",","'',''")+"'')") } 
group by a.NodeCode,a.CategoryCode,a.OccurDate) e on a.CategoryCode=e.CategoryCode and a.YM=e.BudgetYM  and a.NodeCode=e.NodeCode
    order by 1,2,3,5,6,7,8 asc ,4 desc
    




'exec(@sql)

select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

