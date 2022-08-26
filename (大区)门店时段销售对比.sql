select a.FormatCode,a.FormatName,a.AreaCode,a.AreaName,b.BulidMoment,
a.NodeCode,NodeName,
SUM(b.销售金额) SaleMoney,
SUM(c.销售金额) 昨日SaleMoney,
SUM(D.销售金额) 上周SaleMoney,
SUM(b.销售笔数)SaleCount,
SUM(c.销售笔数)昨日SaleCount,
SUM(d.销售笔数)上周SaleCount  from 
dbo.TB部门信息表 a 
left join 
(
select a.DeptCode ,a.BulidMoment/60 BulidMoment,SUM(SaleIncome+SaleTax) 销售金额,SUM(a.SaleCount)销售笔数
 from tb${YM}_门店时段日销售 a 
 
 where CategoryItemCode='0000' and (DeptCode  like '1%' or  DeptCode  like '2%') and BulidDate ='${rq}'
 and a.BulidMoment<='${mm}'
 group by a.DeptCode ,a.BulidMoment/60) b on a.NodeCode =b.DeptCode  
 left join 
(
select a.DeptCode ,a.BulidMoment/60 BulidMoment,SUM(SaleIncome+SaleTax) 销售金额,SUM(a.SaleCount)销售笔数
 from tb${VSYM}_门店时段日销售 a 
 
 where CategoryItemCode='0000' and (DeptCode  like '1%' or  DeptCode  like '2%') and BulidDate ='${vsrq}'
 and a.BulidMoment<='${mm}'
 group by a.DeptCode ,a.BulidMoment/60) c on a.NodeCode =c.DeptCode    and b.BulidMoment=c.BulidMoment
  left join 
(
select a.DeptCode ,a.BulidMoment/60 BulidMoment,SUM(SaleIncome+SaleTax) 销售金额,SUM(a.SaleCount)销售笔数
 from tb${VSYM2}_门店时段日销售 a 
 
 where CategoryItemCode='0000' and (DeptCode  like '1%' or  DeptCode  like '2%') and BulidDate ='${vsrq2}'
 and a.BulidMoment<='${mm}'
 group by a.DeptCode ,a.BulidMoment/60) d on a.NodeCode =d.DeptCode    and b.BulidMoment=d.BulidMoment
where (a.NodeCode like '1%' or  a.NodeCode like '2%') and a.nodecode <>'1047'
and  1=1 ${if(len(bm)==0,"","and a.AreaCode in ('"+replace(bm,",","','")+"')")} 
group by a.FormatCode,a.FormatName,a.AreaCode,a.AreaName,b.BulidMoment,a.NodeCode,a.NodeName
order by a.FormatCode,a.FormatName,a.AreaCode,a.AreaName,b.BulidMoment,a.NodeCode,a.NodeName




