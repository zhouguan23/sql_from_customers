

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' where  Occurdate between  '+@qsrq+' and '+@dqrq+'and left(nodecode,1) in (1,2,7) '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM '+[name]A+' '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_REDEPLOYOUT' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')
SET @SQL3=''
SELECT @SQL3=@SQL3+' UNION ALL SELECT * FROM '+[name]A+' '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_REDEPLOYOUTDETAILS' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL3=STUFF(@SQL3,1,11,'')
SET @SQL1='
select * from 
(select CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN 20 WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN 21 WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN 22 ELSE    a.ParentCategoryCode END ParentCategoryCode,
CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN ''熟食'' WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN ''面点'' WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN ''烘培'' ELSE    a.ParentCategoryName END ParentCategoryName,
CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN 201 WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN 211 WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN 221 ELSE    a.CategoryCode END CategoryCode,
CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN ''熟食'' WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN ''面点'' WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN ''烘培'' ELSE    a.CategoryName END CategoryName,
b.NodeCode,sum(isnull(SaleIncome,0))SaleIncome,sum(isnull(SaleCost,0))SaleCost,sum(isnull(SaleMoney,0))SaleMoney,sum(isnull(SaleGrossProfit,0))SaleGrossProfit,sum(isnull(TaxSaleGrossProfit,0))TaxSaleGrossProfit from 
(select A.CategoryCode ParentCategoryCode,A.CategoryName ParentCategoryName,B.CategoryCode,B.CategoryName,D.CategoryCode CatCode from 
HLCWDW.DBO.TB分类对照表 a 
left join 
HLCWDW.DBO.TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and b.ParentCategoryCode=a.CategoryCode
left join 
HLCWDW.DBO.tbCatToGoods c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.CategoryCode
left join 
tb商品分类表 D ON D.CategoryItemCode=''0000'' AND D.CategoryLevel=''5'' AND  D.CategoryCode LIKE  C.GoodsCode+''%''
where a.CategoryItemCode=''0002'' and a.CategoryLevel=''1'' and a.ParentCategoryCode!=''6''
and not exists(select * from HLCWDW.DBO.tbCatNotToGoods z where c.CategoryItemCode=z.CategoryItemCode and c.CategoryCode=z.CategoryCode  and D.CategoryCode like Z.GoodsCode+''%''))a
left join 
(select a.NodeCode,b.CategoryCode,sum(SaleIncome)SaleIncome,sum(SaleCost)SaleCost,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
('+@SQL+') A
LEFT JOIN 
TB商品档案 b on a.GoodsCode=b.goodscode
where not exists(select * from TB部门特殊商品对照  z ,tb商品档案 zz where z.goodscode=zz.goodscode and zz.CategoryCode NOT like ''23%'' and z.GoodsPropertyCode in(1888) and z.nodecode=a.nodecode and z.goodscode=a.goodscode)
group by a.NodeCode,b.CategoryCode

union all 

select a.DeptCode NodeCode,c.CategoryCode,sum(PurchMoney-PurchTax)SaleIncome,''0''SaleCost,sum(PurchMoney)SaleMoney,''0''SaleGrossProfit,''0''TaxSaleGrossProfit from 
('+@SQL2+') a ,('+@SQL3+') b ,tb商品档案 c 
where a.DeptCode=b.DeptCode and a.BillNumber=b.BillNumber and b.goodscode=c.goodscode
and not exists(select * from TB部门特殊商品对照 z ,tb商品档案 zz where z.goodscode=zz.goodscode and zz.CategoryCode NOT like ''23%'' and  z.GoodsPropertyCode in(1888) and  z.nodecode=a.deptcode and z.goodscode=b.goodscode)
group by a.DeptCode,c.CategoryCode

) b on a.CatCode=b.CategoryCode
where len(b.NodeCode)!=0 
group by CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN 20 WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN 21 WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN 22 ELSE    a.ParentCategoryCode END ,
CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN ''熟食'' WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN ''面点'' WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN ''烘培'' ELSE    a.ParentCategoryName END ,
CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN 201 WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN 211 WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN 221 ELSE    a.CategoryCode END ,
CASE WHEN b.NodeCode!=7777 and a.CategoryCode=280 THEN ''熟食'' WHEN b.NodeCode!=7777 and a.CategoryCode=281 THEN ''面点'' WHEN b.NodeCode!=7777 and a.CategoryCode=282 THEN ''烘培'' ELSE    a.CategoryName END ,
b.NodeCode
)a

order by cast(ParentCategoryCode as varchar),cast(CategoryCode as varchar),nodecode


'exec(@sql1)

