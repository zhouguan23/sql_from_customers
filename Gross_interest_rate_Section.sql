select wsxs, wsml, wsml / wsxs mll, area_name
  from (select sum(wsxs) wsxs，sum(wsml) wsml, area_name
          from (select sum(no_tax_amount) wsxs,
                       sum(no_tax_amount) - sum(no_tax_cost) wsml,
                       e.area_name,
                       a.goods_code
                  from fact_sale     a,
                       dim_cus       b,
                       dim_dtp       c,
                       dim_marketing d,
                       dim_region    e
                 where sale_date between date '${date1}' and date'${date2}'
                    ${if(len(dtp)=0,"","and nvl2(c.goods_code, '是', '否') = ('"+dtp+"')")}
                    ${if(len(oto)=0,"","and d.oto = ('"+oto+"')")}
                    ${if(len(UNION_AREA)=0,"","and e.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
                    ${if(len(AREA)=0,""," and e.area_code in ('"+AREA+"')")}
                   and a.cus_code = b.cus_code
                   and to_char(a.sale_date, 'yyyy-mm') = c.create_month(+)
                   and a.goods_code = c.goods_code(+)
                   and a.area_code = c.area_code(+)
                   and a.marketing_code = d.marketing_code
                   and a.area_code = e.area_code
                   and b.attribute = '直营'
                 group by e.area_name, a.goods_code)
         where wsxs <> 0
           and wsml / wsxs <0
         group by area_name)

select  distinct area_name ,area_code,UNION_AREA_NAME from dim_region 
where area_code<>'00'
 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 ${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
order by 2

select wsxs, wsml, wsml / wsxs mll, area_name
  from (select sum(wsxs) wsxs，sum(wsml) wsml, area_name
          from (select sum(no_tax_amount) wsxs,
                       sum(no_tax_amount) - sum(no_tax_cost) wsml,
                       e.area_name,
                       a.goods_code
                  from fact_sale     a,
                       dim_cus       b,
                       dim_dtp       c,
                       dim_marketing d,
                       dim_region    e
                 where sale_date between date '${date1}' and date'${date2}'
                    ${if(len(dtp)=0,"","and nvl2(c.goods_code, '是', '否') = ('"+dtp+"')")}
                    ${if(len(oto)=0,"","and d.oto = ('"+oto+"')")}
 ${if(len(UNION_AREA)=0,"","and e.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
                   ${if(len(AREA)=0,""," and e.area_code in ('"+AREA+"')")}
                   and a.cus_code = b.cus_code
                   and to_char(a.sale_date, 'yyyy-mm') = c.create_month(+)
                   and a.goods_code = c.goods_code(+)
                   and a.area_code = c.area_code(+)
                   and a.marketing_code = d.marketing_code
                   and a.area_code = e.area_code
                   and b.attribute = '直营'
                 group by e.area_name, a.goods_code)
         where wsxs <> 0
           and wsml / wsxs >= 0
           and wsml / wsxs < 0.1
         group by area_name)

select wsxs, wsml, wsml / wsxs mll, area_name
  from (select sum(wsxs) wsxs，sum(wsml) wsml, area_name
          from (select sum(no_tax_amount) wsxs,
                       sum(no_tax_amount) - sum(no_tax_cost) wsml,
                       e.area_name,
                       a.goods_code
                  from fact_sale     a,
                       dim_cus       b,
                       dim_dtp       c,
                       dim_marketing d,
                       dim_region    e
                 where sale_date between date '${date1}' and date'${date2}'
                    ${if(len(dtp)=0,"","and nvl2(c.goods_code, '是', '否') = ('"+dtp+"')")}
                    ${if(len(oto)=0,"","and d.oto = ('"+oto+"')")}
 ${if(len(UNION_AREA)=0,"","and e.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
                   ${if(len(AREA)=0,""," and e.area_code in ('"+AREA+"')")}
                   and a.cus_code = b.cus_code
                   and to_char(a.sale_date, 'yyyy-mm') = c.create_month(+)
                   and a.goods_code = c.goods_code(+)
                   and a.area_code = c.area_code(+)
                   and a.marketing_code = d.marketing_code
                   and a.area_code = e.area_code
                   and b.attribute = '直营'
                 group by e.area_name, a.goods_code)
         where wsxs <> 0
           and wsml / wsxs >= 0.1
           and wsml / wsxs < 0.3
         group by area_name)

select wsxs, wsml, wsml / wsxs mll, area_name
  from (select sum(wsxs) wsxs，sum(wsml) wsml, area_name
          from (select sum(no_tax_amount) wsxs,
                       sum(no_tax_amount) - sum(no_tax_cost) wsml,
                       e.area_name,
                       a.goods_code
                  from fact_sale     a,
                       dim_cus       b,
                       dim_dtp       c,
                       dim_marketing d,
                       dim_region    e
                 where sale_date between date '${date1}' and date'${date2}'
                    ${if(len(dtp)=0,"","and nvl2(c.goods_code, '是', '否') = ('"+dtp+"')")}
                    ${if(len(oto)=0,"","and d.oto = ('"+oto+"')")}
 ${if(len(UNION_AREA)=0,"","and e.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
                   ${if(len(AREA)=0,""," and e.area_code in ('"+AREA+"')")}
                   and a.cus_code = b.cus_code
                   and to_char(a.sale_date, 'yyyy-mm') = c.create_month(+)
                   and a.goods_code = c.goods_code(+)
                   and a.area_code = c.area_code(+)
                   and a.marketing_code = d.marketing_code
                   and a.area_code = e.area_code
                   and b.attribute = '直营'
                 group by e.area_name, a.goods_code)
         where wsxs <> 0
           and wsml / wsxs >= 0.3
           and wsml / wsxs < 0.5
         group by area_name)

select wsxs, wsml, wsml / wsxs mll, area_name
  from (select sum(wsxs) wsxs，sum(wsml) wsml, area_name
          from (select sum(no_tax_amount) wsxs,
                       sum(no_tax_amount) - sum(no_tax_cost) wsml,
                       e.area_name,
                       a.goods_code
                  from fact_sale     a,
                       dim_cus       b,
                       dim_dtp       c,
                       dim_marketing d,
                       dim_region    e
                 where sale_date between date '${date1}' and date'${date2}'
                    ${if(len(dtp)=0,"","and nvl2(c.goods_code, '是', '否') = ('"+dtp+"')")}
                    ${if(len(oto)=0,"","and d.oto = ('"+oto+"')")}
 ${if(len(UNION_AREA)=0,"","and e.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
                   ${if(len(AREA)=0,""," and e.area_code in ('"+AREA+"')")}
                   and a.cus_code = b.cus_code
                   and to_char(a.sale_date, 'yyyy-mm') = c.create_month(+)
                   and a.goods_code = c.goods_code(+)
                   and a.area_code = c.area_code(+)
                   and a.marketing_code = d.marketing_code
                   and a.area_code = e.area_code
                   and b.attribute = '直营'
                 group by e.area_name, a.goods_code)
         where wsxs <> 0
           and wsml / wsxs >= 0.5
         group by area_name)

 select wsxs，wsml ,mll,area_name from 
 (
 select sum(no_tax_amount) wsxs,
        sum(no_tax_amount) - sum(no_tax_cost) wsml,
        (sum(no_tax_amount) - sum(no_tax_cost))/sum(no_tax_amount) mll,
        e.area_name
   from fact_sale a, dim_cus b, dim_dtp c, dim_marketing d,dim_region e
  where sale_date between date '${date1}' and date'${date2}'
    ${if(len(dtp)=0,"","and nvl2(c.goods_code, '是', '否') = ('"+dtp+"')")}
    ${if(len(oto)=0,"","and d.oto = ('"+oto+"')")}
    and a.area_code = b.area_code
    and a.cus_code = b.cus_code
    and to_char(a.sale_date, 'yyyy-mm') = c.create_month(+)
    and a.goods_code = c.goods_code(+)
    and a.area_code = c.area_code(+)
    and a.marketing_code = d.marketing_code
    and a.area_code=e.area_code
    and b.attribute = '直营'
    group by e.area_name
    ）

SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION

