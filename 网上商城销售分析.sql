


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'
and IsOutRule=''0'' 
and 1=1 ${if(len(gh) == 0,   "and SellCashierCode in (''9200'',''9400'',''8000'',''9000'')",   "and SellCashierCode in (''" + replace(gh,",","'',''")+"'')") }
 and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") } 
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SaleBill' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where  CancelFlag=''0''

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SaleBillDetail' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT * FROM '+[name]A+' 

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SalePaymentDetail' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL3=STUFF(@SQL3,1,11,'')

SET @SQL='

select a.DeptCode,a.BuildDate,a.BillNumber,a.SellCashierCode,a.SellCashierName,
c.PaymentModeCode,c.PaymentMoney,b.GoodsCode,d.GoodsName,d.BaseBarCode,b.SaleAmount,b.SaleEarning+b.SaleTax SaleMoney,b.IntegralValue from 
('+@SQL1+') a ,
('+@SQL2+') b  ,
('+@SQL3+') c,
tb商品档案 d 

where a.deptcode=b.deptcode and a.BillNumber=b.billnumber 
and a.BillNumber=c.BillNumber and a.DeptCode=c.DeptCode
and b.GoodsCode=d.GoodsCode 
and 1=1 ${if(len(spbm) == 0,   "",   "and b.goodscode in (''" + replace(spbm,",","'',''")+"'')") }


order by 1,2,3,4


'exec(@sql)



select a.DeptCode as 部门编码,left(c.CategoryCode,2) as 商品分类,count(left(c.CategoryCode,2)) as 客流 ,SUM(b.SaleEarning+b.SaleTax) as 销售金额,
SUM((b.SaleEarning+b.SaleTax)-b.LastPrice) as 参考毛利 from 

[1025]A.TB201811_SALEBILL a, --销售单
[1025]A.TB201811_SALEBILLDETAIL b, --销售单明细
[1025]A .tbGoods c --商品档案表 

where a.BillNumber=b.BillNumber and a.DeptCode =b.DeptCode and b.GoodsCode =c.GoodsCode  and a.SellCashierCode='8000' and a.SaleTag=0 and a.IsOutRule=0

group by a.DeptCode,left(c.CategoryCode,2)

order by left(c.CategoryCode,2) asc


select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


