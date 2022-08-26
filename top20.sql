SELECT t.* from (
select ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY decode(${an},1,qty,hsje) DESC) rn, a.* from (
select im.dept_name, im.item, im.short_desc, im.attr9, im.attr7, im.mfg_rec_retail as jylsj,
       round(sum(fs.tax_amount),2) as hsje, round(sum(fs.no_tax_amount),2) as wsje, 
       sum(fs.sale_qty) as qty, round( sum(fs.tax_amount) / sum(fs.sale_qty), 2) as pjlsj,
       round(sum(fs.tax_amount - fs.tax_cost),2) as hsml, 
       round(sum(fs.no_tax_amount - fs.no_tax_cost),2) as wsml,
       round( sum(fs.no_tax_amount - fs.no_tax_cost) / sum(fs.no_tax_amount), 4) as mll,
       nvl(ils.stock_on_hand,0) as soh       
from fact_sale fs, item_master im, item_loc_soh ils
where fs.goods_code = im.item
and fs.goods_code = ils.item(+) 
and fs.cus_code = ils.loc(+)
and fs.cus_code = '${store}'
and sale_date between to_date('${startdate}','yyyy-mm-dd') and to_date('${enddate}','yyyy-mm-dd')
group by im.dept_name, im.item, im.short_desc, im.attr9, im.attr7, im.mfg_rec_retail, 
		ils.stock_on_hand
) a
) t where t.rn <= 20


