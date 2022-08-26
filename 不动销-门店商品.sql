
select a.area_code,
       r.area_name,
       a.cus_code,
       c.cus_name,
       g.goods_code,
       g.goods_name,
       g.specification,
       g.unit,
       g.manufacturer,
       g.large_cate,
       datediff,
       date_max,
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
    left join  dm_goods_Fixedpin_days f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
    and a.cus_code=f.cus_code
        left join 
DIM_DTP dd
on to_char(ADD_MONTHS(a.ddate,-1),'YYYY-MM')=dd.CREATE_MONTH
and a.AREA_CODE=dd.AREA_CODE and a.GOODS_CODE=dd.GOODS_CODE
    where a.ddate=trunc(sysdate,'mm')-1
    and f.attribute='直营'
    and c.attribute='直营'
      and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
    and 1=1
    ${if(len(cus)=0,""," and a.cus_Code in ('"+cus+"')")}
    and 1=1
${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
and  1=1
 ${if(len(datediff)=0,""," and datediff >= "+datediff+"")} 
 and 1=1
${if(len(dtp)=0,""," and case when dd.goods_code is not null then '是' else '否' end  = '"+dtp+"'")} 
    group by  a.area_code,
       r.area_name,
        a.cus_code,
       c.cus_name,
	  g.goods_code,
       g.goods_name,
       g.specification,
       g.unit,
       g.manufacturer,
       g.large_cate,
       datediff,
       date_max
    order by 1,3,5
     

select distinct cus_code,cus_name from dim_cus
where attribute='直营'
and 1=1
 ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
order by 1

select distinct goods_code,goods_code||'|'||goods_name goods_name from DM_stock_goods
 where ddate=trunc(sysdate,'mm')-1
 order by 1 desc 

select distinct area_code,area_name from dim_region


