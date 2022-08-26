select SpecialTypeCode,SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
where IsPeriod=1
order by SpecialTypeCode

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName 档期名称,b.BeginDate,b.EndDate  from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018' 

order by 5 desc 

select 
a.档期编码,
a.主题名称,
a.商品编码,
d.GoodsName 商品名称,
d.BaseBarCode 商品条码,
d.BaseMeasureUnit 单位,
c.ColonyName 集群,
b.促销部门 ,
a.促销种类,
a.补差方式,
a.促销方式,
a.批量数量,
a.批量金额,
a.原供价,
a.原售价,
a.特供价,
a.特售价,
b.计划量,
b.计划额,
a.满减金额,
a.最大满减金额,
isnull(b.订货数量,0)订货数量,
a.陈列位,
a.起始日期,
a.结束日期,
a.开始时间,
a.结束时间,
a.状态 into #sj from 
TB档期商品明细 a
left join 
TB档期部门商品明细 b on a.档期编码=b.档期编码 and a.商品编码=b.商品编码
left join 
tb部门信息表 c on b.促销部门=c.nodecode
left join 
TB商品档案 d on a.商品编码=d.GoodsCode
where  1=1 ${if(len(dq) == 0,   "",   "and a.档期编码 in ('" + replace(dq,",","','")+"')") }
and 1=1 ${if(len(sp) == 0,   "",   "and a.商品编码 in ('" + replace(sp,",","','")+"')") }
and 1=1 ${if(len(zhut) == 0,   "",   "and a.主题名称 in ('" + replace(zhut,",","','")+"')") }
and 1=1 ${if(len(zt) == 0,   "",   "and a.状态 in ('" + replace(zt,",","','")+"')") }
and GoodsBrand!='010001'
order by 1,6,7,2

select a.档期编码,a.主题名称,a.商品编码,a.商品名称,a.商品条码,a.单位,STUFF((SELECT distinct ',' + 集群 FROM #sj b WHERE a.档期编码=b.档期编码 and a.商品编码=b.商品编码  FOR XML PATH('')),1, 1, '') 集群
,STUFF((SELECT distinct ',' + 促销部门 FROM #sj b WHERE a.档期编码=b.档期编码 and a.商品编码=b.商品编码  FOR XML PATH('')),1, 1, '') 部门,a.促销种类,a.补差方式,a.促销方式,a.批量数量,a.批量金额,a.原供价,a.原售价,a.特供价,a.特售价,a.满减金额,a.最大满减金额,sum(a.计划量)计划量,sum(a.计划额)计划额,sum(a.订货数量)订货数量,a.起始日期,a.结束日期,a.开始时间,a.结束时间,a.陈列位,a.状态 from 
#sj a

group by  a.档期编码,a.主题名称,a.商品编码,a.商品名称,a.商品条码,a.单位,a.促销种类,a.补差方式,a.促销方式,a.批量数量,a.批量金额,a.原供价,a.原售价,a.特供价,a.特售价,a.满减金额,a.最大满减金额,a.起始日期,a.结束日期,a.陈列位,a.状态,a.开始时间,a.结束时间
order by a.促销种类,a.档期编码,a.商品编码


drop table #sj


