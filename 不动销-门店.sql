
select a.area_code,
       r.area_name,
       a.cus_code,
       c.cus_name,    
       count(distinct g.goods_code) goods_num,
       sum(nvl(a.no_tax_cost, 0))  no_tax_cost
  from dm_stock_shop_detail a
 
    left join dim_disable_code d
    on a.goods_code=d.disable_code
     left join dim_goods g
    on d.goods_code = g.goods_code
  left join dim_region r
    on a.area_code = r.area_code
    left join dim_cus c
    on a.area_code=c.area_code
    and a.cus_code=c.cus_code
     left join  dm_goods_Fixedpin_days  f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
    and a.cus_code=f.cus_code
    where a.ddate=trunc(sysdate,'mm')-1
    and f.attribute='直营'
    and c.attribute='直营'
    and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
  and 1=1
   ${if(len(datediff)=0,""," and datediff >= "+datediff+"")}
     and 1=1
    ${if(len(cus)=0,""," and a.cus_Code in ('"+cus+"')")}
    group by  a.area_code,
       r.area_name,
       a.cus_code,
       c.cus_name
	
    
order by 1,3


select     
       count(distinct g.goods_code) goods_num,
       sum(nvl(a.no_tax_cost, 0))  no_tax_cost
  from dm_stock_shop_detail a
 
    left join dim_disable_code d
    on a.goods_code=d.disable_code
     left join dim_goods g
    on d.goods_code = g.goods_code
  left join dim_region r
    on a.area_code = r.area_code
    left join dim_cus c
    on a.area_code=c.area_code
    and a.cus_code=c.cus_code
     left join  dm_goods_Fixedpin_days  f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
    and a.cus_code=f.cus_code
    where a.ddate=trunc(sysdate,'mm')-1
    and f.attribute='直营'
    and c.attribute='直营'
    and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
  and 1=1
   ${if(len(datediff)=0,""," and datediff >= "+datediff+"")}
     and 1=1
    ${if(len(cus)=0,""," and a.cus_Code in ('"+cus+"')")}
  
	

select distinct area_code,area_name from dim_region
where 1=1
    ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
order by 1

select distinct cus_code,cus_name from dim_cus
where  1=1 ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
order by 1

select distinct goods_code,goods_name from DM_stock_goods
 where ddate=trunc(sysdate,'mm')-1

