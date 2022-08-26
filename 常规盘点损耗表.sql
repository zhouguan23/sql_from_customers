
select a.DeptCategoryCode 业态编码,a.CategoryName 业态名称,a.NodeCode 部门编码,a.NodeName 部门名称,
b.Countid 盘点编号,b.CountName 盘点名称,b.CountDate 盘点日期,b.CarryDate 结转日期 from 
(
--获取部门信息
select DeptCategoryCode,b.CategoryName,a.NodeCode,c.NodeName from 
[000]A .TBCATTODEPARTMENT a 
left join 
[000]A .TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode and b.CategoryItemCode='0011'
left join 
[000]A .tbNode c on a.NodeCode=c.NodeCode 
where DeptCatItemCode='0011' and (a.NodeCode like '1%' or a.NodeCode like '2%' or a.NodeCode like '9%') )a 
left join 
--获取201808（可设置）门店盘点信息
[000]A .TBCOUNTPROJECTSLOG b on a.NodeCode =b.DeptCode 
where CountState in (0,1) and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode  in ('" + replace(bm,",","','")+"')") }
and CountDate like '${YM}%'










DECLARE @SQL VARCHAR(MAX),@zb VARCHAR(MAX),@cb VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@pdjsny varchar(6), @pdqsny varchar(6),@pdqsrq varchar(8),@pddqrq varchar(8)

set @pddqrq=convert(varchar(8),dateadd(dd,0,'${xsdqrq}'),112)
set @pdjsny=@pddqrq
set @pdqsny=convert(varchar(8),dateadd(mm,-5,@pddqrq),112)

SET @zb =''
SELECT @zb=@zb+' UNION ALL SELECT a.* FROM 
[000]A.'+[name]A+' a,
(select a.DeptCode ,a.Countid,
case when b.CountDate IS null then c.OpenDate else convert(varchar(8),dateadd(dd,1,b.CountDate),112) end  PreCountDate,
a.CountDate,
case when b.CarryDate IS null then c.OpenDate else convert(varchar(8),dateadd(dd,1,b.CarryDate),112) end PreCountCarryDate,
case when len(a.CarryDate)=0 then a.CountDate else convert(varchar(8),dateadd(dd,0,a.CarryDate),112) end CountCarryDate      from 
(select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))a
left join 
(select * from 
(select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid not in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0''  and CountState in (0,1) and   a.DeptCode =b.DeptCode ))a
where CountMode =''0'' and CountState in (0,1) and   Countid in (select MAX(Countid) from (select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid not in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))b 
where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))b 
on a.DeptCode =b.DeptCode 
left join 
[000]A .TBDEPARTMENT c on a.DeptCode =c.NodeCode 

where a.CountDate ='+@pddqrq+')b

where a.deptcode=b.deptcode 
and   a.accDate between b.PreCountCarryDate and b.CountCarryDate
and   a.ProfitLossType in  (1)
and    1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in (''" + replace(bm,",","'',''")+"'')") }
 '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_PROFITLOSSBILL' and SUBSTRING(name,3,6) between  @pdqsny and @pdjsny
SET @zb=STUFF(@zb,1,11,'')

SET @cb =''
SELECT @cb=@cb+' UNION ALL SELECT c.CategoryCode GoodsCatCode,a.* FROM 
[000]A.'+[name]A+' a ,
[000]A .tbGoods c 
where  a.goodscode=c.goodscode
and    c.GoodsType =''0'' and    c.CategoryCode not like ''0%''
and not exists(select * from OPENDATASOURCE(''SQLOLEDB'',''Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#'').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and a.GoodsCode=z.goodscode)
and    a.ProfitLossType in  (1)
and    1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in (''" + replace(bm,",","'',''")+"'')") }
'
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_PROFITLOSSBILLDETIAL' and SUBSTRING(name,3,6) between  @pdqsny and @pdjsny
SET @cb=STUFF(@cb,1,11,'')



SET @SQL1='	
select zb.DeptCode,case when left(cb.GoodsCatCode,2)=''35'' then ''30'' else left(cb.GoodsCatCode,2) end GoodsCatCode,SUM(PurchMoney)-sum(PurchTax)PurchMoney from 
('+@zb+') zb,
('+@cb+') cb 
where zb.DeptCode =cb.deptcode and zb.BillNumber =cb.BillNumber  
 group by zb.DeptCode,case when left(cb.GoodsCatCode,2)=''35'' then ''30'' else left(cb.GoodsCatCode,2) end
'exec(@sql1)


	
DECLARE @rq VARCHAR(MAX),@SQL VARCHAR(MAX),@zb VARCHAR(MAX),@cb VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@xsjsny varchar(6), @xsqsny varchar(6),@xsqsrq varchar(8),@xsdqrq varchar(8)
set @xsdqrq=convert(varchar(8),dateadd(dd,0,'${xsdqrq}'),112)
set @xsjsny=@xsdqrq
set @xsqsny=convert(varchar(8),dateadd(mm,-5,@xsdqrq),112)
SET @sql =''
SELECT @SQL=@SQL+' UNION ALL SELECT b.PreCountDate,b.CountDate,b.PreCountCarryDate,b.CountCarryDate,a.nodecode, left(c.CategoryCode,2)CategoryCode,sum(a.SaleCost)SaleCost
FROM [000]A.'+[name]A+' a,
(select a.DeptCode ,a.Countid,
case when b.CountDate IS null then c.OpenDate else convert(varchar(8),dateadd(dd,1,b.CountDate),112) end  PreCountDate,
a.CountDate,
case when b.CarryDate IS null then c.OpenDate else convert(varchar(8),dateadd(dd,1,b.CarryDate),112) end PreCountCarryDate,
case when len(a.CarryDate)=0 then a.CountDate else convert(varchar(8),dateadd(dd,0,a.CarryDate),112) end CountCarryDate      from 
(select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))a
left join 
(select * from 
(select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid not in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0''  and CountState in (0,1) and   a.DeptCode =b.DeptCode ))a
where CountMode =''0'' and CountState in (0,1) and   Countid in (select MAX(Countid) from (select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid not in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))b 
where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))b 
on a.DeptCode =b.DeptCode 
left join 
[000]A .TBDEPARTMENT c on a.DeptCode =c.NodeCode 


where a.CountDate ='+@xsdqrq+')b,
[000]A .tbGoods c   where  a.nodecode=b.deptcode and a.goodscode=c.goodscode
and  c.GoodsType =''0''
and  a.occurdate between b.PreCountDate and b.CountDate
and  c.CategoryCode not like ''0%''
and  c.CategoryCode not like ''35000''
and not exists(select * from OPENDATASOURCE(''SQLOLEDB'',''Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#'').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.GoodsCode=z.goodscode)

and    1=1 ${if(len(bm) == 0,   "",   "and a.nodecode  in (''" + replace(bm,",","'',''")+"'')") }
group by b.PreCountDate,b.CountDate,b.PreCountCarryDate,b.CountCarryDate,a.nodecode, left(c.CategoryCode,2)
  '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM'   and SUBSTRING(name,3,6) between  @xsqsny and @xsjsny
SET @SQL=STUFF(@SQL,1,11,'')
sET @SQL1='
select PreCountDate,CountDate,PreCountCarryDate,CountCarryDate,nodecode,case when CategoryCode=''35'' then ''30'' else CategoryCode end CategoryCode,SUM(SaleCost)SaleCost  from  
('+@SQL+')a
group by PreCountDate,CountDate,PreCountCarryDate,CountCarryDate,nodecode,case when CategoryCode=''35'' then ''30'' else CategoryCode end
order by nodecode,CategoryCode
'exec(@sql1)










DECLARE @SQL VARCHAR(MAX),@zb VARCHAR(MAX),@cb VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@pdjsny varchar(6), @pdqsny varchar(6),@pdqsrq varchar(8),@pddqrq varchar(8)

set @pddqrq=convert(varchar(8),dateadd(dd,0,'${xsdqrq}'),112)
set @pdjsny=@pddqrq
set @pdqsny=convert(varchar(8),dateadd(mm,-5,@pddqrq),112)

SET @zb =''
SELECT @zb=@zb+' UNION ALL SELECT a.* FROM 
[000]A.'+[name]A+' a,
(select a.DeptCode ,a.Countid,
case when b.CountDate IS null then c.OpenDate else convert(varchar(8),dateadd(dd,1,b.CountDate),112) end  PreCountDate,
a.CountDate,
case when b.CarryDate IS null then c.OpenDate else convert(varchar(8),dateadd(dd,1,b.CarryDate),112) end PreCountCarryDate,
case when len(a.CarryDate)=0 then a.CountDate else convert(varchar(8),dateadd(dd,0,a.CarryDate),112) end CountCarryDate      from 
(select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))a
left join 
(select * from 
(select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid not in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0''  and CountState in (0,1) and   a.DeptCode =b.DeptCode ))a
where CountMode =''0'' and CountState in (0,1) and   Countid in (select MAX(Countid) from (select * from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountMode =''0'' and CountState in (0,1) and   Countid not in (select MAX(Countid) from [000]A.TBCOUNTPROJECTSLOG b where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))b 
where CountMode =''0'' and CountState in (0,1) and   a.DeptCode =b.DeptCode ))b 
on a.DeptCode =b.DeptCode 
left join 
[000]A .TBDEPARTMENT c on a.DeptCode =c.NodeCode 

where a.CountDate ='+@pddqrq+')b

where a.deptcode=b.deptcode 
and   a.accDate between b.PreCountCarryDate and b.CountCarryDate
and   a.ProfitLossType in  (0,2,3)
and    1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in (''" + replace(bm,",","'',''")+"'')") }
 '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_PROFITLOSSBILL' and SUBSTRING(name,3,6) between  @pdqsny and @pdjsny
SET @zb=STUFF(@zb,1,11,'')

SET @cb =''
SELECT @cb=@cb+' UNION ALL SELECT c.CategoryCode GoodsCatCode,a.* FROM 
[000]A.'+[name]A+' a ,
[000]A .tbGoods c 
where  a.goodscode=c.goodscode
and    c.GoodsType =''0'' and    c.CategoryCode not like ''0%''
and not exists(select * from OPENDATASOURCE(''SQLOLEDB'',''Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#'').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and a.GoodsCode=z.goodscode)
and    a.ProfitLossType in  (0,2,3)
and    1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in (''" + replace(bm,",","'',''")+"'')") }
'
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_PROFITLOSSBILLDETIAL' and SUBSTRING(name,3,6) between  @pdqsny and @pdjsny
SET @cb=STUFF(@cb,1,11,'')



SET @SQL1='	
select zb.DeptCode,case when left(cb.GoodsCatCode,2)=''35'' then ''30'' else left(cb.GoodsCatCode,2) end  GoodsCatCode,SUM(PurchMoney)-sum(PurchTax)PurchMoney from 
('+@zb+') zb,
('+@cb+') cb 
where zb.DeptCode =cb.deptcode and zb.BillNumber =cb.BillNumber  
 group by zb.DeptCode,case when left(cb.GoodsCatCode,2)=''35'' then ''30'' else left(cb.GoodsCatCode,2) end
'exec(@sql1)


select * from 
TB损耗指标
where CountType='0'and  1=1 ${if(len(bm) == 0,   "",   "and NODECODE  in ('" + replace(bm,",","','")+"')") }
union all 
select NodeCode,'0' CountType,0 TargetValue from 
TB部门信息表
where NodeCode like '9%' and  1=1 ${if(len(bm) == 0,   "",   "and NODECODE  in ('" + replace(bm,",","','")+"')") }

select DISTINCT CountDate,deptcode from 
[000]A.TBCOUNTPROJECTSLOG a 
where CountState in (0,1) and CountDate like '${YM}%' 



select DISTINCT CountDate,deptcode,deptcode+''+c.nodename nodename from 
[000]A.TBCOUNTPROJECTSLOG a 
left join 
[000]A .tbNode c on a.deptcode=c.NodeCode 
where CountState in (0,1) and  CountDate like '${xsdqrq}'  and 
1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and deptcode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}

