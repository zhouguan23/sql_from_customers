select a.*,b.goods_name,specification,product_place,manufacturer,r.area_name,r.union_area_name,r.sorted from dim_goods_directory a
left join dim_goods b
on a.goods_code=b.goods_code
left join dim_region r
on a.area_code=r.area_code
left join dim_disable_code c
on a.goods_code=c.disable_code
where 1=1 
${if(len(GOODS_CODE)=0,"","and a.GOODS_CODE in ('"+GOODS_CODE+"')")}
${if(len(TYPE)=0,"","and a.TYPE in ('"+TYPE+"')")}
${if(len(area)=0,"","and a.area_code in ('"+area+"')")}
${if(len(union)=0,"","and r.union_area_name in ('"+union+"')")}
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
order by r.sorted

select DISTINCT a.GOODS_CODE,a.goods_code||'|'||b.goods_name goods_name from dim_goods_directory  a,dim_goods b
where a.goods_code=b.goods_code
order by 1 desc 

select DISTINCT TYPE from dim_goods_directory  

select * from dim_region  
order by sorted

