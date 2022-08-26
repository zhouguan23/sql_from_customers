 DECLARE  @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@dqrq varchar(8),@jsny varchar(6),@qsrq varchar(8), @qsny varchar(6)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq


SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 

select a.报表日期,a.部门编码 ,LEFT(a.分类编码,2)分类编码,a.商品编码,a.商品名称,a.商品条码,a.商品单位,a.商品规格,a.经营状态,a.流转途径,
a.供应商,b.GoodsPropertyCode,a.最后进价,a.最后售价,a.库存数量,a.含税库存成本,a.正常DMS+a.促销DMS DMS,
进目录日期,最后销货日,最后进货日,最后状态异动日 from 
'+[name]A+' a 
left join 
TB部门特殊商品对照 b on a.部门编码=b.nodecode  and a.商品编码=b.goodscode and b.GoodsPropertyCode=''1999''
left join 
tb商品档案  c on a.商品编码=c.goodscode and c.GoodsType in (''0'')

WHERE a.报表日期 between '+@qsrq+' and '+@dqrq+'  
and 1=1 ${if(len(bm) == 0,   "",   "and a.部门编码 in (''" + replace(bm,",","'',''")+"'')") } 
and a.商品编码=c.goodscode
and 1=1 ${if(len(fl2) == 0,   "",   "and LEFT(a.分类编码,2) in (''" + replace(fl2,",","'',''")+"'')") } 
and  round(a.库存数量,1)<0  


' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%门店商品历史信息' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='



select a.ParentCategoryCode,a.CategoryCode,a.AreaCode,a.NodeCode,a.YM 报表日期
,ISNULL(SKU,0)SKU
,isnull(含税库存成本,0)PurchStockMoney
 from 
(select ParentCategoryCode,CategoryCode ,YM ,AreaCode,NodeCode  from 
(select ParentCategoryCode,CategoryCode from 
TB商品分类表 a

where a.CategoryItemCode=0000 and a.CategoryLevel=2  and a.CategoryCode not like ''1%'' and a.CategoryCode not like ''2%'' and a.CategoryCode not like ''6%'' and a.CategoryCode not like ''0%''

)a,
(SELECT CONVERT(varchar(8),DATEADD(day,number,''${qsrq}''),112) AS YM
FROM master.dbo.spt_values
WHERE type = ''p''
    AND DATEADD(day,number,''${qsrq}'') <=''${dqrq}'' )b
    ,
    TB部门信息表 c 
    where 
    LEFT(NodeCode ,1) between 1 and 2
    and len(AreaCode)!=0
	and 1=1 ${if(len(bm) == 0,   "",   "and c.nodecode in (''" + replace(bm,",","'',''")+"'')") } 
    and 1=1 ${if(len(fl2) == 0,   "",   "and CategoryCode in (''" + replace(fl2,",","'',''")+"'')") } 
    )a
    left join 
    (select a.部门编码 NodeCode,a.分类编码 CategoryCode,a.报表日期 BudgetYM,
    count(a.商品编码)SKU,SUM(a.含税库存成本)含税库存成本 from 
 ('+@SQL1+')  a 
group by a.部门编码 ,a.分类编码 ,a.报表日期) e on a.CategoryCode=e.CategoryCode and a.YM=e.BudgetYM  and a.NodeCode=e.NodeCode



order by 1,2,3,4 asc ,5 desc

'exec(@sql)

