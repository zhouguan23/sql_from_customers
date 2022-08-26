select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称 from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode>='2019' 

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.SubID 子档号,b.PromotionPeriodName+''+cast(b.SubID as varchar(255) ) 档期名称,b.BeginDate+'-'+b.EndDate 档期日期 from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode>='2019' and a.PromotionThemeCode = '${促销种类}'

select a.促销主题编码 促销种类编码,a.促销主题名称 促销种类名称,a.单据号,
a.促销档期编码 档期编码,a.促销档期名称 档期名称,
a. 部门编码,a.供应商编码 供应商,left(b.CategoryCode ,2) 分类编码,a.商品编码,a.商品名称,b.GoodsSpec 商品规格,b.BaseMeasureUnit 单位,a.经营状态,a.流转途径
,a.起始日期+'-'+a.结束日期 促销日期
,case when a.变价原因编码 In ('11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27') then '1'
when a.变价原因编码 In('01','02') then '2'
when a.变价原因编码 In ('03','04','05','06') then '3'
when a.变价原因编码 In ('07','08','09','10') then '4' end  变价种类,a.变价原因编码 变价原因,a.促销方式名称 促销类型,a.补偿方式
,a.商品进价 供价,a.特供价,a.商品售价 销售单价,a.促销价,isnull(c.Amount,0) 库存数量,isnull(c.TaxCost,0) 库存金额,isnull(d.Amount,0) 在途数量,isnull(d.PurchMoney,0) 在途金额
 from 
 TB促销清单 a
 left join 
 TB商品档案 b on a.商品编码=b.GoodsCode 
 left join 
 tbStocks c on a.部门编码=c.CounterCode and a.商品编码=c.GoodsCode 
 left join 
 tbWayArrivalannual d on a.部门编码=d.DeptCode  and a.商品编码=d.GoodsCode 
where 1=1 ${if(len(档期) == 0,   "",   "and a.促销档期编码 in ('" + replace(档期,",","','")+"')") }
and 1=1 ${if(len(分类编码) == 0,   "",   "and left(b.CategoryCode ,2) in ('" + replace(分类编码,",","','")+"')") }
and 1=1 ${if(len(部门编码) == 0,   "",   "and a. 部门编码 in ('" + replace(部门编码,",","','")+"')") }
and 1=1 ${if(len(供应商) == 0,   "",   "and a.供应商编码 in ('" + replace(供应商,",","','")+"')") }
and 1=1 ${if(len(商品编码) == 0,   "",   "and a.商品编码 in ('" + replace(商品编码,",","','")+"')") }
and 1=1 ${if(len(变价原因) == 0,   "",   "and a.变价原因编码 in ('" + replace(变价原因,",","','")+"')") }
order by left(b.CategoryCode ,2),a.商品编码,a. 部门编码


select ChangePriceCode,ChangeCauseCode,ChangeCauseCode+' '+ChangeCauseName ChangeCauseName,OrderAttribution from 
[000]A .TBCHANGEPRICECAUSE 
where ChangePriceCode in ('1') and ChangeCauseCode not in (19,20)



select distinct AreaCode NodeCode ,AreaName NodeName ,'' AreaCode from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}
union all 
select 
NodeCode,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2)   and len(AreaCode)<>0 
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}



