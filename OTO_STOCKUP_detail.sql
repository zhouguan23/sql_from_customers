select distinct c.cus_code,c.cus_code||'|'||c.cus_name cus_name,r.area_code,r.area_name,r.union_area_name from dim_cus c,dim_region r
where c.area_code=r.area_code
and c.attribute<>'批发'
and c.close_date is null 
order by 3,1

select distinct goods_code,goods_code||'|'||goods_Name goods_name from dim_goods 
ORDER BY 1

select * from dim_region order by sorted


SELECT a.AREA_CODE,a.CUS_CODE,a.GOODS_CODE,sum(sale_qty) O2O销售数量,sum(tax_amount) O2O销售金额 FROM DM_GOODS_SALE_PAYMENT A
LEFT JOIN DIM_MARKETING_ALL M
ON A.AREA_CODE=M.AREA_CODE
AND A.MARKETING_CODE=M.MARKETING_CODE
join dim_goods_stockup s
on a.area_code=s.area_code
and a.cus_code=s.cus_code
and a.goods_code=s.goods_code
WHERE M.LARGE_CATE='第三方O2O'
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(AREA)=0,"","and a.area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and a.cus_code in('"+CUS+"')")}  
  ${if(len(goods)=0,"","and g.goods_code in('"+goods+"')")} 
group by a.AREA_CODE,a.CUS_CODE,a.GOODS_CODE

SELECT a.AREA_CODE,a.CUS_CODE,a.GOODS_CODE,sum(sale_qty) 整体销售数量,sum(tax_amount) 整体销售金额 FROM fact_sale A
join dim_goods_stockup s
on a.area_code=s.area_code
and a.cus_code=s.cus_code
and a.goods_code=s.goods_code
WHERE A.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1
 ${if(len(AREA)=0,"","and a.area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and a.cus_code in('"+CUS+"')")}  
  ${if(len(goods)=0,"","and g.goods_code in('"+goods+"')")} 
group by a.AREA_CODE,a.CUS_CODE,a.GOODS_CODE

SELECT  r.sorted,a.area_code,r.area_name,a.cus_code,c.cus_name,case when i.cus_code is not null then '是' else '否' end is_import,g.goods_code,g.goods_name ,g.specification,g.manufacturer,g.bar_code,nvl(t.stock_qty,0) stock_qty,nvl(t.no_tax_cost,0) no_tax_cost FROM dim_goods_stockup A
left join dim_region r
on a.area_code=r.area_code
LEFT JOIN DIM_GOODS G
ON A.GOODS_CODE=G.GOODS_CODE
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join DIM_O2O_IMPORT_CUS i
on a.area_code=i.area_code
and a.cus_code=i.cus_code
left join (select A.AREA_CODE,A.CUS_CODE,A.GOODS_CODE, sum(no_tax_cost) no_tax_cost,sum(stock_qty) stock_qty from dm_stock_shop_day a
join dim_goods_stockup s
on a.area_code=s.area_code
and a.cus_code=s.cus_code
and a.goods_code=s.goods_code
GROUP BY A.AREA_CODE,A.CUS_CODE,A.GOODS_CODE) t
on a.area_code=t.area_code
and a.cus_code=t.cus_code
and a.goods_code=t.goods_code
where 1=1
 ${if(len(AREA)=0,"","and a.area_code in('"+AREA+"')")}
 ${if(len(CUS)=0,"","and a.cus_code in('"+CUS+"')")}  
  ${if(len(goods)=0,"","and g.goods_code in('"+goods+"')")} 
    ${if(len(import)=0,"","and case when i.cus_code is not null then '是' else '否' end in('"+import+"')")} 
    ${if(len(stock)=0,"","and case when nvl(t.stock_qty,0)=0 then '是' else '否' end  in('"+stock+"')")} 
  and  c.attribute<>'批发'
and c.close_date is null 
order by 1,6

