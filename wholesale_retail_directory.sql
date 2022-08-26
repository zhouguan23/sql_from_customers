select a.*,b.goods_name,b.SPECIFICATION,b.MANUFACTURER,b.PRODUCT_PLACE from wholesale_retail_directory a
left join dim_goods b
on a.item=b.goods_code
left join dim_disable_code c
on b.goods_code=c.disable_code　where 1=1 
${if(len(item)=0,"","and item in ('"+item+"')")}
and 1=1 
${if(len(supply)=0,""," and supplier in ('"+supply+"')" )}
and 1=1 
${if(len(status)=0,"","and case
         when c.goods_code is null then
          '废止'
         when c.goods_code <> c.disable_code then
          '禁用'
         WHEN c.goods_code = c.disable_code AND c.disable_code LIKE '6%' THEN
          '临购码'
         else
          '正常'
       end in ('"+status+"')")}
order by 1

select  distinct A.item,B.GOODS_NAME,A.item||'|'||B.GOODS_NAME GOODS_NAME1 from wholesale_retail_directory a left join dim_goods b
on a.item=b.goods_code where 1=1 
${if(len(supply)=0,""," and supplier in ('"+supply+"')" )}
order by 1

select distinct supplier from wholesale_retail_directory

