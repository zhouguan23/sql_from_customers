select * from DIM_DISABLE_CODE where 1=1 
${if(len(JYM)=0,"","and case
         when goods_code is null then
          '废止'
         when goods_code <> disable_code then
          '禁用'
         WHEN goods_code = disable_code AND disable_code LIKE '6%' THEN
          '临购码'
         else
          '正常'
       end in ('"+JYM+"')")}
       order by 1

select A.*,b.goods_name,b.specification,b.manufacturer,b.PRODUCT_PLACE,b.remarks from DIM_DISABLE_CODE A left join DIM_goods b on a.disable_code=b.goods_code
where 
1=1
${if(len(DISABLE_CODE)==0,"","and A.DISABLE_CODE in ('"+ DISABLE_CODE +"')")}
and 
1=1
${if(len(GOODS_CODE)==0,"","and A.GOODS_CODE in ('"+ GOODS_CODE +"')")}
and
1=1
${if(len(JYM)=0,"","and case
         when a.goods_code is null then
          '废止'
         when a.goods_code <> a.disable_code then
          '禁用'
         WHEN a.goods_code = a.disable_code AND disable_code LIKE '6%' THEN
          '临购码'
         else
          '正常'
       end in ('"+JYM+"')")}
order by b.goods_code



select * from DIM_DISABLE_CODE where 1=1
${if(len(JYM)=0,"","and case
         when a.goods_code is null then
          '废止'
         when a.goods_code <> a.disable_code then
          '禁用'
         WHEN a.goods_code = a.disable_code AND disable_code LIKE '6%' THEN
          '临购码'
         else
          '正常'
       end in ('"+JYM+"')")}
order by 1

