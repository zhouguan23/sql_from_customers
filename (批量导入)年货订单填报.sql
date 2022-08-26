SELECT * FROM 
tbYEARPOBILLDETAIL_dr

select round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0000'
and BudgetYM  between  convert(varchar(6),'202001',112) and  convert(varchar(6),'202002',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }



select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from TB商品分类表
  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

select sum(a.SeleMoney)SeleMoney2018,sum(b.SeleMoney)SeleMoney2019 from 
(select sum(a.SaleIncome+a.SaleTax)SeleMoney from 
(select * from tb201802_GoodsDayPSSM union all select * from tb201801_GoodsDayPSSM) a,
tb商品档案 b
where a.GoodsCode=b.goodscode and b.goodstype in (0) and CategoryCode not like '300%'
and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") })a,
(select sum(a.SaleIncome+a.SaleTax)SeleMoney from 
(select * from tb201902_GoodsDayPSSM union all select * from tb201901_GoodsDayPSSM) a,
tb商品档案 b
where a.GoodsCode=b.goodscode and b.goodstype in (0) and CategoryCode not like '300%' and
1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") })b

