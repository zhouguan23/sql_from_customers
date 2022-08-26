select distinct goods_code as goods_code,
goods_code||'|'||goods_name as goods_name  from DIM_GOODS_KEY_CATALOGUE 
order by goods_code

select distinct union_area_name from DIM_GOODS_KEY_CATALOGUE 

select c.*,(case when a.goods_code is null then '否' else '是' end) as dtp 
from dim_dtp a
right join dim_region b
on a.area_code=b.area_code
right join  DIM_GOODS_KEY_CATALOGUE c
on a.create_month=to_char(c.create_xun,'yyyy-mm')
and a.goods_code=c.goods_code
and b.union_area_name=c.union_area_name
left join dim_goods d
on c.goods_code=d.goods_code
where 
create_xun=to_date('${date1}','yyyy-mm-dd')
--to_char(create_xun,'yyyy-mm')='${date1}'
and  1=1
${if(len(attributes)=0,""," and c.key_breed_attributes  in ('"+attributes +"')")}
and  1=1
${if(len(ASSESS_METHOD)=0,""," and c.ASSESS_METHOD  in ('"+ASSESS_METHOD +"')")}  
and  1=1
${if(len(COMBINATION_MARKS)=0,""," and c.COMBINATION_MARKS  in ('"+COMBINATION_MARKS +"')")} 
and 1=1
${if(len(area)=0,""," and c.union_area_name  in ('"+area +"')")}
and 1=1
${if(len(category)=0,""," and d.category in ('"+category+"')")} 
and 1=1
${if(len(sub_category)=0,""," and d.sub_category in ('"+sub_category+"')")} 
and 1=1
${if(len(composition)=0,""," and d.composition in ('"+composition+"')")}
and 1=1
${if(len(gcode)=0,""," and c.goods_code in ('"+gcode+"')")}
AND 1=1 ${if(len(dtp)=0,""," and (case when a.goods_code is null then '否' else '是' end) = '"+dtp+"'")} 
order by c.create_xun,nlssort(c.union_area_name, 'NLS_SORT=SCHINESE_PINYIN_M'),
c.goods_code

SELECT DISTINCT CATEGORY
FROM DIM_GOODS

union 
select '空' from dual

SELECT DISTINCT 
SUB_CATEGORY 
FROM DIM_GOODS
WHERE 
1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
union 
select '空' from dual

SELECT DISTINCT 
COMPOSITION
FROM DIM_GOODS
WHERE 
1=1
${if(len(CATEGORY)=0, "" ,"and CATEGORY in ('"+CATEGORY+"')")}
AND 
1=1
${if(len(SUB_CATEGORY)=0, "" ,"and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
union 
select '空' from dual


select distinct key_breed_attributes from DIM_GOODS_KEY_CATALOGUE

select distinct ASSESS_METHOD from DIM_GOODS_KEY_CATALOGUE

select distinct COMBINATION_MARKS from DIM_GOODS_KEY_CATALOGUE


select distinct to_char(create_xun,'YYYY-MM-DD')create_xun from DIM_GOODS_KEY_CATALOGUE
order by 1 desc

