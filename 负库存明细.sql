select 商品编码,商品名称,部门编码,商品条码,商品单位,商品规格,经营状态,流转途径,供应商,中央控制标识,最小包装数,最后进价,最后售价,库存数量,含税库存成本,在途数量,正常DMS+促销DMS DMS,
进目录日期,最后销货日,最后进货日,最后状态异动日 from 
dbo.TB${YM}_报表数据源 a  
left join 
tb商品档案 b on a.商品编码=b.goodscode 
WHERE 报表日期='${rq}' and  round(库存数量,1)<0 
and 1=1 ${if(len(bm) == 0,   "",   "and a.部门编码 in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
order by 9,1,3

