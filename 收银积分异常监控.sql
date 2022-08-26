 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where AccDate between '+@qsrq+' and '+@dqrq+'
and 1=1 ${if(len(bm) == 0,   "",   "and DepartmentCode in (''" + replace(bm,",","'',''")+"'')") } 
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_CARDTRADINGDETAILS' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' where BuildDate between '+@qsrq+' and '+@dqrq+'
' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_SaleBill' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL='


select a.DepartmentCode,a.AccDate,right(b.TradingTime,6)TradingTime,a.CardCode,a.bs,b.BillNumber,b.PosNo,b.SaleMoney,b.IntegralValue,c.SellCashierCode,c.SellCashierName from 
(select AccDate,DepartmentCode,CardCode,count(BillNumber)bs from 
 ('+@SQL1+') a
where round(SaleMoney,0)>50 and 
round(IntegralValue,0)>0 and CardCode not in( ''10074'',''10075'',''10076'')
 
group by AccDate,DepartmentCode,CardCode  having count(BillNumber) >= 3)a
left join 
 ('+@SQL1+') b on a.AccDate=b.AccDate and a.DepartmentCode=b.DepartmentCode and a.CardCode=b.CardCode and round(b.SaleMoney,0)>50   
 and round(b.IntegralValue,0)>0 and b.CardCode not in(''10074'',''10075'',''10076'')
 
left join 
 ('+@SQL2+')  c on b.DepartmentCode=c.DeptCode and b.BillNumber=c.BillNumber

where c.SaleTag=''0'' and c.IsOutRule=''0''
order by  5 desc, 1,2,3 asc
'exec(@sql)







select CardCode,a.MemberCode,CardInNum,AccountsCode,typeID,LevelID,MemberName,MemberName,MobilePhone,CardState from 
[9001]A.TBCARD a 
left join 
[9001]A.TBMEMBER b on a.MemberCode=b.MemberCode
where a.typeID not in (1) and CardState =2 and a.MemberCode !=''

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

