
--定义变量的类型和长度
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)


--定义变量
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq

--取日进销存
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT a.occurdate,a.NodeCode,a.GoodsCode,b.goodsname,sum(a.SaleAmount)SaleAmount,sum(a.SaleIncome+a.SaleTax)saleMoney  FROM '+[name]A+' a ,TB商品档案 b 
where a.GoodsCode=b.GoodsCode and b.CategoryCode like ''35%''
and  a.occurdate between '+@qsrq+' and '+@dqrq+'
and  a.occurdate !=convert(varchar(8),dateadd(dd,0,getdate()),112)
group by a.occurdate,a.NodeCode,a.GoodsCode,b.goodsname
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')





SET @SQL='

select a.NodeCode,b.GoodsCode,b.GoodsName ,sum(b.SaleAmount)SaleAmount,sum(b.saleMoney)saleMoney 
from 
--按总部门提取
tb部门信息表 a 
left join 
(select * from ('+@SQL1+')a ) b on a.nodecode=b.nodecode
where  LEFT(a.NodeCode ,1) between 1 and 2
    and len(a.AreaCode)!=0
group by a.NodeCode,b.GoodsCode,b.GoodsName 
order by 1,2,3

'exec(@sql)




select * from 
TBDAYCARRYLOG a
where a.CarryDate=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)

