
select to_char(a.ddate,'yyyy-mm') ddate,
	  a.area_code,
       r.area_name,
       r.sorted,
       r.union_area_name,
      
      
     
       sum(nvl(a.no_tax_cost_dc, 0))  no_tax_cost_dc,
       sum(nvl(no_tax_cost_md, 0)) no_tax_cost_md
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
    left join (select max(trunc(sale_date,'mm')) sale_date,area_code,goods_code from (
select s.sale_date,
	  s.area_code,
       goods_code
  from fact_sale s
left join dim_cus c
on s.area_code=c.area_code
and s.cus_code=c.cus_code
 WHERE  sale_date>=add_months(to_date('${start_date}','yyyy-mm'),-nvl('${datediff}',0))
 and 
  sale_date<add_months(to_date('${end_date}','yyyy-mm'),1)
 and c.attribute='直营'
 and s.sale_qty>0
union all
select d.sale_date,
      d.area_code,
       goods_code
  from fact_delivery d
left join dim_cus c
on d.area_code=c.area_code
and d.cus_code=c.cus_code
 WHERE    sale_date>=add_months(to_date('${start_date}','yyyy-mm'),-nvl('${datediff}',0))
 and sale_date<add_months(to_date('${end_date}','yyyy-mm'),1)
and c.attribute in ('加盟','批发')
and case
         when d.area_code <> '00' and
              nvl(c.related_party_trnsaction, '否') <> '是' then
          delivery_qty
         when d.area_code = '00' then
          delivery_qty
         else
          0
       end > 0
 )
group by area_code,goods_code
     ) f
    on a.area_code=f.area_code
    and a.goods_code=f.goods_code
 
    left join (select area_code,goods_code,min(order_date) first_time from (
select area_code,goods_code, order_date from fact_purchase 
union all 
select r.area_code,nsr.item,tran_date from new_shop_reaserch nsr ,dim_region r
where nsr.region_name=r.area_all_name)
group by area_code,goods_code
) n
on a.area_code=n.area_code
and a.goods_code=n.goods_code
    where a.ddate between last_day(to_date('${start_date}','yyyy-mm')) and last_day(to_date('${end_date}','yyyy-mm'))
    --and f.goods_code is null 
    and 1=1
    ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
    and 1=1
${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
and 1=1
${if(newgoods='否',""," and  trunc(a.ddate,'mm')<>nvl(trunc(n.first_time,'mm'),date'2099-12-31') ")}
and 1=1
${if(len(dtp)=0,""," and case when dd.goods_code is not null then '是' else '否' end  = '"+dtp+"'")} 
    ${if(len(category)=0,""," and nvl(g.category,'空') in ('"+category+"')")}
        ${if(len(season)=0,""," and nvl(g.season_attribute,'空')  in ('"+season+"')")}
and f.sale_date=add_months(trunc(a.ddate,'mm'),-nvl('${datediff}',0))
    group by  to_char(a.ddate,'yyyy-mm'),
    a.area_code,
       r.area_name,
       r.sorted,
       r.union_area_name
         

    
     order by ddate,r.sorted

select distinct area_code,area_name from dim_region
where 1=1 ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
order by 1

select  nvl(category,'空') category,
       nvl(season_attribute,'空') season_attribute from dim_goods

