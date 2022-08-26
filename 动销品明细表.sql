select left(五级分类编码,2) 二级分类编码,部门编码,五级分类编码,商品编码,商品名称,商品条码,供应商,
流转途径,最后进价,最后售价,经营状态,最后状态异动日,最后进货日,最后销货日,
datediff(day,case when len(最后销货日)=0 then  最后进货日 else 最后销货日 end,报表日期)未销天数,
正常DMS+促销DMS DMS,库存数量/case when (正常DMS+促销DMS)=0 then  0.1 else (正常DMS+促销DMS) end 可销天数,库存数量,含税库存成本  from 
TB${YM}_报表数据源
where 报表日期=convert(varchar(8),dateadd(mm,0,'${rq}'),112)
and LEFT(部门编码,1)='9'
and  1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in ('" + replace(bm,",","','")+"')") }
and 含税库存成本>'0'
and 销售数量>0

