select a.OccurDate,c.CategoryCode AreaCode,a.NodeCode,a.ParentCategoryCode,a.CategoryCode,
a.TaxSaleGrossProfit,a.SaleMoney ,ISNULL(b.SKU,0)SKU,b.TaxSaleGrossProfit NegativeProfit from 
(select a.OccurDate,a.NodeCode,left(b.CategoryCode,1)ParentCategoryCode,left(b.CategoryCode,3)CategoryCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit,SUM(SaleIncome+SaleTax)SaleMoney from 
(select * from [000]A .tb${YM}_GoodsDayPSSM where left(NodeCode ,1) between 5 and 9 and occurdate<='${rq}')  a,
[000]A .tbGoods b 
where a.GoodsCode =b.GoodsCode  and left(b.CategoryCode,1) between 6 and 9
and  1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,3)  in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in ('" + replace(bm,",","','")+"')") }

group by a.OccurDate,a.NodeCode,left(b.CategoryCode,1),left(b.CategoryCode,3))a
left join 
(select a.OccurDate,a.NodeCode,left(b.CategoryCode,1)ParentCategoryCode,left(b.CategoryCode,3)CategoryCode,
COUNT(a.GoodsCode)SKU,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit,SUM(SaleIncome+SaleTax)SaleMoney from 
(select * from [000]A .tb${YM}_GoodsDayPSSM where round(TaxSaleGrossProfit,1)<0 and SaleAmount >0 and left(NodeCode ,1) between 5 and 9 and occurdate<='${rq}')  a,
[000]A .tbGoods b 
where a.GoodsCode =b.GoodsCode and b.GoodsType in (0,2) and left(b.CategoryCode,1) between 6 and 9 
and  1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,2)  in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in ('" + replace(bm,",","','")+"')") }
group by a.OccurDate,a.NodeCode,left(b.CategoryCode,1),left(b.CategoryCode,3))b on a.occurdate=b.occurdate and a.nodecode =b.nodecode and a.CategoryCode=b.CategoryCode
left join 
(select b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0013'
where  a.DeptCatItemCode ='0013')c on a.nodecode =c.nodecode 
order by  c.CategoryCode ,a.NodeCode,a.ParentCategoryCode ,a.CategoryCode asc ,  a.OccurDate desc

select 
NodeCode,NodeName ,NodeCode+' '+NodeName Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")} and left(nodecode,1) in ('9') and nodecode not in ('9999') and len(AreaCode)>0 

