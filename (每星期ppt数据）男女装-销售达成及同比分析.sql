
select AreaCode,NodeCode DeptCode,WhetherNew ,case when WhetherNew='1'  then '新店' when year='1'  then '开业1年以上' when year>'1'  then '开业2年以上' else '0' end year    ,
isnull(b.Salesindex,0) Salesindex,
isnull(b.Grossprofitindex,0) Grossprofitindex
 from 
(select  AreaCode,NodeCode,case when 
datediff(day,OpenDate,convert(varchar(8),dateadd(dd,0,'${tqdqrq}'),112))>=20
 then 0 else 1 end  WhetherNew  ,
 datediff(year,OpenDate,convert(varchar(8),dateadd(dd,0,'${dqrq}'),112))year
from TB部门信息表 b
where   NodeCode  LIKE '9%' AND nodecode<>'9019' AND nodecode<>'9999'
and OpenDate<=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
 )a
left join 
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where DeptCode   LIKE '9%' and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${qsrq}'),112) and convert(varchar(6),dateadd(dd,0,'${dqrq}'),112)
group by DeptCode)b on a.NodeCode=b.DeptCode
order by 1,4,3,2

select left(GoodsCode,3)SJFLXS,left(GoodsCode,4)SJFL,SUM(SaleIncome +SaleTax)XSJE,SUM(TaxSaleGrossProfit)ML from [000]A.TB${YM}_GOODSDAYPSSM
where  1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") }
and OccurDate between '${qsrq}'  and '${dqrq}'
and left(GoodsCode,3) in ('620')
GROUP BY left(GoodsCode,3),left(GoodsCode,4)
ORDER BY left(GoodsCode,3),left(GoodsCode,4)


select left(GoodsCode,3)SJFLXS,left(GoodsCode,4)SJFL,SUM(SaleIncome +SaleTax)XSJE,SUM(TaxSaleGrossProfit)ML from [000]A.TB${YM}_GOODSDAYPSSM
where  1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") }
and OccurDate between '${tqqsrq}'  and '${tqdqrq}'
and left(GoodsCode,3) in ('620')
GROUP BY left(GoodsCode,3),left(GoodsCode,4)
ORDER BY left(GoodsCode,3),left(GoodsCode,4)


select b.CategoryCode,b.CategoryName from 

[000]A.TBDEPTCATEGORY b 
where CategoryItemCode=0013 and CategoryCode not in (3,9)
and b.CategoryCode='${bm}'

select 
NodeCode,NodeName ,NodeCode+' '+NodeName Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")} and left(nodecode,1) in ('9') and nodecode not in ('9999') and len(AreaCode)>0 

select left(GoodsCode,3)SJFLXS,left(GoodsCode,4)SJFL,SUM(SaleIncome +SaleTax)XSJE,SUM(TaxSaleGrossProfit)ML from [000]A.TB${YM}_GOODSDAYPSSM
where  1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") }
and OccurDate between '${qsrq}'  and '${dqrq}'
and left(GoodsCode,3) in ('621')
GROUP BY left(GoodsCode,3),left(GoodsCode,4)
ORDER BY left(GoodsCode,3),left(GoodsCode,4)


select left(GoodsCode,3)SJFLXS,left(GoodsCode,4)SJFL,SUM(SaleIncome +SaleTax)XSJE,SUM(TaxSaleGrossProfit)ML from [000]A.TB${YM}_GOODSDAYPSSM
where  1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") }
and OccurDate between '${tqqsrq}'  and '${tqdqrq}'
and left(GoodsCode,3) in ('621')
GROUP BY left(GoodsCode,3),left(GoodsCode,4)
ORDER BY left(GoodsCode,3),left(GoodsCode,4)


