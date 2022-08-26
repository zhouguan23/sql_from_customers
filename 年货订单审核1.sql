SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )A
WHERE   1=1 ${if(len(bm) == 0,"","and a.nodecode in (" + bm + ")")}
order by 1


DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX)



SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select * from tbYEARPOBILLDETAIL'+Nodecode+' a
where  
1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") } and
1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") }
and
1=1 ${if(len(zd) == 0,   "",   "and a.IsImportGoods  in (''" + replace(zd,",","'',''")+"'')") }
and
1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and
1=1 ${if(len(LZTJ) == 0,   "",   "and A.CirculationModeCode  in (''" + replace(LZTJ,",","'',''")+"'')") }

and
1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }


and
1=1 ${if(len(jyzt) == 0,   "",if(jyzt =="经营商品",   "and workStateCode in (1,2,5)",   "and workStateCode not in (1,2,5)")) }

and 1=1 ${if(sx == 3,   "",if(sx == 0,"and exists(select * from hldw.dbo.tb商品档案 Y where a.goodscode=y.goodscode and y.GoodsBrand!=''010001'')",   "and exists(select * from hldw.dbo.tb商品档案 Y where a.goodscode=y.goodscode and y.GoodsBrand=''010001'')")) }
 ' 
 FROM hldw.dbo.TB部门信息表 WHERE (NodeCode like '1%' or NodeCode like '2%') and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in ('" + replace(bm,",","','")+"')") }

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='

 select a.deptcode 
      ,a.GoodsCode
      ,a.GoodsName,a.IsImportGoods,a.InProm
      ,sum(a.StoreOrderAmount)StoreOrderAmount
      ,sum(a.StoreOrderMoney)StoreOrderMoney
      ,sum(a.BuyerOrderAmount)BuyerOrderAmount
      ,sum(a.BuyerOrderMoney)BuyerOrderMoney
      ,sum(a.OrderAmount)OrderAmount
      ,sum(a.OrderMoney)OrderMoney
      ,sum(a.The1batch)The1batch
      ,sum(a.The2batch)The2batch
      ,sum(a.The3batch)The3batch
      
,sum(isnull(b.Amount,0))StockAmount
,sum(isnull(c.Amount,0))WayAmount
,sum(isnull(d.Amount,0))PerformAmount
from
('+@SQL1+')a
left join 
[hldw]A.dbo.tbStocks b on a.deptcode=b.CounterCode and a.goodscode=b.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual group by deptcode,goodscode) c on a.deptcode=c.deptcode and a.goodscode=c.goodscode
left join 
(select NodeCode deptcode,goodscode,sum(PurchAmount+RedeployinAmount)Amount,sum(PurchCost+PurchTax +RedeployinCost+RedeployinTax)PurchMoney 
from (select * from [hldw]A.dbo.tb201912_goodsdaypssm where OccurDate between 20191209 and 20200124 
union all 
       select * from [hldw]A.dbo.tb202001_goodsdaypssm where OccurDate between 20191209 and 20200124 )a 
group by nodecode,goodscode) d on a.deptcode=d.deptcode and a.goodscode=d.goodscode


group by  a.deptcode 
      ,a.GoodsCode
      ,a.GoodsName,a.IsImportGoods,a.InProm
	 order by 4 desc ,1,2 asc

'exec(@sql)

select round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0000'
and BudgetYM  between  convert(varchar(6),'202001',112) and  convert(varchar(6),'202002',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }

select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

  SELECT CategoryCode,CategoryName,case when CategoryLevel='1' then '' else ParentCategoryCode end ParentCategoryCode FROM 
  [HLCWDW]A.[dbo]A.TB分类对照表
  WHERE CategoryItemCode='0002' and CategoryLevel>='1'
   AND CategoryCode NOT  LIKE '1%' AND ParentCategoryCode NOT  LIKE '1%' AND CategoryCode NOT  LIKE '2%' AND ParentCategoryCode NOT  LIKE '2%' 
  AND CategoryCode NOT  LIKE '6%' AND ParentCategoryCode NOT  LIKE '6%' 

select distinct goodscode from 
tb部门特殊商品对照
where goodspropertycode='2008'

