

select a.AreaCode,a.FormatCode,a.NodeCode DeptCode,a.ParentCategoryCode,
case when a.NodeCode like '1%' or a.NodeCode like '2%' then '超市部分'
when a.NodeCode like '9%' then '百货部分'
when a.NodeCode like '5%' then '红果生活广场' end PK,
case when a.ParentCategoryCode in ('生鲜团队','常规团队') then '生鲜团队VS常规团队'
when a.ParentCategoryCode in ('加工团队','自有品牌团队') then '加工团队VS自有品牌团队'end ZBPK,
case when a.AreaCode in ('1','5') then '贵阳大区VS凯里大区'
when a.AreaCode in ('6','7') then '惠民一区VS惠民二区'
when a.AreaCode in ('3','4') then '遵义一区VS遵义二区'
when a.AreaCode in ('0','8') then '毕节大区VS兴义大区'
end DQPK,

isnull(b.Salesindex,0)*1.05 Salesindex,
isnull(b.Grossprofitindex,0)*1.05 Grossprofitindex,
isnull(d.SaleMoney,0) SaleMoney,
isnull(d.TaxSaleGrossProfit,0)TaxSaleGrossProfit
 from 
(
select  distinct a.AreaCode,case when a.OpenDate>='20191201' then '新开门店(12、1月)' else a.FormatCode end FormatCode,a.NodeCode,
case when b.ParentCategoryCode like '1%' then '生鲜团队'
when b.ParentCategoryCode like '2%' then '加工团队'
when b.ParentCategoryCode like '3%' or b.ParentCategoryCode like '4%' or b.ParentCategoryCode like '5%' then '常规团队' else b.ParentCategoryCode end ParentCategoryCode
 from 
TB部门信息表 a ,
TB商品分类表 b
where a.State!=2  and (a.nodecode like '1%' or a.NodeCode like '2%') and a.OpenDate<=convert(varchar(8),dateadd(dd,0,'20200229'),112) and a.NodeCode not like '1070'and a.NodeCode not like '1017'
and b.CategoryItemCode='0000' and left(b.CategoryCode,1) between 1 and 5  and b.CategoryLevel='2'
union all 
select  distinct a.AreaCode,a.FormatCode,a.NodeCode,'自有品牌团队' ParentCategoryCode
 from 
TB部门信息表 a 
where a.State!=2  and (a.nodecode like '1%' or a.NodeCode like '2%') and a.OpenDate<=convert(varchar(8),dateadd(dd,0,'20200229'),112) and a.NodeCode not like '1070'and a.NodeCode not like '1017'
union all 
select  distinct a.AreaCode,a.FormatCode,a.NodeCode,'百货团队' ParentCategoryCode
 from 
TB部门信息表 a 
where a.State!=2  and (a.nodecode like '9%') and a.OpenDate<=convert(varchar(8),dateadd(dd,0,'20191201'),112)  and a.nodecode not like '9012' and  a.nodecode not like '9999'
union all 
select  distinct '5001'AreaCode,'5001'FormatCode,a.NodeCode,'购物中心' ParentCategoryCode
 from 
TB部门信息表 a 
where a.State!=2  and (a.nodecode like '5001') and a.OpenDate<=convert(varchar(8),dateadd(dd,0,'20200229'),112)  
 )a
left join 
(select DeptCode,
case when CategoryCode like '1%' then '生鲜团队'
when CategoryCode like '2%' then '加工团队'
when CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%' then '常规团队' else CategoryCode end CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' )  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'20200101'),112) and convert(varchar(6),dateadd(dd,0,'20200229'),112)
group by DeptCode,case when CategoryCode like '1%' then '生鲜团队'
when CategoryCode like '2%' then '加工团队'
when CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%' then '常规团队' else CategoryCode end
union all 
select DeptCode,'自有品牌团队' CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' )  and CategoryItemCode='0001'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'20200101'),112) and convert(varchar(6),dateadd(dd,0,'20200229'),112)
group by DeptCode
union all 
select DeptCode,'百货团队' CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '9%' )  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'20200101'),112) and convert(varchar(6),dateadd(dd,0,'20200229'),112)
group by DeptCode
union all 
select DeptCode,'购物中心' CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '5001' )  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'20200101'),112) and convert(varchar(6),dateadd(dd,0,'20200229'),112)
group by DeptCode

)b on a.NodeCode=b.DeptCode and a.ParentCategoryCode=b.CategoryCode

left join 
(select nodecode ,
case when CategoryCode like '1%' then '生鲜团队'
when CategoryCode like '2%' then '加工团队'
when CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%' then '常规团队' else CategoryCode end CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from tb201912_GoodsDayPSSM a where occurdate between '20191231' and '20191231' and  nodecode='1076' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
union all 
select * from tb202001_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
union all 
 select * from tb202002_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode))a
 ,tb商品档案 b 

WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 

GROUP BY nodecode,case when CategoryCode like '1%' then '生鲜团队'
when CategoryCode like '2%' then '加工团队'
when CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%' then '常规团队' else CategoryCode end
union all 
select nodecode ,'自有品牌团队' CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from tb201912_GoodsDayPSSM a where occurdate between '20191231' and '20191231' and  nodecode='1076' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
union all 
select * from tb202001_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
union all 
 select * from tb202002_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode))a
 ,tb商品档案 b 

WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 
and b.GoodsBrand='010001'
GROUP BY nodecode
union all 
select nodecode ,'百货团队' CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select NodeCode,GoodsCode,sum(SaleIncome)SaleIncome,sum(SaleTax)SaleTax,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from tb202001_GoodsDayPSSM a 
where occurdate between '20200101' and '20200229'  and nodecode LIKE '9%' 
group by NodeCode,GoodsCode
union all 
select NodeCode,GoodsCode,sum(SaleIncome)SaleIncome,sum(SaleTax)SaleTax,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from tb202002_GoodsDayPSSM a
where occurdate between '20200101' and '20200229'and nodecode LIKE '9%' 
group by  NodeCode,GoodsCode
  union all 
select DeptCode NodeCode,GoodsCode,sum(SaleIncome)SaleIncome,sum(SaleTax)SaleTax,sum(TaxSaleGrossProfit)TaxSaleGrossProfit 
from TB202001_租赁商品销售明细 a 
where a.BuildDate between '20200101' and '20200229'  and DeptCode LIKE '9%'  and a.GoodsCode not like '09%'
group by DeptCode,GoodsCode
union all 
select DeptCode NodeCode,GoodsCode,sum(SaleIncome)SaleIncome,sum(SaleTax)SaleTax,sum(TaxSaleGrossProfit)TaxSaleGrossProfit 
from TB202002_租赁商品销售明细 a 
where a.BuildDate between '20200101' and '20200229'  and DeptCode LIKE '9%'  and a.GoodsCode not like '09%'
group by  DeptCode,GoodsCode
  )a
 ,tb商品档案 b 

WHERE a.goodscode=b.goodscode  

GROUP BY nodecode
union all 

select nodecode , CategoryCode,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select nodecode ,'购物中心' CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from tb202001_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and nodecode LIKE '5001' and goodscode not like '900000003'
union all 
 select * from tb202002_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and nodecode LIKE '5001' and goodscode not like '900000003')a

GROUP BY nodecode
 union all 
 select DeptCode nodecode,'购物中心'CategoryCode,
 sum(Salesindex)SaleMoney,sum(Grossprofitindex) TaxSaleGrossProfit
from 购物中心手工进帐日合计 
where defday between '20200101' and '20200229' and deptcode='5001'
group by DeptCode)a
group by nodecode , CategoryCode
)d on a.nodecode= d.nodecode and a.ParentCategoryCode=d.CategoryCode


order by 11 desc,1,2,3,4,5





select a.NodeCode DeptCode,a.ParentCategoryCode,


sum(isnull(b.Salesindex,0))*1.05 Salesindex,
sum(isnull(b.Grossprofitindex,0))*1.05 Grossprofitindex,
sum(isnull(d.SaleMoney,0)) SaleMoney,
sum(isnull(d.TaxSaleGrossProfit,0))TaxSaleGrossProfit
 from 
(select  distinct a.NodeCode,
case when  A.FormatCode in ('01','02') and  a.OpenDate<'20191201' AND  b.CategoryCode IN ('12','13') then '01综标超店蔬果课'
when  A.FormatCode in ('01','02') and  a.OpenDate<'20191201' AND  b.CategoryCode IN ('10','11') then '02综标超店生食课'
when  A.FormatCode in ('01','02') and  a.OpenDate<'20191201' AND  b.CategoryCode IN ('14') then '03综标超店干货课'
when  A.FormatCode in ('01','02') and a.NodeCode  in (1002,1044,1045,1048,1056,1075) and  a.OpenDate<'20191201' AND  left(b.CategoryCode,1) IN ('2') then '03综标超店干货课'
when  A.FormatCode in ('01','02') and a.NodeCode not in (1002,1044,1045,1048,1056,1075)  and  a.OpenDate<'20191201' AND  left(b.CategoryCode,1) in ('2') then '04综标超店加工课'
when  A.FormatCode in ('01','02') and  a.OpenDate<'20191201' AND  left(b.CategoryCode,1) IN ('4','5') then '05综标超店用品课(含日化)'
when  A.FormatCode='02' and  a.OpenDate<'20191201' AND  left(b.CategoryCode,1) in ('3') then '06标超店食品课'
when  A.FormatCode='01' and  a.OpenDate<'20191201' AND  b.CategoryCode IN ('30','31','32') then '07综超休闲酒饮课'
when  A.FormatCode='01' and  a.OpenDate<'20191201' AND  b.CategoryCode IN ('33','34') then '08综超粮油日配课'
when  A.FormatCode in ('03','06') and  a.OpenDate<'20191201' AND  left(b.CategoryCode,1) in ('1','2') then '09社区店生鲜课'
when  A.FormatCode in ('03','06') and  a.OpenDate<'20191201' AND  left(b.CategoryCode,1) in ('3','4','5') then '10社区店常规课'

 end ParentCategoryCode,B.CategoryCode
 from 
TB部门信息表 a ,
TB商品分类表 b 

where a.State!=2  and (a.nodecode like '1%' or a.NodeCode like '2%') and a.OpenDate<=convert(varchar(8),dateadd(dd,0,'20191201'),112) and a.NodeCode not like '1070'and a.NodeCode not like '1017'
and b.CategoryItemCode='0000' and left(b.CategoryCode,1) between 1 and 5  and b.CategoryLevel='2' and b.CategoryCode not in ('19','35')
and a.FormatCode!='07'  
union all
select NodeCode,'餐饮'ParentCategoryCode,'800' CategoryCode  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'皮具家居'ParentCategoryCode,'801' CategoryCode  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'男装'ParentCategoryCode,'802' CategoryCode from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'女装'ParentCategoryCode,'803' CategoryCode  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'儿童服饰'ParentCategoryCode,'804' CategoryCode  from 
TB部门信息表 
where NodeCode ='5001'
union all 
select NodeCode,'儿童娱乐'ParentCategoryCode,'805' CategoryCode  from 
TB部门信息表 
where NodeCode ='5001'
 )a
left join 
(select DeptCode,left(CategoryCode,2) CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' )  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'20200101'),112) and convert(varchar(6),dateadd(dd,0,'20200229'),112)
group by DeptCode,left(CategoryCode,2)

union all 
select DeptCode, CategoryCode,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '5001' )  and CategoryItemCode='5001'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'20200101'),112) and convert(varchar(6),dateadd(dd,0,'20200229'),112)
group by DeptCode,CategoryCode

)b on a.NodeCode=b.DeptCode and a.CategoryCode=b.CategoryCode
left join 
(select nodecode ,case when (left(CategoryCode,3) in ('280','287') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(CategoryCode,3) in ('281','288') then '21' 
   when left(CategoryCode,3) in ('282','289') then '22'   
   when left(CategoryCode,2) in ('35') then '30'    
   else left(CategoryCode,2) end  CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from tb201912_GoodsDayPSSM a where occurdate between '20191231' and '20191231' and  nodecode='1076' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
union all 
select * from tb202001_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode)
union all 
 select * from tb202002_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.nodecode=z.nodecode and a.goodscode=z.goodscode))a
 ,tb商品档案 b 

WHERE a.goodscode=b.goodscode  and  (nodecode LIKE '1%' OR nodecode LIKE '2%' ) 

GROUP BY nodecode,case when (left(CategoryCode,3) in ('280','287') or CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(CategoryCode,3) in ('281','288') then '21' 
   when left(CategoryCode,3) in ('282','289') then '22'   
   when left(CategoryCode,2) in ('35') then '30'    
   else left(CategoryCode,2) end  

   union all 

select nodecode,CategoryCode,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit
from
(   select nodecode ,case 
   when CounterCode in (304) then '800'  
   when CounterCode in (155,140,159,107,212,113,192) then '801'  
   when CounterCode in (228,165,169,2006,2009,2015,226,102) then '802'  
   when CounterCode in (203,210,201,2002,297,191,10401,109) then '803'  
   when CounterCode in (302,325,347) then '804'  
   when CounterCode in (313,311) then '805'  
   else CounterCode end  CategoryCode
,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(

select * from tb202001_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and nodecode LIKE '5001' and  goodscode not like '900000003' and CounterCode  not in ('5001')
union all 
 select * from tb202002_GoodsDayPSSM a where occurdate between '20200101' and '20200229' and nodecode LIKE '5001' and  goodscode not like '900000003' and CounterCode  not in ('5001'))a
 


GROUP BY nodecode,case 
   when CounterCode in (304) then '800'  
   when CounterCode in (155,140,159,107,212,113,192) then '801'  
   when CounterCode in (228,165,169,2006,2009,2015,226,102) then '802'  
   when CounterCode in (203,210,201,2002,297,191,10401,109) then '803'  
   when CounterCode in (302,325,347) then '804'  
   when CounterCode in (313,311) then '805'  
   else CounterCode end

union all 

select DeptCode nodecode,CategoryCode,sum(Salesindex)SaleMoney,sum(Grossprofitindex) TaxSaleGrossProfit
from 购物中心手工进帐日合计 
where defday between '20200101' and '20200229' and deptcode='5001'
group by DeptCode,CategoryCode)a
group by nodecode,CategoryCode

)d on a.nodecode= d.nodecode and a.CategoryCode=d.CategoryCode

group by a.NodeCode,a.ParentCategoryCode

order by 2,1





