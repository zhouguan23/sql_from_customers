
select a.area_code,
       r.area_name,    
       count(distinct g.goods_code) goods_num,
       sum(nvl(a.no_tax_cost_dc, 0)) + sum(nvl(no_tax_cost_md, 0)) no_tax_cost
  from dm_stock_goods a
 
    left join dim_disable_code d
    on a.goods_code=d.disable_code
     left join dim_goods g
    on d.goods_code = g.goods_code
  left join dim_region r
    on a.area_code = r.area_code
     left join (select area_code,goods_code,max(date_max) date_max,TO_NUMBER(trunc(sysdate) - max(date_max)) datediff from 
    dm_goods_Fixedpin_days
    group by area_code,goods_code ) f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
    where a.ddate=trunc(sysdate,'mm')-1
    and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
  and 1=1
   ${if(len(datediff)=0,""," and datediff >= "+datediff+"")}
    group by  a.area_code,
       r.area_name
	
    
order by 1


select  
       count(distinct g.goods_code) goods_num,
       sum(nvl(a.no_tax_cost_dc, 0)) + sum(nvl(no_tax_cost_md, 0)) no_tax_cost
  from dm_stock_goods a
 
    left join dim_disable_code d
    on a.goods_code=d.disable_code
     left join dim_goods g
    on d.goods_code = g.goods_code
  left join dim_region r
    on a.area_code = r.area_code
     left join (select area_code,goods_code,max(date_max) date_max,TO_NUMBER(trunc(sysdate) - max(date_max)) datediff from 
    dm_goods_Fixedpin_days
    group by area_code,goods_code ) f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
    where a.ddate=trunc(sysdate,'mm')-1
    and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
  and 1=1
   ${if(len(datediff)=0,""," and datediff >= "+datediff+"")}
   
    
order by 1

select distinct area_code,area_name from dim_region
where 1=1
    ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
order by 1

select distinct goods_code,goods_name from DM_stock_goods
 where ddate=trunc(sysdate,'mm')-1

