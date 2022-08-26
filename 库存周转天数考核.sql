
select a.NodeCode,a.NodeCode+' '+
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
NodeName
,'祥龙商贸息烽店' ,'息烽店')
,'遵义播州店','播州店')
,'合力连锁白云店','白云店')
,'榕江常驰广场店','榕江店')
,'中天未来方舟H4店','中天H4店')
,'合力连锁花溪店','花溪店')
,'中天未来方舟E1店','中天E1店')
,'中天未来方舟G1店','中天G1店')
,'修文文城逸都店','修文文城店')
,'瓮安麒龙缤纷城店','瓮安麒龙店')
,'遵义大都汇店','大都汇店')
,'合力生鲜批发中心','生鲜批发')
,'合力购物物流中心','常温物流')
,'合力中央厨房','中央厨房')
,'合力连锁配送中心','生鲜物流')
,'合力红果生活超市','红果店')
,'兴义运通广场店','兴义运通店')
,'遵义大恒名城店','大恒名城店')
,'大方佳鑫国际店','大方店')
,'务川麒龙城市广场店','务川麒龙店')
,'余庆国腾商都店','余庆店')
,'安龙翔龙嘉莲店','安龙店')
,'平塘中央大街店','平塘店')
,'遵义中建幸福城店','中建幸福城店')
,'湄潭太阳城店','湄潭店')
,'六盘水雨田境界店','雨田境界店')
,'兴义柯沙坡店','柯沙坡店')
,'兴义万湖汇店','万湖汇店')
,'紫云麒龙城市广场店','紫云店')
,'铜仁麒龙会展城店','铜仁店')
,'遵义南加州店','南加州店')
,'遵义幸福家园店','幸福家园店')
,'花果园中山公馆店','中山公馆店')
,'美的林城阳关站店','美的林城店')
,'亿足鞋业开阳店','开阳百货店')
,'遵义播州百货店','播州百货店')
,'中天未来方舟H4百货店','H4百货店')
,'美的林城阳关站百货店','美的林城百货店')
,'兴义运通广场百货店','兴义运通百货店')
,'遵义中建幸福城百货店','中建幸福城百货店')
,'湄潭太阳城百货店','湄潭百货店')
,'余庆国腾商都百货店','余庆百货店')
,'安龙翔龙嘉莲百货店','安龙百货店')
,'大方佳鑫国际百货店','大方百货店')
,'务川麒龙城市广场百货店','务川百货店')
,'合力连锁',''),'合力','')
 NodeName, a.OpenDate,
case when d.CategoryCode in (02,06) then '1' else '0' END WhetherNew,
isnull(b.CategoryCode,'')  AreaCode,isnull(b.CategoryName,'')  AreaName,isnull(C.CategoryCode,'') FormatCode,isnull(C.CategoryName,'') FormatName from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  
 and b.NodeType in (0,2) )a
left join
(select b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0013'
where  a.DeptCatItemCode ='0013')b on a.NodeCode=b.nodecode
left join
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011')C on a.NodeCode=C.nodecode
left join
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0000'
where  a.DeptCatItemCode ='0000')d on a.NodeCode=d.nodecode
where 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}  and left(a.nodecode,1) between 1 and 2

select b.AreaCode,b.FormatCode,a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${rq}',6)+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm INTO #bm from 
dbo.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000' and b.CategoryCode not like '23%'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0000'
where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode not like '9%' 
and a.CategoryCode not like '0%' and a.CategoryCode not like '6%' and a.CategoryCode not like '7%' and a.CategoryCode  like '1%' 
)a
where left(b.NodeCode,1) in (1,2)   and b.NodeCode not in ('1047')
AND datediff(MONTH ,case when datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left(OpenDate,6)+'01')+1, 0)))>=20 then DATEADD(m, 1, OpenDate) - (DATEPART(day, DATEADD(m, 1, OpenDate)) - 1) else OpenDate end,'${rq}')+1>3

--期初
select A.NodeCode ,LEFT(B.CategoryCode,2)CategoryCode ,sum(StartCost)StartCost,SUM(CASE WHEN  B.GoodsBrand ='010001' then StartCost ELSE 0 END )QH_StartCost into #qc  from 
tb${YM}_GoodsMonPSSM a ,tb商品档案 b
where a.GoodsCode =b.GoodsCode and b.GoodsType not in (1,6,7)   
and not exists(select 1 from 
TB部门特殊商品对照 c
where c.GoodsPropertyCode='2002' and a.NodeCode=c.NodeCode and a.GoodsCode=c.goodscode)
and b.CategoryCode not like '0%' and b.CategoryCode not like '6%' and b.CategoryCode not like '23%'
group by A.NodeCode ,LEFT(B.CategoryCode,2)


--期间
select  A.NodeCode ,LEFT(A.CategoryCode ,2)CategoryCode,sum(SaleCost)SaleCost,sum(StockCost)StockCost,sum(QH_SaleCost)QH_SaleCost,sum(QH_StockCost)QH_StockCost into #qj  from 
(select A.NodeCode ,b.CategoryCode ,sum(A.SaleCost)SaleCost,SUM(CASE WHEN  B.GoodsBrand ='010001' then SaleCost ELSE 0 END )QH_SaleCost
,sum(PURCHCOST + REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost)StockCost
,sum(CASE WHEN  B.GoodsBrand ='010001' THEN PURCHCOST + REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost ELSE 0 END )QH_StockCost from
tb${SYYM}_GoodsDayPSSM a ,tb商品档案 b
where a.GoodsCode =b.GoodsCode and b.GoodsType not in (1,6,7) 
and not exists(select 1 from 
TB部门特殊商品对照 c
where c.GoodsPropertyCode='2002' and a.NodeCode=c.NodeCode and a.GoodsCode=c.goodscode)
and b.CategoryCode not like '0%' and b.CategoryCode not like '6%' and b.CategoryCode not like '23%'
and not exists(select 1 from 
TB部门特殊商品对照 c
where c.GoodsPropertyCode='2002' and a.NodeCode=c.NodeCode and a.GoodsCode=c.goodscode)
and  OccurDate between convert(varchar(8),dateadd(dd,-day(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${rq}',6)+'01')+1, 0)))+1,'${rq}'),112) and convert(varchar(8),dateadd(dd,0,'${rq}'),112)
group by A.NodeCode ,b.CategoryCode
union all 
select A.NodeCode ,b.CategoryCode ,sum(A.SaleCost)SaleCost,SUM(CASE WHEN  B.GoodsBrand ='010001' then SaleCost ELSE 0 END )QH_SaleCost
,sum(PURCHCOST + REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost)StockCost
,sum(CASE WHEN  B.GoodsBrand ='010001' THEN PURCHCOST + REDEPLOYINCOST + PROFITCOST + COUNTPROFITCOST - SALECOST - REDEPLOYOUTCOST - LOSSCOST - COUNTLOSSCOST-ToGiftCost ELSE 0 END )QH_StockCost from 
tb${YM}_GoodsDayPSSM a ,tb商品档案 b
where a.GoodsCode =b.GoodsCode and b.GoodsType not in (1,6,7) 
and not exists(select 1 from 
TB部门特殊商品对照 c
where c.GoodsPropertyCode='2002' and a.NodeCode=c.NodeCode and a.GoodsCode=c.goodscode)
and b.CategoryCode not like '0%' and b.CategoryCode not like '6%' and b.CategoryCode not like '23%'
and OccurDate between convert(varchar(8),dateadd(dd,-day(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${rq}',6)+'01')+1, 0)))+1,'${rq}'),112) and convert(varchar(8),dateadd(dd,0,'${rq}'),112)
group by A.NodeCode ,b.CategoryCode )a
group by A.NodeCode ,LEFT(A.CategoryCode ,2)

select a.AreaCode,a.FormatCode,a.NodeCode,a.ParentCategoryCode,a.CategoryCode,
isnull(sum(c.StartCost),0)+isnull(SUM(d.StockCost),0)库存成本,isnull(SUM(d.SaleCost),0)销售成本,
isnull(sum(c.QH_StartCost),0)+isnull(SUM(d.QH_StockCost),0)自有品牌库存成本,isnull(SUM(d.QH_SaleCost),0)自有品牌销售成本,
day(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${rq}',6)+'01')+1, 0)))周转天数
 from 
#bm a

left join 
#qc c on  a.nodecode=c.nodecode  and a.bm=C.CategoryCode
left join
#qj d  on  a.nodecode=d.nodecode and a.bm=d.CategoryCode


group by a.AreaCode,a.FormatCode,a.NodeCode,a.ParentCategoryCode,a.CategoryCode
order by 3,1,5

drop table #bm
drop table #qc
drop table #qj

select  * from 
tb分类对照表
where CategoryItemCode='0000' and CategoryLevel<=2


