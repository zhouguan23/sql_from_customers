
select a.goods_code,  
         a.area_code,
         r.area_name,
        sum(sale_qty) sale_qty,
        sum(tax_cost) no_tax_cost, 
       sum(tax_amount) no_tax_amount
      
  from fact_sale a
  join dim_goods_ill b
    on a.goods_code = b.goods_code
  left join dim_region r
    on a.area_code = r.area_code
    left join dim_cus c
    on a.area_code=c.area_code
    and a.cus_code=c.cus_code
    where sale_date>=date'${start}'
    and sale_date<=date'${end}'
     ${if(len(goods)=0,""," and a.goods_Code in ('"+goods+"')")}
       ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
     and c.attribute='直营'
    group by a.goods_code,
       
         a.area_code,
         r.area_name
         order by a.area_code,a.goods_code


select a.goods_code,
         a.area_code,
       
       sum(no_tax_amount)/nullif(sum(delivery_qty),0) no_tax_amount
      
  from fact_delivery a
  join dim_goods_ill b
    on a.goods_code = b.goods_code
  join dim_goods c
    on b.goods_code = c.goods_code
  left join dim_region r
    on a.area_code = r.area_code
    where sale_date>=date'${start}'
    and sale_date<=date'${end}'
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
    and delivery_type='批发'
    group by a.goods_code,
     
         a.area_code
        

select * from (
select a.goods_code,
           a.area_code,
             sum(no_tax_price) no_tax_amount,       
              row_number () over (partition by a.goods_code,a.area_code order by order_date desc ) rn
            
            from fact_purchase a
             join dim_goods_ill g
              on a.goods_code = g.goods_code
           where  a.procurement_type = '采进'
                  ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
           group by a.goods_code,a.area_code,order_date
       )
       where rn=1

select nvl(m.goods_code,a.goods_code) goods_code,a.area_code,sum(stock_qty) stock_qyt,sum(a.tax_cost) 
no_tax_cost from dm_stock_shop_day a

left join dim_goods_mapping m
on a.goods_code=m.area_goods_code
and a.area_code=m.area_code
join dim_goods_ill b
on m.goods_code=b.goods_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
where c.attribute='直营'
       ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
group by nvl(m.goods_code,a.goods_code),a.area_code

select nvl(m.goods_code,a.goods_code) goods_code,a.area_code,sum(stock_qty) stock_qyt,sum(a.tax_cost) 
no_tax_cost from dm_stock_general_day a

left join dim_goods_mapping m
on a.goods_code=m.area_goods_code
and a.area_code=m.area_code
join dim_goods_ill b
on m.goods_code=b.goods_code
where 1=1
       ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
group by nvl(m.goods_code,a.goods_code),a.area_code

select a.goods_code,a.goods_code||'|'||b.goods_name goods_name
 from dim_goods_ill a,dim_goods b
 where a.goods_code=b.goods_code
 order by a.goods_code

select t.*,r.area_name,
g.goods_name ,
       g.item_desc_secondary,
       g.specification,
       g.manufacturer,
      -- c.Packing_num,
       c.retail_price,
       c.type from (
select distinct a.area_code,a.goods_code from fact_sale a,dim_goods_ill b
where a.goods_code=b.goods_code
and sale_date>=date'${start}'
and sale_date<=date'${end}'
union 
select distinct a.area_code,a.goods_code from fact_purchase a, dim_goods_ill b
where a.goods_code=b.goods_code
union 
select distinct a.area_code,a.goods_code from dm_stock_shop_day a,dim_goods_ill b
where a.goods_code=b.goods_code
union 
select distinct a.area_code,a.goods_code from dm_stock_general_day a,dim_goods_ill b
where a.goods_code=b.goods_code) t
,dim_region r,dim_goods_ill c,dim_goods g
where t.area_code=r.area_code
and t.goods_code=c.goods_code
and c.goods_code=g.goods_code
and t.area_code<>'00'
and 1=1   ${if(len(goods)=0,""," and t.goods_Code in ('"+goods+"')")}
       ${if(len(area)=0,""," and t.area_Code in ('"+area+"')")}
       order by t.area_code,t.goods_code

select * from dim_region 


