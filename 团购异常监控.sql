 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),@SQL4 VARCHAR(MAX),@SQL5 VARCHAR(MAX),@SQL6 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'      and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") } 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SaleBill' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SaleBillDetail' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT * FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SALERENTDETAIL' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL3=STUFF(@SQL3,1,11,'')
SET @SQL4=''
SELECT @SQL4=@SQL4+' UNION ALL SELECT * FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SALEPAYMENTDETAIL' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL4=STUFF(@SQL4,1,11,'')

SET @SQL5=''
SELECT @SQL5=@SQL5+' UNION ALL SELECT * FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_CARDTRADINGDETAILS' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL5=STUFF(@SQL5,1,11,'')

SET @SQL6=''
SELECT @SQL6=@SQL6+' UNION ALL SELECT * FROM '+[name]A+' 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SALEBANDDETAIL' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL6=STUFF(@SQL6,1,11,'')

SET @SQL='



select a.BuildDate,a.SaleTime,a.DeptCode,a.BillNumber,a.SellCashierCode,a.SellCashierName,CardCode,PosNo,a.SaleMoney,a.HandRebate,c.PaymentModeCode,sum(PayMoney)PaymentMoney from 

(select a.BuildDate,a.SaleTime,a.DeptCode,a.BillNumber,a.SellCashierCode,a.SellCashierName,sum(SaleEarning+SaleTax)SaleMoney,sum(case when IsBinding=1 then scbb.HandRebate else b.HandRebate end)HandRebate from 
 ('+@SQL1+')  a
left join 
(select a.DeptCode,InnerId,IsBinding,a.BillNumber,a.GoodsCode,a.SaleAmount,a.SaleEarning,a.SaleTax,a.HandRebate,a.SaleRemark from  ('+@SQL2+')  a 
union all 
 select a.DeptCode,InnerId,''0''IsBinding,a.BillNumber,a.GoodsCode,a.SaleAmount,a.SaleEarning,a.SaleTax,a.HandRebate,a.SaleRemark from  ('+@SQL3+')  a) b 
  on a.DeptCode=b.DeptCode and a.BillNumber=b.BillNumber
left Join (select cbb.DeptCode,cbb.BillNumber,cbb.MasterID,sum(cbb.AutoRebate) AutoRebate,sum(cbb.HandRebate) HandRebate  from ('+@SQL6+') cbb 
 group by cbb.DeptCode,cbb.BillNumber,cbb.MasterID  ) scbb on scbb.DeptCode=b.DeptCode and scbb.BillNumber=b.BillNumber  and scbb.MasterID=b.InnerId  
 
where IsOutRule =0 
group by a.BuildDate,a.SaleTime,a.DeptCode,a.BillNumber,a.SellCashierCode,a.SellCashierName)a
left join 
 ('+@SQL4+')  c on a.DeptCode=c.DeptCode and a.BillNumber=c.BillNumber
 left join 
 ('+@SQL5+')  d on a.DeptCode=d.DepartmentCode and a.BillNumber=d.BillNumber
  where a.SaleMoney>=2000 and c.PaymentModeCode=''0001'' and a.HandRebate>0 and len(CardCode)=7 
 group by a.BuildDate,a.SaleTime,a.DeptCode,a.BillNumber,a.SellCashierCode,a.SellCashierName,CardCode,PosNo,a.SaleMoney,a.HandRebate,c.PaymentModeCode

order by 1,2,3

'exec(@sql)


select CardCode,a.MemberCode,CardInNum,AccountsCode,typeID,LevelID,MemberName,MemberName,MobilePhone,CardState from 
[9001]A.TBCARD a 
left join 
[9001]A.TBMEMBER b on a.MemberCode=b.MemberCode
where a.typeID not in (1) and CardState =2 and a.MemberCode !=''

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


