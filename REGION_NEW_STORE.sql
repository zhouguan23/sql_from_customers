select * from  dim_region  
where 1=1
${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
order by 2

 select count(1)xkmds,
        area_code
  from dim_cus
 where 1=1
   and attribute = '直营'
   and open_date
 between  to_date('${start_date}','yyyy-mm-dd')
 and to_date('${end_date}','yyyy-mm-dd')
${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
 group by area_code

 select count(1) zygds,area_code 
  from dim_cus
 where attribute = '直营'
 and close_date
 between  to_date('${start_date}','yyyy-mm-dd')
 and to_date('${end_date}','yyyy-mm-dd')
 ${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")}
 group by area_code 

select sum(xs) xs, 
       sum(ml) ml, 
       area_code 
  from (select a.no_tax_amount xs,
               no_tax_amount - no_tax_cost ml,
               a.area_code,
               c.oto,
               nvl2(d.goods_code, '是', '否') dtp
          from fact_sale a,
               dim_cus b,
               dim_marketing c,
               (select *
                  from dim_dtp
                 where create_month =
                       to_char((add_months(sysdate, -1)), 'yyyy-mm')) d
         where a.cus_code = b.cus_code
           and a.area_code=b.area_code
           and b.attribute = '直营'
           and a.marketing_code = c.marketing_code
           and a.goods_code = d.goods_code(+)
           and a.area_code = d.area_code(+)
          ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
           and b.open_date between to_date('${start_date}', 'yyyy-mm-dd') and
               to_date('${end_date}', 'yyyy-mm-dd')
           and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
               to_date('${end_date}', 'yyyy-mm-dd')
               ) t1
        where ${if(len(oto) = 0, "1=1", "  t1.oto='" + oto + "'")}
          and ${if(len(dtp) = 0, "1=1", "  t1.dtp='" + dtp + "'")}
     group by area_code

