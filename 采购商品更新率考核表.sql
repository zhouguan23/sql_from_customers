select case when LEFT(a.CategoryCode,2) in (31,32) then '31'
when LEFT(a.CategoryCode,2) in (46,47) then '42'
when LEFT(a.CategoryCode,2) in (40,41,42,43) then '40'
when LEFT(a.CategoryCode,2) in (44,45,48,49) then '41'
when LEFT(a.CategoryCode,1) in (5) then '50' else LEFT(a.CategoryCode,2) end
ParentCategoryCode,a.CategoryCode ,CategoryName,YM month,a.AreaCode,a.NodeCode DeptCode ,b.可订货次数,b.非中央控制,b.中央控制,b.门店缺货
 from 
(select AreaCode,ParentCategoryCode,CategoryCode ,CategoryName,YM,a.NodeCode  from 
(select '' AreaCode,'' NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from  TB考核分类表 a  where CategoryItemCode='0000' and CategoryLevel=1 and left(CategoryCode,1) between 3 and 5 and a.CategoryCode not in ('39')



)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${jsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${jsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[tb缺货率指标预算表]A b on  a.YM=b.BudgetYM  and a.CategoryCode=b.CategoryCode and   b.CategoryItemCode ='0002' 
        where  b.可订货次数>0 and (b.非中央控制>0 or b.中央控制>0)
        
    order by 2,4,5,6


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

select case when LEFT(a.CategoryCode,2) in (31,32) then '31'
when LEFT(a.CategoryCode,2) in (46,47) then '42'
when LEFT(a.CategoryCode,2) in (40,41,42,43) then '40'
when LEFT(a.CategoryCode,2) in (44,45,48,49) then '41'
when LEFT(a.CategoryCode,1) in (5) then '50' else LEFT(a.CategoryCode,2) end
ParentCategoryCode,case when LEFT(a.CategoryCode,2)='39' then '30' else LEFT(a.CategoryCode,2) end CategoryCode,sum(可订货次数)可订货次数,sum(非中央控制缺货次数)+sum(中央控制缺货次数)+sum(门店缺货次数)缺货次数,
sum(非中央控制缺货次数)非中央控制缺货次数,sum(中央控制缺货次数)中央控制缺货次数,sum(门店缺货次数)门店缺货次数 from  
TB${jsrq}_月度缺货数据 a 
where CategoryItemCode='0000' and nodecode not in (SELECT NodeCode  from 
TB部门信息表 
where DATEDIFF(MM,OpenDate,'${jsrq}'+'01')<=3) and nodecode not in (1047)
GROUP BY case when LEFT(a.CategoryCode,2)='39' then '30' else LEFT(a.CategoryCode,2) end,case when LEFT(a.CategoryCode,2) in (31,32) then '31'
when LEFT(a.CategoryCode,2) in (46,47) then '42'
when LEFT(a.CategoryCode,2) in (40,41,42,43) then '40'
when LEFT(a.CategoryCode,2) in (44,45,48,49) then '41'
when LEFT(a.CategoryCode,1) in (5) then '50' else LEFT(a.CategoryCode,2) end
order by  1



  
  select left(a.CategoryCode,1)  ParentCategoryCode,a.CategoryCode ,CategoryName,YM month,a.AreaCode,a.NodeCode DeptCode ,b.可订货次数,b.非中央控制,b.中央控制,b.门店缺货
 from 
(select AreaCode,ParentCategoryCode,CategoryCode ,CategoryName,YM,a.NodeCode  from 
(select '' AreaCode,'' NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from   TB考核分类表   a  where CategoryItemCode='0000' and CategoryLevel=1 and left(CategoryCode,1) between 3 and 5




)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${jsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${jsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[tb缺货率指标预算表]A b on  a.YM=b.BudgetYM  and a.CategoryCode=b.CategoryCode and   b.CategoryItemCode ='0001' 
        where  b.可订货次数>0 and (b.非中央控制>0 or b.中央控制>0)
        
    order by 2,4,5,6
    
    

select a.occurdate,a.ParentCategoryCode,a.CategoryCode1,a.CategoryName1,a.CategoryCode ,a.CategoryName,
isnull(a.SKUCount,0)SKUCount,isnull(b.SKU,0)SKU from 
(select b.occurdate,a.ParentCategoryCode,a.CategoryCode1,a.CategoryName1,a.CategoryCode ,a.CategoryName,
SUM(isnull(SKUCount,0))SKUCount
 from 
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode CategoryCode1,b.CategoryName CategoryName1,c.CategoryCode ,c.CategoryName ,d.GoodsCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0002'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0002'
left join 
TBCATTOGOODS d on c.CategoryCode=d.CategoryCode and d.CategoryItemCode='0002' and d.GoodsCode<>'300'
where a.CategoryItemCode='0002' and a.CategoryLevel='0' and a.CategoryCode not like '1%' and a.CategoryCode not like '2%' and a.CategoryCode not like '6%')a
left join 
tb采购管辖商品更新率 b on b.occurdate='${jsrq}' and  b.CategoryCode like cast( a.bm as varchar(10)) +'%' and a.CategoryItemCode=b.CategoryItemCode

group by b.occurdate,a.ParentCategoryCode,a.CategoryCode1,a.CategoryName1,a.CategoryCode ,a.CategoryName)a
left join 
(select b.occurdate,a.ParentCategoryCode,a.CategoryCode1,a.CategoryName1,a.CategoryCode ,a.CategoryName,
SUM(isnull(SKUCount,0))SKU
 from 
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode CategoryCode1,b.CategoryName CategoryName1,c.CategoryCode ,c.CategoryName ,d.GoodsCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0002'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0002'
left join 
TBCATTOGOODS d on c.CategoryCode=d.CategoryCode and d.CategoryItemCode='0002' and d.GoodsCode<>'300'
where a.CategoryItemCode='0002' and a.CategoryLevel='0' and a.CategoryCode not like '1%' and a.CategoryCode not like '2%' and a.CategoryCode not like '6%')a
left join 
tb采购管辖商品更新指标 b on b.occurdate='${jsrq}' and  b.CategoryCode  like a.CategoryCode +'%'
group by b.occurdate,a.ParentCategoryCode,a.CategoryCode1,a.CategoryName1,a.CategoryCode ,a.CategoryName
)b on a.CategoryCode=b.CategoryCode and a.occurdate=b.occurdate
where a.OccurDate is not null

select  * from 
tb分类对照表
where CategoryItemCode='0002' and CategoryLevel<=2


