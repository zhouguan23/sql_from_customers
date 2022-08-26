
select a.area_code,
       r.area_name,
       g.goods_code,
       g.goods_name,
       g.specification,
       g.unit,
       g.manufacturer,
       g.large_cate,
       datediff,
       date_max,
       sum(nvl(a.no_tax_cost_dc, 0)) + sum(nvl(no_tax_cost_md, 0)) no_tax_cost
  from dm_stock_goods a
 
    left join dim_disable_code d
    on a.goods_code=d.disable_code
     left join dim_goods g
    on d.goods_code = g.goods_code
  left join dim_region r
    on a.area_code = r.area_code
    left join 
DIM_DTP dd
on to_char(ADD_MONTHS(a.ddate,-1),'YYYY-MM')=dd.CREATE_MONTH
and a.AREA_CODE=dd.AREA_CODE and a.GOODS_CODE=dd.GOODS_CODE
    left join (select area_code,goods_code,max(date_max) date_max,TO_NUMBER(trunc(sysdate) - max(date_max)) datediff from 
    dm_goods_Fixedpin_days
    group by area_code,goods_code ) f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
    where a.ddate=trunc(sysdate,'mm')-1
    and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
    and 1=1
${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
and  1=1
 ${if(len(datediff)=0,""," and datediff >= "+datediff+"")} 
and 1=1
${if(len(dtp)=0,""," and case when dd.goods_code is not null then '是' else '否' end  = '"+dtp+"'")} 
    group by  a.area_code,
       r.area_name,
	  g.goods_code,
       g.goods_name,
       g.specification,
       g.unit,
       g.manufacturer,
       g.large_cate,
       datediff,
       date_max
    
     order by 1

select distinct area_code,area_name from dim_region
where 1=1 ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
order by 1

select distinct goods_code,goods_code||'|'||goods_name goods_name1,goods_name from DM_stock_goods
 where ddate=trunc(sysdate,'mm')-1

