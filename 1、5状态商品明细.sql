select left(五级分类编码,2) 二级分类编码,部门编码,五级分类编码,商品编码,商品名称,商品条码,供应商,流转途径,最后进价,最后售价,经营状态,最后状态异动日,最后进货日,最后销货日,
datediff(day,a.最后销货日,报表日期)未销天数,b.UnSalaNotSellDay,正常DMS+促销DMS DMS,库存数量/case when (正常DMS+促销DMS)=0 then  0.1 else (正常DMS+促销DMS) end 可销天数,
前30天销量 前30天销量,前30天销售收入+前30天销售税金 前30天销售额,前30天含税销售毛利 前30天毛利额,库存数量,含税库存成本  from 
dbo.TB${YM}_报表数据源 a 
left join 
TBREPORTPARADEFINE b on left(五级分类编码,4) = b.goodscode 
where 报表日期=convert(varchar(8),dateadd(mm,0,'${rq}'),112)  and (部门编码 like '1%' or 部门编码 like '2%')
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") }

and  1=1 ${if(len(fl2) == 0,   "",   "and left(五级分类编码,2) in ('" + replace(fl2,",","','")+"')") } 
and 经营状态 in (1,5) and 1=1 ${if(len(zt) == 0,   "",   "and 经营状态 in ('" + replace(zt,",","','")+"')") }
order by 7,4,2



