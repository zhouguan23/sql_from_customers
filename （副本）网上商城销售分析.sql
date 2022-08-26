select a.DeptCode as 部门编码,left(c.CategoryCode,2) as 商品分类,(count(left(c.CategoryCode,2))) as 客流 ,
SUM(b.SaleEarning+b.SaleTax) as 销售金额,
SUM((b.SaleEarning+b.SaleTax)-b.LastPrice) as 参考毛利 from 

[000]A.TB201811_SALEBILL a, --销售单
[000]A.TB201811_SALEBILLDETAIL b, --销售单明细
[000]A .tbGoods c --商品档案表 

where a.BillNumber=b.BillNumber and a.DeptCode =b.DeptCode and b.GoodsCode =c.GoodsCode  and a.SellCashierCode='8000' and a.SaleTag=0 and a.IsOutRule=0 

and a.EnterAccountDate <= CONVERT(varchar(100), GETDATE(), 112)

group by a.DeptCode,left(c.CategoryCode,2)

order by left(c.CategoryCode,2) asc


select a.DeptCode as 部门编码,left(c.CategoryCode,2) as 商品分类,count(left(c.CategoryCode,2)) as 客流 ,SUM(b.SaleEarning+b.SaleTax) as 销售金额,
SUM((b.SaleEarning+b.SaleTax)-b.LastPrice) as 参考毛利 from 

[1025]A.TB201811_SALEBILL a, --销售单
[1025]A.TB201811_SALEBILLDETAIL b, --销售单明细
[1025]A .tbGoods c --商品档案表 

where a.BillNumber=b.BillNumber and a.DeptCode =b.DeptCode and b.GoodsCode =c.GoodsCode  and a.SellCashierCode='8000' and a.SaleTag=0 and a.IsOutRule=0

group by a.DeptCode,left(c.CategoryCode,2)

order by left(c.CategoryCode,2) asc


