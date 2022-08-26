select A.goods_code,
a.goods_name,
a.area_code,
a.area_goods_code,
a.area_price,
a.specification,
a.manufacturer,
a.type_code,
a.unit,
a.quantity,
a.APPROVAL,
(case when a.bar_code is null then b.bar_code else a.bar_code end) as bar_code,
(case when a.tax_rate is null then b.tax_rate else to_number(a.tax_rate) end) as tax_rate,
(case when a.product_place is null then b.product_place else a.product_place end) as product_place,
b.ITEM_DESC_SECONDARY,
r.union_area_name



from DIM_GOODS_MAPPING A left join dim_goods b on a.goods_code=b.goods_code
left join dim_region r
on a.area_code=r.area_code
left join dim_disable_code c
on a.goods_code=c.goods_code where 1=1 
${if(len(gcode)=0,"",if(gcode='空值',"and A.goods_code is null","and A.goods_code in('"+gcode+"')"))}
and 1=1 ${if(len(area)=0,"","and a.Area_code in ('"+area+"')")} and 1=1 
${if(len(acode)=0,"","and area_goods_code in('"+acode+"')")} and 1=1 

${if(len(tcode)=0,"","and A.type_code in('"+tcode+"')")} and 1=1 

${if(len(sp)=0,"","and A.specification in('"+sp+"')")} and 1=1 

${if(len(manu)=0,"","and A.manufacturer in('"+manu+"')")} and 1=1 

${if(len(app)=0,"","and A.approval in('"+app+"')")}

AND 1=1 ${if(len(bc)=0,"","and (b.bar_code in('"+bc+"') or a.bar_code in ('"+bc+"'))")}
AND 1=1 ${if(len(pp)=0,"","and (b.product_place in('"+pp+"') or a.product_place in ('"+pp+"'))")}

${if(len(UPDATE_MONTH)=0,"","and A.UPDATE_MONTH in('"+UPDATE_MONTH+"')")}
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

select '空值' as GOODS_CODE from dual
union
select distinct GOODS_CODE FROM DIM_GOODS_MAPPING
where 1=1 ${if(len(area)=0,"","and area_code in ('"+area+"')")}
and 1=1 ${if(len(acode)=0,"","and area_goods_code in ('"+acode+"')")}

order by goods_code desc


select distinct Area_name,area_code from DIM_REGION

select distinct area_goods_code from DIM_GOODS_MAPPING where 1=1
${if(len(area)=0,"","and area_code in ('"+area+"')")} 

select distinct goods_code from DIM_GOODS_MAPPING

select distinct type_code from DIM_GOODS_MAPPING

select distinct specification from DIM_GOODS_MAPPING

select distinct manufacturer from DIM_GOODS_mapping

SELECT DISTINCT APPROVAL FROM DIM_GOODS_MAPPING

select distinct bar_code from DIM_GOODS MAPPING
UNION 
SELECT DISTINCT BAR_CODE FROM DIM_GOODS

select distinct product_place as pp from DIM_GOODS MAPPING
UNION 
SELECT DISTINCT product_place as pp FROM DIM_GOODS

