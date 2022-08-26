select a.*,r.union_area_name from DIM_GOODS_MAPPING a
left join dim_region r
on a.area_code=r.area_code
left join dim_disable_code c 
on a.goods_code=c.disable_code where 1=1 
${if(len(gcode)=0,"",if(gcode='空值',"and goods_code is null","and a.goods_code in('"+gcode+"')"))}
and 1=1 ${if(len(area)=0,"","and a.Area_code in ('"+area+"')")} and 1=1 
${if(len(acode)=0,"","and area_goods_code in('"+acode+"')")} and 1=1 

${if(len(tcode)=0,"","and type_code in('"+tcode+"')")} and 1=1 

${if(len(sp)=0,"","and specification in('"+sp+"')")} and 1=1 

${if(len(manu)=0,"","and manufacturer in('"+manu+"')")} and 1=1 

${if(len(app)=0,"","and approval in('"+app+"')")}

and 1=1 

${if(len(UPDATE_MONTH)=0,"","and UPDATE_MONTH in('"+UPDATE_MONTH+"')")}
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

