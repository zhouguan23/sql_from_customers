select a.*,b.GOODS_NAME,b.SPECIFICATION,b.MANUFACTURER,b.PRODUCT_PLACE from dim_gifts a left join dim_disable_code c 
on a.goods_code=c.disable_code,DIM_GOODS b
where a.GOODS_CODE=b.GOODS_CODE 
${if(len(GOODS_CODE)==0,"", " and a.GOODS_CODE in ('" + GOODS_CODE + "')")}
${if(len(type)==0,"", " and a.type in ('" + type + "')")}
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

select distinct TYPE from DIM_GIFTS
where 1=1 ${if(len(GOODS_CODE)==0,"", " and GOODS_CODE in ('" + GOODS_CODE + "')")}

select distinct b.GOODS_NAME,b.goods_code,b.goods_code||'|'||b.goods_name goods_Name1 from dim_gifts a,DIM_GOODS b
where a.GOODS_CODE=b.GOODS_CODE 
order by 2

select distinct goods_code from dim_goods

