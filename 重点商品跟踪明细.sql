
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq

SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select d.AreaCode,d.FormatCode,b.nodecode,left(CategoryCode,2)CategoryCode,
case when c.GoodsBrand=''010001'' then ''1'' else ''0'' end GoodsBrand,a.GoodsCode,c.GoodsName,a.BeginDate+''-''+a.EndDate Date,sum(b.TaxSaleGrossProfit  )TaxSaleGrossProfit,
sum(b.SaleIncome+b.SaleTax) SaleMoney,sum(b.SaleAmount   )SaleAmount ,
sum(case when b.OccurDate='''+@dqrq+'''  then  b.SaleAmount else 0 end ) zr_SaleAmount,
sum(case when b.OccurDate='''+@dqrq+'''  then  b.SaleIncome+b.SaleTax else 0 end ) zr_SaleMoney,sum(case when b.OccurDate='''+@dqrq+'''  then  b.TaxSaleGrossProfit else 0 end  )zt_TaxSaleGrossProfit
 from 
tbSpecialGoodsList a
left join 
 '+[name]A+'    b on a.goodscode=b.goodscode  and b.Occurdate between a.BeginDate and a.EndDate
 left join 
tb商品档案 c on a.goodscode =c.goodscode 
left join 

tb部门信息表 d on b.nodecode=d.nodecode

where   b.OccurDate between '''+@qsrq+''' and '''+@dqrq+''' 
AND LEFT(b.NodeCode,1) in (''1'' ,''2'')
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and 1=1 ${if(len(bm) == 0,   "",   "and b.NodeCode in (''" + replace(bm,",","'',''")+"'')") } 
and 1=1 ${if(len(sp) == 0,   "",   "and a.goodscode in (''" + replace(sp,",","'',''")+"'')") } 
and 1=1 ${pp==" ",   "", if(pp==1,"and c.GoodsBrand=''010001''" ,"and c.GoodsBrand!=''010001''") ) }
and 1=1 ${if(len(yt) == 0,   "",   "and d.FormatCode in (''" + replace(yt,",","'',''")+"'')") }
and 1=1 ${if(len(sp) == 0,   "",   "and a.goodscode in (''" + replace(sp,",","'',''")+"'')") }

group by d.AreaCode,d.FormatCode,b.nodecode,left(CategoryCode,2),case when GoodsBrand=''010001'' then ''1'' else ''0'' end ,a.GoodsCode,c.GoodsName,a.BeginDate+''-''+a.EndDate
' 
 FROM  SYS.SYSOBJECTS 
 WHERE  type='U' AND SUBSTRING(name,9,99) like '_GoodsDayPssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

 
SET @SQL1=STUFF(@SQL1,1,11,'')




SET @SQL='

select AreaCode,FormatCode,a.nodecode,a.CategoryCode,a.GoodsBrand,a.GoodsCode,a.GoodsName,Date,
sum(a.SaleAmount ) SaleAmount ,sum(a.SaleMoney) SaleMoney,sum(a.TaxSaleGrossProfit  )TaxSaleGrossProfit,isnull(sum(A.zr_SaleAmount ),0)zr_SaleAmount ,
isnull(sum(A.zr_SaleMoney),0)zr_SaleMoney,isnull(sum(a.zt_TaxSaleGrossProfit),0)zt_TaxSaleGrossProfit ,b.Amount,b.TaxCost  from 
('+@SQL1+'  )             a 
left join

OPENDATASOURCE(''SQLOLEDB'',''Data Source=192.100.0.59,1433\sql2012;User ID=sa;Password=85973099hlxxb!@#'').HLDW2.dbo.tbStocks b on a.nodecode=b.CounterCode and a.goodscode=b.goodscode 

group by AreaCode,FormatCode,a.nodecode,a.CategoryCode,a.GoodsBrand,a.GoodsCode,a.GoodsName,Date
,b.Amount,b.TaxCost 
order by 1,2,3,4,5


'exec(@sql)


select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='1'
union all 
select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2'

