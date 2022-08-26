select e.CategoryCode,e.CategoryName,a.DeptCode ,a.GoodsCode,b.GoodsName,b.BaseBarCode ,a.WorkStateCode,
isnull(sum(c.SaleIncome+c.SaleTax),0)SaleMoney,isnull(sum(c.TaxSaleGrossProfit),0)TaxSaleGrossProfit,isnull(SUM(d.Amount),0)Amount  from 
[000]A .TBDEPTWORKSTATE   a
left join 
[000]A .tbGoods b on a.GoodsCode =b.GoodsCode 
left join 
[000]A .tb${YM}_GoodsDayPSSM c on a.DeptCode =c.NodeCode and a.GoodsCode =c.GoodsCode 
left join 
[000]A .TBSTOCKS d on a.DeptCode =d.CounterCode and a.GoodsCode =d.GoodsCode 
left join 
(select b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode and CategoryItemCode='0011'
where  DeptCatItemCode ='0011' ) e on a.DeptCode =e.NodeCode
where a.GoodsCode =b.GoodsCode and   left(a.DeptCode,1) between 1 and 2  and a.WorkStateCode in (1,2,4,5)  AND b.GoodsType =0 
and 1=1 ${if(len(fl1) == 0,   "",   "and left(b.CategoryCode,1) in ('" + replace(fl1,",","','")+"')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
and 1=1 ${if(len(fl3) == 0,   "",   "and left(b.CategoryCode,3) in ('" + replace(fl3,",","','")+"')") }
and 1=1 ${if(len(fl4) == 0,   "",   "and left(b.CategoryCode,4) in ('" + replace(fl4,",","','")+"')") }
and 1=1 ${if(len(fl5) == 0,   "",   "and left(b.CategoryCode,5) in ('" + replace(fl5,",","','")+"')") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode in ('" + replace(bm,",","','")+"')") }
group by e.CategoryCode,e.CategoryName,a.DeptCode ,a.GoodsCode,b.GoodsName,b.BaseBarCode ,a.WorkStateCode
order by 1,3,4

select * from tbStocks

where 1=1 ${if(len(fl1) == 0,   "",   "and left(goodscode,1) in ('" + replace(fl1,",","','")+"')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and left(goodscode,2) in ('" + replace(fl2,",","','")+"')") }
and 1=1 ${if(len(fl3) == 0,   "",   "and left(goodscode,3) in ('" + replace(fl3,",","','")+"')") }
and 1=1 ${if(len(fl4) == 0,   "",   "and left(goodscode,4) in ('" + replace(fl4,",","','")+"')") }
and 1=1 ${if(len(fl5) == 0,   "",   "and left(goodscode,5) in ('" + replace(fl5,",","','")+"')") }
and 1=1 ${if(len(bm) == 0,   "",   "and CounterCode in ('" + replace(bm,",","','")+"')") }

